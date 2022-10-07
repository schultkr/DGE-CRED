function [ys,params,check,exo] = DGE_CRED_Model_steadystate(ys,exo,M_,options_)
% function [ys,params,check,exo] = DGE_CRED_Model_steadystate(ys,exo,M_,options)
% computes the steady state for the IWH_CRED_Model.mod and uses a numerical
% solver to do so
% Inputs: 
%   - ys        [vector] vector of initial values for the steady state of
%                   the endogenous variables
%   - exo       [vector] vector of values for the exogenous variables
%   - M_        [structure] dynare model structure
%   - options_  [structure] dynare model options structure
%
%
% Output: 
%   - ys        [vector] vector of steady state values for the the endogenous variables
%   - params    [vector] vector of parameter values of the model
%   - exo       [vector] vector of exogenous variables of the model

    check = false;
    options_ = options_;%#ok
    % read out parameters to access them with their name
    NumberOfParameters = M_.param_nbr;
    strpar.casClimatevarsNational = strsplit(strrep(strrep(M_.ClimateVarsNational,'[','' ), ']', ''), ', ');
    strpar.casClimatevarsRegional = strsplit(strrep(strrep(M_.ClimateVarsRegional,'[','' ), ']', ''), ', ');
    strpar.casClimatevars = [strpar.casClimatevarsNational strpar.casClimatevarsRegional];
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
    if strpar.lCalibration_p == 0
        %% find steady state
        if isoctave()
            options = optimset('Display', 'off', 'TolFun', 1e-16, 'TolX', 1e-12, 'Updating', 'on');  
        else
            options = optimset('Display', 'iter', 'TolFun', 1e-16, 'TolX', 1e-12, 'MaxFunEval', 100000);
        end
        sMaxsec = num2str(strpar.inbsectors_p);
        xstart_vec_1 = nan(strpar.(['subend_' sMaxsec '_p'])*strpar.inbregions_p,1);
        xstart_vec_2 = nan(strpar.(['subend_' sMaxsec '_p'])*strpar.inbregions_p,1);
        xstart_vec_3 = nan(strpar.(['subend_' sMaxsec '_p']),1);
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                xstart_vec_3(icosubsec) = strys.(['X_' ssubsec]);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    icovec = icoreg + (icosubsec-1)*strpar.inbregions_p;
                    xstart_vec_1(icovec) = strys.(['K_' ssubsec '_' sreg]);                
                    xstart_vec_2(icovec) = strys.(['Q_I_' ssubsec '_' sreg]);
                end
            end
        end
        if strpar.phiG_p > 0
            xstart_vec = [xstart_vec_1(:); xstart_vec_2; xstart_vec_3; strys.M; strys.G];
        else
            xstart_vec = [xstart_vec_1(:); xstart_vec_2; xstart_vec_3; strys.M];
        end
        if strpar.lEndogenousY_p == 0
            xstart_vec = [xstart_vec; strys.P_M];
        end
        FindKtemp = @(x)FindK(x,strys,strexo,strpar);
        [Fval_vec, strys, strexo] = FindK(xstart_vec, strys, strexo, strpar);
        if max(abs(Fval_vec(:)))>1e-8
            [xopt, ~, ~, ~, ~] = fsolve(FindKtemp, xstart_vec, options);%, strys, strexo, strpar);
            [~, strys,strexo] = FindK(real(xopt), strys, strexo, strpar);
        end
    elseif strpar.lCalibration_p == 2
        if isoctave()
            options = optimset('Display', 'off', 'TolFun', 1e-16, 'TolX', 1e-12, 'Updating', 'on');  
        else
            options = optimset('Display', 'iter', 'TolFun', 1e-16, 'TolX', 1e-12, 'MaxFunEval', 100000);
        end
        sMaxsec = num2str(strpar.inbsectors_p);
        xstart_vec_1 = nan(strpar.(['subend_' sMaxsec '_p'])*strpar.inbregions_p,1);
        xstart_vec_2 = nan(strpar.(['subend_' sMaxsec '_p'])*strpar.inbregions_p,1);
        xstart_vec_3 = nan(strpar.(['subend_' sMaxsec '_p']),1);
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                xstart_vec_3(icosubsec) = strys.(['D_X_' ssubsec]);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    icovec = icoreg + (icosubsec-1)*strpar.inbregions_p;
                    if strpar.(['etaNK_' ssubsec '_' sreg '_p']) ~= 1
                        xstart_vec_1(icovec) = strys.(['K_' ssubsec '_' sreg])/strys.(['Y_' ssubsec '_' sreg]);
                    else                        
                        xstart_vec_1(icovec) = strys.(['A_N_' ssubsec '_' sreg]);%A
                    end
                    xstart_vec_2(icovec) = strys.(['Q_I_' ssubsec '_' sreg])*strys.P / (strys.(['Y_' ssubsec '_' sreg]) * strys.(['P_' ssubsec '_' sreg]));
                end
            end
        end
        if strpar.phiG_p > 0
            xstart_vec = [xstart_vec_1(:); xstart_vec_2(:); xstart_vec_3(:); strys.M/strys.Y; strys.G];
        else
            xstart_vec = [xstart_vec_1(:); xstart_vec_2(:); xstart_vec_3(:); strys.M/strys.Y];
        end
        if strpar.lEndogenousY_p == 0
            xstart_vec = [xstart_vec; strys.P_M];
        end
        %% evaluate residuals of HH FOC w.r.t. labour in each region and sector
        strpar.YT_p = 0;
        strpar.NT_p = 0;
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    strpar.YT_p = strpar.YT_p + strpar.(['phiY0_' ssubsec '_' sreg '_p']) .*  exp(strexo.(['exo_' ssubsec '_' sreg])) .* strpar.Y0_p ./ strpar.P0_p;
                    strpar.NT_p = strpar.NT_p + strpar.(['phiN0_' ssubsec '_' sreg '_p']) .*  exp(strexo.(['exo_N_' ssubsec '_' sreg])) .* strpar.N0_p;
                end
            end
        end
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    strpar.(['phiY_' ssubsec '_' sreg '_p']) = (strpar.(['phiY0_' ssubsec '_' sreg '_p']) .*  exp(strexo.(['exo_' ssubsec '_' sreg ])) .* strpar.Y0_p ./ strpar.P0_p) / strpar.YT_p;
                    strpar.(['phiN_' ssubsec '_' sreg '_p']) = (strpar.(['phiN0_' ssubsec '_' sreg '_p']) .*  exp(strexo.(['exo_N_' ssubsec '_' sreg])) .* strpar.N0_p) ./ strpar.NT_p;
                end
            end
        end        
        FindKtemp = @(x)FindK(x,strys,strexo,strpar);
        [Fval_vec, strys, strexo] = FindK(xstart_vec, strys, strexo, strpar);
        if max(abs(Fval_vec(:)))>1e-8
           [xopt, Fval_vec, ~, ~, ~] = fsolve(FindKtemp, xstart_vec, options);%, strys, strexo, strpar);
           [~, strys, strexo] = FindK(real(xopt), strys, strexo, strpar);
        end 
        strpar.PT_p = strys.P;
        disp(['Maximum absolute residual ' num2str(max(abs(Fval_vec)))])          
        errortemp = 0;
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    wtemp = strys.(['W_' ssubsec '_' sreg]) * (1 + strys.(['tauNF_' ssubsec '_' sreg])) / strys.(['P_' ssubsec '_' sreg]);
                    rkgross = strys.(['r_' ssec '_' sreg]) * (1 + strys.(['tauKF_' ssubsec '_' sreg]));
                    errortemp = max(abs(strys.(['Y_' ssubsec '_' sreg]) - (wtemp * strys.PoP * strys.(['N_' ssubsec '_' sreg]) + rkgross * strys.(['K_' ssubsec '_' sreg]))), errortemp);
                end
            end
        end
        disp(['Maximum profit error ' num2str(max(abs(errortemp)))])
    else 
        % calibrate model
        if isoctave()
            options = optimset('Display', 'off', 'TolFun', 1e-20, 'TolX', 1e-20);  
        else
            options = optimset('Display', 'off', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 10000);
        end
        
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    strpar.(['phiY_' ssubsec '_' sreg '_p']) = strpar.(['phiY0_' ssubsec '_' sreg '_p']);
                    strpar.(['phiN_' ssubsec '_' sreg '_p']) = strpar.(['phiN0_' ssubsec '_' sreg '_p']);
                end
            end
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
                errorwagetemp = max(abs(strys.(['W_' ssec '_' sreg]) * strys.(['N_' ssec '_' sreg]) * strys.PoP * (1 + strys.(['tauNF_' ssec '_' sreg])) / (strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg])) - strpar.(['phiW_' ssec '_' sreg '_p'])), errorwagetemp);
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