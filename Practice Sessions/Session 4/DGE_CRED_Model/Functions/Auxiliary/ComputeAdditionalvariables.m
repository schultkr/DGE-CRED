
sVariable = 'Y_';
casvariables = {[]};
for icosubsec = 1:12
    for icoreg = 1:6
        casvariables = [casvariables; [sVariable num2str(icosubsec) '_' num2str(icoreg) ]];
    end
end

casScenarioNames = {'Baseline', 'SSP126', 'SSP585',...
                    'SSP126_AdaptConstruction', 'SSP126_AdaptTransport', 'SSP126_AdaptForestry',...
                    'SSP585_AdaptConstruction', 'SSP585_AdaptTransport', 'SSP585_AdaptForestry'...
                    };

for icoscenario = 1:size(casScenarioNames,2)
    sScenario = char(casScenarioNames(icoscenario));
    tabletemp = readtable('G:\VWGR\Gemeins.Projekte\2020\GIZ_Klima\Github\master\DGE_CRED_Model_housing\ExcelFiles\ResultsScenarios12Sectorsand6Regions.xlsx', 'Sheet', sScenario);
    tabletemp.Ysum = sum(table2array(tabletemp(:,ismember(tabletemp.Properties.VariableNames, casvariables(2:end)))),2);
    writetable(tabletemp, 'G:\VWGR\Gemeins.Projekte\2020\GIZ_Klima\Github\master\DGE_CRED_Model_housing\ExcelFiles\ResultsScenarios12Sectorsand6Regions.xlsx', 'Sheet', sScenario);
end

