% Climate Change Scenarios for the DGE-CRED Model
% Climate Variable: Sea Level (SL)

% Content of this file: 

% Part 1: Determine the SL trajectories by estimating the model: 
% SL_{t} = SL_{0} + beta_1 * (t-1) + beta_2 * (t-2)^2 + epsilon
% Part 2: Optional, the regression results are strored.

%% Part 1: Determine SL trajectories

% Upload SL data:
[num,text,DATA_SL] = xlsread('Input_Climate_Change_Scenarios.xlsx', 'Sea Level');

% Define the targets:
SCENARIOS_SL = size(DATA_SL,2) - 1;
number_targets_SL = size(DATA_SL,1) - 1;
SL_target = NaN(PERIODS,SCENARIOS_SL);
for i = 1:SCENARIOS_SL
    SL(i).scenario_name = char(DATA_SL{1,1+i});
    for ii = 1:number_targets_SL
        if ismember(cell2mat(DATA_SL(1+ii,1)),YEARS) == 1
            SL_target(cell2mat(DATA_SL(1+ii,1))-YEARS(1,1)+1,i) = cell2mat(DATA_SL(1+ii,1+i));
        end
    end
    % Display notification if NO initial value SL_{0} is provided:
    if (isnan(SL_target(1,i)) == 1) && (sum(isnan(SL_target(:,i))) > PERIODS-1) 
        disp(['NOTE: No initial value for Sea Level is provided for scenario "',char(SL(i).scenario_name),'". The trajectory can be determined, but is recommendable to include an initial value.'])
    elseif sum(isnan(SL_target(:,i))) == PERIODS
        error(['ERROR: No values for Sea Level is provided for scenario "',char(SL(i).scenario_name),'". The trajectory cannot be determined.'])
    elseif sum(isnan(SL_target(:,i))) == PERIODS-1
        error(['ERROR: Only initial value for Sea Level is provided for scenario "',char(SL(i).scenario_name),'". The trajectory cannot be determined.'])
    end
end

% Display notification, if initial values are NOT the same across the sceanrios:
if size(unique(SL_target(1,:)),2) ~= 1
    disp(['NOTE: Initial values for Sea Level are not the same across the scenarios. The trajectories can be determined for all scenarios, but this hampers the comparability between them.'])
end
    
% Subtract intercept (SL_0):
intercept = SL_target(1,:);
intercept(isnan(intercept)) = 0;
SL_projection_no_intercept = SL_target - intercept;

% Create the time variables x(1)=(t-1) and x(2)=(t-1)^2:
X = zeros(PERIODS,2);
for i = 1:PERIODS
    X(i,1) = (i-1);
    X(i,2) = (i-1)^2;
end

% Generate storage variables:
R_squared = NaN(1,SCENARIOS_SL);
exo_SL = NaN(PERIODS,SCENARIOS_SL);
alpha = 0.05; % current default setting, can be changed
result_regression_SL = NaN(SCENARIOS_SL,8);
result_regression_SL(:,8) = alpha;

% Do the Regression:
for i = 1:SCENARIOS_SL
    % Run the quadratic regression:
    warning('off')
    [b,bint,r,rint,stats] = regress(SL_projection_no_intercept(:,i),X,alpha);
    % Drop "beta_2" if not significant at the 5% level:
    if  bint(2,1) <= 0 && 0 <= bint(2,2) 
        [b,bint,r,rint,stats] = regress(SL_projection_no_intercept(:,i),X(:,1),alpha);
        % Check if "beta_1" is now significant:
        if  bint(1,1) <= 0 && 0 <= bint(1,2)
            error('ERROR: After dropping "b_2" in SL regression, "b_1" is not significant at the 5% level in the new reduced functional form.');
        else 
            SL_projection_no_intercept_hat = X(:,1)*b(1,1);
            exo_SL(:,i) = SL_projection_no_intercept_hat + intercept(1,i);
            % Save the regression results:
            result_regression_SL(i,1) = b;
            result_regression_SL(i,3:4) = b;
            result_regression_SL(i,7) = stats(1,1);
        end
    % Display error message, if "beta_2" significant but "beta_1" is not:
    elseif (bint(2,1) > 0 || bint(2,2) < 0) && (bint(1,1) <= 0 && 0 <= bint(1,2))
        error('ERROR: "b_2" in SL regression is significant, but "b_1" is not.');
    % Move on if "beta_2" and "beta_1" both are significant at the 5% level:
    else
        SL_projection_no_intercept_hat = X*b;
        exo_SL(:,i) = SL_projection_no_intercept_hat + intercept(1,i);
        % Save the regression results:
        result_regression_SL(i,1:2) = b';
        result_regression_SL(i,3:4) = bint(1,:);
        result_regression_SL(i,5:6) = bint(2,:);
        result_regression_SL(i,7) = stats(1,1);
        
    end
end
    
%% Part 3: Store the SL Regression Results

if strcmp(RESULTS_regression_SL{1,1}, 'yes') == 1
    % Delete existing file:
    if  isfile('Results_SL_Regression.xlsx') == 1
        delete('Results_SL_Regression.xlsx');
    end
    % Create Excel file containing the results:
    filename = 'Results_SL_Regression.xlsx';
    SL_colum_header = DATA_SL(1,2:SCENARIOS_SL+1)';
    SL_row_header = {'Scenario','beta1','beta2','beta1_CI_95_lower','beta1_CI_95_upper','beta2_CI_95_lower','beta2_CI_95_upper','R_squared','alpha'};
    if isoctave() == 1 
        xlswrite(filename,SL_colum_header,'Sheet1','A2'); 
        xlswrite(filename,SL_row_header,'Sheet1','A1'); 
        xlswrite(filename,result_regression_SL,'Sheet1','B2');
    else
        T = cell(SCENARIOS_SL,9);
        T(1:SCENARIOS_SL,1) = SL_colum_header;
        T(1:SCENARIOS_SL,2:9) = num2cell(result_regression_SL); 
        T = cell2table(T);
        T.Properties.VariableNames = SL_row_header;
        writetable(T, filename, 'Range', 'A1');
    end
end
