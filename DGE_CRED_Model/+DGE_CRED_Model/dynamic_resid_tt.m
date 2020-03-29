function T = dynamic_resid_tt(T, y, x, params, steady_state, it_)
% function T = dynamic_resid_tt(T, y, x, params, steady_state, it_)
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

assert(length(T) >= 148);

T(1) = params(23)*y(60)+params(24)*y(60)^params(25)+params(32)*y(58)+params(33)*y(58)^params(34)+params(29)*y(61)+params(30)*y(61)^params(31)+params(26)*y(59)+params(27)*y(59)^params(28);
T(2) = params(11)^(1/params(2));
T(3) = (-1)/params(2);
T(4) = T(2)*(y(71)/y(65))^T(3);
T(5) = params(12)^(1/params(14));
T(6) = (params(14)-1)/params(14);
T(7) = params(13)^(1/params(14));
T(8) = T(5)*(y(80)*y(13))^T(6)+T(7)*(y(79)*y(48)*y(74))^T(6);
T(9) = T(8)^(params(14)/(params(14)-1));
T(10) = T(5)*y(80)^T(6);
T(11) = (-1)/params(14);
T(12) = (y(13)/y(71))^T(11);
T(13) = (y(45)*y(47)/y(48))^(-params(202));
T(14) = (y(168)/y(169))^(-params(202));
T(15) = T(14)/((1+params(206))*y(167));
T(16) = (y(47)/y(48))^(-params(202));
T(17) = y(45)*(1+params(206));
T(18) = T(16)/T(17);
T(19) = sqrt(params(205)/2);
T(20) = exp(T(19)*(y(81)/y(17)-1));
T(21) = exp((y(81)/y(17)-1)*(-T(19)));
T(22) = 1-(T(20)+T(21)-2);
T(23) = T(22)-T(19)*y(81)/y(17)*(T(20)-T(21));
T(24) = T(14)*params(199)/((1+params(206))*y(167));
T(25) = y(173)^2;
T(26) = y(81)^2;
T(27) = T(19)*y(175)*T(24)*T(25)/T(26);
T(28) = exp(T(19)*(y(173)/y(81)-1));
T(29) = exp((-T(19))*(y(173)/y(81)-1));
T(30) = T(28)-T(29);
T(31) = params(55)*y(63)+params(56)*y(63)^params(57)+y(58)*params(64)+params(65)*y(58)^params(66)+params(61)*y(64)+params(62)*y(64)^params(63)+params(58)*y(62)+params(59)*y(62)^params(60);
T(32) = params(43)^(1/params(2));
T(33) = T(32)*(y(85)/y(65))^T(3);
T(34) = params(44)^(1/params(46));
T(35) = (params(46)-1)/params(46);
T(36) = params(45)^(1/params(46));
T(37) = T(34)*(y(94)*y(18))^T(35)+T(36)*(y(48)*y(93)*y(88))^T(35);
T(38) = T(37)^(params(46)/(params(46)-1));
T(39) = T(34)*y(94)^T(35);
T(40) = (-1)/params(46);
T(41) = (y(18)/y(85))^T(40);
T(42) = exp(T(19)*(y(95)/y(22)-1));
T(43) = exp((-T(19))*(y(95)/y(22)-1));
T(44) = 1-(T(42)+T(43)-2);
T(45) = T(44)-T(19)*y(95)/y(22)*(T(42)-T(43));
T(46) = y(177)^2;
T(47) = y(95)^2;
T(48) = T(19)*T(24)*y(179)*T(46)/T(47);
T(49) = exp(T(19)*(y(177)/y(95)-1));
T(50) = exp((-T(19))*(y(177)/y(95)-1));
T(51) = T(49)-T(50);
T(52) = params(1)^(1/params(203));
T(53) = (-1)/params(203);
T(54) = (params(2)-1)/params(2);
T(55) = T(2)*y(71)^T(54)+T(32)*y(85)^T(54);
T(56) = y(60)*params(89)+params(90)*y(60)^params(91)+y(58)*params(98)+params(99)*y(58)^params(100)+y(61)*params(95)+params(96)*y(61)^params(97)+y(59)*params(92)+params(93)*y(59)^params(94);
T(57) = params(77)^(1/params(68));
T(58) = (-1)/params(68);
T(59) = T(57)*(y(105)/y(99))^T(58);
T(60) = params(78)^(1/params(80));
T(61) = (params(80)-1)/params(80);
T(62) = params(79)^(1/params(80));
T(63) = T(60)*(y(114)*y(24))^T(61)+T(62)*(y(48)*y(113)*y(108))^T(61);
T(64) = T(63)^(params(80)/(params(80)-1));
T(65) = T(60)*y(114)^T(61);
T(66) = (-1)/params(80);
T(67) = (y(24)/y(105))^T(66);
T(68) = exp(T(19)*(y(115)/y(28)-1));
T(69) = exp((-T(19))*(y(115)/y(28)-1));
T(70) = 1-(T(68)+T(69)-2);
T(71) = T(70)-T(19)*y(115)/y(28)*(T(68)-T(69));
T(72) = y(181)^2;
T(73) = y(115)^2;
T(74) = T(19)*T(24)*y(183)*T(72)/T(73);
T(75) = exp(T(19)*(y(181)/y(115)-1));
T(76) = exp((-T(19))*(y(181)/y(115)-1));
T(77) = T(75)-T(76);
T(78) = y(63)*params(121)+params(122)*y(63)^params(123)+y(58)*params(130)+params(131)*y(58)^params(132)+y(64)*params(127)+params(128)*y(64)^params(129)+y(62)*params(124)+params(125)*y(62)^params(126);
T(79) = params(109)^(1/params(68));
T(80) = T(79)*(y(119)/y(99))^T(58);
T(81) = params(110)^(1/params(112));
T(82) = (params(112)-1)/params(112);
T(83) = params(111)^(1/params(112));
T(84) = T(81)*(y(128)*y(29))^T(82)+T(83)*(y(48)*y(127)*y(122))^T(82);
T(85) = T(84)^(params(112)/(params(112)-1));
T(86) = T(81)*y(128)^T(82);
T(87) = (-1)/params(112);
T(88) = (y(29)/y(119))^T(87);
T(89) = exp(T(19)*(y(129)/y(33)-1));
T(90) = exp((-T(19))*(y(129)/y(33)-1));
T(91) = 1-(T(89)+T(90)-2);
T(92) = T(91)-T(19)*y(129)/y(33)*(T(89)-T(90));
T(93) = y(185)^2;
T(94) = y(129)^2;
T(95) = T(19)*T(24)*y(187)*T(93)/T(94);
T(96) = exp(T(19)*(y(185)/y(129)-1));
T(97) = exp((-T(19))*(y(185)/y(129)-1));
T(98) = T(96)-T(97);
T(99) = params(67)^(1/params(203));
T(100) = (params(68)-1)/params(68);
T(101) = T(57)*y(105)^T(100)+T(79)*y(119)^T(100);
T(102) = y(60)*params(155)+params(156)*y(60)^params(157)+y(58)*params(164)+params(165)*y(58)^params(166)+y(61)*params(161)+params(162)*y(61)^params(163)+y(59)*params(158)+params(159)*y(59)^params(160);
T(103) = params(143)^(1/params(134));
T(104) = (-1)/params(134);
T(105) = T(103)*(y(139)/y(133))^T(104);
T(106) = params(144)^(1/params(146));
T(107) = (params(146)-1)/params(146);
T(108) = params(145)^(1/params(146));
T(109) = T(106)*(y(148)*y(35))^T(107)+T(108)*(y(48)*y(147)*y(142))^T(107);
T(110) = T(109)^(params(146)/(params(146)-1));
T(111) = T(106)*y(148)^T(107);
T(112) = (-1)/params(146);
T(113) = (y(35)/y(139))^T(112);
T(114) = exp(T(19)*(y(149)/y(39)-1));
T(115) = exp((-T(19))*(y(149)/y(39)-1));
T(116) = 1-(T(114)+T(115)-2);
T(117) = T(116)-T(19)*y(149)/y(39)*(T(114)-T(115));
T(118) = y(189)^2;
T(119) = y(149)^2;
T(120) = T(19)*T(24)*y(191)*T(118)/T(119);
T(121) = exp(T(19)*(y(189)/y(149)-1));
T(122) = exp((-T(19))*(y(189)/y(149)-1));
T(123) = T(121)-T(122);
T(124) = y(63)*params(187)+params(188)*y(63)^params(189)+y(58)*params(196)+params(197)*y(58)^params(198)+y(64)*params(193)+params(194)*y(64)^params(195)+y(62)*params(190)+params(191)*y(62)^params(192);
T(125) = params(175)^(1/params(134));
T(126) = T(125)*(y(153)/y(133))^T(104);
T(127) = params(176)^(1/params(178));
T(128) = (params(178)-1)/params(178);
T(129) = params(177)^(1/params(178));
T(130) = T(127)*(y(162)*y(40))^T(128)+T(129)*(y(48)*y(161)*y(156))^T(128);
T(131) = T(130)^(params(178)/(params(178)-1));
T(132) = T(127)*y(162)^T(128);
T(133) = (-1)/params(178);
T(134) = (y(40)/y(153))^T(133);
T(135) = exp(T(19)*(y(163)/y(44)-1));
T(136) = exp((-T(19))*(y(163)/y(44)-1));
T(137) = 1-(T(135)+T(136)-2);
T(138) = T(137)-T(19)*y(163)/y(44)*(T(135)-T(136));
T(139) = y(193)^2;
T(140) = y(163)^2;
T(141) = T(19)*T(24)*y(195)*T(139)/T(140);
T(142) = exp(T(19)*(y(193)/y(163)-1));
T(143) = exp((-T(19))*(y(193)/y(163)-1));
T(144) = T(142)-T(143);
T(145) = params(133)^(1/params(203));
T(146) = (params(134)-1)/params(134);
T(147) = T(103)*y(139)^T(146)+T(125)*y(153)^T(146);
T(148) = exp((-params(204))*(y(49)*y(170)*y(171)/y(172)+y(52)/y(56)));

end
