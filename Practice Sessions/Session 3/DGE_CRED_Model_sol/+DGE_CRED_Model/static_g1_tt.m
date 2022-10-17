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

assert(length(T) >= 437);

T = DGE_CRED_Model.static_resid_tt(T, y, x, params);

T(277) = getPowerDeriv(y(30)/y(146),T(132),1);
T(278) = 1/y(142);
T(279) = getPowerDeriv(y(32)/y(142),T(130),1);
T(280) = getPowerDeriv(y(37)/y(38),(-params(262)),1);
T(281) = (params(185)==1)*y(291)+y(276)*(params(185)==1)+(params(127)==1)*y(250)+y(235)*(params(127)==1)+(params(69)==1)*y(209)+y(194)*(params(69)==1)+(params(13)==1)*y(178)+y(144)*(params(245)==1)+y(163)*(params(13)==1);
T(282) = 1/y(118);
T(283) = getPowerDeriv(y(40)/y(156),T(28),1);
T(284) = getPowerDeriv(y(166)/y(40),T(32),1);
T(285) = getPowerDeriv(y(168)/y(40),T(32),1);
T(286) = getPowerDeriv(y(45)/y(156),T(28),1);
T(287) = getPowerDeriv(y(181)/y(45),T(32),1);
T(288) = getPowerDeriv(y(183)/y(45),T(32),1);
T(289) = getPowerDeriv(y(51)/y(146),T(132),1);
T(290) = getPowerDeriv(y(53)/y(142),T(130),1);
T(291) = getPowerDeriv(y(58)/y(59),(-params(262)),1);
T(292) = (params(185)==2)*y(291)+y(276)*(params(185)==2)+(params(127)==2)*y(250)+y(235)*(params(127)==2)+(params(69)==2)*y(209)+y(194)*(params(69)==2)+(params(13)==2)*y(178)+y(144)*(params(245)==2)+y(163)*(params(13)==2);
T(293) = getPowerDeriv(y(61)/y(187),T(56),1);
T(294) = getPowerDeriv(y(197)/y(61),T(60),1);
T(295) = getPowerDeriv(y(199)/y(61),T(60),1);
T(296) = getPowerDeriv(y(66)/y(187),T(56),1);
T(297) = getPowerDeriv(y(212)/y(66),T(60),1);
T(298) = getPowerDeriv(y(214)/y(66),T(60),1);
T(299) = getPowerDeriv(y(73)/y(218),T(1)/params(126),1);
T(300) = getPowerDeriv(y(75)/y(142),T(130),1);
T(301) = getPowerDeriv(y(80)/y(81),(-params(262)),1);
T(302) = (params(185)==3)*y(291)+y(276)*(params(185)==3)+(params(127)==3)*y(250)+y(235)*(params(127)==3)+(params(69)==3)*y(209)+y(194)*(params(69)==3)+(params(13)==3)*y(178)+y(144)*(params(245)==3)+y(163)*(params(13)==3);
T(303) = getPowerDeriv(y(83)/y(228),T(144),1);
T(304) = getPowerDeriv(y(238)/y(83),T(148),1);
T(305) = getPowerDeriv(y(240)/y(83),T(148),1);
T(306) = getPowerDeriv(y(88)/y(228),T(144),1);
T(307) = getPowerDeriv(y(253)/y(88),T(148),1);
T(308) = getPowerDeriv(y(255)/y(88),T(148),1);
T(309) = getPowerDeriv(y(95)/y(259),T(1)/params(184),1);
T(310) = getPowerDeriv(y(97)/y(142),T(130),1);
T(311) = getPowerDeriv(y(102)/y(103),(-params(262)),1);
T(312) = (params(185)==4)*y(291)+y(276)*(params(185)==4)+(params(127)==4)*y(250)+y(235)*(params(127)==4)+(params(69)==4)*y(209)+y(194)*(params(69)==4)+(params(13)==4)*y(178)+y(144)*(params(245)==4)+y(163)*(params(13)==4);
T(313) = getPowerDeriv(y(105)/y(269),T(206),1);
T(314) = getPowerDeriv(y(279)/y(105),T(210),1);
T(315) = getPowerDeriv(y(281)/y(105),T(210),1);
T(316) = getPowerDeriv(y(110)/y(269),T(206),1);
T(317) = getPowerDeriv(y(294)/y(110),T(210),1);
T(318) = getPowerDeriv(y(296)/y(110),T(210),1);
T(319) = (-(T(15)*(1+params(242)*y(131)+y(131)*(1-params(242)))))/(T(16)*T(16));
T(320) = 1/y(115);
T(321) = 1/T(2);
T(322) = getPowerDeriv(T(14),(-params(251)),1);
T(323) = params(241)*T(321)*T(322)/T(16);
T(324) = 1/y(125);
T(325) = getPowerDeriv(T(262),(-params(243)),1);
T(326) = getPowerDeriv(T(262),1-params(243),1);
T(327) = getPowerDeriv(T(268),(-params(251)),1);
T(328) = getPowerDeriv(T(14),1-params(243),1);
T(329) = T(321)*T(328);
T(330) = getPowerDeriv(T(270)*T(273),(-params(251)),1);
T(331) = getPowerDeriv(T(264),params(243),1);
T(332) = T(324)*T(331);
T(333) = getPowerDeriv(T(271),params(243)-1,1);
T(334) = getPowerDeriv(T(271),params(243),1);
T(335) = params(241)*T(322)*(-(params(242)*y(119)+(1-params(242))*y(119)))/(T(2)*T(2))/T(16);
T(336) = (T(2)-y(125))/(T(2)*T(2))*2*y(125)/T(2);
T(337) = (T(2)*(params(242)*y(150)+(1-params(242))*y(150))/y(150)-y(125)*(params(242)*y(150)+(1-params(242))*y(150))/y(150))/(T(2)*T(2));
T(338) = getPowerDeriv(y(170)*y(125)*(1-y(158))*y(167),params(38),1);
T(339) = getPowerDeriv(y(170)*y(125)*(1-y(158))*y(167),T(40),1);
T(340) = getPowerDeriv(T(42),params(39)/(params(39)-1+(params(39)==1)*1000),1);
T(341) = getPowerDeriv(y(125)*y(167)/y(166),T(45),1);
T(342) = getPowerDeriv(y(201)*y(125)*(1-y(189))*y(198),params(94),1);
T(343) = getPowerDeriv(y(201)*y(125)*(1-y(189))*y(198),T(68),1);
T(344) = getPowerDeriv(T(70),params(95)/(params(95)-1+1000*(params(95)==1)),1);
T(345) = getPowerDeriv(y(125)*y(198)/y(197),T(73),1);
T(346) = (T(2)*(params(242)*y(154)+(1-params(242))*y(154))/y(154)-y(125)*(params(242)*y(154)+(1-params(242))*y(154))/y(154))/(T(2)*T(2));
T(347) = getPowerDeriv(y(185)*y(125)*(1-y(173))*y(182),params(60),1);
T(348) = getPowerDeriv(y(185)*y(125)*(1-y(173))*y(182),T(96),1);
T(349) = getPowerDeriv(T(98),params(61)/(params(61)-1+1000*(params(61)==1)),1);
T(350) = getPowerDeriv(y(125)*y(182)/y(181),T(101),1);
T(351) = getPowerDeriv(y(216)*y(125)*(1-y(204))*y(213),params(116),1);
T(352) = getPowerDeriv(y(216)*y(125)*(1-y(204))*y(213),T(117),1);
T(353) = getPowerDeriv(T(119),params(117)/(params(117)-1+1000*(params(117)==1)),1);
T(354) = getPowerDeriv(y(125)*y(213)/y(212),T(122),1);
T(355) = (T(2)*(params(242)*y(222)+(1-params(242))*y(222))/y(222)-y(125)*(params(242)*y(222)+(1-params(242))*y(222))/y(222))/(T(2)*T(2));
T(356) = getPowerDeriv(y(242)*y(125)*(1-y(230))*y(239),params(152),1);
T(357) = getPowerDeriv(y(242)*y(125)*(1-y(230))*y(239),T(156),1);
T(358) = getPowerDeriv(T(158),params(153)/(params(153)-1+1000*(params(153)==1)),1);
T(359) = getPowerDeriv(y(125)*y(239)/y(238),T(161),1);
T(360) = (T(2)*(params(242)*y(226)+(1-params(242))*y(226))/y(226)-y(125)*(params(242)*y(226)+(1-params(242))*y(226))/y(226))/(T(2)*T(2));
T(361) = getPowerDeriv(y(257)*y(125)*(1-y(245))*y(254),params(174),1);
T(362) = getPowerDeriv(y(257)*y(125)*(1-y(245))*y(254),T(184),1);
T(363) = getPowerDeriv(T(186),params(175)/(params(175)-1+1000*(params(175)==1)),1);
T(364) = getPowerDeriv(y(125)*y(254)/y(253),T(189),1);
T(365) = (T(2)*(params(242)*y(263)+(1-params(242))*y(263))/y(263)-y(125)*(params(242)*y(263)+(1-params(242))*y(263))/y(263))/(T(2)*T(2));
T(366) = getPowerDeriv(y(283)*y(125)*(1-y(271))*y(280),params(210),1);
T(367) = getPowerDeriv(y(283)*y(125)*(1-y(271))*y(280),T(218),1);
T(368) = getPowerDeriv(T(220),params(211)/(params(211)-1+1000*(params(211)==1)),1);
T(369) = getPowerDeriv(y(125)*y(280)/y(279),T(223),1);
T(370) = (T(2)*(params(242)*y(267)+(1-params(242))*y(267))/y(267)-y(125)*(params(242)*y(267)+(1-params(242))*y(267))/y(267))/(T(2)*T(2));
T(371) = getPowerDeriv(y(298)*y(125)*(1-y(286))*y(295),params(232),1);
T(372) = getPowerDeriv(y(298)*y(125)*(1-y(286))*y(295),T(246),1);
T(373) = getPowerDeriv(T(248),params(233)/(params(233)-1+1000*(params(233)==1)),1);
T(374) = getPowerDeriv(y(125)*y(295)/y(294),T(251),1);
T(375) = T(11)*(1+params(242)*y(129)+(1-params(242))*y(129))*T(275)*(-params(256))*(params(242)*y(129)+(1-params(242))*y(129))/(params(242)*y(137)+(1-params(242))*y(137));
T(376) = (-(T(3)*T(15)))/(T(16)*T(16));
T(377) = getPowerDeriv(y(135),params(249),1);
T(378) = getPowerDeriv(y(142)/y(138),T(260),1);
T(379) = getPowerDeriv(y(139)/y(138),T(260),1);
T(380) = getPowerDeriv(y(146)/y(139),T(10),1);
T(381) = getPowerDeriv(y(218)/y(139),T(10),1);
T(382) = getPowerDeriv(y(259)/y(139),T(10),1);
T(383) = T(324)-(1-params(244))/y(125);
T(384) = y(125)*(y(150)-(params(242)*y(150)+(1-params(242))*y(150)))/(y(150)*y(150))/T(2);
T(385) = y(125)*(y(154)-(params(242)*y(154)+(1-params(242))*y(154)))/(y(154)*y(154))/T(2);
T(386) = getPowerDeriv(y(171)*y(169)*(1-y(157)),T(40),1);
T(387) = getPowerDeriv(y(169)*(1-y(157))*y(170)*(1-y(158)),T(40),1);
T(388) = getPowerDeriv(y(160)*y(171),params(37),1);
T(389) = getPowerDeriv(y(160)*y(171),T(40),1);
T(390) = getPowerDeriv(y(160)/y(166),T(45),1);
T(391) = getPowerDeriv(T(51),T(52),1);
T(392) = getPowerDeriv(y(186)*y(184)*(1-y(172)),T(96),1);
T(393) = getPowerDeriv(y(184)*(1-y(172))*y(185)*(1-y(173)),T(96),1);
T(394) = getPowerDeriv(y(175)*y(186),params(59),1);
T(395) = getPowerDeriv(y(175)*y(186),T(96),1);
T(396) = getPowerDeriv(y(175)/y(181),T(101),1);
T(397) = getPowerDeriv(T(106),T(52),1);
T(398) = getPowerDeriv(y(202)*y(200)*(1-y(188)),T(68),1);
T(399) = getPowerDeriv(y(200)*(1-y(188))*y(201)*(1-y(189)),T(68),1);
T(400) = getPowerDeriv(y(191)*y(202),params(93),1);
T(401) = getPowerDeriv(y(191)*y(202),T(68),1);
T(402) = getPowerDeriv(y(191)/y(197),T(73),1);
T(403) = getPowerDeriv(T(79),T(80),1);
T(404) = getPowerDeriv(y(217)*y(215)*(1-y(203)),T(117),1);
T(405) = getPowerDeriv(y(215)*(1-y(203))*y(216)*(1-y(204)),T(117),1);
T(406) = getPowerDeriv(y(206)*y(217),params(115),1);
T(407) = getPowerDeriv(y(206)*y(217),T(117),1);
T(408) = getPowerDeriv(y(206)/y(212),T(122),1);
T(409) = getPowerDeriv(T(127),T(80),1);
T(410) = y(125)*(y(222)-(params(242)*y(222)+(1-params(242))*y(222)))/(y(222)*y(222))/T(2);
T(411) = y(125)*(y(226)-(params(242)*y(226)+(1-params(242))*y(226)))/(y(226)*y(226))/T(2);
T(412) = getPowerDeriv(y(243)*y(241)*(1-y(229)),T(156),1);
T(413) = getPowerDeriv(y(241)*(1-y(229))*y(242)*(1-y(230)),T(156),1);
T(414) = getPowerDeriv(y(232)*y(243),params(151),1);
T(415) = getPowerDeriv(y(232)*y(243),T(156),1);
T(416) = getPowerDeriv(y(232)/y(238),T(161),1);
T(417) = getPowerDeriv(T(167),T(168),1);
T(418) = getPowerDeriv(y(258)*y(256)*(1-y(244)),T(184),1);
T(419) = getPowerDeriv(y(256)*(1-y(244))*y(257)*(1-y(245)),T(184),1);
T(420) = getPowerDeriv(y(247)*y(258),params(173),1);
T(421) = getPowerDeriv(y(247)*y(258),T(184),1);
T(422) = getPowerDeriv(y(247)/y(253),T(189),1);
T(423) = getPowerDeriv(T(194),T(168),1);
T(424) = y(125)*(y(263)-(params(242)*y(263)+(1-params(242))*y(263)))/(y(263)*y(263))/T(2);
T(425) = y(125)*(y(267)-(params(242)*y(267)+(1-params(242))*y(267)))/(y(267)*y(267))/T(2);
T(426) = getPowerDeriv(y(284)*y(282)*(1-y(270)),T(218),1);
T(427) = getPowerDeriv(y(282)*(1-y(270))*y(283)*(1-y(271)),T(218),1);
T(428) = getPowerDeriv(y(273)*y(284),params(209),1);
T(429) = getPowerDeriv(y(273)*y(284),T(218),1);
T(430) = getPowerDeriv(y(273)/y(279),T(223),1);
T(431) = getPowerDeriv(T(229),T(230),1);
T(432) = getPowerDeriv(y(299)*y(297)*(1-y(285)),T(246),1);
T(433) = getPowerDeriv(y(297)*(1-y(285))*y(298)*(1-y(286)),T(246),1);
T(434) = getPowerDeriv(y(288)*y(299),params(231),1);
T(435) = getPowerDeriv(y(288)*y(299),T(246),1);
T(436) = getPowerDeriv(y(288)/y(294),T(251),1);
T(437) = getPowerDeriv(T(256),T(230),1);

end
