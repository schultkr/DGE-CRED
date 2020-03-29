function T = static_resid_tt(T, y, x, params)
% function T = static_resid_tt(T, y, x, params)
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

assert(length(T) >= 84);

T(1) = params(23)*y(16)+params(24)*y(16)^params(25)+params(32)*y(14)+params(33)*y(14)^params(34)+params(29)*y(17)+params(30)*y(17)^params(31)+params(26)*y(15)+params(27)*y(15)^params(28);
T(2) = params(11)^(1/params(2));
T(3) = (-1)/params(2);
T(4) = T(2)*(y(27)/y(21))^T(3);
T(5) = params(12)^(1/params(14));
T(6) = (params(14)-1)/params(14);
T(7) = params(13)^(1/params(14));
T(8) = T(5)*(y(36)*y(29))^T(6)+T(7)*(y(35)*y(4)*y(30))^T(6);
T(9) = T(8)^(params(14)/(params(14)-1));
T(10) = T(5)*y(36)^T(6);
T(11) = (-1)/params(14);
T(12) = (y(29)/y(27))^T(11);
T(13) = (y(1)*y(3)/y(4))^(-params(202));
T(14) = (y(3)/y(4))^(-params(202));
T(15) = y(1)*(1+params(206));
T(16) = T(14)/T(15);
T(17) = params(55)*y(19)+params(56)*y(19)^params(57)+y(14)*params(64)+params(65)*y(14)^params(66)+params(61)*y(20)+params(62)*y(20)^params(63)+params(58)*y(18)+params(59)*y(18)^params(60);
T(18) = params(43)^(1/params(2));
T(19) = T(18)*(y(41)/y(21))^T(3);
T(20) = params(44)^(1/params(46));
T(21) = (params(46)-1)/params(46);
T(22) = params(45)^(1/params(46));
T(23) = T(20)*(y(50)*y(43))^T(21)+T(22)*(y(4)*y(49)*y(44))^T(21);
T(24) = T(23)^(params(46)/(params(46)-1));
T(25) = T(20)*y(50)^T(21);
T(26) = (-1)/params(46);
T(27) = (y(43)/y(41))^T(26);
T(28) = params(1)^(1/params(203));
T(29) = (-1)/params(203);
T(30) = (params(2)-1)/params(2);
T(31) = T(2)*y(27)^T(30)+T(18)*y(41)^T(30);
T(32) = y(16)*params(89)+params(90)*y(16)^params(91)+y(14)*params(98)+params(99)*y(14)^params(100)+y(17)*params(95)+params(96)*y(17)^params(97)+y(15)*params(92)+params(93)*y(15)^params(94);
T(33) = params(77)^(1/params(68));
T(34) = (-1)/params(68);
T(35) = T(33)*(y(61)/y(55))^T(34);
T(36) = params(78)^(1/params(80));
T(37) = (params(80)-1)/params(80);
T(38) = params(79)^(1/params(80));
T(39) = T(36)*(y(70)*y(63))^T(37)+T(38)*(y(4)*y(69)*y(64))^T(37);
T(40) = T(39)^(params(80)/(params(80)-1));
T(41) = T(36)*y(70)^T(37);
T(42) = (-1)/params(80);
T(43) = (y(63)/y(61))^T(42);
T(44) = y(19)*params(121)+params(122)*y(19)^params(123)+y(14)*params(130)+params(131)*y(14)^params(132)+y(20)*params(127)+params(128)*y(20)^params(129)+y(18)*params(124)+params(125)*y(18)^params(126);
T(45) = params(109)^(1/params(68));
T(46) = T(45)*(y(75)/y(55))^T(34);
T(47) = params(110)^(1/params(112));
T(48) = (params(112)-1)/params(112);
T(49) = params(111)^(1/params(112));
T(50) = T(47)*(y(84)*y(77))^T(48)+T(49)*(y(4)*y(83)*y(78))^T(48);
T(51) = T(50)^(params(112)/(params(112)-1));
T(52) = T(47)*y(84)^T(48);
T(53) = (-1)/params(112);
T(54) = (y(77)/y(75))^T(53);
T(55) = params(67)^(1/params(203));
T(56) = (params(68)-1)/params(68);
T(57) = T(33)*y(61)^T(56)+T(45)*y(75)^T(56);
T(58) = y(16)*params(155)+params(156)*y(16)^params(157)+y(14)*params(164)+params(165)*y(14)^params(166)+y(17)*params(161)+params(162)*y(17)^params(163)+y(15)*params(158)+params(159)*y(15)^params(160);
T(59) = params(143)^(1/params(134));
T(60) = (-1)/params(134);
T(61) = T(59)*(y(95)/y(89))^T(60);
T(62) = params(144)^(1/params(146));
T(63) = (params(146)-1)/params(146);
T(64) = params(145)^(1/params(146));
T(65) = T(62)*(y(104)*y(97))^T(63)+T(64)*(y(4)*y(103)*y(98))^T(63);
T(66) = T(65)^(params(146)/(params(146)-1));
T(67) = T(62)*y(104)^T(63);
T(68) = (-1)/params(146);
T(69) = (y(97)/y(95))^T(68);
T(70) = y(19)*params(187)+params(188)*y(19)^params(189)+y(14)*params(196)+params(197)*y(14)^params(198)+y(20)*params(193)+params(194)*y(20)^params(195)+y(18)*params(190)+params(191)*y(18)^params(192);
T(71) = params(175)^(1/params(134));
T(72) = T(71)*(y(109)/y(89))^T(60);
T(73) = params(176)^(1/params(178));
T(74) = (params(178)-1)/params(178);
T(75) = params(177)^(1/params(178));
T(76) = T(73)*(y(118)*y(111))^T(74)+T(75)*(y(4)*y(117)*y(112))^T(74);
T(77) = T(76)^(params(178)/(params(178)-1));
T(78) = T(73)*y(118)^T(74);
T(79) = (-1)/params(178);
T(80) = (y(111)/y(109))^T(79);
T(81) = params(133)^(1/params(203));
T(82) = (params(134)-1)/params(134);
T(83) = T(59)*y(95)^T(82)+T(71)*y(109)^T(82);
T(84) = exp((-params(204))*(y(5)*y(9)*y(6)/y(12)+y(8)/y(12)));

end
