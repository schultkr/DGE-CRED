% Climate Change Scenarios for the DGE-CRED Model
% Climate Variables: Temperature (T) and Precipitation (PREC)

% Content of this file: 

% Part 1: Settings and data upload
% Part 2: Determine trajectories for T and PREC

%% Part 1: Settings and data upload

% Determine the number of periods:
PERIODS = length(YEARS); 

% Scenario settings:
[info,sheets_in_Input_file] = xlsfinfo('Input_Climate_Change_Scenarios.xlsx');
comp = @(str, pattern) ~cellfun('isempty', strfind(str, pattern));
if isoctave() == 1 
    sheets_in_Input_file = sheets_in_Input_file';
end
cv(1).logical = comp(sheets_in_Input_file,'Temp');
cv(2).logical = comp(sheets_in_Input_file,'Precipitation');
for i = 1:2
    cv(i).number_scenarios = sum(cv(i).logical(1,:));
    for ii = 1:size(sheets_in_Input_file,2)
        if cv(i).logical(1,ii) == 1
            cv(i).scenario(sum(cv(i).logical(1,1:ii))).name = sheets_in_Input_file{1,ii};
            [num,text,cv(i).scenario(sum(cv(i).logical(1,1:ii))).data] = xlsread('Input_Climate_Change_Scenarios.xlsx', cv(i).scenario(sum(cv(i).logical(1,1:ii))).name);
        end
    end
end

%% Part 2: Determine trajectories for T and PREC

% Run the calculation:
for CV = 1:2
    for R = 1:REGIONS
        for S = 1:cv(CV).number_scenarios                       
            % Split and store begin and end of intervalls:
            for i = 1:(size(cv(CV).scenario(S).data,1)-1)
                splitted = strsplit(char(cv(CV).scenario(S).data{1+i,1}),'-');
                cv(CV).scenario(S).region(R).data(i,1) = str2num(splitted{1,1});
                cv(CV).scenario(S).region(R).data(i,2) = str2num(splitted{1,2});
            end
            % Finde the data of the province, which are in region R:
            for P = 1:region(R).number_of_provinces
                for TP = 1:(size(cv(CV).scenario(S).data,2)-1)
                    if strcmp(cv(CV).scenario(S).data{1,1+TP},region(R).provinces{1,P}) == 1
                        cv(CV).scenario(S).region(R).data(:,P+2) = cell2mat(cv(CV).scenario(S).data(2:size(cv(CV).scenario(S).data,1),1+TP));
                    end
                end
            end
            % Drop the intervalls, which are NOT entirely in the considered time period (region R):
            counter = 0;
            for i = size(cv(CV).scenario(S).region(R).data,1):-1:1
                if not(ismember(cv(CV).scenario(S).region(R).data(i,1),YEARS)) || not(ismember(cv(CV).scenario(S).region(R).data(i,2),YEARS))
                    cv(CV).scenario(S).region(R).data(i,:) = [];
                end
            end
            % Sort the data:
            cv(CV).scenario(S).region(R).data = sortrows(cv(CV).scenario(S).region(R).data);
            
            % Case A: First, aggregate across the provinces within a region. Second, determine the pathways.
            if strcmp(order_of_aggregation, 'first') == 1 
                logical = isnan(cv(CV).scenario(S).region(R).data(:,3:size(cv(CV).scenario(S).region(R).data,2)));
                indicator = sum(logical,2);
                % Heterogenity in the data structure NOT allowed:
                if strcmp(allow_heterogenous_structure, 'no') == 1
                    for i = size(indicator,1):-1:1
                        if indicator(i,1) >= 1
                            % Drop intervals with NaN entries in AT LEAST one province:
                            intv = cv(CV).scenario(S).region(R).data(i,1:2);
                            cv(CV).scenario(S).region(R).data(i,:) = [];
                            province_number_NaN = find(logical(i,:));
                            province_names_NaN = [];
                            for ii = 1:size(province_number_NaN,2)
                                province_names_NaN = [province_names_NaN,'"',region(R).provinces{1,province_number_NaN(1,ii)},'" ']; 
                            end
                            disp(['NOTE: Intervall ',num2str(intv(1,1)),'-',num2str(intv(1,2)),' dropped in "',char(cv(CV).scenario(S).name),'" region ',num2str(R),', because of NaN entry in ',char(province_names_NaN),'. Consider: (i) excluding provinces with NaN entries from that region in input sheet "define regions", (ii) choosing "allow_heterogenous_structure = {''yes''}" or (iii) choosing "order_of_aggregation = {''second''}" in "CCS_Run.m".']);
                            % Error if ALL intervals were dropped:
                            if size(indicator,1) == sum(indicator)
                                province_number_NaN = find(sum(logical));
                                province_names_NaN = [];
                                for ii = 1:size(province_number_NaN,2)
                                    province_names_NaN = [province_names_NaN,'"',region(R).provinces{1,province_number_NaN(1,ii)},'" ']; 
                                end
                                error(['ERROR: All intervalls excluded in "',char(cv(CV).scenario(S).name),'" region ',num2str(R),', because of NaN entries in ',char(province_names_NaN),'.'])
                            end
                        end
                    end 
                % Heterogenity in the data structure allowed:
                else
                    % Error if there is NO data availabe at all:
                    if sum(indicator) == size(logical,1)*size(logical,2)
                        error(['ERROR: No entries provided for "',char(cv(CV).scenario(S).name),'" region ',num2str(R),'. Cannot proceed.'])
                    % Drop intervalls containing ONLY NaN entries:
                    else
                        for i = size(indicator,1):-1:1
                            if size(logical,2) == sum(logical(i,:),2)
                                intv = cv(CV).scenario(S).region(R).data(i,1:2);
                                cv(CV).scenario(S).region(R).data(i,:) = [];
                                disp(['NOTE: Intervall ',num2str(intv(1,1)),'-',num2str(intv(1,2)),' excluded in "',char(cv(CV).scenario(S).name),'" region ',num2str(R),', because of NaN entries in all provinces.'])
                            end
                        end
                    end
                end
                % Store begin and end of intervall:
                cv(CV).scenario(S).region(R).province(1).begin_intv = cv(CV).scenario(S).region(R).data(:,1)' - YEARS(1) + 1;
                cv(CV).scenario(S).region(R).province(1).end_intv = cv(CV).scenario(S).region(R).data(:,2)' - YEARS(1) + 1;
                % Determine the aggregated target:
                    % Option 1: mean
                    if strcmp(method_of_aggregation, 'mean') == 1
                         cv(CV).scenario(S).region(R).province(1).target = nanmean(cv(CV).scenario(S).region(R).data(:,3:size(cv(CV).scenario(S).region(R).data,2)),2);
                    % Option 2: population weighted
                    elseif strcmp(method_of_aggregation, 'population') == 1
                        % TBA 
                    % Option 3: area weighted
                    elseif strcmp(method_of_aggregation, 'area') == 1
                        % TBA 
                    end   
                % Check if initial value is provided:
                if (cv(CV).scenario(S).region(R).province(1).begin_intv(1,1) ~= cv(CV).scenario(S).region(R).province(1).end_intv(1,1)) || (cv(CV).scenario(S).region(R).province(1).end_intv(1,1) ~= 1)
                    error(['ERROR: No initial value found for "',char(cv(CV).scenario(S).name),'". Please provide initial values for all provinces, regions and scenarios if possible. Also check previous notifications if there are any.'])
                end
                % Check if at least two targets are provided:
                if size(cv(CV).scenario(S).region(R).province(1).begin_intv,2) < 2
                    error(['ERROR: Only ONE interval found for "',char(cv(CV).scenario(S).name),'". Please provide AT LEAST TWO valid intervales. Also check previous notifications if there are any.'])
                end
                % Other settings:
                number_loops = 1; 
                round_to = 10;      % current default setting, can be changed
            % Case B: First, determine the pathways for each province. Second, aggregate at the regional level.
            elseif strcmp(order_of_aggregation, 'second') == 1   
                % Split the region into its provinces:
                for i = 1:(size(cv(CV).scenario(S).region(R).data,2)-2)
                     cv(CV).scenario(S).region(R).province(i).data(:,1:2) = cv(CV).scenario(S).region(R).data(:,1:2);
                     cv(CV).scenario(S).region(R).province(i).data(:,3) = cv(CV).scenario(S).region(R).data(:,2+i);
                end
                % Check every province for NaN entries:
                excluded_provinces = 0;
                for i = 1:(size(cv(CV).scenario(S).region(R).data,2)-2)
                    indicator = isnan(cv(CV).scenario(S).region(R).province(i).data(:,3));
                    % Drop province if NO data is provided:
                    if sum(indicator) == size(indicator,1)
                        excluded_provinces = excluded_provinces + 1;
                        disp(['NOTE: Province "',char(region(R).provinces(i)),'" in region ',num2str(R),' was excluded in "',char(cv(CV).scenario(S).name),'", because NO entry was found.'])
                    % Drop province if NO initial value is provided:     
                    elseif indicator(1,1) == 1
                        excluded_provinces = excluded_provinces + 1;
                        disp(['NOTE: Province "',char(region(R).provinces(i)),'" in region ',num2str(R),' was excluded in "',char(cv(CV).scenario(S).name),'", because NO initial value was found.'])
                    % Drop province because ONLY initial value is provided: 
                    elseif size(indicator,1) - sum(indicator) == 1
                        excluded_provinces = excluded_provinces + 1;
                        disp(['NOTE: Province "',char(region(R).provinces(i)),'" in region ',num2str(R),' was excluded in "',char(cv(CV).scenario(S).name),'", because ONLY initial value was found.'])
                    % For all other cases:    
                    else
                        % Drop intervals containing NaN:
                        for ii = size(indicator,1):-1:1
                            if indicator(ii,1) == 1
                                cv(CV).scenario(S).region(R).province(i).data(ii,:) = [];
                            end
                        end
                        % Set up the needed structures:
                        cv(CV).scenario(S).region(R).province(i-excluded_provinces).target = cv(CV).scenario(S).region(R).province(i).data(:,3);
                        cv(CV).scenario(S).region(R).province(i-excluded_provinces).begin_intv = cv(CV).scenario(S).region(R).province(i).data(:,1)' - YEARS(1) + 1;
                        cv(CV).scenario(S).region(R).province(i-excluded_provinces).end_intv = cv(CV).scenario(S).region(R).province(i).data(:,2)' - YEARS(1) + 1;
                        % Display notification if at least one but not all intervals were dropped:
                        if (sum(indicator) < size(cv(CV).scenario(S).region(R).data,1)) && (sum(indicator) > 0)
                            disp(['NOTE: At least one interval in province "',char(region(R).provinces(i)),'" in region ',num2str(R),' was excluded in "',char(cv(CV).scenario(S).name),'" because of missing entries. Trajectory can still be determined.'])
                        end
                    end
                end
                % Ckeck if there is AT LEAST one remaining province in region R:
                if size(cv(CV).scenario(S).region(R).province,2) == excluded_provinces
                    error(['ERROR: There are no provinces for region ',num2str(R),' scenario "',char(cv(CV).scenario(S).name),'", which can be used for the calculation. Provide more date and also check previous notifications if there are any.'])
                end
                % Other settings:
                number_loops = size(cv(CV).scenario(S).region(R).province,2) - excluded_provinces;
                round_to = 1;       % current default setting, can be changed
            end
            
            % Determine the trajectories:
            for P = 1:number_loops
                % Read out relevant information:
                begin_intv = cv(CV).scenario(S).region(R).province(P).begin_intv;
                end_intv = cv(CV).scenario(S).region(R).province(P).end_intv;
                TARGET = cv(CV).scenario(S).region(R).province(P).target;
                number_targets = size(TARGET,1);
                % The objective function is defined as:
                w = [1 10];         % current default setting, can be changed
                target_initial_period = TARGET(1,1);
                objective = @(x) w(1)*1/length(diff([target_initial_period; x]))*sum(diff([target_initial_period; x]).^2) + w(2)*1/length(diff([target_initial_period; x],2))*sum(diff([target_initial_period; x],2).^2);             
                % Inequality constraints (A*x<=b):
                b = zeros(PERIODS-1,1);
                A = zeros(PERIODS-1,PERIODS-1);
                for i = 1:(number_targets-1)
                    if i == 1 && (1 ~= number_targets-1)
                        if TARGET(i,1) <= TARGET(i+1,1)
                            b(i,1) = - target_initial_period;
                            A(i,i) = -1;
                            for ii = 1:round(mean([(begin_intv(i+1)-1) (end_intv(i+1)-1)]))
                                A(ii+1,ii) = 1;
                                A(ii+1,ii+1) = -1;
                            end
                        else 
                            b(i,1) = target_initial_period;
                            A(i,i) = 1;
                            for ii = 1:round(mean([(begin_intv(i+1)-1) (end_intv(i+1)-1)]))
                                A(ii+1,ii) = -1;
                                A(ii+1,ii+1) = 1;
                            end
                        end
                    elseif i == 1 && (1 == number_targets-1)
                        if TARGET(i,1) <= TARGET(i+1,1)
                            b(i,1) = - target_initial_period;
                            A(i,i) = -1;
                            for ii = 1:(PERIODS-2)
                                A(ii+1,ii) = 1;
                                A(ii+1,ii+1) = -1;
                            end
                        else 
                            b(i,1) = target_initial_period;
                            A(i,i) = 1;
                            for ii = 1:(PERIODS-2)
                                A(ii+1,ii) = -1;
                                A(ii+1,ii+1) = 1;
                            end
                        end
                    elseif (1 < i) && (i < (number_targets-1))
                        if TARGET(i,1) <= TARGET(i+1,1)
                            for ii = round(mean([(begin_intv(i)-1) (end_intv(i)-1)])):round(mean([(begin_intv(i+1)-1) (end_intv(i+1)-1)]))
                                A(ii+1,ii) = 1;
                                A(ii+1,ii+1) = -1;
                            end
                        else 
                            for ii = round(mean([(begin_intv(i)-1) (end_intv(i)-1)])):round(mean([(begin_intv(i+1)-1) (end_intv(i+1)-1)]))
                                A(ii+1,ii) = -1;
                                A(ii+1,ii+1) = 1;
                            end
                        end
                    else 
                        if TARGET(i,1) <= TARGET(i+1,1)
                            for ii = round(mean([(begin_intv(i)-1) (end_intv(i)-1)])):(PERIODS-2)
                                A(ii+1,ii) = 1;
                                A(ii+1,ii+1) = -1;
                            end
                        else 
                            for ii = round(mean([(begin_intv(i)-1) (end_intv(i)-1)])):(PERIODS-2)
                                A(ii+1,ii) = -1;
                                A(ii+1,ii+1) = 1;
                            end
                        end
                    end
                end 
                % Equality constraints (Aeq*x=beq) needed to meet the targets:
                beq = NaN(number_targets-1,1);
                Aeq = zeros(number_targets-1,PERIODS-1);
                for i = 2:number_targets
                    if begin_intv(i) == 1
                        Aeq(i-1,1:(end_intv(i)-1)) = 1/(length(begin_intv(i):end_intv(i))-1);
                        beq(i-1,1) = TARGET(i,1) - 1/length(begin_intv(i):end_intv(i))*target_initial_period;
                        x_guess(i-1,1:(end_intv(i)-1)) = TARGET(i,1);
                    else
                        Aeq(i-1,(begin_intv(i)-1):(end_intv(i)-1)) = 1/length(begin_intv(i):end_intv(i));
                        beq(i-1,1) = TARGET(i,1);
                        x_guess(i-1,(begin_intv(i)-1):(end_intv(i)-1)) = TARGET(i,1);
                    end
                end                   
                % Initial guess:
                x_guess = zeros(PERIODS-1,1);
                %{
                % More precise initial guess, but currently not required:
                  for i = 2:number_targets
                    if (i == 2) && (begin_intv(i) ~= 1)
                      x_guess(1:(end_intv(i)-1),1) = TARGET(i,1);
                    elseif (i == 2) && (begin_intv(i) == 1)
                      x_guess(1:(end_intv(i)-1),1) = TARGET(i,1) - 1/length(begin_intv(i):end_intv(i))*target_initial_period;
                    elseif (2 < i) && (i < number_targets)
                      x_guess(end_intv(i-1):(end_intv(i)-1),1) = TARGET(i,1);
                    else
                      x_guess(end_intv(i-1):(PERIODS-1),1) = TARGET(i,1);
                    end
                  end
                %}
                % Set options:
                if isoctave() == 0
                  options = optimoptions('fmincon','Display','off','Algorithm','active-set');
                else
                  Aeq = Aeq';
                  A = A';
                  options = optimset('Algorithm','octave_sqp');
                end
                % Conduct the minimization:
                x_solution = fmincon(objective,x_guess,A,b,Aeq,beq,[],[],[],options);
                X_SOLUTION = [target_initial_period; x_solution]';
                
                % Check whether solution is close enough to the target:
                for i = 2:number_targets
                    if begin_intv(i) == 1
                        if round(mean(x_solution(1:(end_intv(i)-1)))*10^round_to) ~= round(beq(i-1)*10^round_to)
                            % Case A:
                            if strcmp(order_of_aggregation, 'first') == 1
                                disp(['NOTE: Target ', num2str(i), ' in "', char(cv(CV).scenario(S).name), '" is violated in region ', num2str(R),'. Rounded to ',num2str(round_to),' digits to the right of the decimal point.'])
                            % Case B:
                            elseif strcmp(order_of_aggregation, 'second') == 1
                                disp(['NOTE: Target ', num2str(i), ' in "', char(cv(CV).scenario(S).name), '" is violated in region ', num2str(R), ', province: "',char(region(R).provinces{1,P}),'". Rounded to ',num2str(round_to),' digits to the right of the decimal point.'])
                            end
                        end
                    else
                        if round(mean(x_solution((begin_intv(i)-1):(end_intv(i)-1)))*10^round_to) ~= round(beq(i-1)*10^round_to)
                            % Case A:
                            if strcmp(order_of_aggregation, 'first') == 1
                                disp(['NOTE: Target ', num2str(i), ' in "', char(cv(CV).scenario(S).name), '" is violated in region ', num2str(R),'. Rounded to ',num2str(round_to),' digits to the right of the decimal point.'])
                            % Case B:
                            elseif strcmp(order_of_aggregation, 'second') == 1
                                disp(['NOTE: Target ', num2str(i), ' in "', char(cv(CV).scenario(S).name), '" is violated in region ', num2str(R), ', province: "',char(region(R).provinces{1,P}),'". Rounded to ',num2str(round_to),' digits to the right of the decimal point.'])
                            end
                        end
                    end
                end  
                
                % Case A: Store the solution
                if strcmp(order_of_aggregation, 'first') == 1 
                    cv(CV).scenario(S).region(R).output = X_SOLUTION';
                % Case B: Store the solution
                elseif strcmp(order_of_aggregation, 'second') == 1 
                    cv(CV).scenario(S).region(R).province(P).output = X_SOLUTION';
                    if P == number_loops
                        % Case B: Aggregate at the regional level
                        % Option 1: mean
                        if strcmp(method_of_aggregation, 'mean') == 1
                            cv(CV).scenario(S).region(R).output = mean([cv(CV).scenario(S).region(R).province(:).output],2);
                        % Option 2: population weighted
                        elseif strcmp(method_of_aggregation, 'population') == 1
                            % TBA
                        % Option 3: area weighted
                        elseif strcmp(method_of_aggregation, 'area') == 1
                            % TBA
                        end  
                    end
                end
                
            end                    
            
        end
    end
end
    