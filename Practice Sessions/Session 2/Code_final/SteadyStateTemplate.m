function [ys,params,check] = Introduction_Dynare_steadystate(ys,exo,M_,options_)

% This is the steady state file corresponding to the mod-file:
% "Introduction_Dynare.mod"

% Inputs: 
%   - ys        [vector] vector of initial values for the steady state of
%                   the endogenous variables
%   - exo       [vector] vector of values for the exogenous variables
%   - M_        [structure] Dynare model structure
%   - options   [structure] Dynare options structure
%
% Output: 
%   - ys        [vector] vector of steady state values for the the endogenous variables
%   - params    [vector] vector of parameter values
%   - check     [scalar] set to 0 if steady state computation worked and to
%                    1 of not (allows to impose restrictions on parameters)

% Step 1: Read out the parameters, exogenous and endogenous variables, so
% that they can be used in the steady state computation.

% Read out parameters to access them with their name:
NumberOfParameters = M_.param_nbr;
for ii = 1:NumberOfParameters
  paramname = M_.param_names{ii};
  eval([ paramname ' = M_.params(' int2str(ii) ');']);
end

% Read out the exogenous variables to access them with their name:
NumberOfExo = M_.exo_nbr;
for ii = 1:NumberOfExo
  exoname = char(M_.exo_names(ii,:));
  eval([exoname ' = exo(ii);']);
end

% Read out the endogenous variables to access them with their name:
NumberOfEndo = M_.endo_nbr;
for ii = 1:NumberOfEndo
  endoname = char(M_.endo_names(ii,:));
  eval([endoname ' = ys(ii);']);
end

% Initialize indicator:
check = 0;


%% Step 2: Determine the steady state


%% Step 3: Update parameters, exogenous and endogenous variables

% Update parameters:
params=NaN(NumberOfParameters,1);
for iter = 1:length(M_.params) 
  eval([ 'params(' num2str(iter) ') = ' M_.param_names{iter} ';' ])
end

% Update exogenous variables:
NumberOfExogenousVariables = M_.exo_nbr; %auxiliary variables are set automatically
for ii = 1:NumberOfExogenousVariables
  varname = char(M_.exo_names(ii,:));
  exo(ii) = varname;
end

% Update endogenous variables:
NumberOfEndogenousVariables = M_.orig_endo_nbr; 
for ii = 1:NumberOfEndogenousVariables
  varname = M_.endo_names{ii};
  eval(['ys(' int2str(ii) ') = ' varname ';']);
end
