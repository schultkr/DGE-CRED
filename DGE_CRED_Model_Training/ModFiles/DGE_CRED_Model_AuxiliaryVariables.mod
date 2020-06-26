% ===================================
% === Declare Auxiliary Variables ===
% ===================================
casClimateShocks = [arrayfun(@(x) ['exo_T_' num2str(x)], 1:@{Regions}, 'UniformOutput', false),...
                    arrayfun(@(x) ['exo_PERC_' num2str(x)], 1:@{Regions}, 'UniformOutput', false),...
                    arrayfun(@(x) ['exo_WS_' num2str(x)], 1:@{Regions}, 'UniformOutput', false),...
                    ];

casWindSpeedShocks = arrayfun(@(x) ['exo_WS_' num2str(x)], 1:@{Regions}, 'UniformOutput', false);

temp = arrayfun(@(y) arrayfun(@(x) ['exo_' num2str(y) '_' num2str(x)], 1:@{Regions}, 'UniformOutput', false), 1:@{Sectors}, 'UniformOutput', false);
casProdShocks = [temp{:}];

temp = arrayfun(@(y) arrayfun(@(x) ['exo_N_' num2str(y) '_' num2str(x)], 1:@{Regions}, 'UniformOutput', false), 1:@{Sectors}, 'UniformOutput', false);
casProdNShocks = [temp{:}];

temp = arrayfun(@(y) arrayfun(@(x) ['exo_K_' num2str(y) '_' num2str(x)], 1:@{Regions}, 'UniformOutput', false), 1:@{Sectors}, 'UniformOutput', false);
casProdKShocks = [temp{:}];

casDemandShocks = arrayfun(@(y) ['exo_Y_' num2str(y)], 1:@{Sectors}, 'UniformOutput', false);

