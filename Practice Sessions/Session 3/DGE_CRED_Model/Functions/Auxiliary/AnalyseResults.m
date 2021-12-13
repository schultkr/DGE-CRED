% ========================================
% === Analys results stored in matfile ===
% ========================================
sVersion = 'Sectors12Regions6';
tabbaseline = array2table(structScenarioResults.(sVersion).Baseline.oo_.endo_simul');
tabbaseline.Properties.VariableNames = structScenarioResults.(sVersion).Baseline.M_.endo_names;

tabssp126 = array2table(structScenarioResults.(sVersion).SSP126.oo_.endo_simul');
tabssp126.Properties.VariableNames = structScenarioResults.(sVersion).SSP126.M_.endo_names;

tabssp585 = array2table(structScenarioResults.(sVersion).SSP585.oo_.endo_simul');
tabssp585.Properties.VariableNames = structScenarioResults.(sVersion).SSP585.M_.endo_names;

sVersion = 'Sectors12Regions1etaF';
tabbaselineetaf = array2table(structScenarioResults.(sVersion).Baseline.oo_.endo_simul');
tabbaselineetaf.Properties.VariableNames = structScenarioResults.(sVersion).Baseline.M_.endo_names;

tabssp126etaf = array2table(structScenarioResults.(sVersion).SSP126.oo_.endo_simul');
tabssp126etaf.Properties.VariableNames = structScenarioResults.(sVersion).SSP126.M_.endo_names;

tabssp585etaf = array2table(structScenarioResults.(sVersion).SSP585.oo_.endo_simul');
tabssp585etaf.Properties.VariableNames = structScenarioResults.(sVersion).SSP585.M_.endo_names;
