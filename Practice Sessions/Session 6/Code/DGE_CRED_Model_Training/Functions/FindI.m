function [fval_vec,strys] = FindI(x,strys,strexo,strpar)
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
            icovec = icoreg + (icosec-1)*strpar.inbsectors_p;
            strys.(['I_' ssec '_' sreg]) = real(x(icovec));
        end
    end
    %% calculate exogenous variables
    strys.rf = 1/strpar.beta_p-1;
    for icoreg = 1:strpar.inbregions_p
        sreg = num2str(icoreg);
        strys.(['T_' sreg]) = strpar.(['T0_' sreg '_p']) + strexo.(['exo_T_' sreg]);
        strys.(['WS_' sreg]) = strpar.(['WS0_' sreg '_p']) + strexo.(['exo_WS_' sreg]);
        strys.(['PERC_' sreg]) = strpar.(['PERC0_' sreg '_p']) + strexo.(['exo_PERC_' sreg]);
    end
    strys.lambrf = 1;
    strys.SL = strpar.SL0_p + strexo.exo_SL;
    strys.PoP = strpar.PoP0_p * exp(strexo.exo_PoP);
    strys.P = exp(strexo.exo_P);
    %% calculate sectoral and regional production factors and output
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.(['A_Y_' ssec]) = strpar.(['A_Y_' ssec '_p']) * exp(strexo.(['exo_Y_' ssec]));
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            rhotemp = ((strpar.(['etaNK_' ssec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssec '_' sreg '_p']));
            strys.(['lambK_' ssec '_' sreg]) = 0;
            strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p)/(1 - strpar.tauK_p);
            strys.(['A_' ssec '_' sreg]) = strpar.(['A_' ssec '_' sreg '_p']) * exp(strexo.(['exo_' ssec '_' sreg]));
            strys.(['A_K_' ssec '_' sreg]) = strpar.(['A_K_' ssec '_' sreg '_p']) * exp(strexo.(['exo_K_' ssec '_' sreg]));
            strys.(['A_N_' ssec '_' sreg]) = strpar.(['A_N_' ssec '_' sreg '_p']) * exp(strexo.(['exo_N_' ssec '_' sreg]));
            strys.(['D_' ssec '_' sreg]) = strpar.(['a_T_1_' ssec '_' sreg '_p']) * strys.(['T_' sreg]) + strpar.(['a_T_2_' ssec '_' sreg '_p']) * strys.(['T_' sreg])^(strpar.(['a_T_3_' ssec '_' sreg '_p'])) + ...
            strpar.(['a_W_1_' ssec '_' sreg '_p']) * strys.(['WS_' sreg]) + strpar.(['a_W_2_' ssec '_' sreg '_p']) * strys.(['WS_' sreg])^(strpar.(['a_W_3_' ssec '_' sreg '_p'])) + ...
            strpar.(['a_P_1_' ssec '_' sreg '_p']) * strys.(['PERC_' sreg]) + strpar.(['a_P_2_' ssec '_' sreg '_p']) * strys.(['PERC_' sreg])^(strpar.(['a_P_3_' ssec '_' sreg '_p'])) + ...
            strpar.(['a_SL_1_' ssec '_' sreg '_p']) * strys.SL + strpar.(['a_SL_2_' ssec '_' sreg '_p']) * strys.SL^(strpar.(['a_SL_3_' ssec '_' sreg '_p']));
            temp = (((strys.(['r_' ssec '_' sreg])^strpar.(['etaNK_' ssec '_' sreg '_p']) / (strpar.(['alphaK_' ssec '_' sreg '_p']) * strys.(['A_K_' ssec '_' sreg])^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1) * strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg]))))^rhotemp - strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * strys.(['A_K_' ssec '_' sreg])^rhotemp)...
                       / strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])))^(1/rhotemp);
            strys.(['N_' ssec '_' sreg]) = temp * strys.(['K_' ssec '_' sreg]) / (strys.PoP .* strys.(['A_N_' ssec '_' sreg]));
            strys.(['Y_' ssec '_' sreg]) = strys.(['A_' ssec '_' sreg]) * (1 - strys.(['D_' ssec '_' sreg])) * (strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.(['A_K_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]))^rhotemp + strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.PoP * strys.(['A_N_' ssec '_' sreg]) * strys.(['N_' ssec '_' sreg]))^rhotemp)^(1/rhotemp);
        end
        strys.(['Y_' ssec]) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['Y_' ssec]) = strys.(['Y_' ssec]) + strpar.(['omega_' ssec '_' sreg '_p'])^(1/strpar.(['etaC_' ssec '_p'])) * (strys.(['Y_' ssec '_' sreg]))^((strpar.(['etaC_' ssec '_p'])-1)/strpar.(['etaC_' ssec '_p']));
        end
        strys.(['Y_' ssec]) = strys.(['Y_' ssec])^(strpar.(['etaC_' ssec '_p'])/(strpar.(['etaC_' ssec '_p'])-1));        
    end
    
    strys.Y = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.Y = strys.Y + strpar.(['omega_' ssec '_p'])^(1/strpar.etaC_p) * (strys.(['A_Y_' ssec]) * strys.(['Y_' ssec]))^((strpar.etaC_p-1)/strpar.etaC_p);
    end
    strys.Y = strys.Y^(strpar.etaC_p/(strpar.etaC_p-1));        
        
    %% calculate sectoral and regional price indices and sectoral aggregates
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.(['P_' ssec]) = strpar.(['omega_' ssec '_p'])^(1/strpar.etaC_p) * strys.(['A_Y_' ssec])^((strpar.etaC_p-1)/strpar.etaC_p) * (strys.(['Y_' ssec]) / strys.Y)^(-1/strpar.etaC_p) * strys.P;
        strys.(['N_' ssec]) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['P_' ssec '_' sreg]) = strpar.(['omega_' ssec '_' sreg '_p'])^(1/strpar.(['etaC_' ssec '_p'])) * (strys.(['Y_' ssec '_' sreg]) / strys.(['Y_' ssec]))^(-1/strpar.(['etaC_' ssec '_p'])) * strys.(['P_' ssec]);
            strys.(['W_' ssec '_' sreg]) = strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * ((strys.(['A_N_' ssec '_' sreg]) * strys.(['N_' ssec '_' sreg]) * strys.PoP) / strys.(['Y_' ssec '_' sreg]))^(-1/strpar.(['etaNK_' ssec '_' sreg '_p']))*strys.(['P_' ssec '_' sreg]);
            strys.(['N_' ssec]) = strys.(['N_' ssec]) + strys.(['N_' ssec '_' sreg]);               
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
    
    strys.wagebill = 0;
    strys.capitalbill = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.wagebill = strys.wagebill + strys.(['N_' ssec]) * strys.(['W_' ssec]);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.capitalbill = strys.capitalbill + strys.(['P_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]) * strys.(['r_' ssec '_' sreg]);
        end
    end
    strys.NX = strpar.omegaNX_p * strys.Y * exp(strexo.exo_NX);
    strys.B = -strys.NX/strys.rf;
    %strys.NX = -strys.B .*strys.rf;
    strys.BG = strexo.exo_BG;
    strys.I = strpar.delta_p * strys.K;

    strys.C = (strys.Y + strys.NX - strys.I - strpar.tauN_p * strys.wagebill / strys.P  - strpar.tauK_p * strys.capitalbill / strys.P + strys.rf * strys.BG) / (1 + strpar.tauC_p);
    strys.G = ((strpar.tauN_p * strys.wagebill + strpar.tauK_p * strys.capitalbill + strpar.tauC_p * strys.C * strys.P) - strys.rf * strys.BG * strys.P) / strys.P;
    %% evaluate resiudals of HH FOC w.r.t. labour in each region and sector
    fval_vec = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            icovec = icoreg + strpar.inbsectors_p * (icosec-1);
%             strys.(['omegaI_' ssec '_' sreg]) = (strys.P * strys.C/strys.PoP)^(-strpar.sigmaC_p)/((1 + strpar.tauC_p))*strys.(['P_' ssec '_' sreg]);
            strys.(['omegaI_' ssec '_' sreg]) = strys.(['P_' ssec '_' sreg]);
            strys.(['kappaI_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappaIprime_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappaIprimep1_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappap1I_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            lhs = (1 - strpar.tauN_p) * strys.(['W_' ssec '_' sreg]) * (strys.P * strys.C/strys.PoP)^(-strpar.sigmaC_p) / (1 + strpar.tauC_p);
            rhs = strpar.(['phiL_' ssec '_' sreg '_p']) * (strys.(['N_' ssec '_' sreg]))^(strpar.sigmaL_p);
            fval_vec(icovec) = lhs - rhs;
        end
    end
end