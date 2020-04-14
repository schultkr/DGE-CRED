function T = static_g1_tt(T, y, x, params)
% function T = static_g1_tt(T, y, x, params)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%
% Output:
%   T         [#temp variables by 1]  double   vector of temporary terms
%

assert(length(T) >= 139);

T = DGE_CRED_Model.static_resid_tt(T, y, x, params);

T(85) = getPowerDeriv(y(1)*y(3)/y(4),(-params(202)),1);
T(86) = y(3)/y(4)*T(85);
T(87) = (-((1+params(206))*T(14)))/(T(15)*T(15));
T(88) = T(85)*y(1)/y(4);
T(89) = getPowerDeriv(y(3)/y(4),(-params(202)),1);
T(90) = 1/y(4)*T(89);
T(91) = T(90)/T(15);
T(92) = getPowerDeriv(y(35)*y(4)*y(30),T(6),1);
T(93) = getPowerDeriv(T(8),params(14)/(params(14)-1),1);
T(94) = getPowerDeriv(y(35)*y(4)*y(30)/y(27),T(11),1);
T(95) = T(85)*(-(y(1)*y(3)))/(y(4)*y(4));
T(96) = T(89)*(-y(3))/(y(4)*y(4));
T(97) = T(96)/T(15);
T(98) = getPowerDeriv(y(4)*y(49)*y(44),T(21),1);
T(99) = getPowerDeriv(T(23),params(46)/(params(46)-1),1);
T(100) = getPowerDeriv(y(4)*y(49)*y(44)/y(41),T(26),1);
T(101) = getPowerDeriv(y(4)*y(69)*y(64),T(37),1);
T(102) = getPowerDeriv(T(39),params(80)/(params(80)-1),1);
T(103) = getPowerDeriv(y(4)*y(69)*y(64)/y(61),T(42),1);
T(104) = getPowerDeriv(y(4)*y(83)*y(78),T(48),1);
T(105) = getPowerDeriv(T(50),params(112)/(params(112)-1),1);
T(106) = getPowerDeriv(y(4)*y(83)*y(78)/y(75),T(53),1);
T(107) = getPowerDeriv(y(4)*y(103)*y(98),T(63),1);
T(108) = getPowerDeriv(T(65),params(146)/(params(146)-1),1);
T(109) = getPowerDeriv(y(4)*y(103)*y(98)/y(95),T(68),1);
T(110) = getPowerDeriv(y(4)*y(117)*y(112),T(74),1);
T(111) = getPowerDeriv(T(76),params(178)/(params(178)-1),1);
T(112) = getPowerDeriv(y(4)*y(117)*y(112)/y(109),T(79),1);
T(113) = 1/y(12);
T(114) = getPowerDeriv(y(21)/y(12),T(29),1);
T(115) = getPowerDeriv(y(55)/y(12),T(29),1);
T(116) = getPowerDeriv(y(89)/y(12),T(29),1);
T(117) = getPowerDeriv(y(27)/y(21),T(3),1);
T(118) = getPowerDeriv(y(41)/y(21),T(3),1);
T(119) = getPowerDeriv(y(29)/y(27),T(11),1);
T(120) = getPowerDeriv(T(31),params(2)/(params(2)-1),1);
T(121) = getPowerDeriv(y(36)*y(29),T(6),1);
T(122) = (1-params(207))*T(13)/(1+params(206));
T(123) = params(208)/y(1);
T(124) = getPowerDeriv(y(43)/y(41),T(26),1);
T(125) = getPowerDeriv(y(50)*y(43),T(21),1);
T(126) = getPowerDeriv(y(61)/y(55),T(34),1);
T(127) = getPowerDeriv(y(75)/y(55),T(34),1);
T(128) = getPowerDeriv(y(63)/y(61),T(42),1);
T(129) = getPowerDeriv(T(57),params(68)/(params(68)-1),1);
T(130) = getPowerDeriv(y(70)*y(63),T(37),1);
T(131) = getPowerDeriv(y(77)/y(75),T(53),1);
T(132) = getPowerDeriv(y(84)*y(77),T(48),1);
T(133) = getPowerDeriv(y(95)/y(89),T(60),1);
T(134) = getPowerDeriv(y(109)/y(89),T(60),1);
T(135) = getPowerDeriv(y(97)/y(95),T(68),1);
T(136) = getPowerDeriv(T(83),params(134)/(params(134)-1),1);
T(137) = getPowerDeriv(y(104)*y(97),T(63),1);
T(138) = getPowerDeriv(y(111)/y(109),T(79),1);
T(139) = getPowerDeriv(y(118)*y(111),T(74),1);

end
