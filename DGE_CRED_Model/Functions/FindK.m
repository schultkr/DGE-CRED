function [fval_vec,strys,strexo] = FindK(x,strys,strexo,strpar)
    % function [fval_vec,strys] = FindK(x,strys,strexo,strpar)
    % finds capital stock vector to fulfill the static equations of the 
    % model
    % Inputs: 
    %   - x         [vector]     vector of initial values for the steady
    %                            state of the regional and sectoral capital
    %                            stock
    %   - strys     [structure]  structure containing all endogeonous 
    %                            variables of the model
    %   - strexo    [structure]  structure containing all exogeonous 
    %                            variables of the model    
    %   - strpar    [structure]  structure containing all parameters of the
    %                            model
    %
    % Output: 
    %   - fval_vec  [vector]     residuals of regional and sector specific
    %                            for FOC of Households with respect to 
    %                            regional labour
    %   - strys     [structure]  see inputs
    %   - strexo    [structure]  see inputs
    
    % get maximum number of eectors
    strpar.sMaxsec = num2str(strpar.inbsectors_p);
    
    % get guesses for the capital stock
    istart = 1;
    
    iend = strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p;
    
    x_start_vec_1 = x(istart:iend);
    
    % get guesses for intermediate production
    istart = (strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p+1);
    
    iend   = (2*strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p);
    
    x_start_vec_2 = x(istart:iend);
    
    % get guesses for exports
    istart = (2*strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p)+1;
    
    iend   = (2*strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p)+strpar.(['subend_' strpar.sMaxsec '_p']);
    
    x_start_vec_4 = x(istart:iend);
    
    % get guess for total imports
    strys.M = x((2*strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p)+strpar.(['subend_' strpar.sMaxsec '_p'])+1);
    
    % compute foreing interest rate
    strys.rf = strpar.rf0_p + strexo.exo_rf;
    
    % assign regional climate variables 
    for icoreg = 1:strpar.inbregions_p
        sreg = num2str(icoreg);      
        for sClimateVar = strpar.casClimatevarsRegional           
            strys.([char(sClimateVar) '_' sreg]) = strpar.([char(sClimateVar) '0_' sreg '_p']) + strexo.(['exo_' char(sClimateVar) '_' sreg]);
            
        end        
    end
    for sClimateVar = strpar.casClimatevarsNational
        strys.(char(sClimateVar)) = strpar.([char(sClimateVar) '0_p']) + strexo.(['exo_' char(sClimateVar)]); 
        
    end
    
    % define regional price level
    strys.P = strpar.P0_p .* exp(strexo.exo_P);

    % get import price
    if strpar.lEndogenousY_p == 0
        strys.P_M = x(end);
        
    else
        strys.P_M = strpar.P0_M_p + strexo.exo_M; 
        
    end
    
    strys.P_M_1 = strys.P_M^(1 - strpar.etaM_p);
    

    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            if strpar.lCalibration_p == 2
                % get initial guesses for export shares
                strys.(['D_X_' ssubsec]) = x_start_vec_4(icosubsec);    
                
            else
                % get initial guesses for exports
                strys.(['X_' ssubsec]) = x_start_vec_4(icosubsec);    
                
            end
                
            if icosubsec > 1
                % compute import prices
                strys.(['P_M_' ssubsec]) = (strpar.(['P_M_' ssubsec '_p'])./ strpar.P0_M_p + strexo.(['exo_M_' ssubsec])) * strys.P_M;    
                
                % re-compute the first import price
                strys.P_M_1 = strys.P_M_1 - strpar.(['omegaM_' ssubsec '_p']) * strys.(['P_M_' ssubsec])^(1 - strpar.etaM_p);
            end
            
        end
    end 
    
    strys.P_M_1 = (strys.P_M_1/strpar.omegaM_1_p)^(1/(1 - strpar.etaM_p));

    % compute domestic price level
    strys.P_D = ((strys.P^(1 - strpar.etaF_p) - strpar.omegaF_p * strys.P_M^(1 - strpar.etaF_p)) / (1 - strpar.omegaF_p))^(1/(1 - strpar.etaF_p));   
    
    % assign predetermined variables 
    [strys,strpar, strexo] = AssignPredeterminedVariables(strys,strpar, strexo);
    
    % 
    if strpar.lCalibration_p == 2
        
        [strys, strpar, strexo] = Initialize_FindK_ExogenousY(strys, strpar, strexo, x, x_start_vec_1, x_start_vec_2);
        
    else
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                for icoreg = 1:strpar.inbregions_p
                    sreg = num2str(icoreg);
                    icovec = icoreg + (icosubsec-1)*strpar.inbregions_p;
        
                    strys.(['Q_I_' ssubsec '_' sreg]) = sqrt(real(x_start_vec_2(icovec)).^2);
                    
                    strys.(['K_' ssubsec '_' sreg]) = sqrt(real(x_start_vec_1(icovec)).^2);
                end
            end
        end
        if strpar.phiG_p > 0
            if strpar.lEndogenousY_p == 0

                strys.G = x(end-1);
            else
                
                strys.G = x(end);
            end
        end
    end
    
    % public capital stock
    strys.KG = strys.G / strpar.deltaKG_p;
    
    
    %% calculate exogenous variables
    
    % population stock
    strys.PoP = strpar.PoP0_p * exp(strexo.exo_PoP);
    
    if strpar.lEndogenousY_p == 0
        % housing area
        strys.H  = (strpar.H0_p + strexo.exo_H) * strys.PoP;
        
    else
        % price per housing area
        strys.PH  = strpar.PH0_p * exp(strexo.exo_H);        
        
    end
    
    % government expenditure to the housing area
    strys.G_A_DH = strexo.exo_G_A_DH * strpar.Y0_p;
    
    
    %% calculate sectoral and regional production factors and output
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        % compute sectoral rental rate for capital 
        strys.(['r_' ssec]) = (1/strpar.beta_p - 1 + strpar.delta_p)/(1 - strys.tauKH);        
        
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);           
            
            % compute sectoral and regional rental rate for capital 
            strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p)/(1 - strys.tauKH);
            
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);       
            
                % auxiliary variable to define the degree of substitutability
                % between capital and labour in the sector
                rhotemp = ((strpar.(['etaNK_' ssubsec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssubsec '_' sreg '_p']));

                % compute sectoral and regional rental rate for capital                 
                strys.(['lambK_' ssubsec '_' sreg]) = 0;
                
                if strpar.lEndogenousY_p == 1
                    % compute regional and sub-sectoral productivity 
                    strys.(['A_' ssubsec '_' sreg]) = strpar.(['A_' ssubsec '_' sreg '_p']) * exp(strexo.(['exo_' ssubsec '_' sreg])) * strys.KG^strpar.phiG_p;
                    
                end
                
                if strpar.lEndogenousY_p == 1
                    % compute regional and sub-sectoral labour productivity 
                    strys.(['A_N_' ssubsec '_' sreg]) = strpar.(['A_N_' ssubsec '_' sreg '_p']) * exp(strexo.(['exo_N_' ssubsec '_' sreg]));
                    
                end
                
                rkgross = strys.(['r_' ssec '_' sreg]) * (1 + strys.(['tauKF_' ssubsec '_' sreg]));

                if strpar.lCalibration_p == 2 % Baseline / exogenous Y
                    if strpar.(['etaNK_' ssubsec '_' sreg '_p']) ~= 1
                        % compute regional and sub-sectoral productivity 
                        strys.(['A_' ssubsec '_' sreg]) = (rkgross / (strpar.(['alphaK_' ssubsec '_' sreg '_p'])^(1/ strpar.(['etaNK_' ssubsec '_' sreg '_p'])) *  (strys.(['A_K_' ssubsec '_' sreg]) * (1 - strys.(['D_' ssubsec '_' sreg])))^rhotemp * (strys.(['K_' ssubsec '_' sreg])/strys.(['Y_' ssubsec '_' sreg]))^(-1/strpar.(['etaNK_' ssubsec '_' sreg '_p']))))^(1/rhotemp);
                                                      
                    else
                        % compute the capital stock
                        strys.(['K_' ssubsec '_' sreg]) = strpar.(['alphaK_' ssubsec '_' sreg '_p']) * strys.(['Y_' ssubsec '_' sreg]) / rkgross;
                        
                        % compute the gross wage
                        wgross = strpar.(['alphaN_' ssubsec '_' sreg '_p']) / strpar.(['alphaK_' ssubsec '_' sreg '_p']) * strys.(['K_' ssubsec '_' sreg]) / (strys.PoP * strys.(['N_' ssubsec '_' sreg])) * rkgross * strys.(['P_' ssubsec '_' sreg]);
                        
                        % compute auxiliary variable to compute
                        % productivity
                        temp = (rkgross/(strpar.(['alphaK_' ssubsec '_' sreg '_p']) * strys.(['A_K_' ssubsec '_' sreg])))^strpar.(['alphaK_' ssubsec '_' sreg '_p']) * ...
                               (wgross/(strpar.(['alphaN_' ssubsec '_' sreg '_p']) * strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])))^strpar.(['alphaK_' ssubsec '_' sreg '_p']));
                        
                        % compute subsectoral and regional productivity
                        strys.(['A_' ssubsec '_' sreg]) = strys.(['P_' ssubsec '_' sreg]) / temp;                        
                        
                    end
                    
                    % recompute the exogenous disturbances to productivity
                    % should be unneccary if everything is correct
                    if strpar.lEndogenousY_p == 1                       
                        strexo.(['exo_' ssubsec '_' sreg]) = log(strys.(['A_' ssubsec '_' sreg]) / (strys.KG^strpar.phiG_p * strpar.(['A_' ssubsec '_' sreg '_p'])));                        
                        
                    else
                        strexo.(['exo_' ssubsec '_' sreg]) = log((strys.(['Y_' ssubsec '_' sreg]) .* strys.(['P_' ssubsec '_' sreg])/strys.P) ./ (strpar.Y0_p./strpar.P0_p .* strpar.(['phiY0_' ssubsec '_' sreg '_p'])));                        
                        
                    end
                    % compute exogenous labour productivity
                    if strpar.(['etaNK_' ssubsec '_' sreg '_p']) ~= 1 % CES
                        temp1 = (strys.(['K_' ssubsec '_' sreg]) * rkgross^strpar.(['etaNK_' ssubsec '_' sreg '_p']) / (strpar.(['alphaK_' ssubsec '_' sreg '_p']) * strys.(['A_K_' ssubsec '_' sreg])^(strpar.(['etaNK_' ssubsec '_' sreg '_p'])-1) * (strys.(['A_' ssubsec '_' sreg]) * (1 - strys.(['D_' ssubsec '_' sreg])))^(strpar.(['etaNK_' ssubsec '_' sreg '_p']))))^rhotemp;
                        
                        temp2 = strpar.(['alphaK_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * strys.(['A_K_' ssubsec '_' sreg])^rhotemp * strys.(['K_' ssubsec '_' sreg])^rhotemp;
                        
                        temp = ((temp1 - temp2) / (strpar.(['alphaN_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * (strys.PoP .* strys.(['N_' ssubsec '_' sreg]))^rhotemp))^(1/rhotemp);                                    
                        
                        strys.(['A_N_' ssubsec '_' sreg]) = temp / (1 - strys.(['D_N_' ssubsec '_' sreg]));
                        
                        if strpar.lEndogenousY_p == 1
                            strexo.(['exo_N_' ssubsec '_' sreg]) = log(strys.(['A_N_' ssubsec '_' sreg])/strpar.(['A_N_' ssubsec '_' sreg '_p']));
                            
                        else
                            strexo.(['exo_N_' ssubsec '_' sreg]) = log(strys.(['N_' ssubsec '_' sreg])/(strpar.(['phiN0_' ssubsec '_' sreg '_p'])*strpar.N0_p));
                            
                        end                        
                    else % Cobb-Douglas
                        if strpar.lEndogenousY_p == 1
                            strexo.(['exo_N_' ssubsec '_' sreg]) = log(strys.(['A_N_' ssubsec '_' sreg])/strpar.(['A_N_' ssubsec '_' sreg '_p']));

                        end
                    end      
                else  % Climate Change Scenarios / endogenous Y
                    if strpar.(['etaNK_' ssubsec '_' sreg '_p']) ~= 1
                        temp1 = (strys.(['K_' ssubsec '_' sreg]) * rkgross^strpar.(['etaNK_' ssubsec '_' sreg '_p']) / (strpar.(['alphaK_' ssubsec '_' sreg '_p']) * strys.(['A_K_' ssubsec '_' sreg])^(strpar.(['etaNK_' ssubsec '_' sreg '_p'])-1) * (strys.(['A_' ssubsec '_' sreg]) * (1 - strys.(['D_' ssubsec '_' sreg])))^(strpar.(['etaNK_' ssubsec '_' sreg '_p']))))^rhotemp;
                        
                        temp2 = strpar.(['alphaK_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * strys.(['A_K_' ssubsec '_' sreg])^rhotemp * strys.(['K_' ssubsec '_' sreg])^rhotemp;
                        
                        temp = ((temp1 - temp2) / (strpar.(['alphaN_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p']))))^(1/rhotemp);
                        
                        if strpar.lEndogenousY_p == 1
                            % compute labour
                            strys.(['N_' ssubsec '_' sreg]) = temp / (strys.PoP * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.(['A_N_' ssubsec '_' sreg]));                        
                            
                        else
                            % compute labour productivity
                            strys.(['A_N_' ssubsec '_' sreg]) = temp / (strys.PoP * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.(['N_' ssubsec '_' sreg]));
                            
                        end
                    else
                        % compute labour demand
                        strys.(['N_' ssubsec '_' sreg]) = (strys.(['K_' ssubsec '_' sreg]) * rkgross / (strpar.(['alphaK_' ssubsec '_' sreg '_p']) * strys.(['A_' ssubsec '_' sreg]) *  (1 - strys.(['D_' ssubsec '_' sreg])) * (strys.(['A_K_' ssubsec '_' sreg]) * ...
                                                           strys.(['K_' ssubsec '_' sreg]))^strpar.(['alphaK_' ssubsec '_' sreg '_p'])))^(1/strpar.(['alphaN_' ssubsec '_' sreg '_p'])) / (strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.PoP);
                        

                    end
                        
                end
                if strpar.(['etaNK_' ssubsec '_' sreg '_p']) ~= 1 % CES
                    if strpar.lEndogenousY_p == 1
                        % compute gross vlaue added
                        strys.(['Y_' ssubsec '_' sreg]) = strys.(['A_' ssubsec '_' sreg]) * (1 - strys.(['D_' ssubsec '_' sreg])) * (strpar.(['alphaK_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * (strys.(['A_K_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]))^rhotemp + strpar.(['alphaN_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * (strys.PoP * strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.(['N_' ssubsec '_' sreg]))^rhotemp)^(1/rhotemp);
                        
                    else
                        % compute productivity
                        strys.(['A_' ssubsec '_' sreg]) = strys.(['Y_' ssubsec '_' sreg]) /((1 - strys.(['D_' ssubsec '_' sreg])) * (strpar.(['alphaK_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * (strys.(['A_K_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]))^rhotemp + strpar.(['alphaN_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * (strys.PoP * strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.(['N_' ssubsec '_' sreg]))^rhotemp)^(1/rhotemp));
                        
                    end
                else
                    if strpar.lEndogenousY_p == 1
                        % compute gross vlaue added % Cobb Douglas
                        strys.(['Y_' ssubsec '_' sreg]) = strys.(['A_' ssubsec '_' sreg]) * (1 - strys.(['D_' ssubsec '_' sreg])) *  (strys.(['A_K_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]))^strpar.(['alphaK_' ssubsec '_' sreg '_p']) * (strys.PoP * strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.(['N_' ssubsec '_' sreg]))^strpar.(['alphaN_' ssubsec '_' sreg '_p']);
                        
                    else
                        % compute productivity
                        strys.(['A_' ssubsec '_' sreg]) = strys.(['Y_' ssubsec '_' sreg]) / ((1 - strys.(['D_' ssubsec '_' sreg])) *  (strys.(['A_K_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]))^strpar.(['alphaK_' ssubsec '_' sreg '_p']) * (strys.PoP * strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])) * strys.(['N_' ssubsec '_' sreg]))^strpar.(['alphaN_' ssubsec '_' sreg '_p']));
                        
                    end
                end
                % compute substitutability between intermediate goods and
                % gross value added
                rhotemp = (strpar.(['etaI_' ssubsec '_p']) - 1)/strpar.(['etaI_' ssubsec '_p']);
                
                % compute outputs
                strys.(['Q_' ssubsec '_' sreg]) = (strpar.(['omegaQI_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaI_' ssubsec '_p'])) * strys.(['Q_I_' ssubsec '_' sreg])^rhotemp + ...
                                                (1 - strpar.(['omegaQI_' ssubsec '_' sreg '_p']))^(1/strpar.(['etaI_' ssubsec '_p'])) * strys.(['Y_' ssubsec '_' sreg])^rhotemp)^(1/rhotemp);
            end
        end
        % initiliaze aggregate sector production
        strys.(['Q_A_' ssec]) = 0;        
        
        % compute subsitutability between different sbsectors in the sector
        rhotemp = (strpar.(['etaQA_' ssec '_p'])-1)/strpar.(['etaQA_' ssec '_p']);
        
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);       
            % initiliaze aggregate subsector production
            strys.(['Q_' ssubsec]) = 0;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                % compute subsector production
                strys.(['Q_' ssubsec]) = strys.(['Q_' ssubsec]) + strpar.(['omegaQ_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaQ_' ssubsec '_p'])) * (strys.(['Q_' ssubsec '_' sreg]))^((strpar.(['etaQ_' ssubsec '_p'])-1)/strpar.(['etaQ_' ssubsec '_p']));
                
            end
            % compute subsector production
            strys.(['Q_' ssubsec]) = strys.(['Q_' ssubsec])^(strpar.(['etaQ_' ssubsec '_p'])/(strpar.(['etaQ_' ssubsec '_p'])-1));        
            
            if strpar.lCalibration_p == 2                   
                % compute exports
                strys.(['X_' ssubsec]) = strys.(['Q_' ssubsec]) * strys.(['D_X_' ssubsec]);
                
            else
                % compute export share
                strys.(['D_X_' ssubsec]) = strys.(['X_' ssubsec]) / strys.(['Q_' ssubsec]);
                
            end
            
            % compute domestically used products
            strys.(['Q_D_' ssubsec]) = strys.(['Q_' ssubsec]) - strys.(['X_' ssubsec]);
            
            % aggregate sector production
            strys.(['Q_A_' ssec])  = strys.(['Q_A_' ssec]) + strpar.(['omegaQ_' ssubsec '_p'])^(1/strpar.(['etaQA_' ssec '_p'])) * strys.(['Q_D_' ssubsec])^rhotemp;
        end
        % aggregate sector production
        strys.(['Q_A_' ssec])  = strys.(['Q_A_' ssec])^(1/rhotemp);
        
    end
    
    % init domestically used products
    strys.Q_D = 0;
    
    % substituatibility between sectoral products
    rhotemp = (strpar.etaQ_p-1)/strpar.etaQ_p;
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        % aggregate domestically used products
        strys.Q_D  = strys.Q_D + strpar.(['omegaQA_' ssec '_p'])^(1/strpar.etaQ_p) * strys.(['Q_A_' ssec])^rhotemp;        
    end
    
    % domestic output
    strys.Q_D = strys.Q_D^(1/rhotemp);
    
    % substituatibility between domestic and foreign products
    rhotemp = (strpar.etaF_p-1)/strpar.etaF_p;
    
    % domestically used output
    strys.Q_U = (strpar.omegaF_p^(1/strpar.etaF_p) * strys.M^rhotemp + (1 - strpar.omegaF_p)^(1/strpar.etaF_p) * strys.Q_D^rhotemp)^(1/rhotemp);
    
    % domestic price level 
    strys.P_D = (1 - strpar.omegaF_p)^(1/strpar.etaF_p) * (strys.Q_D/strys.Q_U)^(-1/strpar.etaF_p) * strys.P;
    
    %% calculate sectoral and regional price indices and sectoral aggregates
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        % compute sectoral price level
        strys.(['P_A_' ssec]) = strpar.(['omegaQA_' ssec '_p'])^(1/strpar.etaQ_p) * (strys.(['Q_A_' ssec]) / strys.Q_D)^(-1/strpar.etaQ_p) * strys.P_D;
        
        % init sectoral capital stock
        strys.(['KH_' ssec]) = 0;
        
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);            
            % compute sub-sectoral imports
            strys.(['M_' ssubsec]) = strpar.(['omegaM_' ssubsec '_p']) * (strys.(['P_M_' ssubsec]) / strys.P_M)^(-strpar.etaM_p) * strys.M;
            
            % init sub-sectoral labour
            strys.(['N_' ssubsec]) = 0;
            
            % compute sub-sectoral price level
            strys.(['P_D_' ssubsec]) = strpar.(['omegaQ_' ssubsec '_p'])^(1/strpar.(['etaQA_' ssec '_p'])) * (strys.(['Q_D_' ssubsec]) / strys.(['Q_A_' ssec]))^(-1/strpar.(['etaQA_' ssec '_p'])) * strys.(['P_A_' ssec]);strys.(['D_X_' ssubsec]);       
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                rhotemp = ((strpar.(['etaNK_' ssubsec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssubsec '_' sreg '_p']));
                
                % compute sub-sectoral and regional domestic price level
                strys.(['P_D_' ssubsec '_' sreg]) = strpar.(['omegaQ_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaQ_' ssubsec '_p'])) * (strys.(['Q_' ssubsec '_' sreg]) / strys.(['Q_' ssubsec]))^(-1/strpar.(['etaQ_' ssubsec '_p'])) * strys.(['P_D_' ssubsec]);
                
                % compute sub-sectoral and regional price level of primary
                % production factors
                strys.(['P_' ssubsec '_' sreg]) = (1 - strpar.(['omegaQI_' ssubsec '_' sreg '_p']))^(1/strpar.(['etaI_' ssubsec '_p'])) * (strys.(['Y_' ssubsec '_' sreg]) / strys.(['Q_' ssubsec '_' sreg]))^(-1/strpar.(['etaI_' ssubsec '_p'])) * strys.(['P_D_' ssubsec '_' sreg]);
                
                % compute sub-sectoral and regional wages
                strys.(['W_' ssubsec '_' sreg]) = strpar.(['alphaN_' ssubsec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssubsec '_' sreg '_p'])) * (strys.(['A_' ssubsec '_' sreg]) * (1 - strys.(['D_' ssubsec '_' sreg])) * strys.(['A_N_' ssubsec '_' sreg]) * (1 - strys.(['D_N_' ssubsec '_' sreg])))^rhotemp * ((strys.(['N_' ssubsec '_' sreg]) * strys.PoP) / strys.(['Y_' ssubsec '_' sreg]))^(-1/strpar.(['etaNK_' ssubsec '_' sreg '_p']))*strys.(['P_' ssubsec '_' sreg]) / (1 + strys.(['tauNF_' ssubsec '_' sreg]));
                
                % aggregate sub-sectoral labour
                strys.(['N_' ssubsec]) = strys.(['N_' ssubsec]) + strys.(['N_' ssubsec '_' sreg]);               
                
            end
            
            % init sub-sectoral capital stock
            strys.(['K_' ssubsec]) = 0;
            
            % init sub-sectoral wages
            strys.(['W_' ssubsec]) = 0;
            
            % init intermediate subsectoral gross value added
            strys.(['Y_' ssubsec]) = 0;
            
            % init intermediate subsectoral products
            strys.(['Q_I_' ssubsec]) = 0;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                
                % aggregate sectoral and regional capital stock of households
                if icosubsec == strpar.(['substart_' ssec '_p'])
                    strys.(['KH_' ssec '_' sreg]) = 0;
                end
                
                % compute subsectoral capital sotck
                strys.(['K_' ssubsec]) = strys.(['K_' ssubsec]) + strys.(['P_' ssubsec '_' sreg]) / strys.P * strys.(['K_' ssubsec '_' sreg]) ;
                
                % compute subsectoral wages
                strys.(['W_' ssubsec]) = strys.(['W_' ssubsec]) + strys.(['N_' ssubsec '_' sreg]) / strys.(['N_' ssubsec]) * strys.(['W_' ssubsec '_' sreg]) ;               
                
                % compute subsectoral gross value added
                strys.(['Y_' ssubsec]) = strys.(['Y_' ssubsec]) + strys.(['P_' ssubsec '_' sreg]) * strys.(['Y_' ssubsec '_' sreg]) ;               
                
                % compute aggregate subsectoral intermediate products demand 
                strys.(['Q_I_' ssubsec]) = strys.(['Q_I_' ssubsec]) + strys.(['Q_I_' ssubsec '_' sreg]) ;               
                
                % compute sectoral and regional capital demand
                strys.(['KH_' ssec '_' sreg]) = strys.(['KH_' ssec '_' sreg]) + strys.(['P_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]) ./ strys.P;
                
                % compute sectoral and regional investment 
                strys.(['I_' ssec '_' sreg]) = (strpar.delta_p) * strys.(['KH_' ssec '_' sreg]) + strys.(['D_KHelp_' ssec '_' sreg]);           
                
                % compute aggregate sectoral capital stock
                strys.(['KH_' ssec]) = strys.(['KH_' ssec]) + strys.(['P_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]) ./ strys.P;
                
            end
        end
        
        % init aggregate sectoral invesment
        strys.(['I_' ssec]) = 0;
        
        % compute aggregate sectoral invesment
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['I_' ssec]) = strys.(['I_' ssec]) + strys.(['I_' ssec '_' sreg]) ;
        end
    end
    
    % compute aggregates
    [strys, strpar, strexo] = ComputeAggregates(strys, strpar, strexo);
    
    % net exports
    strys.NX = (strys.P_D * strys.X - strys.P_M * strys.M)/strys.P;
    
    % products used domestically
    strys.Q_U = (strys.M * strys.P_M + strys.Q_D * strys.P_D)/strys.P;
    
    % compute tax income of the government
    [strys,strpar, strexo] = TaxIncome(strys,strpar, strexo);  
    
    % define private net foreign asset position
    strys.B = -strys.NX/strys.rf-strys.BG;
    

    %% Households consumption level, FOC w.r.t housing and consumption
    strys.C = ((strys.P_D / strys.P * strys.Q - strys.NX - strys.Q_I  - strys.I - strys.wagetax  - strys.capitaltax + strys.rf * strys.BG - strys.Y * strexo.exo_DH * (1 + strys.tauH)) / (1 + strys.tauC)) / (1 + strpar.gamma_p/(1- strpar.gamma_p) * strpar.deltaH_p * strpar.beta_p / (1-strpar.beta_p*(1-strpar.deltaH_p)));
    
    if strpar.lEndogenousY_p == 0
        % house prices
        strys.PH = (strpar.gamma_p/(1 - strpar.gamma_p)  * strpar.beta_p / (1 - strpar.beta_p * (1 - strpar.deltaH_p)) * strys.C * strys.P * (1 + strys.tauC)) / (strys.H * (1 + strys.tauH));    
        
    else
        % housing stock
        strys.H  = (strpar.gamma_p/(1 - strpar.gamma_p)  * strpar.beta_p / (1 - strpar.beta_p * (1 - strpar.deltaH_p)) * strys.C * strys.P * (1 + strys.tauC)) / (strys.PH * (1 + strys.tauH));    
        
    end
    
    % Lagrange multiplier for the evolution of the household stock
    strys.omegaH = strys.PH * (1 + strys.tauH);
    
    % damages to the housing stock
    strys.DH = strexo.exo_DH * strys.Y .* strys.P  /strys.PH;
    
    % investments into the housing stock
    strys.IH = strpar.deltaH_p * strys.H + strys.DH;
    
    % Lagrange multiplier for the budget constraint
    strys.lambda = (1-strpar.gamma_p) * (strys.C/strys.PoP)^(-strpar.gamma_p) * (strys.H/strys.PoP)^strpar.gamma_p * ((strys.C/strys.PoP)^(1-strpar.gamma_p) * (strys.H/strys.PoP)^strpar.gamma_p)^(-strpar.sigmaC_p) / (strys.P * (1 + strys.tauC));
    

    %% government budget constraint
    if strpar.phiG_p > 0
        fval_vec_G = 1 - strys.G / ((strys.wagetax + strys.capitaltax + strys.tauC * strys.C + strys.tauH * strys.PH/strys.P * strys.IH) - strys.rf * strys.BG - strys.adaptationcost);
        
    else
        strys.G = (strys.wagetax + strys.capitaltax + strys.tauC * strys.C + strys.tauH * strys.PH/strys.P * strys.IH) - strys.rf * strys.BG - strys.adaptationcost;
        
        strys.KG = strys.G/strpar.deltaKG_p;
        
    end
    %% evaluate resiudals for: 
    % - HH FOC w.r.t. labour in each region and subsector
    % - Firms FOC w.r.t. intermediate goods in each region and subsector
    % - Export demand for each region and subsector

    strpar.sMaxsec = num2str(strpar.inbsectors_p);
    
    fval_vec_1 = nan(strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p,1);
    
    fval_vec_2 = nan(strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p,1);
    
    fval_vec_4 = nan(strpar.(['subend_' strpar.sMaxsec '_p']),1);
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        
        strys.(['omegaI_' ssec]) = strys.P;        

        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            
            lhs = strys.(['X_' ssubsec]);
            rhs = (strpar.(['D_X_' ssubsec '_p']) + strexo.(['exo_X_' ssubsec])) * (strys.(['P_D_' ssubsec])/strys.(['P_M_' ssubsec]))^(-strpar.etaX_p);
            fval_vec_4(icosubsec) = 1 - lhs/rhs;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
               
                icovec = icoreg + strpar.inbregions_p * (icosubsec-1);
                
                lhs = (1 - strys.tauNH) * strys.(['W_' ssubsec '_' sreg]) * strys.lambda;
                
                rhs = strpar.(['phiL_' ssubsec '_' sreg '_p']) * strys.(['A_N_' ssubsec '_' sreg]) * (strys.(['N_' ssubsec '_' sreg]))^(strpar.sigmaL_p);
                
                fval_vec_1(icovec) = 1 - lhs./rhs;
                
                lhs = strys.P / strys.(['P_D_' ssubsec '_' sreg]);
                
                rhs = (strpar.(['omegaQI_' ssubsec '_' sreg '_p']))^(1/strpar.(['etaI_' ssubsec '_p'])) * (strys.(['Q_I_' ssubsec '_' sreg])/strys.(['Q_' ssubsec '_' sreg]))^(-1/strpar.(['etaI_' ssubsec '_p']));
                
                fval_vec_2(icovec) = 1 - lhs./rhs;               
            end

        end
    end
    
    lhs = strys.P_M;
    
    rhs = strpar.omegaF_p^(1/strpar.etaF_p) * (strys.M/strys.Q_U)^(-1/strpar.etaF_p) * strys.P;
    
    fval_vec_3 = 1 - lhs./rhs;            
    
    if strpar.phiG_p > 0
        fval_vec = [fval_vec_1(:); fval_vec_2(:); fval_vec_3(:); fval_vec_G; fval_vec_4(:)];
        
    else
        fval_vec = [fval_vec_1(:); fval_vec_2(:); fval_vec_3(:); fval_vec_4(:)];
        
    end
    if strpar.lEndogenousY_p == 0
        % evaluation of the net export to gross value added ratio
        fval_vec_NX = strys.NX./strys.Y - strpar.NX0_p;
        
        fval_vec = [fval_vec; fval_vec_NX];
        
   end
end

function [strys, strpar, strexo] = Initialize_FindK_ExogenousY(strys, strpar, strexo, x, x_start_vec_1, x_start_vec_2);
    % function [fval_vec,strys] = 
    % Initialize_FindK_ExogenousY(strys, strpar, strexo, x, x_start_vec_1,
    %                             x_start_vec_2)
    % finds capital stock vector to fulfill the static equations of the 
    % model
    % Inputs: 
    %   - x         [vector]     vector of initial values for the steady
    %                            state of the regional and sectoral capital
    %                            stock
    %   - strys     [structure]  structure containing all endogeonous 
    %                            variables of the model
    %   - strexo    [structure]  structure containing all exogeonous 
    %                            variables of the model    
    %   - strpar    [structure]  structure containing all parameters of the
    %                            model
    %
    % Output: 
    %   - fval_vec  [vector]     residuals of regional and sector specific 
    %                            for FOC of Households with respect to 
    %                            regional labour
    %   - strys     [structure]  see inputs
    %   - strexo    [structure]  see inputs
    
    % terminal labour supply
    strys.N = strpar.NT_p;
    
    % terminal GDP
    strys.Y = strpar.YT_p;
    
    % init output
    strys.Q = 0;
    
    % init domestically used output
    strys.Q_D = 0;
    
    % imports
    strys.M = x((2*strpar.(['subend_' strpar.sMaxsec '_p'])*strpar.inbregions_p)+strpar.(['subend_' strpar.sMaxsec '_p'])+1) *strys.Y;
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        % init sectoral expenditure
        strpar.(['phiQA_' ssec '_p']) = 0;
        
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            
            % init sub-sectoral expenditure
            strpar.(['phiQ_' ssubsec '_p']) = 0;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                icovec = icoreg + (icosubsec-1)*strpar.inbregions_p;
                
                % labour 
                strys.(['N_' ssubsec '_' sreg]) = strpar.(['phiN_' ssubsec '_' sreg '_p']) * strpar.NT_p;
                
                % intermediate goods
                strys.(['Q_I_' ssubsec '_' sreg]) = sqrt(real(x_start_vec_2(icovec)).^2) * strpar.(['phiY_' ssubsec '_' sreg '_p']) * strys.Y;
                
                % sub-sectoral and regional expenditures
                strpar.(['phiQ_' ssubsec '_' sreg '_p']) = strys.P * strys.(['Q_I_' ssubsec '_' sreg]) + strpar.(['phiY_' ssubsec '_' sreg '_p']) * strys.Y * strys.P;                    
                
                % sub-sectoral expenditures
                strpar.(['phiQ_' ssubsec '_p']) = strpar.(['phiQ_' ssubsec '_p']) + strpar.(['phiQ_' ssubsec '_' sreg '_p']);
                
            end
            % aggregate total production
            strys.Q = strys.Q + strpar.(['phiQ_' ssubsec '_p']) / strys.P_D;
            
            % aggregate domestic total production
            strys.Q_D = strys.Q_D + strpar.(['phiQ_' ssubsec '_p']) * (1 - strys.(['D_X_' ssubsec])) / strys.P_D;
            
            % sectoral expenditure share
            strpar.(['phiQA_' ssec '_p']) = strpar.(['phiQA_' ssec '_p']) + strpar.(['phiQ_' ssubsec '_p']) * (1 - strys.(['D_X_' ssubsec]));
            
        end
    end
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);          
        
        % sectoral price level
        strys.(['P_A_' ssec]) = strpar.(['omegaQA_' ssec '_p'])^(1/(strpar.etaQ_p - 1)) * (strpar.(['phiQA_' ssec '_p'])/(strys.P_D * strys.Q_D))^(1/(1 - strpar.etaQ_p)) * strys.P_D;
        
        % sectoral output
        strys.(['Q_A_' ssec]) = strpar.(['phiQA_' ssec '_p']) / strys.(['P_A_' ssec]);
        
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
                        
            % subsectoral price level
            strys.(['P_D_' ssubsec]) = strpar.(['omegaQ_' ssubsec '_p'])^(1/(strpar.(['etaQA_' ssec '_p']) - 1)) * (strpar.(['phiQ_' ssubsec '_p']) * (1 - strys.(['D_X_' ssubsec]))/(strys.(['P_A_' ssec]) * strys.(['Q_A_' ssec])))^(1/(1 - strpar.(['etaQA_' ssec '_p']))) * strys.(['P_A_' ssec]);

            % subsectoral output
            strys.(['Q_D_' ssubsec]) = strpar.(['phiQ_' ssubsec '_p']) * (1 - strys.(['D_X_' ssubsec])) / strys.(['P_D_' ssubsec]);
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                % subsectoral regional price level
                strys.(['P_D_' ssubsec '_' sreg]) = strpar.(['omegaQ_' ssubsec '_' sreg '_p'])^(1/(strpar.(['etaQ_' ssubsec '_p'])-1)) * (strpar.(['phiQ_' ssubsec '_' sreg '_p'])/strpar.(['phiQ_' ssubsec '_p']))^(1/(1-strpar.(['etaQ_' ssubsec '_p']))) * strys.(['P_D_' ssubsec]);
                
                % subsectoral output
                strys.(['Q_' ssubsec '_' sreg]) = strpar.(['phiQ_' ssubsec '_' sreg '_p']) / strys.(['P_D_' ssubsec '_' sreg]);
                
                % subsectoral price level of primary production factors
                strys.(['P_' ssubsec '_' sreg]) = ((strys.(['P_D_' ssubsec '_' sreg])^(1 - strpar.(['etaI_' ssubsec '_p'])) - strpar.(['omegaQI_' ssubsec '_' sreg '_p']) * strys.P^(1 - strpar.(['etaI_' ssubsec '_p'])))/(1 - strpar.(['omegaQI_' ssubsec '_' sreg '_p'])))^(1/(1 - strpar.(['etaI_' ssubsec '_p'])));
                
                % subsectoral gross vlaue added
                strys.(['Y_' ssubsec '_' sreg]) = strpar.(['phiY_' ssubsec '_' sreg '_p']) * strys.Y * strys.P / strys.(['P_' ssubsec '_' sreg]);
                
                icovec = icoreg + (icosubsec-1)*strpar.inbregions_p;
                if strpar.(['etaNK_' ssubsec '_' sreg '_p']) ~= 1
                    % subsectoral regional capital stock
                    strys.(['K_' ssubsec '_' sreg]) = sqrt(real(x_start_vec_1(icovec)).^2) * strys.(['Y_' ssubsec '_' sreg]);
                    
                else
                    % subsectoral regional labour productivity
                    strys.(['A_N_' ssubsec '_' sreg]) = sqrt(real(x_start_vec_1(icovec)).^2);
                    
                end

            end
        end
    end
    if strpar.phiG_p > 0
        % init government expenditure
        strys.G = x(end-1) * strys.Y;
            
    end            
end


