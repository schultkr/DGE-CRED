function [fval_vec,strys,strexo] = FindK(x,strys,strexo,strpar)
    % function [fval_vec,strys] = FindK(x,strys,strexo,strpar)
    % finds capital stock vector to fulfill thestatic equations of the 
    % model
    % Inputs: 
    %   - x         [vector]     vector of initial values for the steady state of
    %                           the regional and sctoral capital stock
    %   - strys     [structure]  structure containing all endogeonous variables of the model
    %   - strexo    [structure]  structure containing all exogeonous variables of the model    
    %   - strpar    [structure]  structure containing all parameters of the model
    %
    % Output: 
    %   - fval_vec  [vector] residuals of regional and sector specific for
    %                        FOC of Households with respect to regional labour
    %   - strys     [structure] see inputs

    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            icovec = icoreg + (icosec-1)*strpar.inbregions_p;
            strys.(['K_' ssec '_' sreg]) = sqrt(real(x(icovec)).^2);
        end
    end
    %% calculate exogenous variables
    strys.rf = 1/strpar.beta_p-1;
    for icoreg = 1:strpar.inbregions_p
        sreg = num2str(icoreg);
        strys.(['T_' sreg]) = strpar.(['T0_' sreg '_p']) + strexo.(['exo_T_' sreg]);
        strys.(['WS_' sreg]) = strpar.(['WS0_' sreg '_p']) + strexo.(['exo_WS_' sreg]);
        strys.(['PREC_' sreg]) = strpar.(['PREC0_' sreg '_p']) + strexo.(['exo_PREC_' sreg]);
		strys.(['CYC_' sreg]) = strpar.(['CYC0_' sreg '_p']) + strexo.(['exo_CYC_' sreg]);
		strys.(['DRO_' sreg]) = strpar.(['DRO0_' sreg '_p']) + strexo.(['exo_DRO_' sreg]);
    end
    strys.lambrf = 1;
    temp = 0;
    if strpar.lCalibration_p == 2
        strexo.exo_PoP = log(strpar.PoPT_p / strpar.PoP0_p);
        strys.N = strpar.NT_p;
        for icosec = 1:strpar.inbsectors_p
            ssec = num2str(icosec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                strys.(['N_' ssec '_' sreg]) = strpar.(['phiN_' ssec '_' sreg '_p']) * strpar.NT_p;
                temp = temp + strpar.(['phiN_' ssec '_' sreg '_p']);
            end
        end
    end

    strys.Sf = 1;
    strys.SL = strpar.SL0_p + strexo.exo_SL;
    strys.PoP = strpar.PoP0_p + strexo.exo_PoP;
    strys.P = strpar.P0_p*exp(strexo.exo_P);
    %% calculate sectoral and regional production factors and output
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['tauK_' ssec '_' sreg]) = strpar.(['tauK_' ssec '_' sreg '_p']) + strexo.(['exo_tauK_' ssec '_' sreg]);
            strys.(['tauN_' ssec '_' sreg]) = strpar.(['tauN_' ssec '_' sreg '_p']) + strexo.(['exo_tauN_' ssec '_' sreg]);
            rhotemp = ((strpar.(['etaNK_' ssec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssec '_' sreg '_p']));
            strys.(['lambK_' ssec '_' sreg]) = 0;
            strys.(['A_' ssec '_' sreg]) = strpar.(['A_' ssec '_' sreg '_p']) * exp(strexo.(['exo_' ssec '_' sreg]));
            strys.(['gA_' ssec '_' sreg]) = 1;
            strys.(['A_K_' ssec '_' sreg]) = strpar.(['A_K_' ssec '_' sreg '_p']) * exp(strexo.(['exo_K_' ssec '_' sreg]));
            strys.(['A_N_' ssec '_' sreg]) = strpar.(['A_N_' ssec '_' sreg '_p']) * exp(strexo.(['exo_N_' ssec '_' sreg]));
            if strpar.lCalibration_p == 3
                strys.(['G_A_' ssec '_' sreg]) = strpar.(['GAT_' ssec '_' sreg '_p']);
                strexo.(['exo_GA_' ssec '_' sreg]) = strys.(['G_A_' ssec '_' sreg]);            
            else
                strys.(['G_A_' ssec '_' sreg]) = strexo.(['exo_GA_' ssec '_' sreg]);
            end
            strys.(['D_' ssec '_' sreg]) = min(0.7,strpar.(['a_T_1_' ssec '_' sreg '_p']) * strys.(['T_' sreg]) + strpar.(['a_T_2_' ssec '_' sreg '_p']) * strys.(['T_' sreg])^(strpar.(['a_T_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['a_W_1_' ssec '_' sreg '_p']) * strys.(['WS_' sreg]) + strpar.(['a_W_2_' ssec '_' sreg '_p']) * strys.(['WS_' sreg])^(strpar.(['a_W_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['a_P_1_' ssec '_' sreg '_p']) * strys.(['PREC_' sreg]) + strpar.(['a_P_2_' ssec '_' sreg '_p']) * strys.(['PREC_' sreg])^(strpar.(['a_P_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['a_SL_1_' ssec '_' sreg '_p']) * strys.SL + strpar.(['a_SL_2_' ssec '_' sreg '_p']) * strys.SL^(strpar.(['a_SL_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['a_DR_1_' ssec '_' sreg '_p']) * strys.(['DRO_' sreg]) + strpar.(['a_DR_2_' ssec '_' sreg '_p']) * strys.(['DRO_' sreg])^(strpar.(['a_DR_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['a_CY_1_' ssec '_' sreg '_p']) * strys.(['CYC_' sreg]) + strpar.(['a_CY_2_' ssec '_' sreg '_p']) * strys.(['CYC_' sreg])^(strpar.(['a_CY_3_' ssec '_' sreg '_p']))) * exp(-strpar.(['phiGA_' ssec '_' sreg '_p']) * strys.(['G_A_' ssec '_' sreg]));

            strys.(['D_N_' ssec '_' sreg]) = min(1,strpar.(['aN_T_1_' ssec '_' sreg '_p']) * strys.(['T_' sreg]) + strpar.(['aN_T_2_' ssec '_' sreg '_p']) * strys.(['T_' sreg])^(strpar.(['aN_T_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aN_W_1_' ssec '_' sreg '_p']) * strys.(['WS_' sreg]) + strpar.(['aN_W_2_' ssec '_' sreg '_p']) * strys.(['WS_' sreg])^(strpar.(['aN_W_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aN_P_1_' ssec '_' sreg '_p']) * strys.(['PREC_' sreg]) + strpar.(['aN_P_2_' ssec '_' sreg '_p']) * strys.(['PREC_' sreg])^(strpar.(['aN_P_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aN_SL_1_' ssec '_' sreg '_p']) * strys.SL + strpar.(['aN_SL_2_' ssec '_' sreg '_p']) * strys.SL^(strpar.(['aN_SL_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aN_DR_1_' ssec '_' sreg '_p']) * strys.(['DRO_' sreg]) + strpar.(['aN_DR_2_' ssec '_' sreg '_p']) * strys.(['DRO_' sreg])^(strpar.(['aN_DR_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aN_CY_1_' ssec '_' sreg '_p']) * strys.(['CYC_' sreg]) + strpar.(['aN_CY_2_' ssec '_' sreg '_p']) * strys.(['CYC_' sreg])^(strpar.(['aN_CY_3_' ssec '_' sreg '_p']))) * exp(-strpar.(['phiGA_' ssec '_' sreg '_p']) * strys.(['G_A_' ssec '_' sreg]));         
                       
            strys.(['D_K_' ssec '_' sreg]) = min(1,strpar.(['aK_T_1_' ssec '_' sreg '_p']) * strys.(['T_' sreg]) + strpar.(['aK_T_2_' ssec '_' sreg '_p']) * strys.(['T_' sreg])^(strpar.(['aK_T_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aK_W_1_' ssec '_' sreg '_p']) * strys.(['WS_' sreg]) + strpar.(['aK_W_2_' ssec '_' sreg '_p']) * strys.(['WS_' sreg])^(strpar.(['aK_W_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aK_P_1_' ssec '_' sreg '_p']) * strys.(['PREC_' sreg]) + strpar.(['aK_P_2_' ssec '_' sreg '_p']) * strys.(['PREC_' sreg])^(strpar.(['aK_P_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aK_SL_1_' ssec '_' sreg '_p']) * strys.SL + strpar.(['aK_SL_2_' ssec '_' sreg '_p']) * strys.SL^(strpar.(['aK_SL_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aK_DR_1_' ssec '_' sreg '_p']) * strys.(['DRO_' sreg]) + strpar.(['aK_DR_2_' ssec '_' sreg '_p']) * strys.(['DRO_' sreg])^(strpar.(['aK_DR_3_' ssec '_' sreg '_p'])) + ...
                           strpar.(['aK_CY_1_' ssec '_' sreg '_p']) * strys.(['CYC_' sreg]) + strpar.(['aK_CY_2_' ssec '_' sreg '_p']) * strys.(['CYC_' sreg])^(strpar.(['aK_CY_3_' ssec '_' sreg '_p']))) * exp(-strpar.(['phiGA_' ssec '_' sreg '_p']) * strys.(['G_A_' ssec '_' sreg]));                                                          
        
            strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p + strys.(['D_K_' ssec '_' sreg]))/(1 - strpar.tauK_p);
            rkgross = strys.(['r_' ssec '_' sreg]) * (1 + strys.(['tauK_' ssec '_' sreg]));                
            if strpar.lCalibration_p == 2
                temp1 = (strys.(['K_' ssec '_' sreg]) * rkgross^strpar.(['etaNK_' ssec '_' sreg '_p']) / (strpar.(['alphaK_' ssec '_' sreg '_p']) * strys.(['A_K_' ssec '_' sreg])^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1) * (strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg])))^(strpar.(['etaNK_' ssec '_' sreg '_p']))))^rhotemp;
                temp2 = strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * strys.(['A_K_' ssec '_' sreg])^rhotemp * strys.(['K_' ssec '_' sreg])^rhotemp;
                temp = ((temp1 - temp2) / (strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.PoP .* strys.(['N_' ssec '_' sreg]))^rhotemp))^(1/rhotemp);
                strys.(['A_N_' ssec '_' sreg]) = temp / (1 - strys.(['D_N_' ssec '_' sreg]));
                strexo.(['exo_N_' ssec '_' sreg]) = log(strys.(['A_N_' ssec '_' sreg])/strpar.(['A_N_' ssec '_' sreg '_p']));
            else
                temp1 = (strys.(['K_' ssec '_' sreg]) * rkgross^strpar.(['etaNK_' ssec '_' sreg '_p']) / (strpar.(['alphaK_' ssec '_' sreg '_p']) * strys.(['A_K_' ssec '_' sreg])^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1) * (strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg])))^(strpar.(['etaNK_' ssec '_' sreg '_p']))))^rhotemp;
                temp2 = strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * strys.(['A_K_' ssec '_' sreg])^rhotemp * strys.(['K_' ssec '_' sreg])^rhotemp;
                temp = ((temp1 - temp2) / (strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p']))))^(1/rhotemp);
                strys.(['N_' ssec '_' sreg]) = temp / (strys.PoP * (1 - strys.(['D_N_' ssec '_' sreg])) * strys.(['A_N_' ssec '_' sreg]));
            end
            strys.(['Y_' ssec '_' sreg]) = strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg])) * (strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.(['A_K_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]))^rhotemp + (strpar.(['alphaN_' ssec '_' sreg '_p']))^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.PoP * strys.(['N_' ssec '_' sreg]) * strys.(['A_N_' ssec '_' sreg]) * (1 - strys.(['D_N_' ssec '_' sreg])))^rhotemp)^(1/rhotemp);
            strys.(['I_' ssec '_' sreg]) = (strpar.delta_p + strys.(['D_K_' ssec '_' sreg])) * strys.(['K_' ssec '_' sreg]);
        end
        strys.(['Y_' ssec]) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['Y_' ssec]) = strys.(['Y_' ssec]) + strpar.(['omegaQ_' ssec '_' sreg '_p'])^(1/strpar.(['etaQ_' ssec '_p'])) * (strys.(['Y_' ssec '_' sreg]))^((strpar.(['etaQ_' ssec '_p'])-1)/strpar.(['etaQ_' ssec '_p']));
        end
        strys.(['Y_' ssec]) = strys.(['Y_' ssec])^(strpar.(['etaQ_' ssec '_p'])/(strpar.(['etaQ_' ssec '_p'])-1));        
    end
    
    strys.Y = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.Y = strys.Y + strpar.(['omegaQ_' ssec '_p'])^(1/strpar.etaQ_p) * (strys.(['Y_' ssec]))^((strpar.etaQ_p-1)/strpar.etaQ_p);
    end
    strys.Y = strys.Y^(strpar.etaQ_p/(strpar.etaQ_p-1));        
        
    %% calculate sectoral and regional price indices and sectoral aggregates
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.(['P_' ssec]) = strpar.(['omegaQ_' ssec '_p'])^(1/strpar.etaQ_p) * (strys.(['Y_' ssec]) / strys.Y)^(-1/strpar.etaQ_p) * strys.P;
        strys.(['N_' ssec]) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            rhotemp = ((strpar.(['etaNK_' ssec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssec '_' sreg '_p']));
            strys.(['P_' ssec '_' sreg]) = strpar.(['omegaQ_' ssec '_' sreg '_p'])^(1/strpar.(['etaQ_' ssec '_p'])) * (strys.(['Y_' ssec '_' sreg]) / strys.(['Y_' ssec]))^(-1/strpar.(['etaQ_' ssec '_p'])) * strys.(['P_' ssec]);
            strys.(['W_' ssec '_' sreg]) = strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg])))^rhotemp * (strys.(['A_N_' ssec '_' sreg]) * (1 - strys.(['D_N_' ssec '_' sreg])))^rhotemp * ((strys.(['N_' ssec '_' sreg])  * strys.PoP) / strys.(['Y_' ssec '_' sreg]))^(-1/strpar.(['etaNK_' ssec '_' sreg '_p']))*strys.(['P_' ssec '_' sreg]) / (1 + strys.(['tauN_' ssec '_' sreg]));
            strys.(['N_' ssec]) = strys.(['N_' ssec]) + strys.(['N_' ssec '_' sreg]);               
            strys.(['Ptest_' ssec '_' sreg]) = (strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg])))^(-1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strpar.(['alphaK_' ssec '_' sreg '_p']) * (strys.(['r_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg]))^(1 - strpar.(['etaNK_' ssec '_' sreg '_p'])) + strpar.(['alphaN_' ssec '_' sreg '_p']) * strys.(['W_' ssec '_' sreg])^(1 - strpar.(['etaNK_' ssec '_' sreg '_p'])))^(1/(1 - strpar.(['etaNK_' ssec '_' sreg '_p'])));
        end
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
        strys.I = strys.I + strys.(['P_' num2str(icosec)]) * strys.(['I_' num2str(icosec)]) / strys.P;
    end
    
    strys.K = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.K = strys.K + strys.(['P_' num2str(icosec)]) * strys.(['K_' num2str(icosec)]) / strys.P;
    end
    
    strys.Y = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.Y = strys.Y + strys.(['P_' num2str(icosec)]) * strys.(['Y_' num2str(icosec)]) / strys.P;
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
            strys.wagetax = strys.wagetax + strys.(['W_' ssec '_' sreg]) * strys.(['N_' ssec '_' sreg]) * strys.(['A_N_' ssec '_' sreg]) * (1 - strys.(['D_N_' ssec '_' sreg])) * strys.PoP /strys.P * (strpar.tauN_p + strys.(['tauN_' ssec '_' sreg]));
            strys.capitaltax = strys.capitaltax + strys.(['P_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]) * strys.(['r_' ssec '_' sreg])./strys.P * (strpar.tauK_p + strys.(['tauK_' ssec '_' sreg]));
            strys.adaptationcost = strys.adaptationcost + strys.(['G_A_' ssec '_' sreg]);
        end
    end
    strys.NX = strpar.omegaNX_p * strys.Y * strys.P * exp(strexo.exo_NX);
    strys.B = -strys.NX/strys.rf;
    strys.BG = strexo.exo_BG;
    strys.lambrf = 1;

    strys.C = (strys.Y - strys.NX - strys.I - strys.wagetax  - strys.capitaltax + strys.rf * strys.BG) / (1 + strpar.tauC_p);
    strys.G = (strys.wagetax + strys.capitaltax + strpar.tauC_p * strys.C) - strys.rf * strys.BG - strys.adaptationcost;
    %% evaluate resiudals of HH FOC w.r.t. labour in each region and sector
    fval_vec = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            icovec = icoreg + strpar.inbregions_p * (icosec-1);
            strys.(['omegaI_' ssec '_' sreg]) = strys.(['P_' ssec '_' sreg]);
            strys.(['kappaI_' ssec '_' sreg]) = 0;
            strys.(['kappaIprime_' ssec '_' sreg]) = 0;
            strys.(['kappaIprimep1_' ssec '_' sreg]) = 0;
            strys.(['kappap1I_' ssec '_' sreg]) = 0;
            lhs = (1 - strpar.tauN_p) * strys.(['W_' ssec '_' sreg]) * (strys.C/strys.PoP)^(-strpar.sigmaC_p) / (strys.P*(1 + strpar.tauC_p));
            rhs = strpar.(['phiL_' ssec '_' sreg '_p']) * strys.(['A_N_' ssec '_' sreg]) * (strys.(['N_' ssec '_' sreg]))^(strpar.sigmaL_p);
            fval_vec(icovec) = 1 - lhs./rhs;
        end
    end
end