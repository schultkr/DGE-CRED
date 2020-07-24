% =========================================
% === Script to do multiple Simulations ===
% =========================================
% add dynare path to the search path of matlab
addpath('C:\dynare\4.6.1\matlab')
% specify scenario names
% casScenarioNames = {'Baseline', 'Temperature', 'SeaLevel', 'Adaptation', 'Extremes'};
casScenarioNames = {'Temperature'};
% execute dynare to run the model
dynare DGE_CRED_Model noclearall
close all;
sVarMain = 'N_';
for icosec = 1:inbsectors_p
    for icoreg = 1:inbregions_p
        icovec = icoreg + inbregions_p * (icosec-1);
        subplot(inbsectors_p,inbregions_p,icovec);plot(eval([sVarMain num2str(icosec) '_' num2str(icoreg) '(1:' num2str(iTermination_p) ')' ]));title([sVarMain num2str(icosec) '_' num2str(icoreg)]);
    end
end
