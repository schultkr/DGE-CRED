% UpdateDataExcel is a Matlab script to update the
% ModelSimulationandCalibration<Number of Subsectors>Sectorsand<Number of
% Regions>Regions.xlsx  workbook for parameter and scenario definitions of the
% model. It writes theinformation in the data sheet to the sheets
% Structural parameters and Start.

%% User Input
clearvars;
% define working directory path
sPathWD = pwd();
% define number of total subsectors
inbsubsectors_p = 12;
% define number of regions
inbregions_p = 2;


%% Update the excel file
% define name of excel workbook for input of model
sWorkBookName = ['ModelSimulationandCalibration' num2str(inbsubsectors_p) 'Sectorsand' num2str(inbregions_p) 'Regions.xlsx'];

addpath([sPathWD '\Functions'])
addpath([sPathWD '\Functions\Auxiliary'])

sExcelFileName = [pwd() '\ExcelFiles\' sWorkBookName];
if ~exist(sExcelFileName, 'file')
    error('First run CreateRawExcelInputFile.m')
end

exl = actxserver('excel.application');
set(exl,'AskToUpdateLinks',0)
exl.Visible = 1;
exlWkbk = exl.Workbooks;
exlFile = exlWkbk.Open(sExcelFileName);

[inbrow, inbcol] = size(exlFile.Sheets.Item('Data').UsedRange.Value);
casCellNames = {''};
for icorow = 1:inbrow
    for icocol = 1:inbcol
        try 
            casCellNames = [casCellNames {exlFile.Sheets.Item('Data').Range([GetExcelColumn(icocol) num2str(icorow)]).Name.Name}];%#ok
        catch
            
        end
    end
end
casCellNames = casCellNames(2:end);

for icosheet = 1:exlFile.Sheets.Count
    if ~ismember(exlFile.Sheets.Item(icosheet).Name, {'Content', 'Data', 'Damage Functions'})
        exlSheet1 = exlFile.Sheets.Item(icosheet);
        exlSheet1.Activate
        inbrow = size(exlSheet1.UsedRange.Value,1);
        inbcol = size(exlSheet1.UsedRange.Value,2);
        caHeader = exlSheet1.Range(['A1:' GetExcelColumn(inbcol) '1']).Value;
        [~, iparamcol] = ismember('Parameter', caHeader);
        [~, ivaluecol] = ismember('Value', caHeader);
        if iparamcol > 0 && ivaluecol > 0
            for icorow = 1:inbrow
                dat_range = ['A' num2str(icorow) ':' GetExcelColumn(inbcol) num2str(icorow)];
                nam_range = [GetExcelColumn(iparamcol) num2str(icorow)];
                rngObj = exlSheet1.Range(dat_range);
                cavalues = rngObj.Value;
                if ismember(cavalues{1, iparamcol}, casCellNames) 
                    sParamName = cavalues{1, iparamcol};
                    sDefaultValue = cavalues{1, iparamcol};
                    dat_range = [GetExcelColumn(ivaluecol) num2str(icorow)];
                    rngObj = exlSheet1.Range(dat_range);
                    if ~isequal(exlFile.Sheets.Item('Data').Range(sParamName).Value,'enter value here')
                        rngObj.Value = exlFile.Sheets.Item('Data').Range(sParamName).Value;
                    end
                end
            end
        end
    end
end
exlFile.Save
exl.Quit
exl.release
% format excel files


exl = actxserver('excel.application');
set(exl,'AskToUpdateLinks',0)
exl.Visible = 1;
exlWkbk = exl.Workbooks;
exlFile = exlWkbk.Open(sExcelFileName);

[inbrow, inbcol] = size(exlFile.Sheets.Item('Data').UsedRange.Value);
casCellNames = {''};
for icorow = 1:inbrow
    for icocol = 1:inbcol
        try 
            casCellNames = [casCellNames {exlFile.Sheets.Item('Data').Range([GetExcelColumn(icocol) num2str(icorow)]).Name.Name}];%#ok
        catch
            
        end
    end
end
casCellNames = casCellNames(2:end);
for icosheet = 1:exlFile.Sheets.Count
    if ~ismember(exlFile.Sheets.Item(icosheet).Name, {'Content', 'Data', 'Damage Functions'})
        exlSheet1 = exlFile.Sheets.Item(icosheet);
        exlSheet1.Activate
        inbrow = size(exlSheet1.UsedRange.Value,1);
        inbcol = size(exlSheet1.UsedRange.Value,2);
        caHeader = exlSheet1.Range(['A1:' GetExcelColumn(inbcol) '1']).Value;
        [~, iparamcol] = ismember('Parameter', caHeader);
        [~, ivaluecol] = ismember('Value', caHeader);
        if iparamcol > 0 && ivaluecol > 0
            for icorow = 1:inbrow
                dat_range = ['A' num2str(icorow) ':' GetExcelColumn(inbcol) num2str(icorow)];
                nam_range = [GetExcelColumn(iparamcol) num2str(icorow)];
                rngObj = exlSheet1.Range(dat_range);
                cavalues = rngObj.Value;
                if ismember(cavalues{1, iparamcol}, casCellNames) 
                    sParamName = cavalues{1, iparamcol};
                    sDefaultValue = cavalues{1, iparamcol};
                    dat_range = [GetExcelColumn(ivaluecol) num2str(icorow)];
                    rngObj = exlSheet1.Range(dat_range);
                    if ~isequal(exlFile.Sheets.Item('Data').Range(sParamName).Value,'enter value here')
                        rngObj.Value = exlFile.Sheets.Item('Data').Range(sParamName).Value;
                    end
                end
            end
        end
    end
end

exlFile.Save
exl.Quit
exl.release