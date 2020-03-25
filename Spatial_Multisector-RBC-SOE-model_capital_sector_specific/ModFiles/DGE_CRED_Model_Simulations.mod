% =================================
% === Deterministic Simulations ===
% =================================
perfect_foresight_setup(periods = 1000);
iStep = 20;
imaxTermination_p = 110;
iminTermination_p = 110;
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
        oo_.endo_simul(:, 2:end) = repmat(DGE_CRED_Model_steadystate(oo_.endo_simul(:, 1), oo_.exo_simul(end,:)),1, size(oo_.endo_simul,2)-1);
    else
        oo_.endo_simul(:, (iTermination_p+1):end) = repmat(DGE_CRED_Model_steadystate(oo_.endo_simul(:, end), oo_.exo_simul(end,:)),1, size(oo_.endo_simul,2)-iTermination_p);
    end
    oo_.exo_steady_state = oo_.exo_simul(end,:)';
    oo_.steady_state = oo_.endo_simul(:,end);
    if icostep == iStep
        steady;
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
    rhogrowthrates = fsolve(@(x) ((iInitGrowthRates-1)~=0) .* (log(oo_.endo_simul(lSelectProdVars,end)./oo_.endo_simul(lSelectProdVars,1)) - sum(log(1 + (iInitGrowthRates-1) .* x.^(0:(iTermination_p-1))),2)) + ((iInitGrowthRates-1)==0).*(x-0), 0.5.*ones(inbsectors_p.*inbregions_p,1),[]);
    rhogrowthratesN = fsolve(@(x) ((iInitGrowthRatesN-1)~=0) .* (log((oo_.endo_simul(lSelectNVars,end)./oo_.endo_simul(lSelectN,end))./(oo_.endo_simul(lSelectNVars,1)./oo_.endo_simul(lSelectN,end))) - sum(log(1 + (iInitGrowthRatesN-1) .* x.^(0:(iTermination_p-1))),2)) + ((iInitGrowthRatesN-1)==0).*(x-0), 0.5.*ones(inbsectors_p.*inbregions_p,1),[]);
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
        fval_vec = [fvalY_vec fvalN_vec];
        iaDifference = diff(oo_.exo_simul((M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocks));
        iaNDifference = diff(oo_.exo_simul((M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocksN));
        iaDifference = iaDifference + 1./5.*fvalY_vec';
        iaNDifference = iaNDifference - 1./5 .*fvalN_vec';
        oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocks)  = cumsum(iaDifference);
        oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lag),lSelectProdShocksN) = cumsum(iaNDifference);
        disp('=============================================')
    end
end

lSelectClimateShocks = ismember(cellstr(M_.exo_names), casClimateShocks);
lSelectWindSpeedShocks = ismember(cellstr(M_.exo_names), casWindSpeedShocks);
lSelectProdShocks = ismember(cellstr(M_.exo_names), casProdShocks);
iVarTemp = 0;
//oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lead), lSelectClimateShocks) = oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lead), lSelectClimateShocks) + randn(iTermination_p, size(oo_.exo_simul(1, lSelectClimateShocks), 2)).*iVarTemp;
//oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lead), lSelectProdShocks) = oo_.exo_simul((1+M_.maximum_lag):(iTermination_p+M_.maximum_lead), lSelectProdShocks) + randn(iTermination_p, size(oo_.exo_simul(1, lSelectProdShocks), 2)).*iVarTemp;
/*
if isequal(sScenario, 'Baseline')
    oo_.exo_simul(1:10:iTermination_p, lSelectWindSpeedShocks) = 1;
else
    oo_.exo_simul(1:5:iTermination_p, lSelectWindSpeedShocks) = 1;
end
*/
perfect_foresight_solver;




iDisplay = 100;
iFrequency = 1;
iStartYear = 2018;
tabvars = array2table(oo_.endo_simul(:,1:iDisplay)');
tabvars.Properties.VariableNames = cellstr(M_.endo_names);
iaYear_vec = iStartYear + ((0:(size(tabvars,1)-1))./iFrequency)';
tabvars.Properties.RowNames = cellstr(num2str(iaYear_vec, '%.2f'));
writetable(tabvars,sWorkbookNameOutput, 'Sheet', sScenario, 'WriteRowNames', true)
