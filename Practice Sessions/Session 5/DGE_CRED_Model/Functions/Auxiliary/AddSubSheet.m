function strSubSheet  = AddSubSheet(casVariables, casCellNames, casSectors, casRegions, lSectoral, lRegional, inbsubsectors_p, inbregions_p)
    if lSectoral && lRegional
        caHeader = [{'Sector'}, {'Region'}, cellfun(@(x,y) [x ' (' y ')'], casVariables, casCellNames, 'UniformOutput', false)];
        casData = repmat({'enter value here'}, inbregions_p * inbsubsectors_p, size(caHeader,2)-2);
        casCategories = [caHeader; ...
            [reshape(casSectors(sort(repmat(1:inbsubsectors_p,1, inbregions_p))),[],1)...
             reshape(casRegions(repmat(1:inbregions_p,1, inbsubsectors_p)),[],1) ...
            casData]];
        casDataCellNames = repmat({[]}, size(casCategories));
        temp = arrayfun(@(x,y) ['_' num2str(x) '_' num2str(y) '_p'],sort(repmat(1:inbsubsectors_p,1,inbregions_p)) , repmat(1:inbregions_p,1,inbsubsectors_p), 'UniformOutput', false);
        temp = cellfun(@(x) cellfun(@(y) [x y], temp, 'UniformOutput', false), casCellNames, 'UniformOutput', false);
        lUpdate = ismember(casCategories,'enter value here');
        casDataCellNames(lUpdate) = [temp{:}];
    elseif ~lSectoral && lRegional
        caHeader = [{'Region'}, cellfun(@(x,y) [x ' (' y ')'], casVariables, casCellNames, 'UniformOutput', false)];
        casData = repmat({'enter value here'}, inbregions_p, size(caHeader,2)-1);
        casCategories = [caHeader; ...
            [casRegions(1:inbregions_p)...
            casData]];
        casDataCellNames = repmat({[]}, size(casCategories));
        temp = arrayfun(@(x) ['0_' num2str(x) '_p'],1:inbregions_p, 'UniformOutput', false);
        temp = cellfun(@(x) cellfun(@(y) [x y], temp, 'UniformOutput', false), casCellNames,'UniformOutput', false);
        lUpdate = ismember(casCategories,'enter value here');
        casDataCellNames(lUpdate) = [temp{:}];
    elseif lSectoral && ~lRegional
        caHeader = [{'Sector'}, cellfun(@(x,y) [x ' (' y ')'], casVariables, casCellNames, 'UniformOutput', false)];
        casData = repmat({'enter value here'}, inbsubsectors_p, size(caHeader,2)-1);
        casCategories = [caHeader; ...
            [casSectors(1:inbsubsectors_p)...
            casData]];
        casDataCellNames = repmat({[]}, size(casCategories));
        temp = arrayfun(@(x) ['_' num2str(x) '_p'],1:inbsubsectors_p, 'UniformOutput', false);
        temp = cellfun(@(x) cellfun(@(y) [x y], temp, 'UniformOutput', false), casCellNames,'UniformOutput', false);
        lUpdate = ismember(casCategories,'enter value here');
        casDataCellNames(lUpdate) = [temp{:}];                
    elseif ~lSectoral && ~lRegional
        casCategories = [{'Name', 'Value'}; ...
            [casVariables' repmat({'enter value here'}, size(casVariables', 1), 1)]];
        casDataCellNames = repmat({[]}, size(casCategories));
        lUpdate = ismember(casCategories,'enter value here');
        casDataCellNames(lUpdate) = casCellNames;                
    end
    strSubSheet.Data  = casCategories;
    strSubSheet.CellNames = casDataCellNames;
end