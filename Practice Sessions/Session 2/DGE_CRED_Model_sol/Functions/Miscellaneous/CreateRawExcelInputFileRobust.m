% CreateRawExcelInputFileRobust is a Matlab script to create the
% ModelSimulationandCalibration<Number of Subsectors>Sectorsand<Number of
% Regions>Regions.xlsx  workbook for parameter and scenario definitions of the
% model.

%% Prologue
clearvars;
% define working directory path
sPathWD = pwd();

%% Define sectors
casSectors = {'Agriculture, forestry and fishing'; 'Industry'; 'Services'};
inbsectors_p = length(casSectors);
%% Define subsectors
casSubSectors = {'Agriculture, forestry and fishing'; 'Industry'; 'Services'};
inbsubsectors_p = length(casSubSectors);
%% Define regions
casRegions = {'Vietnam'};
inbregions_p = length(casRegions);

%% Define regional climate variables
casClimateVarsRegionalName = {'surface temperature (Celsius)', 'storms (storms)'};
casClimateVarsRegional = {'tas', 'storms'};

%% Define national climate variables
casClimateVarsNationalName = {'Sea level (SL)'};
casClimateVarsNational = {'SL'};
casClimateVars = [casClimateVarsRegional casClimateVarsNational];

%% Create the workbook
sWorkBookName = ['ModelSimulationandCalibration' num2str(inbsubsectors_p) 'Sectorsand' num2str(inbregions_p) 'Regions.xlsx'];


addpath([sPathWD '\Functions'])
addpath([sPathWD '\Functions\Auxiliary'])
run DefineSheetsInputFileRobust

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

for icosheet = 1:size(strSheet,2)
    if isstruct(strSheet(icosheet).Categories)
        strsubsheets = strSheet(icosheet).Categories;
        icostartcol = 1;
        for icosubsheet = 1:size(strsubsheets,2)
            inbrow = size(strsubsheets(icosubsheet).Data,1);
            inbcol = size(strsubsheets(icosubsheet).Data,2);
            dat_range = [GetExcelColumn(icostartcol) '1:' GetExcelColumn(icostartcol+inbcol-1) num2str(inbrow)]; % Example range
            writecell(strsubsheets(icosubsheet).Data,sExcelFileName, 'Sheet', strSheet(icosheet).Name, 'Range', dat_range); 
            icostartcol = icostartcol + inbcol;
        end

    elseif isequal(strSheet(icosheet).Name,'Baseline') || isequal(strSheet(icosheet).Name,'Scenario')
        inbrow = size(strSheet(icosheet).Categories,1);
        inbcol = size(strSheet(icosheet).Categories,2);
        [~, iparamcol] = ismember('Parameter', strSheet(icosheet).Categories(1,:));
        [~, ivaluecol] = ismember('Value', strSheet(icosheet).Categories(1,:));
        for icocol = 1:inbcol
                dat_range = [GetExcelColumn(icocol) '1:' GetExcelColumn(icocol) '1']; % Example range
                writecell(strSheet(icosheet).Categories(1, icocol),...
                    sExcelFileName, 'Sheet', strSheet(icosheet).Name, 'Range', dat_range)

                dat_range = [GetExcelColumn(icocol) '2:' GetExcelColumn(icocol) num2str(inbrow)]; % Example range
                writecell(strSheet(icosheet).Categories(2:end, icocol),...
                    sExcelFileName, 'Sheet', strSheet(icosheet).Name, 'Range', dat_range)
        end
    else
        inbrow = size(strSheet(icosheet).Categories,1);
        inbcol = size(strSheet(icosheet).Categories,2);
        [~, iparamcol] = ismember('Parameter', strSheet(icosheet).Categories(1,:));
        [~, ivaluecol] = ismember('Value', strSheet(icosheet).Categories(1,:));
        for icocol = 1:inbcol
            if icocol == ivaluecol
                dat_range = [GetExcelColumn(icocol) '1:' GetExcelColumn(icocol) '1']; % Example range
                writecell(strSheet(icosheet).Categories(1, icocol),...
                    sExcelFileName, 'Sheet', strSheet(icosheet).Name, 'Range', dat_range)

                dat_range = [GetExcelColumn(icocol) '2:' GetExcelColumn(icocol) num2str(inbrow)]; % Example range
                writecell(strSheet(icosheet).Categories(2:end, icocol),...
                    sExcelFileName, 'Sheet', strSheet(icosheet).Name, 'Range', dat_range)

            else
                dat_range = [GetExcelColumn(icocol) '1:' GetExcelColumn(icocol) num2str(inbrow)]; % Example range
                writecell(strSheet(icosheet).Categories(:, icocol),...
                    sExcelFileName, 'Sheet', strSheet(icosheet).Name, 'Range', dat_range)
            end
        end
    end
end

