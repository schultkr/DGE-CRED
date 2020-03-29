% ============================================
% === Define number of sectors and regions ===
% ============================================
@# define Sectors = 3
@# define Regions = 2

% ==============================
% === Define number of steps ===
% ==============================
options_.iStepSteadyState = 10;
options_.iStepSimulation = 20;

% =====================================================
% === Define excel files names and add search paths ===
% =====================================================
sWorkbookNameInput = [pwd() '/ExcelFiles/ModelSimulationandCalibration' num2str(@{Sectors}) 'Sectorsand' num2str(@{Regions}) 'Regions.xlsx'];
sWorkbookNameOutput = [pwd() '/ExcelFiles/ResultsScenarios' num2str(@{Sectors}) 'Sectorsand' num2str(@{Regions}) 'Regions.xlsx'];
addpath([pwd() '/Functions'])
if isoctave()
    addpath([pwd() '/Functions/Octave'])
end

% =====================
% === Add mod files ===
% =====================
@# include "MOdFiles/DGE_CRED_Model_AuxiliaryVariables.mod"
@# include "ModFiles/DGE_CRED_Model_Declaration.mod"
@# include "ModFiles/DGE_CRED_Model_Parameters.mod"
@# include "ModFiles/DGE_CRED_Model_Equations.mod"
//@# include "ModFiles/DGE_CRED_Model_LatexOutput.mod"
for icoScenario = 1:size(casScenarioNames,2)
    sScenario = char(casScenarioNames(icoScenario));
    @# include "ModFiles/DGE_CRED_Model_SteadyState.mod"
    @# include "ModFiles/DGE_CRED_Model_Simulations.mod"
    sVersion = ['Sectors' num2str(inbsectors_p) 'Regions' num2str(inbregions_p)];
    structScenarioResults.(sVersion).(sScenario).oo_ = oo_;
    structScenarioResults.(sVersion).(sScenario).M_ = M_;
    if exist('structScenarioResults.mat', 'file')
        save('structScenarioResults.mat', 'structScenarioResults', '-append')
    else
        save('structScenarioResults.mat', 'structScenarioResults')
    end
end