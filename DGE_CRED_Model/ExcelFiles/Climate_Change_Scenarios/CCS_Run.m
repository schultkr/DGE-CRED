clear all
close all

disp '********************* START CCS ***********************'

% Title: Climate Change Scenarios for the DGE-CRED Model

% Description: The aim of this set of files is to generate regional climate 
% change scenarios (CCS) for the climate variables temperature (T), 
% precipitation (PREC) and sea level (SL). 

% Note on using Matlab or Octave:
% This version of the CCS code  in general runs on both, Matlab R2018b (or 
% newer) and GNU Octave 5.2.0. The only difference is that the
% "order_of_aggregation" can not be set to {'second'} in Octave, due to a
% lack of computational power. Also, the algorithm "active-set/octave_sqp"
% has to be used in Octave during the determiniation of the temperature and
% precipitation trajectories. In Matlab other algorithmus could be chosen
% as well.

% Content of this file: 

% Part 1: Choose among different options/procedures. 
% Part 2: Run the complementary MATLAB files.

%% Part 1: Settings

% Provide information in "Input_Climate_Change_Scenarios.xlsx":
% Remove "XR_" infront of the workbooks available in this directory if you 
% want to use them. 
% The mapping between the provinces/cities and regions has to be defined 
% mannually by the user. Data for the three climate variables must also be
% provided in the respective input sheets.

% Choose the time period:
YEARS = 2016:1:2100;

% Only if Octave is used:
install_packages = {'no'};                                                  % choose among: {'yes', 'no'}; Only relevant for first time users.
load_packages = {'yes'};                                                    % choose among: {'yes', 'no'}; Only relevant during first run of a session.

% Methode of aggregation among the provinces/cities within each region:
method_of_aggregation = {'mean'};                                           % Currently: only 'mean' available. Could be extended for {'mean','population','area'}.  
order_of_aggregation = {'first'};                                           % choose among: {'first', 'second'}
allow_heterogenous_structure = {'no'};                                      % choose among: {'yes', 'no'}; Heterogenous stucture: Potentially not the same number of observations in each time interval provided.

% Safe regression results for SL:
RESULTS_regression_SL = {'no'};                                             % choose among: {'yes', 'no'}

% Choose desired output:
generate_entire_output = {'no'};                                           % choose among: {'yes', 'no'}
generate_customized_output = {'no'};                                       % choose among: {'yes', 'no'}

% If customized_output = {'yes'}:
customized_output_RCP = {'4.5'};                                            % enter RCP number as: {'X.Y'}
customized_output_T = {'yes'};                                              % choose among: {'yes', 'no'}
customized_output_T_type = {'Average'};                                     % choose among: {'Average', 'Lower', 'Upper'}
customized_output_PREC = {'yes'};                                           % choose among: {'yes', 'no'}
customized_output_PREC_type = {'Average'};                                  % choose among: {'Average', 'Lower', 'Upper'}
customized_output_SL = {'yes'};                                             % choose among: {'yes', 'no'}
customized_output_SL_type = {'Average'};                                    % choose among: {'Average', 'Lower', 'Upper'}

% Generate figures for the customized output:
customized_output_figures = {'no'};                                        % choose among: {'yes', 'no'}

% Delete existing excel output file, before generating the new one:
delete_existing_output = {'yes'};                                           % choose among: {'yes', 'no'}; Recommended to choose 'yes'.
delete_existing_customized_output = {'yes'};                                % choose among: {'yes', 'no'}; Recommended to choose 'yes'.

% Now: Press "Run" to obtain the results.

%% Part 2: Run the complementary MATLAB files

% Run "CCS_Octave_setup.m":
CCS_octave_setup;

% Run "CCS_mapping_region_provinces.m":
CCS_mapping_region_provinces;

% Run "CCS_T_and_PREC.m":
CCS_T_and_PREC;

% Run "CCS_SL.m":
CCS_SL;

% Run "CCS_output.m":
CCS_output;

disp '********************** END CCS ************************'
