% =================================
% === Deterministic Simulations ===
% =================================
if ~isequal(sScenario,'Baseline')
    oo_.exo_simul(:,lSelectProdShocks) = log(structScenarioResults.(sVersion).Baseline.oo_.endo_simul(lSelectAVars,:)./structScenarioResults.(sVersion).Baseline.oo_.endo_simul(lSelectAVars,1))';
    oo_.exo_simul(:,lSelectProdShocksN) = log(structScenarioResults.(sVersion).Baseline.oo_.endo_simul(lSelectANVars,:))';
    oo_.exo_simul(:,lSelectPMShock) = (structScenarioResults.(sVersion).Baseline.oo_.endo_simul(lSelectPM,:)-structScenarioResults.(sVersion).Baseline.M_.params(ismember(M_.param_names, 'P0_M_p')))';
    oo_.exo_simul(:,lSelectPriceHShock) = log(structScenarioResults.(sVersion).Baseline.oo_.endo_simul(lSelectPH,:)./structScenarioResults.(sVersion).Baseline.oo_.endo_simul(lSelectPH,1))';
    oo_.exo_steady_state = oo_.exo_simul(end,:)';
    M_.params(ismember(M_.param_names, 'lCalibration_p')) = 0;
end

M_.params(ismember(M_.param_names, 'lCalibration_p')) = 0;
iStep = options_.iStepSimulation;
imaxTermination_p = 100;
iminTermination_p = 100;

imaxsec_p = eval(['subend_' num2str(inbsectors_p) '_p']);

options_.periods = 1000;
if isequal(sScenario, 'Baseline')
    perfect_foresight_setup;
end
oo_ = LoadExogenous(sWorkbookNameInput, sScenario, oo_, M_);
oo_.endo_simul_start = oo_.endo_simul;
oo_.exo_simul_start = oo_.exo_simul;
[iaTargetGrowthRatestemp, iaTargetGrowthRatesNtemp] = LoadGrowthRates(sWorkbookNameInput, 'Baseline', M_);
iaTargetGrowthRates = [ones(1,size(iaTargetGrowthRatestemp',2)); iaTargetGrowthRatestemp'; ones(size(oo_.exo_simul,1)-size(iaTargetGrowthRatestemp',1)-1,size(iaTargetGrowthRatestemp',2))];
iaTargetGrowthRatesN = [ones(1,size(iaTargetGrowthRatesNtemp',2)); iaTargetGrowthRatesNtemp'; ones(size(oo_.exo_simul,1)-size(iaTargetGrowthRatesNtemp',1)-1,size(iaTargetGrowthRatesNtemp',2))];
iTermination_p = size(iaTargetGrowthRatestemp,2);
exo_temp = zeros(size(oo_.exo_simul));

% Here the code finds the solution to the dynamic equations of the system
if isequal(sScenario, 'Baseline')
    % For the baseline scenario we look for productivity shocks to meet a pre defined path for GDP growth rates.
    % Here we increase with each step the total GDP growth rate. 
    for icostep = 1:iStep
        disp('=============================================')
        disp(['=== Step ' num2str(icostep) ' of ' num2str(iStep) ' for ' sScenario ' ==='])
        if isequal(sScenario, 'Baseline')
            M_.params(ismember(M_.param_names, 'lCalibration_p')) = 2;
            options_.iStepSteadyState = 1;
            oo_.exo_simul(:,lSelectProdShocks)  = log(cumprod(iaTargetGrowthRates.^(icostep./iStep),1));
            oo_.exo_simul(:,lSelectProdShocksN) = log(cumprod(iaTargetGrowthRatesN.^(icostep./iStep),1));
            oo_.exo_simul(:,lSelectPriceHShock) = oo_.exo_simul_start(:, lSelectPriceHShock).*(icostep./iStep);
            [ystemp, ~, ~, exotemp] = DGE_CRED_Model_steadystate(oo_.endo_simul(:, end), oo_.exo_simul(end,:),M_,options_);
            [ystemp, ~, ~, exotemp] = DGE_CRED_Model_steadystate(ystemp, exotemp,M_,options_);
            if icostep == 1
                oo_.endo_simul(:, 2:end) = repmat(ystemp,1, size(oo_.endo_simul,2)-1);
            else
                oo_.endo_simul(:, (iTermination_p+1):end) = repmat(ystemp,1, size(oo_.endo_simul,2)-iTermination_p);
            end
            oo_.steady_state = oo_.endo_simul(:,end);
            oo_.exo_steady_state = oo_.exo_simul(end,:)';
        end
        steady;
        if icostep == iStep
            options_.qz_zero_threshold =  1e-12;
            [eigenvalues_,result,info] = check(M_, options_, oo_);
        end
        tic;
        perfect_foresight_solver;
        toc;
        disp('=============================================')
    end
else
    % For a climate change scenario we use the solution for the baseline scenario as initial guess.
    % Here we increase the size of the cloimate shocks reflected by damages. 
    for icostep = 1:iStep
        disp('=============================================')
        disp(['=== Step ' num2str(icostep) ' of ' num2str(iStep) ' for ' sScenario ' ==='])
        oo_.exo_simul(:,lSelectDamShocks) = oo_.exo_simul_start(:,lSelectDamShocks).*(icostep./iStep);
        oo_.exo_simul(:,lSelectDamKShocks) = oo_.exo_simul_start(:,lSelectDamKShocks).*(icostep./iStep);
        oo_.exo_simul(:,lSelectDamNShocks) = oo_.exo_simul_start(:,lSelectDamNShocks).*(icostep./iStep);
        oo_.exo_simul(:,lSelectDamHShock) = oo_.exo_simul_start(:,lSelectDamHShock).*(icostep./iStep);
        [ystemp, ~, ~, exotemp] = DGE_CRED_Model_steadystate(oo_.endo_simul(:, end), oo_.exo_simul(end,:),M_,options_);            
        oo_.steady_state = ystemp;
        oo_.endo_simul(:, end) = repmat(ystemp,1,size(oo_.endo_simul(:, end), 2));
        oo_.exo_steady_state = oo_.exo_simul(end,:)';
        steady;
        if icostep == iStep
            options_.qz_zero_threshold =  1e-12;
            [eigenvalues_,result,info] = check(M_, options_, oo_);
        end
        tic;
        perfect_foresight_solver;
        toc;
       disp('=============================================')
    end    
end
M_.params(ismember(M_.param_names, 'lCalibration_p')) = 0;
perfect_foresight_solver;
iDisplay = 100;
iFrequency = 1;
iStartYear = 2014;
if isoctave()
    caResults = [cellstr(M_.endo_names)'; mat2cell(oo_.endo_simul(:,1:iFrequency:iDisplay)', ones(iDisplay,1), ones(M_.endo_nbr,1))];
    caYear = cellstr(['Year'; num2str((iStartYear + (1:iFrequency:iDisplay))')]);
    caExcelFile = [caYear caResults];
    sAddress = [FindExcelCell(M_.endo_nbr) num2str(iDisplay+1)];
    sRange = ['A1:' sAddress];
    xlswrite(sWorkbookNameOutput, caExcelFile, sScenario, sRange);
else
    iaYear_vec = iStartYear + ((0:(size(oo_.endo_simul(:,1:iDisplay)',1)-1))./iFrequency)';
    tabvars = array2table([iaYear_vec oo_.endo_simul(:,1:iDisplay)']);
    tabvars.Properties.VariableNames = [{'Year'}; cellstr(M_.endo_names)];
    writetable(tabvars,sWorkbookNameOutput, 'Sheet', sScenario, 'WriteRowNames', false)
end

