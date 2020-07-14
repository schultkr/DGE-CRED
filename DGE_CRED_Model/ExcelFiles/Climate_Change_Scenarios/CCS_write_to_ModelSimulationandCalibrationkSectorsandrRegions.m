% Important: The file "CCS_Run.m" has to be excecuted before this file can
% be used!

% Content: This file allows to assemble different scenarios for the climate 
% variables temperature (T), precipitation (PREC) and sea level (SL), AFTER
% the trajectories of the climate variables have been determined. It writes 
% these scenarios directly into the Excel workbook 
% "ModelSimulationandCalibrationXSectorsandYRegions.xlsx", which is needed 
% for the simulation of the DGE-CRED model. The number of considered regions 
% is determined by the previously executed files, while the number of sectors 
% must be chosen by the user.

% Note: (i) The current version of this code overwrites existing sheets if 
% the new sheet has the same name. (ii) The initial values (t=1) are
% subtracted.

%% Part 1: Settings for the scenario sheet

% Choose the number of sectors:
number_of_sectors = 3;

% Design your scenario:
simulation_scenario_RCP = {'4.5'};                                            % enter RCP number as: {'X.Y'}
simulation_scenario_T = {'yes'};                                              % choose among: {'yes', 'no'}
simulation_scenario_type = {'Average'};                                     % choose among: {'Average', 'Lower', 'Upper'}
simulation_scenario_PREC = {'yes'};                                           % choose among: {'yes', 'no'}
simulation_scenario_PREC_type = {'Average'};                                  % choose among: {'Average', 'Lower', 'Upper'}
simulation_scenario_SL = {'yes'};                                             % choose among: {'yes', 'no'}
simulation_scenario_SL_type = {'Average'};                                    % choose among: {'Average', 'Lower', 'Upper'}

%% Part 2: Generate the scenario sheet

% Filename:
this_dir = pwd;
idcs = strfind(this_dir,'/');
directory = this_dir(1:idcs(end)-1);
filename = [directory,'/ModelSimulationandCalibration',num2str(number_of_sectors),'Sectorsand',num2str(REGIONS),'Regions.xlsx'];
% Generate storage for the scenario output:
output_scenario = zeros((PERIODS-2),2*REGIONS+3);
output_scenario(:,1) = (2:(PERIODS-1))';
% Population:
DATA_pop = xlsread('Input_Climate_Change_Scenarios.xlsx', 'Population');
for i = 1:size(DATA_pop,1)
    if ismember(DATA_pop(i,1),YEARS)
        output_scenario(DATA_pop(i,1)-YEARS(1),2) = DATA_pop(i,2);
    end
end
% Temperature:
if strcmp(simulation_scenario_T, 'yes') == 1        
    for S = 1:cv(1).number_scenarios
        if strcmp(char(cv(1).scenario(S).name), ['RCP ',char(simulation_scenario_RCP),' Temp ',char(simulation_scenario_type)]) == 1
            for R = 1:REGIONS
                output_scenario(:,2+R) = cv(1).scenario(S).region(R).output(2:(PERIODS-1)) - cv(1).scenario(S).region(R).output(1); % subtract initial value
            end
        end
    end
end
% Precipitation:
if strcmp(simulation_scenario_PREC, 'yes') == 1        
    for S = 1:cv(2).number_scenarios
        if strcmp(char(cv(2).scenario(S).name), ['RCP ',char(simulation_scenario_RCP),' Precipitation ',char(simulation_scenario_PREC_type)]) == 1
            for R = 1:REGIONS
                output_scenario(:,2+REGIONS+R) = cv(2).scenario(S).region(R).output(2:(PERIODS-1)) - cv(2).scenario(S).region(R).output(1); % subtract initial value
            end
        end
    end
end
% Sea Level:
if strcmp(simulation_scenario_SL, 'yes') == 1        
    for S = 1:SCENARIOS_SL
        if  strcmp(char(SL(S).scenario_name), ['RCP ',char(simulation_scenario_RCP),' Sea Level ',char(simulation_scenario_SL_type)]) == 1
            output_scenario(:,2*REGIONS+3) = (exo_SL(2:(PERIODS-1),S) - exo_SL(1,S))/100; % subtract initial value
        end
    end
end
% Generate the table heading:
table_heading = cell(1,2+2*REGIONS);
table_heading{1,1} = 'Time';
table_heading{1,2} = 'exo_PoP';
table_heading{1,3+2*REGIONS} = 'exo_SL';
for i = 1:2*REGIONS
    if i < 1+REGIONS
        table_heading{1,2+i} = ['exo_T_', num2str(i)];
    else
        table_heading{1,2+i} = ['exo_PREC_', num2str(i-REGIONS)];
    end
end
% Generate the sheet name:
splitted = strsplit(char(simulation_scenario_RCP),'.');
str_RCP_number = [splitted{1,1} splitted{1,2}];
simulation_scenario(1).yesno = simulation_scenario_T;
simulation_scenario(2).yesno = simulation_scenario_PREC;
simulation_scenario(3).yesno = simulation_scenario_SL;
simulation_scenario(1).type = simulation_scenario_type;
simulation_scenario(2).type = simulation_scenario_PREC_type;
simulation_scenario(3).type = simulation_scenario_SL_type;
simulation_scenario(1).sheet_name = {'Ta_','Tl_','Tu_',''};
simulation_scenario(2).sheet_name = {'PRECa_','PRECl_','PRECu_',''};
simulation_scenario(3).sheet_name = {'SLa','SLl','SLu',''};
% Set up a logical to check whether the same scenario "type" (i.e. Average/Lower/Upper is selected:
logical = zeros(3,2);
for i = 1:3
    if strcmp(simulation_scenario(i).yesno,'yes') == 1
        logical(i,1) = 1;  
    end
    if strcmp(simulation_scenario(i).type,'Average') == 1
        logical(i,2) = 1;
    elseif strcmp(simulation_scenario(i).type,'Lower') == 1
        logical(i,2) = 2;
    elseif strcmp(simulation_scenario(i).type,'Upper') == 1
        logical(i,2) = 3;
    end
end
% Exclude the climate variables, which are not considered:
for i = 3:1:1
    if logical(i,1) == 0
        logical(i,1) = [];
    end
end
% Determine the sheet name:
if size(unique(logical(:,2)),1) == 1
    if unique(logical(:,2)) == 1
        simulation_scenario_sheet_name = ['RCP_', str_RCP_number, '_Average' ];
    elseif unique(logical(:,2)) == 2
        simulation_scenario_sheet_name = ['RCP_', str_RCP_number, '_Lower', ];
    elseif unique(logical(:,2)) == 3
        simulation_scenario_sheet_name = ['RCP_', str_RCP_number, '_Upper', ];
    end
else
    label = cell(1,3);
    for i = 1:3
        if  strcmp(char(simulation_scenario(i).yesno), 'yes') == 1
            if strcmp(char(simulation_scenario(i).type), 'Average') == 1
                label{1,i} = simulation_scenario(i).sheet_name{1,1};
            elseif strcmp(char(simulation_scenario(i).type), 'Lower') == 1
                label{1,i} = simulation_scenario(i).sheet_name{1,2};
            else
                label{1,i} = simulation_scenario(i).sheet_name{1,3};
            end
        else
            label{1,i} = simulation_scenario(i).sheet_name{1,4};
        end
    end
    simulation_scenario_sheet_name = ['RCP_', str_RCP_number, '_', label{1,1}, label{1,2}, label{1,3}];
end
% Generate the excel sheet:
if isoctave() == 1 
    xlswrite(filename,table_heading,simulation_scenario_sheet_name,'A1'); 
    xlswrite(filename,output_scenario,simulation_scenario_sheet_name,'A2');
else
    T = array2table(output_scenario);
    T.Properties.VariableNames = table_heading;
    writetable(T, filename, 'Sheet', simulation_scenario_sheet_name, 'Range', 'A1');
end
