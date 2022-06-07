% DefineSheetsInputFile is a Matlab script called by CreateRawExcelInputFile
% to define the sheets of the ModelSimulationandCalibration<Number of Subsectors>Sectorsand<Number of
% Regions>Regions.xlsx  workbook for parameter and scenario definitions of the
% model. The sheets are:
% - Data
% - Start
% - Structural Parameters
% - Baseline
% - Scenario
% - Content

%% Define Data Sheet
icosheet = 0;

icosheet = icosheet + 1;
strSheet(icosheet).Name = 'Data';
strSheet(icosheet).Description = 'a sheet to store data used for calibration';

icosubsheet = 0;
icosubsheet = icosubsheet + 1;
casVariables = {'Initial Value Added Shares', 'Initial Employment Shares', 'Labour Cost Shares'};
casCellNames = {'phiY0', 'phiN0', 'phiW'};
lSectoral = true;
lRegional = true;
strSubSheet(icosubsheet)  = AddSubSheet(casVariables, casCellNames, casSubSectors(:), casRegions(:), lSectoral, lRegional, inbsubsectors_p, inbregions_p);

icosubsheet = icosubsheet + 1;
casVariables = {'export share', 'import share', 'intermediate products', 'subsectors for adaptation measures'};
casCellNames = {'phiX', 'phiM', 'phiQI', 'iGA'};
lSectoral = true;
lRegional = false;
strSubSheet(icosubsheet)  = AddSubSheet(casVariables, casCellNames, casSubSectors(:), casRegions(:), lSectoral, lRegional, inbsubsectors_p, inbregions_p);

icosubsheet = icosubsheet + 1;
casVariables = cellfun(@(x) ['initial ' x ], casClimateVarsRegionalName, 'UniformOutput', false);
casCellNames = cellfun(@(x) [x], casClimateVarsRegional, 'UniformOutput', false);
lSectoral = false;
lRegional = true;
strSubSheet(icosubsheet) = AddSubSheet(casVariables, casCellNames, casSubSectors(:), casRegions(:), lSectoral, lRegional, inbsubsectors_p, inbregions_p);

icosubsheet = icosubsheet + 1;
casVariables = cellfun(@(x) ['initial ' x ], casClimateVarsNationalName, 'UniformOutput', false);
casCellNames = cellfun(@(x) [x '0_p'], casClimateVarsNational, 'UniformOutput', false);
lSectoral = false;
lRegional = false;
strSubSheet(icosubsheet) = AddSubSheet(casVariables, casCellNames, casSubSectors(:), casRegions(:), lSectoral, lRegional, inbsubsectors_p, inbregions_p);

icosubsheet = icosubsheet + 1;
casVariables = {'initial population', 'initial value added', 'import share', 'housing to population ratio', 'investmetns in residential building relative to GDP', 'subsector for adaptation measures in the housing sector'};
casCellNames = {'PoP0_p', 'Y0_p', 'phiM_p', 'H0_p', 'sH_p', 'iGAH_p'};
lSectoral = false;
lRegional = false;
strSubSheet(icosubsheet) = AddSubSheet(casVariables, casCellNames, casSubSectors(:), casRegions(:), lSectoral, lRegional, inbsubsectors_p, inbregions_p);

strSheet(icosheet).Categories = strSubSheet;      

%% Define Start Sheet with initial values for Simulation
icosheet = icosheet + 1;
strSheet(icosheet).Name = 'Start';
strSheet(icosheet).Description = 'a sheet to assign values for the initial conditions';
casParams = [{'Y0'; '=1'; 'initial GDP'; false; false; false} ...
             {'P0'; '=1'; 'initial price level'; false; false; false} ...
             {'PoP0'; '=1'; 'initial population'; false; false; false}...
             {'N0'; '=0.15'; 'initial sum of hours worked to potential hours worked'; false; false; false}... 
             {'sH'; '=0.01'; 'investmetns in residential building relative to GDP'; false; false; false}... 
             [cellfun(@(x) [x '0'], casClimateVarsRegional, 'UniformOutput', false)'...
             arrayfun(@(x) ['=' num2str(x)], zeros(length(casClimateVarsRegional),1), 'UniformOutput', false)...
             cellfun(@(x) ['initial value for ' x], casClimateVarsRegional, 'UniformOutput', false)'...
             repmat({false}, length(casClimateVarsRegional), 1) repmat({false}, length(casClimateVarsRegional), 1) repmat({true}, length(casClimateVarsRegional), 1)]' ....
             [cellfun(@(x) [x '0'], casClimateVarsNational, 'UniformOutput', false)'...
             arrayfun(@(x) ['=' num2str(x)], zeros(length(casClimateVarsNational),1), 'UniformOutput', false)...
             cellfun(@(x) ['initial value for ' x], casClimateVarsNational, 'UniformOutput', false)'...
             repmat({false}, length(casClimateVarsNational), 1) repmat({false}, length(casClimateVarsNational), 1) repmat({false}, length(casClimateVarsNational), 1)]' ....
             {'phiY0'; ['= 1/' num2str(inbregions_p * inbsubsectors_p)]; 'initial share of value added'; false; true; true} ... 
             {'phiN0'; ['= 1/' num2str(inbregions_p * inbsubsectors_p)]; 'initial share of employment'; false; true; true} ...
             ];
casCategories = DefineSheetsInputFileHelp1(casParams, inbregions_p, inbsubsectors_p, inbsectors_p);
strSheet(icosheet).Categories = casCategories;                

%% Define Strucutral Parameter Sheet
icosheet = icosheet + 1;
strSheet(icosheet).Name = 'Structural Parameters';
strSheet(icosheet).Description = 'a sheet to assign values for structural parameters';
% Here we define the parameters we want to assign values in the excel sheet
% structural parameters. Column 1 assigns the symbol as used in the DGE
% CRED model, column 2 asssigns the value, column 3 assigns the description,
% in column 4 we define whether this parameter is sector specific, in
% column 5 we define whether this parameter is subsector specific, in
% column 6 we define whether this parameter is region specific. 
casParams = [{'beta'; '=0.9606'; 'discount factor'; false; false; false} ...
             {'delta'; '=0.045'; 'depreciation rate'; false; false; false} ...
             {'sH_p'; '=0.01'; 'share of investments in residential buildings relative to GDP'; false; false; false} ...
             {'phiB'; '=10'; 'foreign bond adjustment cost'; false; false; false}... s
             {'phiK'; '=10'; 'investment adjustment cost'; false; false; false}... 
             {'sigmaL'; '=0.5'; 'inverse Frisch elasticity'; false; false; false}... 
             {'sigmaC'; '=1'; 'intertemporal elasticity of substitution for consumption'; false; false; false}... 
             {'etaQ'; '=0.01'; 'elasticity of substitution between sectors'; false; false; false}... 
             {'etaF'; '=1.83'; 'elasticity of substitution between imports and domestic products'; false; false; false}... 
             {'etaX'; '=0.83'; 'supply price elasticity of exports'; false; false; false}...              
             {'tauC'; '=0.2'; 'consumption tax rate'; false; false; false}... 
             {'tauNH'; '=0'; 'tax rate on labour income'; false; false; false}... 
             {'tauKH'; '=0'; 'tax rate on capital income'; false; false; false}... 
             {'phiM'; '=0.3'; 'share of imports on total used domestic products'; false; false; false}... 
             {'iGAH'; '=8'; 'subsector to provide output for adaptaion measures for housing sector'; false; false; false}...                                        
             {'iGA'; '=0'; 'subsector to provide output for adaptaion measures in respective subsector'; false; true; false}...                           
             {'etaQA'; '=0.01'; 'elasticity of substitution between subsectors in one sector'; false; true; false}... 
             {'etaQ'; '=2'; 'elasticity of substitution between regions in one subsector'; false; true; false}... 
             {'phiQI'; '=0.5'; 'cost share of intermeidate goods'; false; true; false}... 
             {'phiM'; ['=1/' num2str(inbsubsectors_p)]; 'import shares'; false; true; false}... 
             {'phiX'; '=0.1'; 'share of exports on revenues '; false; true; false}... 
             {'etaI'; '=1.01'; 'elasticity of subsitution between primary production factors and intermediate products'; false; true; false}... 
             {'phiW'; '=0.6'; 'labour cost share'; false; true; true} ...
             {'etaNK'; '=1'; 'elasticity of subsitution between labour and captial'; false; true; true}... 
             {'tauKF'; '=0'; 'tax rate on capital expenditures'; false; true; true}... 
             {'tauNF'; '=0'; 'tax rate on labour costs'; false; true; true}... 
             ];

casCategories = DefineSheetsInputFileHelp1(casParams, inbregions_p, inbsubsectors_p, inbsectors_p);
% collect infornation in structure
strSheet(icosheet).Categories = casCategories;                
                    
%% Define Baseline scenario sheet
icosheet = icosheet + 1;
strSheet(icosheet).Name = 'Baseline';
strSheet(icosheet).Description = 'a sheet for the baseline scenario';
temp = arrayfun(@(x) arrayfun(@(y) ['gY_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casGrowthRatesY = [temp{:}];
temp = arrayfun(@(x) arrayfun(@(y) ['gN_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casGrowthRatesN = [temp{:}];

casCategoriesHeader = [{'Time'}, {'exo_PoP'}, casGrowthRatesY, casGrowthRatesN];
casData = arrayfun(@(x) num2str(x), [(2:100)' zeros(99, size(casCategoriesHeader,2)-1-size(casGrowthRatesY,2)-size(casGrowthRatesN,2)) ones(99, size(casGrowthRatesY,2)+size(casGrowthRatesN,2))],'UniformOutput', false);
casCategories = [casCategoriesHeader; casData];
strSheet(icosheet).Categories = casCategories;

%% Define Example scenario sheet
icosheet = icosheet + 1;
strSheet(icosheet).Name = 'Scenario';
strSheet(icosheet).Description = 'a sheet for a specific scenario you want to run';
temp = cellfun(@(x) arrayfun(@(y) ['exo_' x '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), casClimateVarsRegional, 'UniformOutput', false);
casClimExoReg = [temp{:}];
temp = cellfun(@(x) ['exo_' x], casClimateVarsNational, 'UniformOutput', false);
casClimExoNat = [temp{:}];
temp = arrayfun(@(x) arrayfun(@(y) ['exo_D_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casDam = [temp{:}];
temp = arrayfun(@(x) arrayfun(@(y) ['exo_D_N_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casDamN = [temp{:}];
temp = arrayfun(@(x) arrayfun(@(y) ['exo_D_K_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casDamK = [temp{:}];
temp = arrayfun(@(x) arrayfun(@(y) ['exo_GA_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casAdapt = [temp{:}];
temp = arrayfun(@(x) arrayfun(@(y) ['exo_GAP_' num2str(x) '_' num2str(y)], 1:inbregions_p, 'UniformOutput', false), 1:inbsubsectors_p, 'UniformOutput', false);
casAdaptP = [temp{:}];

casCategoriesHeader = [{'Time'}, {'exo_PoP'}, casClimExoReg, casClimExoNat, casAdapt, casAdaptP, casDam, casDamN, casDamK, {'exo_DH'},{'exo_G_A_DH'},{'exo_G_AP_DH'}];
casData = arrayfun(@(x) num2str(x), [(2:100)' zeros(99, size(casCategoriesHeader,2)-1)],'UniformOutput', false);
casCategories = [casCategoriesHeader; casData];
strSheet(icosheet).Categories = casCategories;

%% Define Content Sheet
icosheet = icosheet + 1;
casSheets = cellfun(@(x) ['=HYPERLINK("#''' x '''!A1";"' x '")'], {strSheet.Name}', 'UniformOutput', false);
casSheetDescriptions = {strSheet.Description}';
strSheet(icosheet).Name = 'Content';
casContentSheet = [{'Sheets', '', ''};...
                  [casSheets casSheetDescriptions, repmat({''}, length(casSheets),1)];...
                  {'Regions', '', ''};...
                  [arrayfun(@(x) num2str(x), 1:inbregions_p, 'UniformOutput', false)' , casRegions repmat({''}, length(casRegions),1)];...
                  {'Sectors', '', ''};...
                  [arrayfun(@(x) num2str(x), 1:inbsubsectors_p, 'UniformOutput', false)' , casSubSectors repmat({''}, length(casSubSectors),1)];...
                  ];
strSheet(icosheet).Categories = casContentSheet;




