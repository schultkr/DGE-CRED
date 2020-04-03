% =========================================
% === Script to do multiple Simulations ===
% =========================================
% add dynare path to the search path of matlab
addpath('C:\dynare\4.6.1\matlab')
% specify scenario names
casScenarioNames = {'Baseline', 'Temperature', 'SeaLevel', 'Adaptation', 'Drought'};
% casScenarioNames = {'Drought'};
% execute dynare to run the model
dynare DGE_CRED_Model noclearall