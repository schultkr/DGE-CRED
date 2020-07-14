% Climate Change Scenarios for the DGE-CRED Model
% Final Step: Generate the output.

% Content of this file: 

% Part 1: Delete the existing output files.
% Part 2: Generates the entire output for all regions, climate variables 
% and climate scenarios.
% Part 3: Generate only the customized output for all regions. 
% Part 4: Generate graphics for the customized output.

%% Part 1: Delete existing output files

% Delete Entire output:
if (strcmp(delete_existing_output, 'yes') == 1) && (strcmp(generate_entire_output, 'yes') == 1) && (isfile('entire_Output_Climate_Change_Scenarios.xlsx') == 1)
    delete('entire_Output_Climate_Change_Scenarios.xlsx');
end
% Delete Customized output:
if (strcmp(delete_existing_customized_output, 'yes') == 1) && (strcmp(generate_customized_output, 'yes') == 1) && (isfile('customized_Output_Climate_Change_Scenarios.xlsx') == 1)
    delete('customized_Output_Climate_Change_Scenarios.xlsx');
end

%% Part 2: Generate the entire output

if  strcmp(generate_entire_output, 'yes') == 1
    % Filename:
    filename = 'entire_Output_Climate_Change_Scenarios.xlsx';
    % Generate T and PREC output:
    for CV = 1:2
        for S = 1:cv(CV).number_scenarios
            % Set up the output table:
            table_heading = cell(1,REGIONS+1);
            table_heading{1,1} = 'year';
            output = NaN(PERIODS,REGIONS+1);
            output(:,1) = YEARS';
            for R = 1:REGIONS
                if CV == 1
                    cv(CV).scenario(S).region(R).output_var_name = ['exo_T_', num2str(R)];
                else
                    cv(CV).scenario(S).region(R).output_var_name = ['exo_PREC_', num2str(R)];
                end
                table_heading{1,1+R} = cv(CV).scenario(S).region(R).output_var_name;
                output(:,1+R) = cv(CV).scenario(S).region(R).output;
            end
            % Generate the excel sheet:
            if isoctave() == 1 
                xlswrite(filename,table_heading,cv(CV).scenario(S).name,'A1'); 
                xlswrite(filename,output,cv(CV).scenario(S).name,'A2');
            else
                T = array2table(output);
                T.Properties.VariableNames = table_heading;
                writetable(T, filename, 'Sheet', cv(CV).scenario(S).name, 'Range', 'A1');
            end
        end
    end
    % Generate the SL output:
    for S = 1:SCENARIOS_SL
        % Set up the output table:
        table_heading = {'year','exo_SL'};
        % Generate the excel sheet:
        if isoctave() == 1 
            xlswrite(filename,table_heading,SL(S).scenario_name,'A1'); 
            xlswrite(filename,exo_SL(:,S),SL(S).scenario_name,'A2');
        else
            T = table(YEARS',exo_SL(:,S));
            T.Properties.VariableNames = table_heading;
            writetable(T, filename, 'Sheet', SL(S).scenario_name, 'Range', 'A1');
        end
    end
    % Generate sheet with information about regions:
    table_info = cell(REGIONS,2);
    table_info_heading = cell(1,2);
    table_info_heading{1,1} = 'Region_Number';
    table_info_heading{1,2} = 'Region_Name';
    for i = 1:REGIONS
        table_info{i,1} = i;
        table_info{i,2} = region(i).name;
    end
    if isoctave() == 1 
        xlswrite(filename,table_info_heading,'info','A1'); 
        xlswrite(filename,table_info,'info','A2');
    else
        T = cell2table(table_info);
        T.Properties.VariableNames = table_info_heading;
        writetable(T, filename, 'Sheet', 'info', 'Range', 'A1');
    end
end
    
%% Part 3: Generate the customized output: 

if  strcmp(generate_customized_output, 'yes') == 1
    % Filename:
    filename = 'customized_Output_Climate_Change_Scenarios.xlsx';
    % Generate storage for the customized output:
    output_customized = zeros(PERIODS,2*REGIONS+2);
    output_customized(:,1) = YEARS';
    % Temperature:
    if strcmp(customized_output_T, 'yes') == 1        
        for S = 1:cv(1).number_scenarios
            if strcmp(char(cv(1).scenario(S).name), ['RCP ',char(customized_output_RCP),' Temp ',char(customized_output_T_type)]) == 1
                for R = 1:REGIONS
                    output_customized(:,1+R) = cv(1).scenario(S).region(R).output;
                end
            end
        end
    end
    % Precipitation:
    if strcmp(customized_output_PREC, 'yes') == 1        
        for S = 1:cv(2).number_scenarios
            if strcmp(char(cv(2).scenario(S).name), ['RCP ',char(customized_output_RCP),' Precipitation ',char(customized_output_PREC_type)]) == 1
                for R = 1:REGIONS
                    output_customized(:,1+REGIONS+R) = cv(2).scenario(S).region(R).output;
                end
            end
        end
    end
    % Sea Level:
    if strcmp(customized_output_SL, 'yes') == 1        
        for S = 1:SCENARIOS_SL
            if  strcmp(char(SL(S).scenario_name), ['RCP ',char(customized_output_RCP),' Sea Level ',char(customized_output_SL_type)]) == 1
                output_customized(:,2*REGIONS+2) = exo_SL(:,S);
            end
        end
    end
    % Generate the table heading:
    table_heading = cell(1,2+2*REGIONS);
    table_heading{1,1} = 'year';
    table_heading{1,2+2*REGIONS} = 'exo_SL';
    for i = 1:2*REGIONS
        if i < 1+REGIONS
            table_heading{1,1+i} = ['exo_T_', num2str(i)];
        else
            table_heading{1,1+i} = ['exo_PREC_', num2str(i-REGIONS)];
        end
    end
    % Generate the sheet name:
    label = cell(1,3);
    customized(1).yesno = customized_output_T;
    customized(2).yesno = customized_output_PREC;
    customized(3).yesno = customized_output_SL;
    customized(1).type = customized_output_T_type;
    customized(2).type = customized_output_PREC_type;
    customized(3).type = customized_output_SL_type;
    customized(1).sheet_name = {'Ta ','Tl ','Tu ',''};
    customized(2).sheet_name = {'PRECa ','PRECl ','PRECu ',''};
    customized(3).sheet_name = {'SLa','SLl','SLu',''};
    for i = 1:3
        if  strcmp(char(customized(i).yesno), 'yes') == 1
            if strcmp(char(customized(i).type), 'Average') == 1
                label{1,i} = customized(i).sheet_name{1,1};
            elseif strcmp(char(customized(i).type), 'Lower') == 1
                label{1,i} = customized(i).sheet_name{1,2};
            else
                label{1,i} = customized(i).sheet_name{1,3};
            end
        else
            label{1,i} = customized(i).sheet_name{1,4};
        end
    end
    customized_sheet_name = ['RCP ', char(customized_output_RCP), ' ', label{1,1}, label{1,2}, label{1,3}];
    % Generate the excel file:
    if isoctave() == 1 
        xlswrite(filename,table_heading,customized_sheet_name,'A1'); 
        xlswrite(filename,output_customized,customized_sheet_name,'A2');
    else
        T = array2table(output_customized);
        T.Properties.VariableNames = table_heading;
        writetable(T, filename, 'Sheet', customized_sheet_name, 'Range', 'A1');
    end
    % Generate sheet with information about regions:
    table_info = cell(REGIONS,2);
    table_info_heading = cell(1,2);
    table_info_heading{1,1} = 'Region_Number';
    table_info_heading{1,2} = 'Region_Name';
    for i = 1:REGIONS
        table_info{i,1} = i;
        table_info{i,2} = region(i).name;
    end
    if isoctave() == 1 
        xlswrite(filename,table_info_heading,'info','A1'); 
        xlswrite(filename,table_info,'info','A2');
    else
        T = cell2table(table_info);
        T.Properties.VariableNames = table_info_heading;
        writetable(T, filename, 'Sheet', 'info', 'Range', 'A1');
    end
end

%% Part 4: Graphics for the customized output

if strcmp(customized_output_figures, 'yes') == 1       
    % Figure settings:
    graph(1).title = ['RCP ', char(customized_output_RCP), ' Temperature ', char(customized_output_T_type)];
    graph(2).title = ['RCP ', char(customized_output_RCP), ' Precipitation ', char(customized_output_PREC_type)];
    graph(3).title = ['RCP ', char(customized_output_RCP), ' Sea Level ', char(customized_output_SL_type)];
    graph(1).y_lable = 'temperature (°C)';
    graph(2).y_lable = 'precipitation (%)';
    graph(3).y_lable = 'sea level (cm)';
    graph(1).position = 2:REGIONS+1;
    graph(2).position = REGIONS+2:2*REGIONS+1;
    graph(3).position = 2*REGIONS+2;
    for R = 1:REGIONS
        graph(1).legend{1,R} = ['Region ', num2str(R)];
        graph(2).legend{1,R} = ['Region ', num2str(R)];
    end
    graph(3).legend = 'coastline';
    % Generate figure:
    for i = 1:3        
        if strcmp(char(customized(i).yesno), 'yes') == 1 
            if isoctave() == 0
                fig = figure; clf
                opts.width = 10;
                opts.height = 8;
                opts.fontType = 'Arial';
                opts.fontSize = 9;
                axis tight
                fig.Units = 'centimeters';
                fig.Position(3) = opts.width;
                fig.Position(4) = opts.height;
            else
                figure(i);
            end
        plot(YEARS,output_customized(:,graph(i).position), 'LineWidth', 1)        
        ylabel(graph(i).y_lable)
        xlabel('years')
        xlim([YEARS(1) YEARS(PERIODS)]);
            if isoctave() == 0
                set(fig.Children, ...
                    'FontName',     'Arial', ...
                    'FontSize',     9);
                set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
                set(gca,'box','off')
                set(0,'DefaultAxesTitleFontWeight','normal');
                legend(char(graph(i).legend), 'Location', 'NorthWest', 'FontSize',7)
            else
                legend(char(graph(i).legend), "location", "northwest")
            end
        title(graph(i).title)
        end            
    end    
end
