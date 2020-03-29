function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_g1_tt(T, y, x, params, steady_state, it_)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double  vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double  vector of endogenous variables in the order stored
%                                                    in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double  matrix of exogenous variables (in declaration order)
%                                                    for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double  vector of steady state values
%   params        [M_.param_nbr by 1]        double  vector of parameter values in declaration order
%   it_           scalar                     double  time period for exogenous variables for which
%                                                    to evaluate the model
%
% Output:
%   T           [#temp variables by 1]       double  vector of temporary terms
%

assert(length(T) >= 222);

T = DGE_CRED_Model.dynamic_resid_tt(T, y, x, params, steady_state, it_);

T(149) = getPowerDeriv(y(45)*y(47)/y(48),(-params(202)),1);
T(150) = y(47)/y(48)*T(149);
T(151) = (-((1+params(206))*T(16)))/(T(17)*T(17));
T(152) = (-((1+params(206))*T(14)))/((1+params(206))*y(167)*(1+params(206))*y(167));
T(153) = (-((1+params(206))*T(14)*params(199)))/((1+params(206))*y(167)*(1+params(206))*y(167));
T(154) = T(149)*y(45)/y(48);
T(155) = getPowerDeriv(y(47)/y(48),(-params(202)),1);
T(156) = 1/y(48)*T(155);
T(157) = T(156)/T(17);
T(158) = getPowerDeriv(y(168)/y(169),(-params(202)),1);
T(159) = 1/y(169)*T(158)/((1+params(206))*y(167));
T(160) = params(199)*1/y(169)*T(158)/((1+params(206))*y(167));
T(161) = getPowerDeriv(y(79)*y(48)*y(74),T(6),1);
T(162) = getPowerDeriv(T(8),params(14)/(params(14)-1),1);
T(163) = getPowerDeriv(y(79)*y(48)*y(74)/y(71),T(11),1);
T(164) = T(149)*(-(y(45)*y(47)))/(y(48)*y(48));
T(165) = T(155)*(-y(47))/(y(48)*y(48));
T(166) = T(165)/T(17);
T(167) = getPowerDeriv(y(48)*y(93)*y(88),T(35),1);
T(168) = getPowerDeriv(T(37),params(46)/(params(46)-1),1);
T(169) = getPowerDeriv(y(48)*y(93)*y(88)/y(85),T(40),1);
T(170) = getPowerDeriv(y(48)*y(113)*y(108),T(61),1);
T(171) = getPowerDeriv(T(63),params(80)/(params(80)-1),1);
T(172) = getPowerDeriv(y(48)*y(113)*y(108)/y(105),T(66),1);
T(173) = getPowerDeriv(y(48)*y(127)*y(122),T(82),1);
T(174) = getPowerDeriv(T(84),params(112)/(params(112)-1),1);
T(175) = getPowerDeriv(y(48)*y(127)*y(122)/y(119),T(87),1);
T(176) = getPowerDeriv(y(48)*y(147)*y(142),T(107),1);
T(177) = getPowerDeriv(T(109),params(146)/(params(146)-1),1);
T(178) = getPowerDeriv(y(48)*y(147)*y(142)/y(139),T(112),1);
T(179) = getPowerDeriv(y(48)*y(161)*y(156),T(128),1);
T(180) = getPowerDeriv(T(130),params(178)/(params(178)-1),1);
T(181) = getPowerDeriv(y(48)*y(161)*y(156)/y(153),T(133),1);
T(182) = T(158)*(-y(168))/(y(169)*y(169))/((1+params(206))*y(167));
T(183) = params(199)*T(158)*(-y(168))/(y(169)*y(169))/((1+params(206))*y(167));
T(184) = 1/y(56);
T(185) = getPowerDeriv(y(65)/y(56),T(53),1);
T(186) = getPowerDeriv(y(99)/y(56),T(53),1);
T(187) = getPowerDeriv(y(133)/y(56),T(53),1);
T(188) = getPowerDeriv(y(71)/y(65),T(3),1);
T(189) = getPowerDeriv(y(85)/y(65),T(3),1);
T(190) = getPowerDeriv(y(13)/y(71),T(11),1);
T(191) = getPowerDeriv(T(55),params(2)/(params(2)-1),1);
T(192) = getPowerDeriv(y(80)*y(13),T(6),1);
T(193) = (1-params(207))*T(13)/(1+params(206));
T(194) = (-(T(20)*T(19)*(-y(81))/(y(17)*y(17))+T(21)*(-T(19))*(-y(81))/(y(17)*y(17))));
T(195) = (-(T(20)*T(19)*1/y(17)+T(21)*(-T(19))*1/y(17)));
T(196) = params(208)/y(45);
T(197) = getPowerDeriv(y(18)/y(85),T(40),1);
T(198) = getPowerDeriv(y(94)*y(18),T(35),1);
T(199) = (-(T(42)*T(19)*(-y(95))/(y(22)*y(22))+T(43)*(-T(19))*(-y(95))/(y(22)*y(22))));
T(200) = (-(T(42)*T(19)*1/y(22)+T(43)*(-T(19))*1/y(22)));
T(201) = getPowerDeriv(y(105)/y(99),T(58),1);
T(202) = getPowerDeriv(y(119)/y(99),T(58),1);
T(203) = getPowerDeriv(y(24)/y(105),T(66),1);
T(204) = getPowerDeriv(T(101),params(68)/(params(68)-1),1);
T(205) = getPowerDeriv(y(114)*y(24),T(61),1);
T(206) = (-(T(68)*T(19)*(-y(115))/(y(28)*y(28))+T(69)*(-T(19))*(-y(115))/(y(28)*y(28))));
T(207) = (-(T(68)*T(19)*1/y(28)+T(69)*(-T(19))*1/y(28)));
T(208) = getPowerDeriv(y(29)/y(119),T(87),1);
T(209) = getPowerDeriv(y(128)*y(29),T(82),1);
T(210) = (-(T(89)*T(19)*(-y(129))/(y(33)*y(33))+T(90)*(-T(19))*(-y(129))/(y(33)*y(33))));
T(211) = (-(T(89)*T(19)*1/y(33)+T(90)*(-T(19))*1/y(33)));
T(212) = getPowerDeriv(y(139)/y(133),T(104),1);
T(213) = getPowerDeriv(y(153)/y(133),T(104),1);
T(214) = getPowerDeriv(y(35)/y(139),T(112),1);
T(215) = getPowerDeriv(T(147),params(134)/(params(134)-1),1);
T(216) = getPowerDeriv(y(148)*y(35),T(107),1);
T(217) = (-(T(114)*T(19)*(-y(149))/(y(39)*y(39))+T(115)*(-T(19))*(-y(149))/(y(39)*y(39))));
T(218) = (-(T(114)*T(19)*1/y(39)+T(115)*(-T(19))*1/y(39)));
T(219) = getPowerDeriv(y(40)/y(153),T(133),1);
T(220) = getPowerDeriv(y(162)*y(40),T(128),1);
T(221) = (-(T(135)*T(19)*(-y(163))/(y(44)*y(44))+T(136)*(-T(19))*(-y(163))/(y(44)*y(44))));
T(222) = (-(T(135)*T(19)*1/y(44)+T(136)*(-T(19))*1/y(44)));

end
