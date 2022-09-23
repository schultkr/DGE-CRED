function [strys, strpar, strexo] = ComputeAggregates(strys, strpar, strexo)
    % function [strys,strpar, strexo] = ComputeAggregates(strys,strpar, strexo)
    % computes aggregate variables from regional and sectoral level.
    % Inputs: 
    %   - strys     [structure]  structure containing all endogeonous variables of the model
    %   - strpar    [structure]  structure containing all parameters of the model
    %   - strexo    [structure]  structure containing all exogeonous variables of the model    	
    %
    % Output: 

    %   - strys     [structure] see inputs
	%   - strpar     [structure] see inputs
    %   - strexo    [structure] see inputs
    
    % tax rates

    % output
    strys.Q = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            strys.Q = strys.Q + strys.(['Q_' num2str(icosubsec)]) * strys.(['P_D_' num2str(icosubsec)]) / strys.P_D;
        end
    end
    
    % intermediate products
    strys.Q_I = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            strys.Q_I = strys.Q_I + strys.(['Q_I_' num2str(icosubsec)]);
        end
    end
    
    % investments
    strys.I = 0;
    for icosec = 1:strpar.inbsectors_p
        strys.I = strys.I + strys.P * strys.(['I_' num2str(icosec)])/strys.P;
    end
    
    % capital stock
    strys.K = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            strys.K = strys.K + strys.P * strys.(['K_' num2str(icosubsec)])/strys.P;
        end
    end
    
    % gross value added
    strys.Y = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                strys.Y = strys.Y + strys.(['P_' ssubsec '_' sreg]) * strys.(['Y_' ssubsec '_' sreg])/strys.P;
            end
        end
    end

    % employment
    strys.N = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            strys.N = strys.N + strys.(['N_' num2str(icosubsec)]);
        end
    end
    
    % exports
    strys.X = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            strys.X = strys.X + strys.(['X_' num2str(icosubsec)]) * strys.(['P_D_' num2str(icosubsec)]) / strys.P_D;
        end
    end
    % compute domestically used products accounting for spedicifc demand
    % caused by adaptation
    strys.adaptationused = 0;
    strys.privateadaptationcost = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                if strpar.(['iGA_' ssubsec '_p']) > 0
                    strys.adaptationused = strys.adaptationused + strys.(['G_A_' ssubsec '_' sreg]) * strys.P * strys.(['P_D_' num2str(strpar.(['iGA_' ssubsec '_p']))]);     
                end
                if strpar.(['iIAP_' ssubsec '_p']) > 0
                    strys.adaptationused = strys.adaptationused + strys.(['I_AP_' ssubsec '_' sreg]) * strys.P * strys.(['P_D_' num2str(strpar.(['iIAP_' ssubsec '_p']))]);     
                    strys.privateadaptationcost = strys.privateadaptationcost + strys.(['I_AP_' ssubsec '_' sreg]) * strys.P * strys.(['P_D_' num2str(strpar.(['iIAP_' ssubsec '_p']))]);
                else
                    strys.privateadaptationcost = strys.privateadaptationcost + strys.(['I_AP_' ssubsec '_' sreg]) * strys.P;
                end
                
            end
        end
    end
    if strpar.iGAH_p > 0
        strys.adaptationused = strys.adaptationused + strys.G_A_DH * strys.P * strys.(['P_D_' num2str(strpar.iGAH_p)]);       
    end
    if strpar.iIAPH_p > 0
        strys.adaptationused = strys.adaptationused + strys.I_AP_DH * strys.P * strys.(['P_D_' num2str(strpar.iIAPH_p)]);       
        strys.privateadaptationcost = strys.privateadaptationcost + strys.I_AP_DH * strys.P * strys.(['P_D_' num2str(strpar.iIAPH_p)]);       
    else   
        strys.privateadaptationcost = strys.privateadaptationcost + strys.I_AP_DH * strys.P;       
    end
    strys.Q_D = strys.Q - strys.X - strys.adaptationused / strys.P_D;
    
end


