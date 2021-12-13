function oo_ = LoadExogenous(sWorkbookNameInput, sScenario, oo_, M_)
    % oo_ = LoadExogenous(sWorkbookNameInput, sScenario, oo_, M_)
    % loads path for exogeonous variables
    % Inputs: 
    %   - sWorkbookNameInput [character] name of workbook with paths
    %   - sScenario          [character] name of scneario and sheet in workbook
    %   - oo_                [structure] see dynare manual
    %   - M_                 [structure] see dynare manual
    %
    % Output: 
    %   - oo_                [structure] see dynare manual
    
    % read excel file
    [danum, catext] = xlsread(sWorkbookNameInput, sScenario);
    % find positions of exogenous variables
    [lSelectExogenous, ipostext] = ismember(M_.exo_names, catext(1,:));
    % update values of exogenous variables
    oo_.exo_simul(danum(:,1), lSelectExogenous) = danum(:, ipostext(ipostext>0));
    oo_.exo_simul((danum(end,1)+1):end, lSelectExogenous) = repmat(oo_.exo_simul(danum(end,1), lSelectExogenous), size(oo_.exo_simul,1)-danum(end,1), 1);
end