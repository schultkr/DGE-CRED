% DefineAuxiliaryExpressions is a Matlab script to create integer arrays 
% to find values for specific variables in the results struvutre oo_.
% The function SimulationModel uses the postion arrays to update exogenous
% variables.

% find number of sectors on subsector level
imaxsec_p = eval(['subend_' num2str(inbsectors_p) '_p']);
% find positions of initial growth parameters of gross value added
temp = arrayfun(@(y) arrayfun(@(x) ['gY0_' num2str(y) '_' num2str(x) '_p'], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casInitGrowthValues = [temp{:}];
[lSelectInitGrowthParams, iposInitGrowthParams] = ismember(casInitGrowthValues,cellstr(M_.param_names));

% find positions of initial growth parameters of employment
temp = arrayfun(@(y) arrayfun(@(x) ['gN0_' num2str(y) '_' num2str(x) '_p'], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casInitGrowthValuesN = [temp{:}];
[lSelectInitGrowthParamsN,iposInitGrowthParamsN]  = ismember(casInitGrowthValuesN,cellstr(M_.param_names));

% find positions of technology shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casProdShocks = [temp{:}];
[lSelectProdShocks, iposProdShocks] = ismember(casProdShocks, cellstr(M_.exo_names));
[lSelectPShocks,iposPshocks] = ismember('exo_P', cellstr(M_.exo_names));

% find positions of sectoral production
temp = arrayfun(@(y) arrayfun(@(x) ['Y_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casProdVars = [temp{:}];
[lSelectProdVars,iposProdVars] = ismember(casProdVars, cellstr(M_.endo_names));

% find positions of sectoral TFP
temp = arrayfun(@(y) arrayfun(@(x) ['A_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casAVars = [temp{:}];
[lSelectAVars,iposAVars] = ismember(casAVars, cellstr(M_.endo_names));

% find positions of sectoral labour productivity
temp = arrayfun(@(y) arrayfun(@(x) ['A_N_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casANVars = [temp{:}];
[lSelectANVars,iposANVars] = ismember(casANVars, cellstr(M_.endo_names));

% find positions of sectoral value added prices
temp = arrayfun(@(y) arrayfun(@(x) ['P_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casPVars = [temp{:}];
[lSelectPVars,iposPVars] = ismember(casPVars, cellstr(M_.endo_names));

% find positions of technology shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_N_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casProdNShocks = [temp{:}];
[lSelectProdShocksN, iposProdShocksN] = ismember(casProdNShocks, cellstr(M_.exo_names));

% find positions of damage shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_D_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casDamageShocks = [temp{:}];
[lSelectDamShocks,iposDamShocks] = ismember(casDamageShocks, cellstr(M_.exo_names));

% find positions of exogenous expenditures
temp = arrayfun(@(y) arrayfun(@(x) ['exo_GA_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casExoExpendShocks = [temp{:}];
[lSelectExoExpendShocks,iposExoExpendShocks] = ismember(casExoExpendShocks, cellstr(M_.exo_names));


% find positions of capital damage shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_D_K_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casDamageShocks = [temp{:}];
[lSelectDamKShocks,iposDamKShocks] = ismember(casDamageShocks, cellstr(M_.exo_names));

% find positions of capital damage shocks
temp = arrayfun(@(y) arrayfun(@(x) ['exo_D_N_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casDamageShocks = [temp{:}];
[lSelectDamNShocks, iposDamNShocks] = ismember(casDamageShocks,cellstr(M_.exo_names));

% find positions of damages
temp = arrayfun(@(y) arrayfun(@(x) ['D_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casDamages = [temp{:}];
[lSelectDamages,iposDamages] = ismember(casDamages,cellstr(M_.endo_names));

% find positions of sectoral labour
temp = arrayfun(@(y) arrayfun(@(x) ['N_' num2str(y) '_' num2str(x)], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
casNVars = [temp{:}];
lSelectNVars = ismember(cellstr(M_.endo_names), casNVars);
[lSelectN,iposN] = ismember('N',cellstr(M_.endo_names));
% find position of price index and price shocks
[lSelectPop,iposPop] = ismember('PoP', cellstr(M_.endo_names));
[lSelectPoPShock,iposPoPshock] = ismember('exo_PoP',cellstr(M_.exo_names));

% find position of price index and price shocks
[lSelectP,iposP] = ismember('P', cellstr(M_.endo_names));
[lSelectPriceShock,iposPriceShock] = ismember('exo_P', cellstr(M_.exo_names));

% find position of price index and price shocks
[lSelectDamH,iposDamH] = ismember('DH', cellstr(M_.endo_names));
[lSelectDamHShock, iposDamHShock] = ismember('exo_DH', cellstr(M_.exo_names));


% find position of house price index and house price shocks
[lSelectPH,iposPH] = ismember('PH', cellstr(M_.endo_names));
[lSelectPriceHShock, iposPriceHShock] = ismember('exo_H', cellstr(M_.exo_names));

% find position of price index and price shocks
[lSelectPM, iposPM] = ismember('P_M', cellstr(M_.endo_names));
[lSelectPMShock, iposPMShock] = ismember('exo_M', cellstr(M_.exo_names));

