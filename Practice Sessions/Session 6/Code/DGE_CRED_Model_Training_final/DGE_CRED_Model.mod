% Copyright (C) 2019 Christoph Schult
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or (at
% your option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see http://www.gnu.org/licenses/.
warning off;
% ============================================
% === Define number of sectors and regions ===
% ============================================
@# define Sectors = 3
@# define Regions = 3
@# define ClimateVars = ["T", "WS", "PREC", "SL", "CYC", "DRO"]
% ==============================
% === Define number of steps ===
% ==============================
options_.iStepSteadyState = 10;
options_.iStepSimulation = 10;

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
@# include "ModFiles/DGE_CRED_Model_Equations.mod"


@# include "ModFiles/DGE_CRED_Model_Parameters.mod"
M_.ClimateVars = '@{ClimateVars}';
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
