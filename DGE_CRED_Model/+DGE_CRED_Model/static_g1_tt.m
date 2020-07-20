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

assert(length(T) >= 319);

T = DGE_CRED_Model.static_resid_tt(T, y, x, params);

T(228) = (-(T(26)*(1+y(11))))/(T(27)*T(27));
T(229) = getPowerDeriv(y(3)/y(4),(-params(813)),1);
T(230) = 1/y(4)*T(229);
T(231) = T(230)/T(27);
T(232) = getPowerDeriv(y(61)*(1-y(42))*y(4)*y(45),T(15),1);
T(233) = getPowerDeriv(T(17),params(19)/(params(19)-1),1);
T(234) = getPowerDeriv(y(4)*y(45)/y(40),T(22),1);
T(235) = T(229)*(-y(3))/(y(4)*y(4));
T(236) = T(235)/T(27);
T(237) = getPowerDeriv(y(4)*y(90)*(1-y(71))*y(74),T(42),1);
T(238) = getPowerDeriv(T(44),params(108)/(params(108)-1),1);
T(239) = getPowerDeriv(y(4)*y(74)/y(69),T(49),1);
T(240) = getPowerDeriv(y(4)*y(119)*(1-y(100))*y(103),T(65),1);
T(241) = getPowerDeriv(T(67),params(197)/(params(197)-1),1);
T(242) = getPowerDeriv(y(4)*y(103)/y(98),T(72),1);
T(243) = getPowerDeriv(y(4)*y(154)*(1-y(135))*y(138),T(93),1);
T(244) = getPowerDeriv(T(95),params(288)/(params(288)-1),1);
T(245) = getPowerDeriv(y(4)*y(138)/y(133),T(100),1);
T(246) = getPowerDeriv(y(4)*y(183)*(1-y(164))*y(167),T(116),1);
T(247) = getPowerDeriv(T(118),params(377)/(params(377)-1),1);
T(248) = getPowerDeriv(y(4)*y(167)/y(162),T(123),1);
T(249) = getPowerDeriv(y(4)*y(212)*(1-y(193))*y(196),T(139),1);
T(250) = getPowerDeriv(T(141),params(466)/(params(466)-1),1);
T(251) = getPowerDeriv(y(4)*y(196)/y(191),T(146),1);
T(252) = getPowerDeriv(y(4)*y(247)*(1-y(228))*y(231),T(166),1);
T(253) = getPowerDeriv(T(168),params(557)/(params(557)-1),1);
T(254) = getPowerDeriv(y(4)*y(231)/y(226),T(173),1);
T(255) = getPowerDeriv(y(4)*y(276)*(1-y(257))*y(260),T(189),1);
T(256) = getPowerDeriv(T(191),params(646)/(params(646)-1),1);
T(257) = getPowerDeriv(y(4)*y(260)/y(255),T(196),1);
T(258) = getPowerDeriv(y(4)*y(305)*(1-y(286))*y(289),T(212),1);
T(259) = getPowerDeriv(T(214),params(735)/(params(735)-1),1);
T(260) = getPowerDeriv(y(4)*y(289)/y(284),T(219),1);
T(261) = T(227)*(-params(815))*y(6)*y(9)/y(16);
T(262) = T(227)*(-params(815))*y(5)*y(9)/y(16);
T(263) = 1/y(16);
T(264) = T(227)*(-params(815))*y(5)*y(6)/y(16);
T(265) = (-(T(26)*y(1)))/(T(27)*T(27));
T(266) = getPowerDeriv(y(14),params(811),1);
T(267) = getPowerDeriv(y(34)/y(16),T(78),1);
T(268) = getPowerDeriv(y(127)/y(16),T(78),1);
T(269) = getPowerDeriv(y(220)/y(16),T(78),1);
T(270) = T(227)*(-params(815))*((-(y(5)*y(6)*y(9)))/(y(16)*y(16))+(-y(8))/(y(16)*y(16)));
T(271) = getPowerDeriv(y(40)/y(34),T(12),1);
T(272) = getPowerDeriv(y(69)/y(34),T(12),1);
T(273) = getPowerDeriv(y(98)/y(34),T(12),1);
T(274) = getPowerDeriv(y(44)/y(40),T(22),1);
T(275) = getPowerDeriv(T(80),params(2)/(params(2)-1),1);
T(276) = getPowerDeriv(y(47)*(1-y(41)),T(15),1);
T(277) = getPowerDeriv(y(47)*(1-y(41))*y(61)*(1-y(42)),T(15),1);
T(278) = getPowerDeriv(y(62)*y(44),T(15),1);
T(279) = (1-y(12))*T(26)/T(27);
T(280) = getPowerDeriv(y(73)/y(69),T(49),1);
T(281) = getPowerDeriv(y(76)*(1-y(70)),T(42),1);
T(282) = getPowerDeriv(y(76)*(1-y(70))*y(90)*(1-y(71)),T(42),1);
T(283) = getPowerDeriv(y(91)*y(73),T(42),1);
T(284) = getPowerDeriv(y(102)/y(98),T(72),1);
T(285) = getPowerDeriv(y(105)*(1-y(99)),T(65),1);
T(286) = getPowerDeriv(y(105)*(1-y(99))*y(119)*(1-y(100)),T(65),1);
T(287) = getPowerDeriv(y(120)*y(102),T(65),1);
T(288) = getPowerDeriv(y(133)/y(127),T(90),1);
T(289) = getPowerDeriv(y(162)/y(127),T(90),1);
T(290) = getPowerDeriv(y(191)/y(127),T(90),1);
T(291) = getPowerDeriv(y(137)/y(133),T(100),1);
T(292) = getPowerDeriv(T(153),params(271)/(params(271)-1),1);
T(293) = getPowerDeriv(y(140)*(1-y(134)),T(93),1);
T(294) = getPowerDeriv(y(140)*(1-y(134))*y(154)*(1-y(135)),T(93),1);
T(295) = getPowerDeriv(y(155)*y(137),T(93),1);
T(296) = getPowerDeriv(y(166)/y(162),T(123),1);
T(297) = getPowerDeriv(y(169)*(1-y(163)),T(116),1);
T(298) = getPowerDeriv(y(169)*(1-y(163))*y(183)*(1-y(164)),T(116),1);
T(299) = getPowerDeriv(y(184)*y(166),T(116),1);
T(300) = getPowerDeriv(y(195)/y(191),T(146),1);
T(301) = getPowerDeriv(y(198)*(1-y(192)),T(139),1);
T(302) = getPowerDeriv(y(198)*(1-y(192))*y(212)*(1-y(193)),T(139),1);
T(303) = getPowerDeriv(y(213)*y(195),T(139),1);
T(304) = getPowerDeriv(y(226)/y(220),T(163),1);
T(305) = getPowerDeriv(y(255)/y(220),T(163),1);
T(306) = getPowerDeriv(y(284)/y(220),T(163),1);
T(307) = getPowerDeriv(y(230)/y(226),T(173),1);
T(308) = getPowerDeriv(T(226),params(540)/(params(540)-1),1);
T(309) = getPowerDeriv(y(233)*(1-y(227)),T(166),1);
T(310) = getPowerDeriv(y(233)*(1-y(227))*y(247)*(1-y(228)),T(166),1);
T(311) = getPowerDeriv(y(248)*y(230),T(166),1);
T(312) = getPowerDeriv(y(259)/y(255),T(196),1);
T(313) = getPowerDeriv(y(262)*(1-y(256)),T(189),1);
T(314) = getPowerDeriv(y(262)*(1-y(256))*y(276)*(1-y(257)),T(189),1);
T(315) = getPowerDeriv(y(277)*y(259),T(189),1);
T(316) = getPowerDeriv(y(288)/y(284),T(219),1);
T(317) = getPowerDeriv(y(291)*(1-y(285)),T(212),1);
T(318) = getPowerDeriv(y(291)*(1-y(285))*y(305)*(1-y(286)),T(212),1);
T(319) = getPowerDeriv(y(306)*y(288),T(212),1);

end
