%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'NGM';
M_.dynare_version = '4.6.1';
oo_.dynare_version = '4.6.1';
options_.dynare_version = '4.6.1';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('NGM.log');
M_.exo_names = cell(1,1);
M_.exo_names_tex = cell(1,1);
M_.exo_names_long = cell(1,1);
M_.exo_names(1) = {'A'};
M_.exo_names_tex(1) = {'A'};
M_.exo_names_long(1) = {'A'};
M_.endo_names = cell(3,1);
M_.endo_names_tex = cell(3,1);
M_.endo_names_long = cell(3,1);
M_.endo_names(1) = {'c'};
M_.endo_names_tex(1) = {'c'};
M_.endo_names_long(1) = {'c'};
M_.endo_names(2) = {'k'};
M_.endo_names_tex(2) = {'k'};
M_.endo_names_long(2) = {'k'};
M_.endo_names(3) = {'lamb'};
M_.endo_names_tex(3) = {'lamb'};
M_.endo_names_long(3) = {'lamb'};
M_.endo_partitions = struct();
M_.param_names = cell(4,1);
M_.param_names_tex = cell(4,1);
M_.param_names_long = cell(4,1);
M_.param_names(1) = {'alpha_p'};
M_.param_names_tex(1) = {'alpha\_p'};
M_.param_names_long(1) = {'alpha_p'};
M_.param_names(2) = {'beta_p'};
M_.param_names_tex(2) = {'beta\_p'};
M_.param_names_long(2) = {'beta_p'};
M_.param_names(3) = {'sigma_p'};
M_.param_names_tex(3) = {'sigma\_p'};
M_.param_names_long(3) = {'sigma_p'};
M_.param_names(4) = {'delta_p'};
M_.param_names_tex(4) = {'delta\_p'};
M_.param_names_long(4) = {'delta_p'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 3;
M_.param_nbr = 4;
M_.orig_endo_nbr = 3;
M_.aux_vars = [];
M_.Sigma_e = zeros(1, 1);
M_.Correlation_matrix = eye(1, 1);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = [];
options_.linear = false;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
options_.linear_decomposition = false;
M_.orig_eq_nbr = 3;
M_.eq_nbr = 3;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 1;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 1;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 1;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 1;
M_.lead_lag_incidence = [
 0 2 0;
 1 3 0;
 0 4 5;]';
M_.nstatic = 1;
M_.nfwrd   = 1;
M_.npred   = 1;
M_.nboth   = 0;
M_.nsfwrd   = 1;
M_.nspred   = 1;
M_.ndynamic   = 2;
M_.dynamic_tmp_nbr = [3; 0; 0; 0; ];
M_.equations_tags = {
  1 , 'name' , 'lamb' ;
  2 , 'name' , '2' ;
  3 , 'name' , '3' ;
};
M_.mapping.c.eqidx = [1 2 ];
M_.mapping.k.eqidx = [2 3 ];
M_.mapping.lamb.eqidx = [1 3 ];
M_.mapping.A.eqidx = [2 3 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.state_var = [2 ];
M_.exo_names_orig_ord = [1:1];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(3, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 1;
oo_.exo_steady_state = zeros(1, 1);
M_.params = NaN(4, 1);
M_.endo_trends = struct('deflator', cell(3, 1), 'log_deflator', cell(3, 1), 'growth_factor', cell(3, 1), 'log_growth_factor', cell(3, 1));
M_.NNZDerivatives = [10; -1; -1; ];
M_.static_tmp_nbr = [1; 0; 0; 0; ];
M_.params(1) = 0.5;
alpha_p = M_.params(1);
M_.params(2) = 0.95;
beta_p = M_.params(2);
M_.params(3) = 0.5;
sigma_p = M_.params(3);
M_.params(4) = 0.02;
delta_p = M_.params(4);
%
% INITVAL instructions
%
options_.initval_file = false;
oo_.exo_steady_state(1) = 1;
if M_.exo_nbr > 0
	oo_.exo_simul = ones(M_.maximum_lag,1)*oo_.exo_steady_state';
end
if M_.exo_det_nbr > 0
	oo_.exo_det_simul = ones(M_.maximum_lag,1)*oo_.exo_det_steady_state';
end
steady;
oo_.dr.eigval = check(M_,options_,oo_);
%
% ENDVAL instructions
%
ys0_= oo_.steady_state;
ex0_ = oo_.exo_steady_state;
oo_.exo_steady_state(1) = 1.1;
steady;
oo_.dr.eigval = check(M_,options_,oo_);
options_.periods = 100;
perfect_foresight_setup;
perfect_foresight_solver;
var_list_ = {'c'};
rplot(var_list_);
var_list_ = {'k'};
rplot(var_list_);
var_list_ = {'A'};
rplot(var_list_);
save('NGM_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('NGM_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('NGM_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('NGM_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('NGM_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('NGM_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('NGM_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
diary off
