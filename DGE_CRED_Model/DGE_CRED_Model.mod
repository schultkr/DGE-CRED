% ============================================
% === Define number of sectors and regions ===
% ============================================
@# define Subsecstart = [1, 7, 9, 10, 11]
@# define Subsecend = [6, 8, 9, 10, 12]
@# define Sectors = length(Subsecend)
@# define ForwardLooking = 1
@# define Regions = 6
@# define ClimateVarsRegional = ["tas", "SfcWind", "pr", "sunshine", "hurs", "heatwave", "maxdrydays", "maxwetdays", "storms", "floods", "fire", "landslide"]
@# define ClimateVarsNational = ["SL"]
@# define ClimateVars = ClimateVarsRegional + ClimateVarsNational
% ===================================
% === Define number of iterations ===
% ===================================
options_.iStepSteadyState = 1;
options_.iStepSimulation  = 20;
% =====================================================
% === Define excel files names and add search paths ===
% =====================================================
sWorkbookNameInput = ['ExcelFiles/ModelSimulationandCalibration' num2str(@{Subsecend[Sectors]}) 'Sectorsand' num2str(@{Regions}) 'Regions' sSensitivity '.xlsx'];
sWorkbookNameOutput = ['ExcelFiles/ResultsScenarios' num2str(@{Subsecend[Sectors]}) 'Sectorsand' num2str(@{Regions})  'Regions' sSensitivity '.xlsx'];
% =====================
% === Add mod files ===
% =====================
@# define YEndogenous = 1
@# include "ModFiles/DGE_CRED_Model_Declaration.mod"
@# include "ModFiles/DGE_CRED_Model_Equations.mod"
//@# include "ModFiles/DGE_CRED_Model_LatexOutput.mod"
M_.ClimateVarsRegional = '@{ClimateVarsRegional}';
M_.ClimateVarsNational = '@{ClimateVarsNational}';
@# include "ModFiles/DGE_CRED_Model_Parameters.mod"
% run script to define expressions used later on. 
DefineAuxiliaryExpressions
@# if ForwardLooking == 1
    sVersion = ['Sectors' num2str(imaxsec_p) 'Regions' num2str(inbregions_p) sSensitivity];
@# else
    sVersion = ['Sectors' num2str(imaxsec_p) 'Regions' num2str(inbregions_p) 'Backward' sSensitivity];
@# endif
% run script to compute steady state and calibrate the model.
SteadyState_Model
% run script to simulate the model.
Simulation_Model
if exist('structScenarioResults.mat', 'file')
    load('structScenarioResults.mat', 'structScenarioResults')
    structScenarioResults.(sVersion).(sScenario).oo_ = oo_;
    structScenarioResults.(sVersion).(sScenario).M_ = M_;
    structScenarioResults.(sVersion).(sScenario).options_ = options_;    
    save('structScenarioResults.mat', 'structScenarioResults', '-append')
else
    structScenarioResults.(sVersion).(sScenario).oo_ = oo_;
    structScenarioResults.(sVersion).(sScenario).M_ = M_;
    structScenarioResults.(sVersion).(sScenario).options_ = options_; 
    save('structScenarioResults.mat', 'structScenarioResults')
end