% ============================================
% === Find initial and terminal conditions ===
% ============================================
imaxsec_p = eval(['subend_' num2str(inbsectors_p) '_p']);
if isequal(sScenario, 'Baseline')
    options_.initval_file = false;
    oo_.exo_steady_state(:) = 0;
    M_.params(ismember(M_.param_names, 'lCalibration_p')) = 1;
    [oo_.steady_state, params, ~, oo_.exo_steady_state] = DGE_CRED_Model_steadystate(oo_.steady_state, oo_.exo_steady_state,M_,options_);
    M_.params = params;
    steady;

    M_.params(ismember(M_.param_names, 'lCalibration_p')) = 0;
    steady;
    options_.qz_zero_threshold =  1e-12;
    %options_.qz_criterium =  1e-12;
    if ~isoctave()
      [eigenvalues_,result,info] = check(M_, options_, oo_);
    end

    temp = arrayfun(@(y) arrayfun(@(x) ['phiY_' num2str(y) '_' num2str(x) '_p'], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
    casShareParams = [temp{:}];

    temp = arrayfun(@(y) arrayfun(@(x) ['phiN_' num2str(y) '_' num2str(x) '_p'], 1:inbregions_p, 'UniformOutput', false), 1:imaxsec_p, 'UniformOutput', false);
    casShareNParams = [temp{:}];

    ys0_= oo_.steady_state;
    ex0_ = oo_.exo_steady_state;
    oo_.exo_steady_state(:) = 0;
else
    load('structScenarioResults.mat','structScenarioResults');
    oo_.endo_simul = structScenarioResults.(sVersion).Baseline.oo_.endo_simul;
    oo_.steady_state = structScenarioResults.(sVersion).Baseline.oo_.steady_state;
    oo_.exo_simul = structScenarioResults.(sVersion).Baseline.oo_.exo_simul;
    oo_.exo_steady_state = structScenarioResults.(sVersion).Baseline.oo_.exo_steady_state;
    M_.params = structScenarioResults.(sVersion).Baseline.M_.params;
    ys0_ = oo_.endo_simul(:,1);
    ex0_ = oo_.exo_simul(1,:);
    M_.params(ismember(M_.param_names, 'lEndogenousY_p')) = 1;
end
if ~exist('sScenario', 'var')
    sScenario = 'Baseline';
end
