% ============================================
% === Find initial and terminal conditions ===
% ============================================
if isequal(sScenario, 'Baseline') 
    oo_.steady_state = zeros(size(oo_.steady_state));
    oo_.exo_steady_state = zeros(size(oo_.exo_steady_state));
    initval;
		exo_SL = 0;
    end;
    lCalibration_p = 1;
    options_.qz_zero_threshold = 1e-6;
    [oo_.steady_state, params, oo_.exo_steady_state] = DGE_CRED_Model_steadystate(oo_.steady_state, oo_.exo_steady_state,M_,options_);
    steady;
    check;

    model_diagnostics;

    temp = arrayfun(@(y) arrayfun(@(x) ['phiY_' num2str(y) '_' num2str(x) '_p'], 1:@{Regions}, 'UniformOutput', false), 1:@{Sectors}, 'UniformOutput', false);
    casShareParams = [temp{:}];

    temp = arrayfun(@(y) arrayfun(@(x) ['phiN_' num2str(y) '_' num2str(x) '_p'], 1:@{Regions}, 'UniformOutput', false), 1:@{Sectors}, 'UniformOutput', false);
    casShareNParams = [temp{:}];

    endval;
		exo_SL = 0;
    end;
    lCalibration_p = 2;
    omegaNX_p = omegaNXT_p;
    TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Terminal');
    [lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
    M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

    iaTerminalVars = M_.params(lParams);
    [ys, ~, exo] = DGE_CRED_Model_steadystate(oo_.steady_state, oo_.exo_steady_state,M_,options_);
    oo_.exo_steady_state = exo;
    oo_.steady_state = ys;
    lCalibration_p = 0;
    steady;
    check;
else
    sVersion = ['Sectors' num2str(inbsectors_p) 'Regions' num2str(inbregions_p)];
    load('structScenarioResults.mat','structScenarioResults');
    oo_ = structScenarioResults.(sVersion).Baseline.oo_;
    M_ = structScenarioResults.(sVersion).Baseline.M_;
    ys0_ = oo_.endo_simul(:,1);
end
if ~exist('sScenario', 'var')
    sScenario = 'Baseline';
end
