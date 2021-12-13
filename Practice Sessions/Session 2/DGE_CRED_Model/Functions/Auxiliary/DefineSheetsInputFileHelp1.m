function casCategories = DefineSheetsInputFileHelp1(casParams, inbregions_p, inbsubsectors_p, inbsectors_p)
    casCategories = {'Parameter', 'Value', 'Description'};
    for icoparam = 1:length(casParams)  
        sParam = casParams{1, icoparam, 1};
        sValue = casParams{2, icoparam};
        sDes = casParams{3, icoparam};
        lsectoral = casParams{4, icoparam};
        lsubsectoral= casParams{5, icoparam};
        lregional= casParams{6, icoparam};
        if lregional && lsubsectoral && ~lsectoral
            carowtemp = {['Parameter values for ' sDes ], '', ''};
            for icosubsec = 1:inbsubsectors_p
                for icoreg = 1:inbregions_p
                    carowtemp = [carowtemp;...
                                 {[sParam '_' num2str(icosubsec) '_' num2str(icoreg) '_p'], sValue, [sDes ' in sector ' num2str(icosubsec) ' and region ' num2str(icoreg)]};...
                                 ];%#ok
                end
            end
        elseif ~lregional && lsubsectoral && ~lsectoral        
            carowtemp = {['Parameter values for ' sDes ], '', ''};
            for icosubsec = 1:inbsubsectors_p
                carowtemp = [carowtemp;...
                             {[sParam '_' num2str(icosubsec) '_p'], sValue, [sDes ' in sector ' num2str(icosubsec)]};...
                            ];%#ok
            end
        elseif lregional && ~lsubsectoral && ~lsectoral
            carowtemp = {['Parameter values for ' sDes ], '', ''};
            for icoreg = 1:inbregions_p
                carowtemp = [carowtemp;...
                             {[sParam '_' num2str(icoreg) '_p'], sValue, [sDes ' in  region ' num2str(icoreg)]};...
                             ];%#ok
            end        
        elseif ~lregional && ~lsubsectoral && lsectoral
            carowtemp = {['Parameter values for ' sDes ], '', ''};
            for icosec = 1:inbsectors_p
                carowtemp = [carowtemp;...
                            {[sParam '_' num2str(icosec) '_p'], sValue, [sDes ' in sector ' num2str(icosec)]};...
                            ];%#ok
            end
        elseif ~lregional && ~lsubsectoral && ~lsectoral
            carowtemp = {[sParam '_p'], sValue, sDes};
        end
        casCategories = [casCategories; carowtemp];%#ok
    end
end