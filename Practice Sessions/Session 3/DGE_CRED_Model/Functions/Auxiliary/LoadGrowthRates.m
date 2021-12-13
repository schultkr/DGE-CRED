function [iTargetGrowthRatesY, iTargetGrowthRatesN] = LoadGrowthRates(sWorkbookNameInput, sScenario, M_)
    % oo_ = LoadGrowthRates(sWorkbookNameInput, sScenario, oo_, M_)
    % loads path for exogeonous variables
    % Inputs: 
    %   - sWorkbookNameInput [character] name of workbook with paths
    %   - sScenario          [character] name of scneario and sheet in workbook
    %   - M_                 [structure] see dynare manual
    %
    % Output: 
    %   - oo_                [structure] see dynare manual
    
    % read excel file
    [danum, catext] = xlsread(sWorkbookNameInput, sScenario);
    % find positions of exogenous variables
    inbregions_p = M_.params(ismember(M_.param_names, 'inbregions_p'));
    inbsectors_p = M_.params(ismember(M_.param_names, 'inbsectors_p'));
    inbsubsectors_p = M_.params(ismember(M_.param_names, ['subend_' num2str(inbsectors_p) '_p']));
    temp = arrayfun(@(y) arrayfun(@(x) ['gY_' num2str(y) '_'  num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
    casgrowthratesY = [temp{:}];
    temp = arrayfun(@(y) arrayfun(@(x) ['gN_' num2str(y) '_'  num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
    casgrowthratesN = [temp{:}];
    
    
    [~, ipostext] = ismember(casgrowthratesY, catext);
    % update values of exogenous variables
    iTargetGrowthRatesY = danum(:, ipostext(ipostext>0))';
    % update values of exogenous variables
    [~, ipostext] = ismember(casgrowthratesN, catext);
    iTargetGrowthRatesN = danum(:, ipostext(ipostext>0))';
    
end