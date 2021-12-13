% CreateRawExcelInputFile is a Matlab script to create the
% ModelSimulationandCalibration<Number of Subsectors>Sectorsand<Number of
% Regions>Regions.xlsx  workbook for parameter and scenario definitions of the
% model.

%% Prologue
clearvars;
% define working directory path
sPathWD = pwd();

%% Define sectors
casSectors = {'Rice, Agriculture excluding rice, Aquaculture, Forestry';...
              'Water, Energy, Manufacturing and Construction';
              'TransportWater'; 'TransportLand';  'Health and Services'...
              };
inbsectors_p = length(casSectors);
%% Define subsectors
casSubSectors = {'Rice'; 'Agriculture excluding rice'; 'Aquaculture'; 'Forestry';...
              'Water'; 'Energy'; 'Manufacturing'; 'Construction';
              'TransportWater'; 'TransportLand';  'Health'; 'Services'...
              };
inbsubsectors_p = length(casSubSectors);
%% Define regions
casRegions = {'Vietnam'; 'RoW'};
inbregions_p = length(casRegions);

%% Define regional climate variables
casClimateVarsRegionalName = {'surface temperature (Celsius)', 'surface windspeed (m/s)',...
    'surface precipitation flux (mm)', 'sunshine (hour per day)', 'surface relative humidity (percent)',...
    'heatwaves per year', 'maximal consecutive dry days', 'maximal consecutive wet days',...
    'number of storms (equivalent to average historic storm)', 'number of floods (equivalent to historic floods)', 'number of forest fire', ' land slides'...
    };
casClimateVarsRegional = {'tas', 'SfcWind', 'pr', 'sunshine', 'hurs', 'heatwave', 'maxdrydays', 'maxwetdays', 'storms', 'floods', 'fire', 'landslide'};

%% Define national climate variables
casClimateVarsNationalName = {'Sea level'};
casClimateVarsNational = {'SL'};
casClimateVars = [casClimateVarsRegional casClimateVarsNational];

%% Create the workbook
sWorkBookName = ['ModelSimulationandCalibration' num2str(inbsubsectors_p) 'Sectorsand' num2str(inbregions_p) 'Regions.xlsx'];


addpath([sPathWD '\Functions'])
addpath([sPathWD '\Functions\Auxiliary'])
run DefineSheetsInputFile

sExcelFileName = [pwd() '\ExcelFiles\' sWorkBookName];
if exist(sExcelFileName, 'file')
    delete(sExcelFileName)
end
writecell({' '}, sExcelFileName);
% reorder sheets
strSheettemp = strSheet;
strSheet(1) = strSheettemp(end);
strSheet(2:end) = strSheettemp(1:end-1);

[~, iposData] = ismember('Data', {strSheet.Name});
temp = cellfun(@(x) reshape(x,[],1), {strSheet(iposData).Categories.CellNames}, 'UniformOutput', false);
casCellNamesTotal = vertcat(temp{:});
casCellNamesTotal = casCellNamesTotal(cellfun(@(x) ~isempty(x), casCellNamesTotal));
exl = actxserver('excel.application');
set(exl,'AskToUpdateLinks',0)
exl.Visible = 1;
exlWkbk = exl.Workbooks;
exlFile = exlWkbk.Open(sExcelFileName);
% write data to eccel files
for icosheet = 1:size(strSheet,2)-exlFile.Sheets.Count
    exlFile.Sheets.Add;
end

for icosheet = 1:size(strSheet,2)
    exlFile.Sheets.Item(icosheet).Name = strSheet(icosheet).Name;
    exlSheet1 = exlFile.Sheets.Item(strSheet(icosheet).Name);
    exlSheet1.Activate
    if isstruct(strSheet(icosheet).Categories)
        strsubsheets = strSheet(icosheet).Categories;
        icostartcol = 1;
        for icosubsheet = 1:size(strsubsheets,2)
            inbrow = size(strsubsheets(icosubsheet).Data,1);
            inbcol = size(strsubsheets(icosubsheet).Data,2);
            dat_range = [GetExcelColumn(icostartcol) '1:' GetExcelColumn(icostartcol+inbcol-1) num2str(inbrow)]; % Example range
            rngObj = exlSheet1.Range(dat_range);
            set(rngObj,'NumberFormat','0.00');
            rngObj.Value = strsubsheets(icosubsheet).Data;
            for icorow = 1:inbrow
                for icocol = 1:inbcol
                    if ~isempty(strsubsheets(icosubsheet).CellNames{icorow, icocol})
                        rngObj = exlSheet1.Range([GetExcelColumn(icostartcol+icocol-1) num2str(icorow)]);
                        rngObj.Name = strsubsheets(icosubsheet).CellNames{icorow, icocol};
                    end
                end
            end
            icostartcol = icostartcol + inbcol+1; 
        end
        dat_range = 'A:A';
        rngObj = exlSheet1.Range(dat_range);
        exl.Cells.Select;
        % Auto fit all the columns.
        exl.Cells.EntireColumn.AutoFit;
    else
        inbrow = size(strSheet(icosheet).Categories,1);
        inbcol = size(strSheet(icosheet).Categories,2);
        [~, iparamcol] = ismember('Parameter', strSheet(icosheet).Categories(1,:));
        [~, ivaluecol] = ismember('Value', strSheet(icosheet).Categories(1,:));
        for icocol = 1:inbcol
            if icocol == ivaluecol
                dat_range = [GetExcelColumn(icocol) '1:' GetExcelColumn(icocol) '1']; % Example range
                rngObj = exlSheet1.Range(dat_range);
                rngObj.Value = strSheet(icosheet).Categories(1, icocol);                      
                dat_range = [GetExcelColumn(icocol) '2:' GetExcelColumn(icocol) num2str(inbrow)]; % Example range
                rngObj = exlSheet1.Range(dat_range);
                tempvals = cellfun(@(x) str2double(x), strSheet(icosheet).Categories(2:end, icocol), 'UniformOutput', false);               
                tempvals(cellfun(@(x) isempty(x), tempvals)) = {nan};
                rngObj.Formula = strSheet(icosheet).Categories(2:end, icocol); 
            else
                dat_range = [GetExcelColumn(icocol) '1:' GetExcelColumn(icocol) num2str(inbrow)]; % Example range
                rngObj = exlSheet1.Range(dat_range);                
                rngObj.Value = strSheet(icosheet).Categories(:, icocol);        
            end
        end
        invoke(exl.Selection.Columns,'Autofit');
        iposmerge = find(sum(cellfun(@(x) isequal(x, ' '), strSheet(icosheet).Categories),2) == 2);
        for icorow = 1:inbrow
            dat_range = ['A' num2str(icorow) ':' GetExcelColumn(inbcol) num2str(icorow)]; % Example range
            rngObj = exlSheet1.Range(dat_range);
            if sum(cellfun(@(x) isequal(x, ''), strSheet(icosheet).Categories(icorow, :)),2) == 2
                rngObj.MergeCells = 1;
                rngObj.Interior.ColorIndex = 48;
            end
            if icorow == 1 && ~ismember(strSheet(icosheet).Name , {'Data'})
                rngObj.Interior.ColorIndex = 48;
            end
        end
        dat_range = 'A:A';
        rngObj = exlSheet1.Range(dat_range);
        exl.Cells.Select;
        % Auto fit all the columns.
        exl.Cells.EntireColumn.AutoFit;
    end
end
exlFile.Save
exl.Quit
exl.release
% format excel files

