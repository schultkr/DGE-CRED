function [ys,check,exo] = DGE_CRED_Model_steadystate(ys,exo)
% function [ys,check] = IWH_CRED_Model_steadystate(ys,exo)
% computes the steady state for the IWH_CRED_Model.mod and uses a numerical
% solver to do so
% Inputs: 
%   - ys        [vector] vector of initial values for the steady state of
%                   the endogenous variables
%   - exo       [vector] vector of values for the exogenous variables
%
% Output: 
%   - ys        [vector] vector of steady state values for the the endogenous variables
%   - check     [scalar] set to 0 if steady state computation worked and to
%                    1 if not (allows to impose restriction on parameters)
    check = 0;
    global M_
    % read out parameters to access them with their name
    NumberOfParameters = M_.param_nbr;
    strpar.Init = nan;
    for ii = 1:NumberOfParameters
      paramname = deblank(M_.param_names(ii,:));
      eval([ paramname ' = M_.params(' int2str(ii) ');']);
      strpar.(paramname) = M_.params(ii);
    end
    
    % read out parameters to access them with their name
    NumberOfEndo = M_.endo_nbr;
    strys.Init = nan;
    for ii = 1:NumberOfEndo
      varname = deblank(M_.endo_names(ii,:));
      strys.(varname) = ys(ii);
    end
    
    % read out parameters to access them with their name
    NumberOfExo = M_.exo_nbr;
    strexo.Init = nan;
    for ii = 1:NumberOfExo
      exoname = deblank(M_.exo_names(ii,:));
      strexo.(exoname) = exo(ii);
    end
    if strpar.lCalibration_p == 0 || strpar.lCalibration_p == 3
        %% find steady state
        options = optimset('Display', 'iter', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 10000);
        xstart_vec = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                icovec = icoreg + (icosec-1)*strpar.inbregions_p;
                xstart_vec(icovec) = strys.(['K_' ssec '_' sreg]);
            end
        end
        FindKtemp = @(x)FindK(x,strys,strexo,strpar);
        [Fval_vec, strys,strexo] = FindK(xstart_vec, strys, strexo, strpar);
        if max(abs(Fval_vec(:)))>1e-8
            [xopt, ~, ~, ~, ~] = fsolve(FindKtemp, xstart_vec, options);%, strys, strexo, strpar);
            [~, strys,strexo] = FindK(real(xopt), strys, strexo, strpar);
        end
    elseif strpar.lCalibration_p == 2
        options = optimset('Display', 'iter', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 10000, 'Algorithm', 'trust-region', 'SubproblemAlgorithm', 'cg');
        xstart_vec_1 = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        xstart_vec_2 = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        xstart_vec_3 = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                icovec = icoreg + (icosec-1)*strpar.inbregions_p;
                xstart_vec_1(icovec) = strys.(['A_' ssec '_' sreg]);
                xstart_vec_2(icovec) = strys.(['A_N_' ssec '_' sreg]);
                xstart_vec_3(icovec) = strys.(['K_' ssec '_' sreg]);
            end
        end
%         xstart_vec = [xstart_vec_1(:); xstart_vec_2(:); xstart_vec_3(:)];
        xstart_vec = [xstart_vec_1(:); xstart_vec_3(:)];
        %% evaluate residuals of HH FOC w.r.t. labour in each region and sector
        fval_vec_1 = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        fval_vec_2 = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                icovec = icoreg + strpar.inbregions_p * (icosec-1);
                if icosec == 1 && icoreg == 1
                    lhs_1 = strpar.YT_p;
                    rhs_1 = strys.Y*strys.P;
                    lhs_2 = strpar.NT_p;
                    rhs_2 = strys.N;
                else
                    strpar.(['phiY0_' ssec '_' sreg '_p']) = strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg])./(strys.Y * strys.P);
                    strpar.(['phiN0_' ssec '_' sreg '_p']) = strys.(['N_' ssec '_' sreg])./ strys.N;
                    lhs_1 = strpar.(['phiY_' ssec '_' sreg '_p']);
                    rhs_1 = strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg])./(strys.Y * strys.P);
                    lhs_2 = strpar.(['phiN_' ssec '_' sreg '_p']);
                    rhs_2 = strys.(['N_' ssec '_' sreg])./(strys.N);
                end           
                fval_vec_1(icovec) = lhs_1 - rhs_1;
                fval_vec_2(icovec) = lhs_2 - rhs_2;
            end
        end
        iStep = 10;
        YTtemp_p = strpar.YT_p;
        NTtemp_p = strpar.NT_p;
        for icostep = 1:iStep
            for icosec = 1:strpar.inbsectors_p
                ssec = num2str(icosec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    icovec = icoreg + strpar.inbregions_p * (icosec-1);
                    if icosec == 1 && icoreg == 1
                        strpar.YT_p = YTtemp_p - (iStep-icostep)./iStep .* fval_vec_1(icovec);
                        strpar.NT_p = NTtemp_p - (iStep-icostep)./iStep .* fval_vec_2(icovec);
                    else                    
                        strpar.(['phiY_' ssec '_' sreg '_p']) = strpar.(['phiY0_' ssec '_' sreg '_p']) + icostep./iStep .* fval_vec_1(icovec);
                        strpar.(['phiN_' ssec '_' sreg '_p']) = strpar.(['phiN0_' ssec '_' sreg '_p']) + icostep./iStep .* fval_vec_2(icovec);
                    end
                end
            end
            FindAtemp = @(x)FindA(x,strys,strexo,strpar);
            [Fval_vec, strys,strexo] = FindA(xstart_vec, strys, strexo, strpar);
            if max(abs(Fval_vec(:)))>1e-8
                [xopt, ~, ~, ~, ~] = fsolve(FindAtemp, xstart_vec, options);%, strys, strexo, strpar);
                [~, strys,strexo] = FindA(real(xopt), strys, strexo, strpar);
            end           
        end
    else
        
        
        %% calibrate model
        options = optimset('Display', 'iter', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 10000);
        Calibrationtemp = @(x)Calibration(x,strys,strexo,strpar);
%         xstart_vec = ones(strpar.inbsectors_p,1);
        xstart_vec = 1;
%         xstart_vec = [0.9 0.9 1.05 1.05 0.9 0.9];%ones(strpar.inbsectors_p.*strpar.inbregions_p,1);
        [xopt, Feval, Info, outtemp, fjac] = fsolve(Calibrationtemp, xstart_vec, options);%#ok
        [~, strpar,strys] = Calibration(xopt, strys, strexo, strpar);
        
    end
    %% end own model equations

    for iter = 1:length(M_.params) %update parameters set in the file
      M_.params(iter) = strpar.(deblank(M_.param_names(iter,:)));
    end

    NumberOfEndogenousVariables = M_.orig_endo_nbr; %auxiliary variables are set automatically
    for ii = 1:NumberOfEndogenousVariables
      varname = deblank(M_.endo_names(ii,:));
      ys(ii) = strys.(varname);
    end
    
    NumberOfExogenousVariables = M_.exo_nbr; %auxiliary variables are set automatically
    for ii = 1:NumberOfExogenousVariables
      varname = deblank(M_.exo_names(ii,:));
      exo(ii) = strexo.(varname);
    end
    
end