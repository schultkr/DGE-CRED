function table = readtable(sFileName, sAttribute, sAttrValue)
% Example
% sFileName = 'ExcelFiles/Model Simulation and Calibration 3 Sectors and 2 Regions.xlsx'
% sAttribute = 'Sheet'
% sAttrValue = 'Start'
if isequal(sAttribute, 'Sheet')
    sSheetName = sAttrValue;
end

[~,~,caData] = xlsread(sFileName, sSheetName);

lSelectColumns = cellfun(@(x) ~all(isnan(x)), caData(1,:), 'UniformOutput', true);
casvars = caData(1, lSelectColumns);
caValues = caData(2:end, lSelectColumns);

table.Init = nan;
for icovars = 1:size(casvars, 2)
    if isequal(char(casvars(1,icovars)), 'Value')
        lSelectEmpty = cellfun(@(x) isempty(x), caValues(:,icovars));
        caValues(lSelectEmpty,icovars) = 0;
        tempvalues = cell2mat(caValues(:,icovars));
    else
        tempvalues = cellfun(@(x) num2str(x), caValues(:,icovars),  'UniformOutput', false);
    end
    table.(char(casvars(icovars))) = tempvalues;
end
