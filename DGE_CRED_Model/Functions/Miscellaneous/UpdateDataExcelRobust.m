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

caData = readcell(sExcelFileName, 'Sheet','Data');
casDataString = caData;
casDataString(cellfun(@(x) isequal(ismissing(x),1), casDataString)) = {' '};
casDataString(cellfun(@(x) isnumeric(x), casDataString)) = cellfun(@(x) num2str(x), casDataString(cellfun(@(x) isnumeric(x), casDataString)), 'UniformOutput', false);

casSheetNames = sheetnames(sExcelFileName);
for icosheet = 1:length(casSheetNames)
    sSheetName = char(casSheetNames(icosheet));
    if ~ismember(sSheetName, {'Sheet1', 'Content', 'Data', 'Damage Functions'})
        caValues = readcell(sExcelFileName, 'Sheet', sSheetName);
        inbrow = size(caValues,1);
        inbcol = size(caValues,2);
        caHeader = readcell(sExcelFileName, 'Sheet', sSheetName, 'Range', 'A1:C1');
        [~, iparamcol] = ismember('Parameter', caHeader);
        [~, ivaluecol] = ismember('Value', caHeader);
        if iparamcol > 0 && ivaluecol > 0
            for icorow = 1:inbrow
                caValueWrite = {'enter value here'};
                dat_range = ['A' num2str(icorow) ':' GetExcelColumn(inbcol) num2str(icorow)];
                temp = strsplit(caValues{icorow, iparamcol}, '_');
                sSearchTerm = {['(' char(temp(1)) ')']};
                [iposrow, iposcol] = find(cellfun(@(x) ~isempty(strfind(x,sSearchTerm)), casDataString));

                


                if iposrow > 1
                    caValueWrite = caData(iposrow, iposcol+1);
                elseif iposrow  == 1
                    temploc = strsplit(caValues{icorow, iparamcol}, '_');
                    if length(temploc) == 3
                        itemploc = str2double(temploc(2));
                    elseif length(temploc) == 4
                        itemploc = str2double(temploc(3)) + (str2double(temploc(2))-1) * inbregions_p;
                    end
                    caValueWrite = caData(iposrow+itemploc, iposcol);
                end
                if ~isequal(caValueWrite, {'enter value here'})
                    writecell(caValueWrite,sExcelFileName, 'Sheet', sSheetName, 'Range', [GetExcelColumn(ivaluecol) num2str(icorow)])
                end
            end
        end
    end
end