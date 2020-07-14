function [fval_vec,strpar,strys] = Calibration(x,strys,strexo,strpar)
    % function [ys,check] = Calibration(strys,strexo,strpar)
    % calibrates the parameters of the IWH_CRED_Model.mod
    % Inputs: 
    %   - strys     [structure]  structure containing all endogeonous variables of the model
    %   - strexo    [structure]  structure containing all exogeonous variables of the model    
    %   - strpar    [structure]  structure containing all parameters of the model
    %
    % Output: 
    %   - strys     [structure] see inputs

    %% calculate exogenous variables
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.(['A_Y_' ssec]) = 1;
        strpar.(['A_Y_' ssec '_p']) = strys.(['A_Y_' ssec]);
    end
    strys.Y = x;
    strys.P = x;
%     strys.Y = strpar.Y0_p./strys.P;
    strys.P = strpar.Y0_p./strys.Y;
    strpar.P0_p = strys.P / exp(strexo.exo_P);
    strys.rf = 1/strpar.beta_p-1;
    strys.SL = strpar.SL0_p + strexo.exo_SL;
    strys.Sf = 1;
    for icoreg = 1:strpar.inbregions_p
        sreg = num2str(icoreg);
        for sClimateVar = strpar.casClimatevars
            if isequal(char(sClimateVar), 'SL')
                strys.(char(sClimateVar)) = strpar.([char(sClimateVar) '0_p']) + strexo.(['exo_' char(sClimateVar)]);                
            else
                strys.([char(sClimateVar) sreg]) = strpar.([char(sClimateVar) '0_' sreg '_p']) + strexo.(['exo_' char(sClimateVar) '_' sreg]);
            end
        end
    end
    strys.PoP = strpar.PoP0_p + strexo.exo_PoP;
    strys.N = strpar.N0_p;
    strys.tauKH = strpar.tauKH_p + strexo.exo_tauKH;
    strys.tauNH = strpar.tauNH_p + strexo.exo_tauNH;
    strys.tauC = strpar.tauC_p + strexo.exo_tauC;
    %% calculate sectoral and regional production factors and output
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
%         strys.(['P_' ssec]) = x(icosec) * strys.P;
        strys.(['A_Y_' ssec]) = 1;
        strpar.(['A_Y_' ssec '_p']) = strys.(['A_Y_' ssec]);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            rhotemp = ((strpar.(['etaNK_' ssec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssec '_' sreg '_p']));
            strys.(['D_' ssec '_' sreg]) = 0;
            strys.(['D_N_' ssec '_' sreg]) = 0;
            strys.(['D_K_' ssec '_' sreg]) = 0;
            for sClimateVar = strpar.casClimatevars
                strys.(['K_A_' char(sClimateVar) '_' ssec '_' sreg]) = strexo.(['exo_GA_' char(sClimateVar) '_' ssec '_' sreg]);
                strys.(['G_A_' char(sClimateVar) '_' ssec '_' sreg]) = strpar.(['deltaKA' char(sClimateVar) '_' ssec '_' sreg '_p']) * strys.(['K_A_' char(sClimateVar) '_' ssec '_' sreg]);
                if isequal(char(sClimateVar), 'SL')
                    strys.(['D_' ssec '_' sreg]) = min(0.7,strys.(['D_' ssec '_' sreg])+...
                           (strpar.(['a_' char(sClimateVar) '_1_' ssec '_' sreg '_p']) * strys.(char(sClimateVar))...
                           + strpar.(['a_' char(sClimateVar) '_2_' ssec '_' sreg '_p']) * strys.(char(sClimateVar))^(strpar.(['a_' char(sClimateVar) '_3_' ssec '_' sreg '_p'])))...
                           * (strys.(char(sClimateVar)) > strys.(['K_A_' char(sClimateVar) '_' ssec '_' sreg])/strpar.(['phiGA' char(sClimateVar) '_' ssec '_' sreg '_p']))...
                           );
                    strys.(['D_N_' ssec '_' sreg]) = min(1,strys.(['D_N_' ssec '_' sreg]) + ...
                           strpar.(['aN_' char(sClimateVar) '_1_' ssec '_' sreg '_p']) * strys.(char(sClimateVar))...
                           + strpar.(['aN_' char(sClimateVar) '_2_' ssec '_' sreg '_p']) * strys.(char(sClimateVar))^(strpar.(['aN_' char(sClimateVar) '_3_' ssec '_' sreg '_p'])));

                    strys.(['D_K_' ssec '_' sreg]) = min(1,strys.(['D_K_' ssec '_' sreg]) + ...
                           strpar.(['aK_' char(sClimateVar) '_1_' ssec '_' sreg '_p']) * strys.(char(sClimateVar))...
                           + strpar.(['aK_' char(sClimateVar) '_2_' ssec '_' sreg '_p']) * strys.(char(sClimateVar))^(strpar.(['aK_' char(sClimateVar) '_3_' ssec '_' sreg '_p'])));                         
                           
                else
                    strys.(['D_' ssec '_' sreg]) = min(0.7,strys.(['D_' ssec '_' sreg])+...
                            (strpar.(['a_' char(sClimateVar) '_1_' ssec '_' sreg '_p']) * strys.([char(sClimateVar) '_' sreg])...
                            + strpar.(['a_' char(sClimateVar) '_2_' ssec '_' sreg '_p']) * strys.([char(sClimateVar) '_' sreg])^(strpar.(['a_' char(sClimateVar) '_3_' ssec '_' sreg '_p'])))...
                            * exp(-strpar.(['phiGA' char(sClimateVar) '_' ssec '_' sreg '_p']) * strys.(['K_A_' char(sClimateVar) '_' ssec '_' sreg]))...
                            );
                    strys.(['D_N_' ssec '_' sreg]) = min(1,strys.(['D_N_' ssec '_' sreg]) + ...
                            strpar.(['aN_' char(sClimateVar) '_1_' ssec '_' sreg '_p']) * strys.([char(sClimateVar) '_' sreg])...
                            + strpar.(['aN_' char(sClimateVar) '_2_' ssec '_' sreg '_p']) * strys.([char(sClimateVar) '_' sreg])^(strpar.(['aN_' char(sClimateVar) '_3_' ssec '_' sreg '_p']))...
                            );
                    strys.(['D_K_' ssec '_' sreg]) = min(1,strys.(['D_K_' ssec '_' sreg]) + ...
                            strpar.(['aK_' char(sClimateVar) '_1_' ssec '_' sreg '_p']) * strys.([char(sClimateVar) '_' sreg])...
                            + strpar.(['aK_' char(sClimateVar) '_2_' ssec '_' sreg '_p']) * strys.([char(sClimateVar) '_' sreg])^(strpar.(['aK_' char(sClimateVar) '_3_' ssec '_' sreg '_p']))...
                            );                                                       
                end
            end

            strys.(['tauKF_' ssec '_' sreg]) = strpar.(['tauKF_' ssec '_' sreg '_p']) + strexo.(['exo_tauKF_' ssec '_' sreg]);
            strys.(['tauNF_' ssec '_' sreg]) = strpar.(['tauNF_' ssec '_' sreg '_p']) + strexo.(['exo_tauNF_' ssec '_' sreg]);
            strpar.(['phiY_' ssec '_' sreg '_p']) = strpar.(['phiY0_' ssec '_' sreg '_p']);
            strpar.(['phiN_' ssec '_' sreg '_p']) = strpar.(['phiN0_' ssec '_' sreg '_p']);
            strys.(['A_N_' ssec '_' sreg]) = strpar.(['A_N_' ssec '_' sreg '_p']);
            strys.(['A_' ssec '_' sreg]) = strpar.(['A_' ssec '_' sreg '_p']);
            strys.(['A_K_' ssec '_' sreg]) = strpar.(['A_K_' ssec '_' sreg '_p']);

            strys.(['N_' ssec '_' sreg]) = strpar.(['phiN_' ssec '_' sreg '_p']) * strys.N;
            strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p + strys.(['D_K_' ssec '_' sreg]))/(1 - strys.tauKH);
            rkgross = strys.(['r_' ssec '_' sreg]) * (1 + strys.(['tauKF_' ssec '_' sreg]));
            wtemp = ((strys.(['A_' ssec '_' sreg])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) - (1 - strpar.(['phiW_' ssec '_' sreg '_p'])) * rkgross^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1)) / strpar.(['phiW_' ssec '_' sreg '_p']))^(1/(strpar.(['etaNK_' ssec '_' sreg '_p'])-1)) * strys.(['A_N_' ssec '_' sreg]) * (1 -  strys.(['D_N_' ssec '_' sreg]));
            strpar.(['alphaK_' ssec '_' sreg '_p']) = (1 - strpar.(['phiW_' ssec '_' sreg '_p'])) * (rkgross/strys.(['A_' ssec '_' sreg]))^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1);
            strpar.(['alphaN_' ssec '_' sreg '_p']) = strpar.(['phiW_' ssec '_' sreg '_p']) *  (wtemp/(((1 - strys.(['D_N_' ssec '_' sreg])) * strys.(['A_N_' ssec '_' sreg])) * strys.(['A_' ssec '_' sreg])))^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1);		
            strys.(['P_' ssec '_' sreg]) = strpar.(['phiW_' ssec '_' sreg '_p'])/wtemp * strpar.(['phiY_' ssec '_' sreg '_p']) * strys.Y *strys.P / (strys.PoP * strys.(['N_' ssec '_' sreg]));

            strys.(['K_' ssec '_' sreg]) = strpar.(['alphaK_' ssec '_' sreg '_p']) / (strpar.(['alphaN_' ssec '_' sreg '_p']) * strys.(['A_N_' ssec '_' sreg])^(rhotemp * strpar.(['etaNK_' ssec '_' sreg '_p']))) * (rkgross/wtemp)^(-strpar.(['etaNK_' ssec '_' sreg '_p'])) * strys.PoP * strys.(['N_' ssec '_' sreg]);
            strys.(['Y_' ssec '_' sreg]) = wtemp * strys.PoP * strys.(['N_' ssec '_' sreg]) + rkgross * strys.(['K_' ssec '_' sreg]);
            strys.(['W_' ssec '_' sreg]) = strpar.(['phiW_' ssec '_' sreg '_p']) * strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg]) / (strys.PoP * strys.(['N_' ssec '_' sreg]) * (1 + strys.(['tauNF_' ssec '_' sreg])));                         
            
            temp = (strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.(['A_K_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]))^(rhotemp) + strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.PoP * strys.(['A_N_' ssec '_' sreg]) * (1 - strys.(['D_N_' ssec '_' sreg])) * strys.(['N_' ssec '_' sreg]))^(rhotemp))^(1/rhotemp);
            strys.(['A_' ssec '_' sreg]) = strys.(['Y_' ssec '_' sreg]) / ((1 - strys.(['D_' ssec '_' sreg])) * temp);
            strys.(['gA_' ssec '_' sreg]) = 1;
            strpar.(['A_N_' ssec '_' sreg '_p']) = strys.(['A_N_' ssec '_' sreg]) ./ exp(strexo.(['exo_N_' ssec '_' sreg]));
            strys.(['I_' ssec '_' sreg]) = (strpar.delta_p + strys.(['D_K_' ssec '_' sreg])) * strys.(['K_' ssec '_' sreg]);
        end
    end
    
        
    %% calculate sectoral and regional price indices and sectoral aggregates
    rhs_vec = zeros(strpar.inbsectors_p, 1);
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.(['N_' ssec]) = 0;
        strys.(['P_' ssec]) = 0;
        strys.(['Y_' ssec]) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            temp= 0;
            tempdenom = (strys.(['P_' ssec '_' sreg]) /((strys.(['Y_' ssec '_' sreg]))^(-1/strpar.(['etaQ_' ssec '_p']))))^(strpar.(['etaQ_' ssec '_p']));
            for icoregm = 1:strpar.inbregions_p
                sregm = num2str(icoregm);
                tempnum = (strys.(['P_' ssec '_' sregm]) /((strys.(['Y_' ssec '_' sregm]))^(-1/strpar.(['etaQ_' ssec '_p']))))^(strpar.(['etaQ_' ssec '_p']));
                temp = temp + tempnum / tempdenom;
            end
            strpar.(['omegaQ_' ssec '_' sreg '_p']) = 1/temp;
            strys.(['N_' ssec]) = strys.(['N_' ssec]) + strys.(['N_' ssec '_' sreg]);               
            strys.(['P_' ssec]) = strys.(['P_' ssec]) + strpar.(['omegaQ_' ssec '_' sreg '_p']) * strys.(['P_' ssec '_' sreg])^(1 - strpar.(['etaQ_' ssec '_p']));
            rhs_vec(icosec) = rhs_vec(icosec) + strpar.(['omegaQ_' ssec '_' sreg '_p']) * strys.(['P_' ssec '_' sreg])^(1 - strpar.(['etaQ_' ssec '_p']));
        end
        strys.(['P_' ssec]) = strys.(['P_' ssec])^(1/(1 - strpar.(['etaQ_' ssec '_p'])));
        rhs_vec(icosec) = rhs_vec(icosec)^(1/(1 - strpar.(['etaQ_' ssec '_p'])));
        strys.(['Y_' ssec]) = 0;
        rhs_vec(icosec) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['Y_' ssec]) = strys.(['Y_' ssec]) + strpar.(['omegaQ_' ssec '_' sreg '_p'])^(1/strpar.(['etaQ_' ssec '_p'])) * (strys.(['Y_' ssec '_' sreg]))^((strpar.(['etaQ_' ssec '_p'])-1)/strpar.(['etaQ_' ssec '_p']));
        end
        strys.(['Y_' ssec]) = strys.(['Y_' ssec])^(strpar.(['etaQ_' ssec '_p'])/(strpar.(['etaQ_' ssec '_p'])-1));
    end
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        temp= 0;
        tempdenom = (strys.(['P_' ssec]) /((strys.(['Y_' ssec]))^(-1/strpar.etaQ_p)))^(strpar.etaQ_p);
        for icosecm = 1:strpar.inbsectors_p
            ssecm = num2str(icosecm);
            tempnum = (strys.(['P_' ssecm]) /((strys.(['Y_' ssecm]))^(-1/strpar.etaQ_p)))^(strpar.etaQ_p);
            temp = temp + tempnum / tempdenom;
        end
        strpar.(['omegaQ_' ssec '_p']) = 1/temp;
        strys.(['I_' ssec]) = 0;
        strys.(['K_' ssec]) = 0;
        strys.(['W_' ssec]) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['I_' ssec]) = strys.(['I_' ssec]) + strys.(['P_' ssec '_' sreg]) / strys.(['P_' ssec]) * strys.(['I_' ssec '_' sreg]) ;
            strys.(['K_' ssec]) = strys.(['K_' ssec]) + strys.(['P_' ssec '_' sreg]) / strys.(['P_' ssec]) * strys.(['K_' ssec '_' sreg]) ;
            strys.(['W_' ssec]) = strys.(['W_' ssec]) + strys.(['N_' ssec '_' sreg]) / strys.(['N_' ssec]) * strys.(['W_' ssec '_' sreg]) ;               
        end
    end
    %% compute aggregates
    strys.I = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.I = strys.I + strys.(['P_' num2str(icosec)]) * strys.(['I_' num2str(icosec)])/strys.P;
    end
    
    strys.K = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.K = strys.K + strys.(['P_' num2str(icosec)]) * strys.(['K_' num2str(icosec)])/strys.P;
    end
    
    strys.Y = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.Y = strys.Y + strys.(['P_' num2str(icosec)]) * strys.(['Y_' num2str(icosec)])/strys.P;
    end
    
    strys.N = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.N = strys.N + strys.(['N_' num2str(icosec)]);
    end
    
    strys.wagetax = 0;
    strys.capitaltax = 0;
    strys.adaptationcost = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.wagetax = strys.wagetax + strys.(['W_' ssec '_' sreg]) * strys.(['N_' ssec '_' sreg]) * strys.PoP ./strys.P * (strys.tauNH + strys.(['tauNF_' ssec '_' sreg]));
            strys.capitaltax = strys.capitaltax + strys.(['P_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]) * strys.(['r_' ssec '_' sreg])./strys.P * (strys.tauKH + strys.(['tauKF_' ssec '_' sreg]));
            for sClimateVar = strpar.casClimatevars            
                strys.adaptationcost = strys.adaptationcost + strys.(['G_A_' char(sClimateVar) '_' ssec '_' sreg]);
            end
        end
    end
    strys.NX = strpar.omegaNX_p * strys.Y * strys.P * exp(strexo.exo_NX);
    strys.B = -strys.NX/strys.rf;
    strys.BG = strexo.exo_BG;
    strys.I = strpar.delta_p * strys.K;

    strys.C = (strys.Y - strys.NX - strys.I - strys.wagetax  - strys.capitaltax + strys.rf * strys.BG) / (1 + strys.tauC);
    strys.G = (strys.wagetax + strys.capitaltax + strys.tauC * strys.C) - strys.rf * strys.BG - strys.adaptationcost;
    strys.KG = strys.G / strpar.deltaKG_p;
    %% compute labour disutlity parameters
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strpar.(['A_' ssec '_' sreg '_p']) = strys.(['A_' ssec '_' sreg]) ./ (strys.KG^strpar.phiG_p * exp(strexo.(['exo_' ssec '_' sreg])));
            strys.(['omegaI_' ssec '_' sreg]) = strys.(['P_' ssec '_' sreg]);
            strys.(['kappaI_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappaIprime_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappaIprimep1_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappap1I_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            lhs = (1 - strys.tauNH) * strys.(['W_' ssec '_' sreg]) * (strys.C/strys.PoP)^(-strpar.sigmaC_p) / (strys.P*(1 + strys.tauC));
            strpar.(['phiL_' ssec '_' sreg '_p']) =  lhs / ((strys.(['N_' ssec '_' sreg]))^(strpar.sigmaL_p) * strys.(['A_N_' ssec '_' sreg]));
        end
    end
    %% check initial value of output and implied one
    fval_vec = zeros(strpar.inbsectors_p, 1);
    Y_temp = 0;
    P_temp = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        Y_temp = Y_temp + strpar.(['omegaQ_' ssec '_p'])^(1/strpar.etaQ_p) * (strys.(['Y_' ssec]))^((strpar.etaQ_p-1)/strpar.etaQ_p);
        P_temp = P_temp + strpar.(['omegaQ_' ssec '_p']) * (strys.(['P_' ssec]))^(1-strpar.etaQ_p);
        rhs = strpar.(['omegaQ_' ssec '_p'])^(1/strpar.etaQ_p) * (strys.(['Y_' ssec])/strys.Y)^(-1/strpar.etaQ_p) * strys.P;
        fval_vec(icosec) = 1 - strys.(['P_' ssec])./rhs;
    end
    Y_temp = Y_temp^(strpar.etaQ_p/(strpar.etaQ_p - 1));
    fval_vec = 1 - strys.Y/Y_temp;
    
end