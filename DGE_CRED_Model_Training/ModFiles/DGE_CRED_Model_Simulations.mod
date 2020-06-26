% =================================
% === Deterministic Simulations ===
% =================================
perfect_foresight_setup(periods = 500);
iStep = options_.iStepSimulation;
imaxTermination_p = 120;
iminTermination_p = 120;
lCalibration_p = 0;

% find positions of initial growth parameters of gross value added
temp = arrayfun(@(y) arrayfun(@(x) ['gY0_' num2str(y) '_' num2str(x) '_p'], 1:inbregions_p, 'UniformOutput', false), 1:inbsectors_p, 'UniformOutput', false);
casInitGrowthValues = [temp{:}];
lSelectInitGrowthParams = ismember(cellstr(M_.param_names), casInitGrowthValues);

% find positions of initial growth parameters of employment
temp = arrayfun(@(y) arrayfun(@(x) ['gN0_' num2str(y) '_' num2str(x) '_p'], 1:inbregions_p, 'UniformOutput', false), 1:inbsectors_p, 'UniformOutput', false);
casInitGrowthValuesN = [temp{:}];
lSelectInitGrowthParamsN = ismember(cellstr(M_.param_names), casInitGrowthValuesN);

% find positions of technology shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:inbsectors_p, 'UniformOutput', false);
casProdShocks = [temp{:}];
lSelectProdShocks = ismember(cellstr(M_.exo_names), casProdShocks);

% find positions of sectoral production
temp = arrayfun(@(y) arrayfun(@(x) ['Y_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:inbsectors_p, 'UniformOutput', false);
casProdVars = [temp{:}];
lSelectProdVars = ismember(cellstr(M_.endo_names), casProdVars);

% find positions of technology shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_N_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:inbsectors_p, 'UniformOutput', false);
casProdNShocks = [temp{:}];
lSelectProdShocksN = ismember(cellstr(M_.exo_names), casProdNShocks);

% find positions of sectoral production
temp = arrayfun(@(y) arrayfun(@(x) ['N_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:inbsectors_p, 'UniformOutput', false);
casNVars = [temp{:}];
lSelectNVars = ismember(cellstr(M_.endo_names), casNVars);
lSelectN = ismember(cellstr(M_.endo_names), 'N');

oo_ = LoadExogenous(sWorkbookNameInput, sScenario, oo_, M_);

if ~isequal(sScenario,'Baseline')
    sVersion = ['Sectors' num2str(inbsectors_p) 'Regions' num2str(inbregions_p)];
    oo_.exo_simul(:,lSelectProdShocks) = structScenarioResults.(sVersion).Baseline.oo_.exo_simul(:,lSelectProdShocks);
    oo_.exo_simul(:,lSelectProdShocksN) = structScenarioResults.(sVersion).Baseline.oo_.exo_simul(:,lSelectProdShocksN);
end

oo_.endo_simul_start = oo_.endo_simul;
oo_.exo_simul_start = oo_.exo_simul;
exo_temp = zeros(size(oo_.exo_simul));
for icostep = 1:iStep
    disp('=============================================')
    disp(['=== Step ' num2str(icostep) ' of ' num2str(iStep) ' for ' sScenario ' ==='])
    iTermination_p = iminTermination_p + floor(icostep*(imaxTermination_p-iminTermination_p)/iStep);
    if isequal(sScenario, 'Baseline')
        exo_temp = oo_.exo_simul_start .* ([(0:iTermination_p)'; repmat(iTermination_p, size(oo_.exo_simul_start,1)-(1+iTermination_p),1)]./iTermination_p).^(1./2) .* (icostep./iStep).^(2./3);
        oo_.exo_simul(:,lSelectProdShocks | lSelectProdShocksN) = exo_temp(:,lSelectProdShocks | lSelectProdShocksN);
    else
        exo_temp = oo_.exo_simul_start .* (icostep./iStep);
        oo_.exo_simul = exo_temp;
    end
    if icostep == 1
        oo_.endo_simul(:, 2:end) = repmat(DGE_CRED_Model_steadystate(oo_.endo_simul(:, 1), oo_.exo_simul(end,:),M_,options_),1, size(oo_.endo_simul,2)-1);
    else
        oo_.endo_simul(:, (iTermination_p+1):end) = repmat(DGE_CRED_Model_steadystate(oo_.endo_simul(:, end), oo_.exo_simul(end,:),M_,options_),1, size(oo_.endo_simul,2)-iTermination_p);
    end
    oo_.exo_steady_state = oo_.exo_simul(end,:)';
    oo_.steady_state = oo_.endo_simul(:,end);

    steady;
    if icostep == iStep
        check;
    end
    tic;
    perfect_foresight_solver;
    toc;
    disp('=============================================')
end

if isequal(sScenario, 'Baseline')
    imaxiter = 100;
    icoiter = 1;
    iInitGrowthRates = M_.params(lSelectInitGrowthParams);
    iInitGrowthRatesN = M_.params(lSelectInitGrowthParamsN);
    rhogrowthrates = fsolve(@(x) ((iInitGrowthRates-1)~=0) .* (log(oo_.endo_simul(lSelectProdVars,iTermination_p)./oo_.endo_simul(lSelectProdVars,1)) - sum(log(1 + (iInitGrowthRates-1) .* x.^(0:(iTermination_p-1))),2)) + ((iInitGrowthRates-1)==0).*(x-0), 0.5.*ones(inbsectors_p.*inbregions_p,1));
    rhogrowthratesN = fsolve(@(x) ((iInitGrowthRatesN-1)~=0) .* (log((oo_.endo_simul(lSelectNVars,iTermination_p)./oo_.endo_simul(lSelectN,iTermination_p))./(oo_.endo_simul(lSelectNVars,1)./oo_.endo_simul(lSelectN,1))) - sum(log(1 + (iInitGrowthRatesN-1) .* x.^(0:(iTermination_p-1))),2)) + ((iInitGrowthRatesN-1)==0).*(x-0), 0.5.*ones(inbsectors_p.*inbregions_p,1));
    iaTargetGrowthRates = 1 + (iInitGrowthRates-1).*rhogrowthrates.^(0:(iTermination_p-1));
    iaTargetGrowthRatesN = 1 + (iInitGrowthRatesN-1).*rhogrowthratesN.^(0:(iTermination_p-1));
    fvalY_vec = iaTargetGrowthRates-oo_.endo_simul(lSelectProdVars,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag))./oo_.endo_simul(lSelectProdVars,(1+M_.maximum_lag-1):(iTermination_p+M_.maximum_lag-1));
    fvalN_vec = iaTargetGrowthRatesN-(oo_.endo_simul(lSelectNVars,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag))./oo_.endo_simul(lSelectN,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag)))./(oo_.endo_simul(lSelectNVars,(1+M_.maximum_lag-1):(iTermination_p+M_.maximum_lag-1))./oo_.endo_simul(lSelectN,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag)));
    fval_vec = [fvalY_vec fvalN_vec];
    while icoiter < imaxiter && max(abs(fval_vec(:))) > 1e-3
        disp('=============================================')
        disp(['=== Step ' num2str(icoiter) ' of ' num2str(imaxiter) ' to find persistency parameters for ' sScenario ' ==='])
        disp(['maximum deviation ' num2str(max(abs(fval_vec(:))), '%.4f')])      
        tic;
        perfect_foresight_solver;
        toc;
        icoiter = icoiter + 1;
        fvalY_vec = iaTargetGrowthRates-oo_.endo_simul(lSelectProdVars,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag))./oo_.endo_simul(lSelectProdVars,(1+M_.maximum_lag-1):(iTermination_p+M_.maximum_lag-1));
        fvalN_vec = iaTargetGrowthRatesN-(oo_.endo_simul(lSelectNVars,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag))./oo_.endo_simul(lSelectN,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag)))./(oo_.endo_simul(lSelectNVars,(1+M_.maximum_lag-1):(iTermination_p+M_.maximum_lag-1))./oo_.endo_simul(lSelectN,(1+M_.maximum_lag):(iTermination_p+M_.maximum_lag)));
        fval_vec = fvalY_vec;%[fvalY_vec fvalN_vec];
        iaDifference = diff(oo_.exo_simul((M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocks));
        iaNDifference = diff(oo_.exo_simul((M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocksN));
        iaDifference = iaDifference + 1./7.*fvalY_vec';
        iaNDifference = iaNDifference - 1./7 .*fvalN_vec';
        oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocks)  = cumsum(iaDifference);
        oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocksN) = cumsum(iaNDifference);
        disp('=============================================')
    end
end

lSelectClimateShocks = ismember(cellstr(M_.exo_names), casClimateShocks);
lSelectWindSpeedShocks = ismember(cellstr(M_.exo_names), casWindSpeedShocks);
lSelectProdShocks = ismember(cellstr(M_.exo_names), casProdShocks);
iVarTemp = 0;
perfect_foresight_solver;




iDisplay = 85;
iFrequency = 1;
iStartYear = 2016;
if isoctave()
    caResults = [cellstr(M_.endo_names)'; mat2cell(oo_.endo_simul(:,1:iFrequency:iDisplay)', ones(iDisplay,1), ones(M_.endo_nbr,1))];
    caYear = cellstr(['Year'; num2str((iStartYear + (1:iFrequency:iDisplay))')]);
    caExcelFile = [caYear caResults];
    sAddress = [FindExcelCell(M_.endo_nbr) num2str(iDisplay+1)];
    sRange = ['A1:' sAddress];
    xlswrite(sWorkbookNameOutput, caExcelFile, sScenario, sRange);
else
    tabvars = array2table(oo_.endo_simul(:,1:iDisplay)');
    tabvars.Properties.VariableNames = cellstr(M_.endo_names);
    iaYear_vec = iStartYear + ((0:(size(tabvars,1)-1))./iFrequency)';
    tabvars.Properties.RowNames = cellstr(num2str(iaYear_vec, '%.2f'));
    writetable(tabvars,sWorkbookNameOutput, 'Sheet', sScenario, 'WriteRowNames', true)
end

