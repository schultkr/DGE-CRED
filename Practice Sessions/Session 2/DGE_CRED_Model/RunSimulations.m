% RunSimulations is a Matlab script to run different scenarios stroed in
% ModelSimulationandCalibration<Number of Subsectors>Sectorsand<Number of
% Regions>Regions.xlsx  workbook. The DGE_CRED_Model.mod file is changed 
% in the script.

addpath('C:\dynare\4.6.4\matlab')
%% Specify scenario names
casScenarioNames = {...
                     'Baseline', 'Scenario'...
                     };
                 
                 
%% Define sector strucutre
sSubsecstart = '[1, 2, 3]';                 
sSubsecend =   '[1, 2, 3]';

%% Define number of regions
sRegions = '1';

%% Define additonal specification ofthe version of the modle for sensitivity analysis.
sSensitivity = '';


%% Execute dynare to run the model
addpath([pwd() '/Functions'])
addpath([pwd() '/Functions/Miscellaneous'])
addpath([pwd() '/Functions/Auxiliary'])
if isoctave()
    error('Octave is currently not supported please use Matlab 2019 or above')
end

timestart = tic;
for icoScenario = 1:size(casScenarioNames,2)
    sScenario = char(casScenarioNames(icoScenario));
    % This function allows to switch between endogenous production or
    % productivity shocks.
    ChangeModFile(sScenario,sSubsecstart,sSubsecend,sRegions);
    % Model is called each time. We need to run the preprocessor to update
    % all .m files depending on whether productivity shocks are endogenous or
    % exogenous.
    dynare DGE_CRED_Model noclearall        
end
timeend = toc(timestart);
disp(['time for computation ' num2str(timeend/60) ' minutes'])