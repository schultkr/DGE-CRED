function [strys,strpar, strexo] = AssignPredeterminedVariables(strys,strpar, strexo)
    % function [strys,strpar, strexo] = AssignPredeterminedVariables(strys,strpar, strexo)
    % assigns values for predetermined variables of the model. 
    % Inputs: 
    %   - strys     [structure]  structure containing all endogeonous variables of the model
    %   - strexo    [structure]  structure containing all exogeonous variables of the model    
    %   - strpar    [structure]  structure containing all parameters of the model
    %
    % Output: 

    %   - strys     [structure] see inputs
    %   - strexo    [structure] see inputs
    
    % tax rates
    strys.tauKH = strpar.tauKH_p + strexo.exo_tauKH;
    strys.tauNH = strpar.tauNH_p + strexo.exo_tauNH;
    strys.tauC = strpar.tauC_p + strexo.exo_tauC;
    strys.tauH = strpar.tauH_p + strexo.exo_tauH;
      
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                strys.(['tauKF_' ssubsec '_' sreg]) = strpar.(['tauKF_' ssubsec '_' sreg '_p']) + strexo.(['exo_tauKF_' ssubsec '_' sreg]);
                strys.(['tauNF_' ssubsec '_' sreg]) = strpar.(['tauNF_' ssubsec '_' sreg '_p']) + strexo.(['exo_tauNF_' ssubsec '_' sreg]);
            end
        end
    end
    
    % government foreign debt 
    strys.BG = strexo.exo_BG;    
       
    % exogenous sectoral productivity for capital, damages to TFP, capital
    % and labour, adaptation capital stocks and expenditures
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);       
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            strys.(['D_KHelp_' ssec '_' sreg]) = 0;
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])  
                ssubsec = num2str(icosubsec);       
                strys.(['A_K_' ssubsec '_' sreg]) = strpar.(['A_K_' ssubsec '_' sreg '_p']) * exp(strexo.(['exo_K_' ssubsec '_' sreg]));
                strys.(['D_' ssubsec '_' sreg]) = strexo.(['exo_D_' ssubsec '_' sreg]);
                strys.(['D_N_' ssubsec '_' sreg]) = strexo.(['exo_D_N_' ssubsec '_' sreg]);
                strys.(['D_K_' ssubsec '_' sreg]) = strexo.(['exo_D_K_' ssubsec '_' sreg]) * strpar.Y0_p;
                strys.(['D_KHelp_' ssec '_' sreg]) = strys.(['D_KHelp_' ssec '_' sreg]) + strys.(['D_K_' ssubsec '_' sreg]);
                if strpar.(['iGA_' ssubsec '_p']) == 0
                    strys.(['K_A_' ssubsec '_' sreg]) = strexo.(['exo_GA_' ssubsec '_' sreg]) * strpar.Y0_p / strpar.P0_p;
                    strys.(['G_A_' ssubsec '_' sreg]) = strpar.(['deltaKA_' ssubsec '_' sreg '_p']) * strys.(['K_A_' ssubsec '_' sreg]);
                end
                if strpar.(['iGA_' ssubsec '_p']) ~= 0 && strpar.lCalibration_p ~= 1
                    strys.(['K_A_' ssubsec '_' sreg]) = strexo.(['exo_GA_' ssubsec '_' sreg]) * strpar.Y0_p / (strpar.P0_p * strpar.(['P_D_' num2str(strpar.(['iGA_' ssubsec '_p'])) '_p']));
                    strys.(['G_A_' ssubsec '_' sreg]) = strpar.(['deltaKA_' ssubsec '_' sreg '_p']) * strys.(['K_A_' ssubsec '_' sreg]);
                end
                if strpar.(['iIAP_' ssubsec '_p']) == 0
                    strys.(['K_AP_' ssubsec '_' sreg]) = strexo.(['exo_IAP_' ssubsec '_' sreg]) * strpar.Y0_p / strpar.P0_p;
                    strys.(['I_AP_' ssubsec '_' sreg]) = strpar.(['deltaKA_' ssubsec '_' sreg '_p']) * strys.(['K_AP_' ssubsec '_' sreg]);
                end
                if strpar.(['iIAP_' ssubsec '_p']) ~= 0 && strpar.lCalibration_p ~= 1
                    strys.(['K_AP_' ssubsec '_' sreg]) = strexo.(['exo_IAP_' ssubsec '_' sreg]) * strpar.Y0_p / (strpar.P0_p * strpar.(['P_D_' num2str(strpar.(['iIAP_' ssubsec '_p'])) '_p']));
                    strys.(['I_AP_' ssubsec '_' sreg]) = strpar.(['deltaKA_' ssubsec '_' sreg '_p']) * strys.(['K_AP_' ssubsec '_' sreg]);
                end                
                
            end
        end
    end
    
    %foreign exchange rate
    strys.Sf = 0;
    
    % climate variables
    for icoreg = 1:strpar.inbregions_p
        sreg = num2str(icoreg);
        for sClimateVar = strpar.casClimatevarsRegional
            strys.([char(sClimateVar) '_' sreg]) = strpar.([char(sClimateVar) '0_' sreg '_p']) + strexo.(['exo_' char(sClimateVar) '_' sreg]);
        end
    end
    for sClimateVar = strpar.casClimatevarsNational
        strys.(char(sClimateVar)) = strpar.([char(sClimateVar) '0_p']) + strexo.(['exo_' char(sClimateVar)]);
    end
    

end


