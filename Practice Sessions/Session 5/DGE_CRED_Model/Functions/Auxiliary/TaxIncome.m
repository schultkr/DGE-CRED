function [strys,strpar, strexo] = TaxIncome(strys,strpar, strexo)
    % function [strys,strpar, strexo] = TaxIncome(strys,strpar, strexo)
    % to compute tax income from different sources.
    % Inputs: 
    %   - strys     [structure]  structure containing all endogeonous variables of the model
    %   - strpar    [structure]  structure containing all parameters of the model
    %   - strexo    [structure]  structure containing all exogeonous variables of the model    
    %
    % Output: 
    %   - strys     [structure] see inputs
    %   - strpar    [structure] see inputs	
    %   - strexo    [structure] see inputs
    
    strys.wagetax = 0;
    strys.capitaltax = 0;
    strys.adaptationcost = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                strys.wagetax = strys.wagetax + strys.(['W_' ssubsec '_' sreg]) * strys.(['N_' ssubsec '_' sreg]) * strys.PoP ./strys.P * (strys.tauNH + strys.(['tauNF_' ssubsec '_' sreg]));
                strys.capitaltax = strys.capitaltax + strys.(['P_' ssubsec '_' sreg]) * strys.(['K_' ssubsec '_' sreg]) * strys.(['r_' ssec '_' sreg])./strys.P * (strys.tauKH + strys.(['tauKF_' ssubsec '_' sreg]));
                strys.adaptationcost = strys.adaptationcost + strys.(['G_A_' ssubsec '_' sreg]);                    
            end
        end
    end
    strys.adaptationcost = strys.adaptationcost+ strys.G_A_DH;    

end


