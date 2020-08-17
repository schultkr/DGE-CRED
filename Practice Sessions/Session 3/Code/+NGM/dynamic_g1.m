function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = NGM.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(3, 9);
g1(1,4)=1;
g1(1,8)=exp((-(x(it_, 2)*params(6)+x(it_, 3)*params(7))))*(-params(6));
g1(1,9)=exp((-(x(it_, 2)*params(6)+x(it_, 3)*params(7))))*(-params(7));
g1(2,2)=1;
g1(2,1)=(-(1-params(4)+x(it_, 1)*(1-y(4))*getPowerDeriv(y(1),params(1),1)));
g1(2,3)=1;
g1(2,4)=(-(T(3)*(-x(it_, 1))));
g1(2,7)=(-((1-y(4))*T(3)));
g1(3,2)=getPowerDeriv(y(2),(-params(3)),1);
g1(3,5)=(-(T(5)*params(2)*getPowerDeriv(y(5),(-params(3)),1)));
g1(3,3)=(-(params(2)*T(2)*params(1)*x(it_+1, 1)*(1-y(6))*getPowerDeriv(y(3),params(1)-1,1)));
g1(3,6)=(-(params(2)*T(2)*T(4)*(-(params(1)*x(it_+1, 1)))));
g1(3,7)=(-(params(2)*T(2)*T(4)*params(1)*(1-y(6))));

end
