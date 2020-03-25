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
    strys.P = x;
    strpar.P0_p = strys.P / exp(strexo.exo_P);
    strys.Y = strpar.Y0_p./strys.P;
    strys.rf = 1/strpar.beta_p-1;
    strys.SL = strpar.SL0_p + strexo.exo_SL;
    strys.Sf = 1;
    for icoreg = 1:strpar.inbregions_p
        sreg = num2str(icoreg);
        strys.(['T_' sreg]) = strpar.(['T0_' sreg '_p']) + strexo.(['exo_T_' sreg]);
        strys.(['WS_' sreg]) = strpar.(['WS0_' sreg '_p']) + strexo.(['exo_WS_' sreg]);
        strys.(['PERC_' sreg]) = strpar.(['PERC0_' sreg '_p']) + strexo.(['exo_PERC_' sreg]);
    end
    strys.PoP = strpar.PoP0_p * exp(strexo.exo_PoP);
    strys.N = strpar.N0_p;
    %% calculate sectoral and regional production factors and output
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
%         strys.(['P_' ssec]) = x(icosec) * strys.P;
        strys.(['A_Y_' ssec]) = 1;
        strpar.(['A_Y_' ssec '_p']) = strys.(['A_Y_' ssec]);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['A_N_' ssec '_' sreg]) = 1;
            strys.(['A_K_' ssec '_' sreg]) = 1;
            strpar.(['A_N_' ssec '_' sreg '_p']) = strys.(['A_N_' ssec '_' sreg]);
            strpar.(['A_K_' ssec '_' sreg '_p']) = strys.(['A_K_' ssec '_' sreg]);
            strys.(['G_A' ssec '_' sreg]) = strexo.(['exo_GA_' ssec '_' sreg]);
%             strys.(['P_' ssec '_' sreg]) = strpar.(['phiP_' ssec '_' sreg '_p']) * strys.(['P_' ssec]);
%             strys.(['Y_' ssec '_' sreg]) = strpar.(['phiY_' ssec '_' sreg '_p']) * strys.Y *strys.P / strys.(['P_' ssec '_' sreg]);
            strys.(['N_' ssec '_' sreg]) = strpar.(['phiN_' ssec '_' sreg '_p']) * strys.N;
                        strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p)/(1 - strpar.tauK_p);
            wtemp = ((1 - (1 - strpar.(['phiW_' ssec '_' sreg '_p'])) * strys.(['r_' ssec '_' sreg])^(strpar.(['etaNK_' ssec '_' sreg '_p'])-1)) / strpar.(['phiW_' ssec '_' sreg '_p']))^(1/(strpar.(['etaNK_' ssec '_' sreg '_p'])-1));
            strys.(['P_' ssec '_' sreg]) = strpar.(['phiW_' ssec '_' sreg '_p'])/wtemp * strpar.(['phiY_' ssec '_' sreg '_p']) * strys.Y *strys.P / (strys.PoP * strys.(['N_' ssec '_' sreg]));
            strys.(['Y_' ssec '_' sreg]) = strpar.(['phiY_' ssec '_' sreg '_p']) * strys.Y *strys.P / strys.(['P_' ssec '_' sreg]);
            strys.(['K_' ssec '_' sreg]) = (1 - strpar.(['phiW_' ssec '_' sreg '_p'])) * strys.(['Y_' ssec '_' sreg]) / strys.(['r_' ssec '_' sreg]);
            tempK = strys.(['r_' ssec '_' sreg])^strpar.(['etaNK_' ssec '_' sreg '_p']) * strys.(['K_' ssec '_' sreg]);
            tempN = (strys.(['W_' ssec '_' sreg])/ strys.(['P_' ssec '_' sreg]))^strpar.(['etaNK_' ssec '_' sreg '_p']) * strys.PoP * strys.(['N_' ssec '_' sreg]);
            strpar.(['alphaK_' ssec '_' sreg '_p']) = tempK / (tempN + tempK);
            strpar.(['alphaN_' ssec '_' sreg '_p']) = tempN / (tempN + tempK);
            strys.(['W_' ssec '_' sreg]) = strpar.(['phiW_' ssec '_' sreg '_p']) * strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg]) / (strys.PoP * strys.(['N_' ssec '_' sreg]));
%             strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p)/(1 - strpar.tauK_p);
%             strys.(['K_' ssec '_' sreg]) = (1 - strpar.(['phiW_' ssec '_' sreg '_p'])) * strys.(['Y_' ssec '_' sreg]) / strys.(['r_' ssec '_' sreg]);
%             strpar.(['alphaK_' ssec '_' sreg '_p']) = strys.(['r_' ssec '_' sreg])^strpar.(['etaNK_' ssec '_' sreg '_p']) * strys.(['K_' ssec '_' sreg]) / strys.(['Y_' ssec '_' sreg]);
%             strpar.(['alphaN_' ssec '_' sreg '_p']) = (strys.(['W_' ssec '_' sreg])/strys.(['P_' ssec '_' sreg]))^strpar.(['etaNK_' ssec '_' sreg '_p']) * strys.PoP * strys.(['A_N_' ssec '_' sreg]) .* strys.(['N_' ssec '_' sreg]) / strys.(['Y_' ssec '_' sreg]); 
            strys.(['D_' ssec '_' sreg]) = min(1,strpar.(['a_T_1_' ssec '_' sreg '_p']) * strys.(['T_' sreg]) + strpar.(['a_T_2_' ssec '_' sreg '_p']) * strys.(['T_' sreg])^(strpar.(['a_T_3_' ssec '_' sreg '_p'])) + ...
                               strpar.(['a_W_1_' ssec '_' sreg '_p']) * strys.(['WS_' sreg]) + strpar.(['a_W_2_' ssec '_' sreg '_p']) * strys.(['WS_' sreg])^(strpar.(['a_W_3_' ssec '_' sreg '_p'])) + ...
                               strpar.(['a_P_1_' ssec '_' sreg '_p']) * strys.(['PERC_' sreg]) + strpar.(['a_P_2_' ssec '_' sreg '_p']) * strys.(['PERC_' sreg])^(strpar.(['a_P_3_' ssec '_' sreg '_p'])) + ...
                               strpar.(['a_SL_1_' ssec '_' sreg '_p']) * strys.SL + strpar.(['a_SL_2_' ssec '_' sreg '_p']) * strys.SL^(strpar.(['a_SL_3_' ssec '_' sreg '_p']))) * exp(-strpar.(['phiGA_' ssec '_' sreg '_p']) * strys.(['G_A_' ssec '_' sreg]));
            temp = (strpar.(['alphaK_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.(['A_K_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]))^((strpar.(['etaNK_' ssec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssec '_' sreg '_p'])) + strpar.(['alphaN_' ssec '_' sreg '_p'])^(1/strpar.(['etaNK_' ssec '_' sreg '_p'])) * (strys.PoP * strys.(['N_' ssec '_' sreg]))^((strpar.(['etaNK_' ssec '_' sreg '_p'])-1)/strpar.(['etaNK_' ssec '_' sreg '_p'])))^(strpar.(['etaNK_' ssec '_' sreg '_p'])/(strpar.(['etaNK_' ssec '_' sreg '_p'])-1));
            strys.(['A_' ssec '_' sreg]) = strys.(['Y_' ssec '_' sreg]) / ((1 - strys.(['D_' ssec '_' sreg])) * temp);
            strys.(['gA_' ssec '_' sreg]) = 1;
            strpar.(['A_' ssec '_' sreg '_p']) = strys.(['A_' ssec '_' sreg]) ./ exp(strexo.(['exo_' ssec '_' sreg]));
            strys.(['I_' ssec '_' sreg]) = strpar.delta_p * strys.(['K_' ssec '_' sreg]);
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
            tempdenom = (strys.(['P_' ssec '_' sreg]) /((strys.(['Y_' ssec '_' sreg]))^(-1/strpar.(['etaC_' ssec '_p']))))^(strpar.(['etaC_' ssec '_p']));
            for icoregm = 1:strpar.inbregions_p
                sregm = num2str(icoregm);
                tempnum = (strys.(['P_' ssec '_' sregm]) /((strys.(['Y_' ssec '_' sregm]))^(-1/strpar.(['etaC_' ssec '_p']))))^(strpar.(['etaC_' ssec '_p']));
                temp = temp + tempnum / tempdenom;
            end
            strpar.(['omega_' ssec '_' sreg '_p']) = 1/temp;
            strys.(['N_' ssec]) = strys.(['N_' ssec]) + strys.(['N_' ssec '_' sreg]);               
            strys.(['P_' ssec]) = strys.(['P_' ssec]) + strpar.(['omega_' ssec '_' sreg '_p']) * strys.(['P_' ssec '_' sreg])^(1 - strpar.(['etaC_' ssec '_p']));
            rhs_vec(icosec) = rhs_vec(icosec) + strpar.(['omega_' ssec '_' sreg '_p']) * strys.(['P_' ssec '_' sreg])^(1 - strpar.(['etaC_' ssec '_p']));
        end
        strys.(['P_' ssec]) = strys.(['P_' ssec])^(1/(1 - strpar.(['etaC_' ssec '_p'])));
        rhs_vec(icosec) = rhs_vec(icosec)^(1/(1 - strpar.(['etaC_' ssec '_p'])));
        strys.(['Y_' ssec]) = 0;
        rhs_vec(icosec) = 0;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['Y_' ssec]) = strys.(['Y_' ssec]) + strpar.(['omega_' ssec '_' sreg '_p'])^(1/strpar.(['etaC_' ssec '_p'])) * (strys.(['Y_' ssec '_' sreg]))^((strpar.(['etaC_' ssec '_p'])-1)/strpar.(['etaC_' ssec '_p']));
        end
        strys.(['Y_' ssec]) = strys.(['Y_' ssec])^(strpar.(['etaC_' ssec '_p'])/(strpar.(['etaC_' ssec '_p'])-1));
    end
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        temp= 0;
        tempdenom = (strys.(['P_' ssec]) /((strys.(['Y_' ssec]))^(-1/strpar.etaC_p)))^(strpar.etaC_p);
        for icosecm = 1:strpar.inbsectors_p
            ssecm = num2str(icosecm);
            tempnum = (strys.(['P_' ssecm]) /((strys.(['Y_' ssecm]))^(-1/strpar.etaC_p)))^(strpar.etaC_p);
            temp = temp + tempnum / tempdenom;
        end
        strpar.(['omega_' ssec '_p']) = 1/temp;
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
    
    strys.wagebill = 0;
    strys.capitalbill = 0;
    strys.adaptationcost = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.wagebill = strys.wagebill + strys.(['N_' ssec]) * strys.(['W_' ssec])./strys.P;
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.capitalbill = strys.capitalbill + strys.(['P_' ssec '_' sreg]) * strys.(['K_' ssec '_' sreg]) * strys.(['r_' ssec '_' sreg])./strys.P;
            strys.adaptationcost = strys.adaptationcost + strys.(['G_A_' ssec '_' sreg]);
        end
    end
    strys.NX = strpar.omegaNX0_p * strys.Y * exp(strexo.exo_NX);
    strys.B = -strys.NX/strys.rf;
    strys.BG = strexo.exo_BG;
    strys.I = strpar.delta_p * strys.K;
    strys.lambrf = 1;

    strys.C = (strys.Y + strys.NX - strys.I - strpar.tauN_p * strys.wagebill  - strpar.tauK_p * strys.capitalbill + strys.rf * strys.BG) / (1 + strpar.tauC_p);
    strys.G = (strpar.tauN_p * strys.wagebill + strpar.tauK_p * strys.capitalbill + strpar.tauC_p * strys.C) - strys.rf * strys.BG - strys.adaptationcost;
    %% compute labour disutlity parameters
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['omegaI_' ssec '_' sreg]) = strys.(['P_' ssec '_' sreg]);
            strys.(['kappaI_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappaIprime_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappaIprimep1_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            strys.(['kappap1I_' ssec '_' sreg]) = 0;%strys.(['P_' ssec '_' sreg]);
            lhs = (1 - strpar.tauN_p) * strys.(['W_' ssec '_' sreg]) * (strys.C/strys.PoP)^(-strpar.sigmaC_p) / (strys.P*(1 + strpar.tauC_p));
            strpar.(['phiL_' ssec '_' sreg '_p']) =  lhs / (strys.(['N_' ssec '_' sreg]))^(strpar.sigmaL_p);
        end
    end
    %% check initial value of output and implied one
    fval_vec = zeros(strpar.inbsectors_p, 1);
    Y_temp = 0;
    P_temp = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        Y_temp = Y_temp + strpar.(['omega_' ssec '_p'])^(1/strpar.etaC_p) * (strys.(['Y_' ssec]))^((strpar.etaC_p-1)/strpar.etaC_p);
        P_temp = P_temp + strpar.(['omega_' ssec '_p']) * (strys.(['P_' ssec]))^(1-strpar.etaC_p);
        rhs = strpar.(['omega_' ssec '_p'])^(1/strpar.etaC_p) * (strys.(['Y_' ssec])/strys.Y)^(-1/strpar.etaC_p) * strys.P;
        fval_vec(icosec) = 1 - strys.(['P_' ssec])./rhs;
    end
    P_temp = P_temp^(1/(1 - strpar.etaC_p));
    fval_vec = 1 - strys.P/P_temp;
    
end