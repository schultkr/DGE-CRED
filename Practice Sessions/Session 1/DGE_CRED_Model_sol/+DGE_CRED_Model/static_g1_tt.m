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

assert(length(T) >= 206);

T = DGE_CRED_Model.static_resid_tt(T, y, x, params);

T(125) = getPowerDeriv(y(18)/y(98),(-1)/params(12),1);
T(126) = getPowerDeriv(y(20)/y(94),T(42),1);
T(127) = getPowerDeriv(y(25)/y(26),(-params(140)),1);
T(128) = 1/y(70);
T(129) = getPowerDeriv(y(28)/y(104),(-1)/params(23),1);
T(130) = getPowerDeriv(y(114)/y(28),T(21),1);
T(131) = getPowerDeriv(y(116)/y(28),T(21),1);
T(132) = getPowerDeriv(y(35)/y(120),(-1)/params(48),1);
T(133) = getPowerDeriv(y(37)/y(94),T(42),1);
T(134) = getPowerDeriv(y(42)/y(43),(-params(140)),1);
T(135) = getPowerDeriv(y(45)/y(126),(-1)/params(59),1);
T(136) = getPowerDeriv(y(136)/y(45),T(53),1);
T(137) = getPowerDeriv(y(138)/y(45),T(53),1);
T(138) = getPowerDeriv(y(52)/y(142),(-1)/params(84),1);
T(139) = getPowerDeriv(y(54)/y(94),T(42),1);
T(140) = getPowerDeriv(y(59)/y(60),(-params(140)),1);
T(141) = getPowerDeriv(y(62)/y(148),(-1)/params(95),1);
T(142) = getPowerDeriv(y(158)/y(62),T(84),1);
T(143) = getPowerDeriv(y(160)/y(62),T(84),1);
T(144) = (-(T(8)*(1+params(120)*y(83)+y(83)*(1-params(120)))))/(T(9)*T(9));
T(145) = 1/y(67);
T(146) = 1/T(1);
T(147) = getPowerDeriv(T(7),(-params(129)),1);
T(148) = params(119)*T(146)*T(147)/T(9);
T(149) = 1/y(77);
T(150) = getPowerDeriv(T(109),(-params(121)),1);
T(151) = getPowerDeriv(T(109),1-params(121),1);
T(152) = getPowerDeriv(T(115),(-params(129)),1);
T(153) = getPowerDeriv(T(7),1-params(121),1);
T(154) = T(146)*T(153);
T(155) = getPowerDeriv(T(117)*T(120),(-params(129)),1);
T(156) = getPowerDeriv(T(111),params(121),1);
T(157) = T(149)*T(156);
T(158) = getPowerDeriv(T(118),params(121)-1,1);
T(159) = getPowerDeriv(T(118),params(121),1);
T(160) = params(119)*T(147)*(-(params(120)*y(71)+(1-params(120))*y(71)))/(T(1)*T(1))/T(9);
T(161) = (T(1)-y(77))/(T(1)*T(1))*2*y(77)/T(1);
T(162) = (T(1)*(params(120)*y(102)+(1-params(120))*y(102))/y(102)-y(77)*(params(120)*y(102)+(1-params(120))*y(102))/y(102))/(T(1)*T(1));
T(163) = getPowerDeriv(y(118)*y(77)*(1-y(106))*y(115),params(38),1);
T(164) = getPowerDeriv(y(118)*y(77)*(1-y(106))*y(115),T(29),1);
T(165) = getPowerDeriv(T(31),params(39)/(params(39)-1+(params(39)==1)*1000),1);
T(166) = getPowerDeriv(y(77)*y(115)/y(114),T(34),1);
T(167) = (T(1)*(params(120)*y(124)+(1-params(120))*y(124))/y(124)-y(77)*(params(120)*y(124)+(1-params(120))*y(124))/y(124))/(T(1)*T(1));
T(168) = getPowerDeriv(y(140)*y(77)*(1-y(128))*y(137),params(74),1);
T(169) = getPowerDeriv(y(140)*y(77)*(1-y(128))*y(137),T(61),1);
T(170) = getPowerDeriv(T(63),params(75)/(params(75)-1+1000*(params(75)==1)),1);
T(171) = getPowerDeriv(y(77)*y(137)/y(136),T(66),1);
T(172) = (T(1)*(params(120)*y(146)+(1-params(120))*y(146))/y(146)-y(77)*(params(120)*y(146)+(1-params(120))*y(146))/y(146))/(T(1)*T(1));
T(173) = getPowerDeriv(y(162)*y(77)*(1-y(150))*y(159),params(110),1);
T(174) = getPowerDeriv(y(162)*y(77)*(1-y(150))*y(159),T(92),1);
T(175) = getPowerDeriv(T(94),params(111)/(params(111)-1+1000*(params(111)==1)),1);
T(176) = getPowerDeriv(y(77)*y(159)/y(158),T(97),1);
T(177) = T(122)*T(123)*(-params(134))*(params(120)*y(81)+(1-params(120))*y(81))/(params(120)*y(89)+(1-params(120))*y(89));
T(178) = (-((params(120)*y(67)+(1-params(120))*y(67))*T(8)))/(T(9)*T(9));
T(179) = getPowerDeriv(y(87),params(127),1);
T(180) = getPowerDeriv(y(94)/y(90),T(107),1);
T(181) = getPowerDeriv(y(91)/y(90),T(107),1);
T(182) = getPowerDeriv(y(98)/y(91),T(4),1);
T(183) = getPowerDeriv(y(120)/y(91),T(4),1);
T(184) = getPowerDeriv(y(142)/y(91),T(4),1);
T(185) = T(149)-(1-params(122))/y(77);
T(186) = y(77)*(y(102)-(params(120)*y(102)+(1-params(120))*y(102)))/(y(102)*y(102))/T(1);
T(187) = getPowerDeriv(y(119)*y(117)*(1-y(105)),T(29),1);
T(188) = getPowerDeriv(y(117)*(1-y(105))*y(118)*(1-y(106)),T(29),1);
T(189) = getPowerDeriv(y(108)*y(119),params(37),1);
T(190) = getPowerDeriv(y(108)*y(119),T(29),1);
T(191) = getPowerDeriv(y(108)/y(114),T(34),1);
T(192) = getPowerDeriv(T(40),params(24)/(params(24)-1),1);
T(193) = y(77)*(y(124)-(params(120)*y(124)+(1-params(120))*y(124)))/(y(124)*y(124))/T(1);
T(194) = getPowerDeriv(y(141)*y(139)*(1-y(127)),T(61),1);
T(195) = getPowerDeriv(y(139)*(1-y(127))*y(140)*(1-y(128)),T(61),1);
T(196) = getPowerDeriv(y(130)*y(141),params(73),1);
T(197) = getPowerDeriv(y(130)*y(141),T(61),1);
T(198) = getPowerDeriv(y(130)/y(136),T(66),1);
T(199) = getPowerDeriv(T(72),params(60)/(params(60)-1),1);
T(200) = y(77)*(y(146)-(params(120)*y(146)+(1-params(120))*y(146)))/(y(146)*y(146))/T(1);
T(201) = getPowerDeriv(y(163)*y(161)*(1-y(149)),T(92),1);
T(202) = getPowerDeriv(y(161)*(1-y(149))*y(162)*(1-y(150)),T(92),1);
T(203) = getPowerDeriv(y(152)*y(163),params(109),1);
T(204) = getPowerDeriv(y(152)*y(163),T(92),1);
T(205) = getPowerDeriv(y(152)/y(158),T(97),1);
T(206) = getPowerDeriv(T(103),params(96)/(params(96)-1),1);

end
