function [ys,params,exo] = DGE_CRED_Model_steadystate(ys,exo,M_,options_)
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
    % read out parameters to access them with their name
    NumberOfParameters = M_.param_nbr;
    strpar.Init = nan;
    for ii = 1:NumberOfParameters
      paramname = char(M_.param_names(ii,:));
      eval([ paramname ' = M_.params(' int2str(ii) ');']);
      strpar.(paramname) = M_.params(ii);
    end
    
    % read out parameters to access them with their name
    NumberOfEndo = M_.endo_nbr;
    strys.Init = nan;
    for ii = 1:NumberOfEndo
      varname = char(M_.endo_names(ii,:));
      strys.(varname) = ys(ii);
    end
    
    % read out parameters to access them with their name
    NumberOfExo = M_.exo_nbr;
    strexo.Init = nan;
    for ii = 1:NumberOfExo
      exoname = char(M_.exo_names(ii,:));
      strexo.(exoname) = exo(ii);
    end
    if strpar.lCalibration_p == 0 || strpar.lCalibration_p == 3
        %% find steady state
        if isoctave()
            options = optimset('Display', 'off', 'TolFun', 1e-20, 'TolX', 1e-20, 'Updating', 'on');  
        else
            options = optimset('Display', 'iter', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 100000);
        end
        if strpar.phiG_p > 0
            xstart_vec = nan(strpar.inbsectors_p*strpar.inbregions_p+1,1);
        else
            xstart_vec = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        end
        
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                icovec = icoreg + (icosec-1)*strpar.inbregions_p;
                xstart_vec(icovec) = strys.(['K_' ssec '_' sreg]);
            end
        end
        if strpar.phiG_p > 0
            xstart_vec(end) = strys.G;
        end
        FindKtemp = @(x)FindK(x,strys,strexo,strpar);
        [Fval_vec, strys,strexo] = FindK(xstart_vec, strys, strexo, strpar);
        if max(abs(Fval_vec(:)))>1e-8
            [xopt, ~, ~, ~, ~] = fsolve(FindKtemp, xstart_vec, options);%, strys, strexo, strpar);
            [~, strys,strexo] = FindK(real(xopt), strys, strexo, strpar);
        end
    elseif strpar.lCalibration_p == 2
        if isoctave()
            options = optimset('Display', 'off', 'TolFun', 1e-20, 'TolX', 1e-20, 'Updating', 'on');  
        else
            options = optimset('Display', 'iter', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 100000);
        end
        if strpar.phiG_p > 0
            xstart_vec = nan(strpar.inbsectors_p*strpar.inbregions_p+1,1);
        else
            xstart_vec = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
        end
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                icovec = icoreg + (icosec-1)*strpar.inbregions_p;
                xstart_vec(icovec) = strys.(['K_' ssec '_' sreg])/strys.(['Y_' ssec '_' sreg]);
            end
        end
        if strpar.phiG_p > 0
            xstart_vec(end) = strys.G / strys.Y;
        end
        % evaluate residuals of HH FOC w.r.t. labour in each region and sector
        iStep = options_.iStepSteadyState;
        YTtemp_p = strpar.YT_p;
        NTtemp_p = strpar.NT_p;
        for icostep = 1:iStep
            disp(['Step ' num2str(icostep) ' of ' num2str(iStep) ' to find terminal condition'])
            for icosec = 1:strpar.inbsectors_p
                ssec = num2str(icosec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    strpar.YT_p = icostep./iStep .* YTtemp_p + (iStep-icostep)./iStep .* strpar.Y0_p;
                    strpar.NT_p = icostep./iStep .* NTtemp_p + (iStep-icostep)./iStep .* strpar.N0_p;
                    strpar.(['phiY_' ssec '_' sreg '_p']) = (iStep-icostep)./iStep .* strpar.(['phiY0_' ssec '_' sreg '_p']) + icostep./iStep .* strpar.(['phiYT_' ssec '_' sreg '_p']);
                    strpar.(['phiN_' ssec '_' sreg '_p']) = (iStep-icostep)./iStep .* strpar.(['phiN0_' ssec '_' sreg '_p']) + icostep./iStep .* strpar.(['phiNT_' ssec '_' sreg '_p']);
                end
            end
            FindKtemp = @(x)FindK(x,strys,strexo,strpar);
            [Fval_vec, strys,strexo] = FindK(xstart_vec, strys, strexo, strpar);
            if max(abs(Fval_vec(:)))>1e-8
                [xopt, Fval_vec, ~, ~, ~] = fsolve(FindKtemp, xstart_vec, options);%, strys, strexo, strpar);
                [~, strys,strexo] = FindK(real(xopt), strys, strexo, strpar);
                xstart_vec = xopt;
            end 
            disp(['Maximum absolute residual ' num2str(max(abs(Fval_vec)))])          
            errortemp = 0;
            for icosec = 1:strpar.inbsectors_p
                ssec = num2str(icosec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    wtemp = strys.(['W_' ssec '_' sreg]) * (1 + strys.(['tauN_' ssec '_' sreg])) / strys.(['P_' ssec '_' sreg]);
                    rkgross = strys.(['r_' ssec '_' sreg]) * (1 + strys.(['tauK_' ssec '_' sreg]));
                    errortemp = max(abs(strys.(['Y_' ssec '_' sreg]) - (wtemp * strys.PoP * strys.(['N_' ssec '_' sreg]) + rkgross * strys.(['K_' ssec '_' sreg]))), errortemp);
                end
            end
            disp(['Maximum profit error ' num2str(max(abs(errortemp)))])
            
        end
    else
        % calibrate model
        if isoctave()
            options = optimset('Display', 'off', 'TolFun', 1e-20, 'TolX', 1e-20);  
        else
            options = optimset('Display', 'iter', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 10000);
        end
        
        Calibrationtemp = @(x)Calibration(x,strys,strexo,strpar);
        xstart_vec = 1;
        [xopt, Feval, Info, outtemp, fjac] = fsolve(Calibrationtemp, xstart_vec, options);%#ok
        [~, strpar,strys] = Calibration(xopt, strys, strexo, strpar);
        
        errorvatemp = 0;
        errorwagetemp = 0;        
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                errorvatemp = max(abs(strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg]) / (strys.Y * strys.P) - strpar.(['phiY_' ssec '_' sreg '_p'])), errorvatemp);
                errorwagetemp = max(abs(strys.(['W_' ssec '_' sreg]) * strys.(['N_' ssec '_' sreg]) * strys.PoP * (1 + strys.(['tauN_' ssec '_' sreg])) / (strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg])) - strpar.(['phiW_' ssec '_' sreg '_p'])), errorwagetemp);
            end
        end
        disp(['Maximum value added share error ' num2str(max(abs(errorvatemp)))])
        disp(['Maximum wage share error ' num2str(max(abs(errorwagetemp)))])
        
    end
    %% end own model equations
    
    for iter = 1:length(M_.params) %update parameters set in the file
      M_.params(iter) = strpar.(char(M_.param_names(iter,:)));
    end
    params = M_.params;
    
    NumberOfEndogenousVariables = M_.orig_endo_nbr; %auxiliary variables are set automatically
    for ii = 1:NumberOfEndogenousVariables
      varname = char(M_.endo_names(ii,:));
      ys(ii) = strys.(varname);
    end
    
    NumberOfExogenousVariables = M_.exo_nbr; %auxiliary variables are set automatically
    for ii = 1:NumberOfExogenousVariables
      varname = char(M_.exo_names(ii,:));
      exo(ii) = strexo.(varname);
    end
    
end