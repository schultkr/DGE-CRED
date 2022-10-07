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

assert(length(T) >= 182);

T(1) = (-1);
T(2) = 1-params(120);
T(3) = params(120)*y(185)+T(2)*y(94);
T(4) = params(120)*y(181)+T(2)*y(84);
T(5) = params(120)*y(190)+T(2)*y(106);
T(6) = params(120)*y(193)+T(2)*y(120);
T(7) = params(120)*y(196)+T(2)*y(142);
T(8) = params(120)*y(199)+T(2)*y(164);
T(9) = y(113)*((params(123)==0)+(params(123)==1)*y(42)+(params(123)==2)*y(59)+(params(123)==3)*y(76))+y(128)*((params(13)==0)+y(42)*(params(13)==1)+y(59)*(params(13)==2)+y(76)*(params(13)==3))+y(150)*((params(49)==0)+y(42)*(params(49)==1)+y(59)*(params(49)==2)+y(76)*(params(49)==3))+y(172)*((params(85)==0)+y(42)*(params(85)==1)+y(59)*(params(85)==2)+y(76)*(params(85)==3));
T(10) = params(11)^(1/params(130));
T(11) = T(1)/params(130);
T(12) = sqrt(params(135)/2);
T(13) = y(119)/y(7);
T(14) = T(13)*y(2)/y(94);
T(15) = T(14)-1;
T(16) = (-T(12));
T(17) = exp(T(15)*T(16));
T(18) = exp(T(12)*(T(13)-1));
T(19) = T(18)-T(17);
T(20) = 1-(exp(T(12)*T(15))+T(17)-2)-T(12)*T(14)*T(19);
T(21) = y(119)^2;
T(22) = y(119)/y(94);
T(23) = y(104)^params(127);
T(24) = y(84)*((params(14)==0)+(params(14)==1)*params(20)+(params(14)==2)*params(56)+(params(14)==3)*params(92));
T(25) = y(84)*((params(13)==0)+(params(13)==1)*params(20)+(params(13)==2)*params(56)+(params(13)==3)*params(92));
T(26) = params(35)^(1/params(23));
T(27) = T(26)*(y(45)/y(121))^(T(1)/params(23));
T(28) = (1-params(36))^(1/params(24));
T(29) = T(1)/params(24);
T(30) = T(28)*(y(131)/y(45))^T(29);
T(31) = params(36)^(1/params(24));
T(32) = T(31)*(y(133)/y(45))^T(29);
T(33) = (y(125)*y(136))^params(37);
T(34) = y(134)*(params(39)==1)*(1-y(122))*T(33);
T(35) = (y(135)*y(94)*(1-y(123))*y(132))^params(38);
T(36) = y(134)*(1-y(122))*(params(39)~=1);
T(37) = params(37)^(1/params(39));
T(38) = (params(39)-1)/params(39);
T(39) = params(38)^(1/params(39));
T(40) = T(37)*(y(125)*y(136))^T(38)+T(39)*(y(135)*y(94)*(1-y(123))*y(132))^T(38);
T(41) = params(39)/(params(39)-1+(params(39)==1)*1000);
T(42) = T(40)^T(41);
T(43) = T(37)*(y(136)*y(134)*(1-y(122)))^T(38);
T(44) = T(1)/params(39);
T(45) = (y(125)/y(131))^T(44);
T(46) = T(39)*(y(134)*(1-y(122))*y(135)*(1-y(123)))^T(38);
T(47) = (y(94)*y(132)/y(131))^T(44);
T(48) = y(132)^params(128);
T(49) = (params(24)-1)/params(24);
T(50) = T(31)*y(133)^T(49)+T(28)*y(131)^T(49);
T(51) = params(21)^(1/params(131));
T(52) = T(1)/params(131);
T(53) = params(22)^(1/params(12));
T(54) = (y(42)/y(43))^(-params(140));
T(55) = params(47)^(1/params(130));
T(56) = y(141)/y(11);
T(57) = y(2)*T(56)/y(94);
T(58) = T(57)-1;
T(59) = 1-(exp(T(12)*T(58))+exp(T(16)*T(58))-2);
T(60) = exp(T(12)*(T(56)-1));
T(61) = T(60)-exp(T(16)*T(58));
T(62) = T(59)-T(12)*T(57)*T(61);
T(63) = y(141)^2;
T(64) = y(141)/y(94);
T(65) = y(84)*((params(50)==0)+(params(50)==1)*params(20)+(params(50)==2)*params(56)+(params(50)==3)*params(92));
T(66) = y(84)*((params(49)==0)+(params(49)==1)*params(20)+(params(49)==2)*params(56)+(params(49)==3)*params(92));
T(67) = params(71)^(1/params(59));
T(68) = T(67)*(y(62)/y(143))^(T(1)/params(59));
T(69) = (1-params(72))^(1/params(60));
T(70) = T(1)/params(60);
T(71) = T(69)*(y(153)/y(62))^T(70);
T(72) = params(72)^(1/params(60));
T(73) = T(72)*(y(155)/y(62))^T(70);
T(74) = (y(147)*y(158))^params(73);
T(75) = y(156)*(params(75)==1)*(1-y(144))*T(74);
T(76) = (y(157)*y(94)*(1-y(145))*y(154))^params(74);
T(77) = y(156)*(1-y(144))*(params(75)~=1);
T(78) = params(73)^(1/params(75));
T(79) = (params(75)-1)/params(75);
T(80) = params(74)^(1/params(75));
T(81) = T(78)*(y(147)*y(158))^T(79)+T(80)*(y(157)*y(94)*(1-y(145))*y(154))^T(79);
T(82) = params(75)/(params(75)-1+1000*(params(75)==1));
T(83) = T(81)^T(82);
T(84) = T(78)*(y(158)*y(156)*(1-y(144)))^T(79);
T(85) = T(1)/params(75);
T(86) = (y(147)/y(153))^T(85);
T(87) = T(80)*(y(156)*(1-y(144))*y(157)*(1-y(145)))^T(79);
T(88) = (y(94)*y(154)/y(153))^T(85);
T(89) = y(154)^params(128);
T(90) = (params(60)-1)/params(60);
T(91) = T(72)*y(155)^T(90)+T(69)*y(153)^T(90);
T(92) = params(57)^(1/params(131));
T(93) = params(58)^(1/params(48));
T(94) = (y(59)/y(60))^(-params(140));
T(95) = params(83)^(1/params(130));
T(96) = y(163)/y(15);
T(97) = y(2)*T(96)/y(94);
T(98) = T(97)-1;
T(99) = 1-(exp(T(12)*T(98))+exp(T(16)*T(98))-2);
T(100) = exp(T(12)*(T(96)-1));
T(101) = T(100)-exp(T(16)*T(98));
T(102) = T(99)-T(12)*T(97)*T(101);
T(103) = y(163)^2;
T(104) = y(163)/y(94);
T(105) = y(84)*((params(86)==0)+(params(86)==1)*params(20)+(params(86)==2)*params(56)+(params(86)==3)*params(92));
T(106) = y(84)*((params(85)==0)+(params(85)==1)*params(20)+(params(85)==2)*params(56)+(params(85)==3)*params(92));
T(107) = params(107)^(1/params(95));
T(108) = T(107)*(y(79)/y(165))^(T(1)/params(95));
T(109) = (1-params(108))^(1/params(96));
T(110) = T(1)/params(96);
T(111) = T(109)*(y(175)/y(79))^T(110);
T(112) = params(108)^(1/params(96));
T(113) = T(112)*(y(177)/y(79))^T(110);
T(114) = (y(169)*y(180))^params(109);
T(115) = y(178)*(params(111)==1)*(1-y(166))*T(114);
T(116) = (y(179)*y(94)*(1-y(167))*y(176))^params(110);
T(117) = y(178)*(1-y(166))*(params(111)~=1);
T(118) = params(109)^(1/params(111));
T(119) = (params(111)-1)/params(111);
T(120) = params(110)^(1/params(111));
T(121) = T(118)*(y(169)*y(180))^T(119)+T(120)*(y(179)*y(94)*(1-y(167))*y(176))^T(119);
T(122) = params(111)/(params(111)-1+1000*(params(111)==1));
T(123) = T(121)^T(122);
T(124) = T(118)*(y(180)*y(178)*(1-y(166)))^T(119);
T(125) = T(1)/params(111);
T(126) = (y(169)/y(175))^T(125);
T(127) = T(120)*(y(178)*(1-y(166))*y(179)*(1-y(167)))^T(119);
T(128) = (y(94)*y(176)/y(175))^T(125);
T(129) = y(176)^params(128);
T(130) = (params(96)-1)/params(96);
T(131) = T(112)*y(177)^T(130)+T(109)*y(175)^T(130);
T(132) = params(93)^(1/params(131));
T(133) = params(94)^(1/params(84));
T(134) = (y(76)/y(77))^(-params(140));
T(135) = params(133)^(1/params(132));
T(136) = T(1)/params(132);
T(137) = (1-params(133))^(1/params(132));
T(138) = y(88)/y(94);
T(139) = (1-params(121))*T(138)^(-params(121));
T(140) = y(89)/y(94);
T(141) = T(140)^params(121);
T(142) = T(139)*T(141);
T(143) = T(138)^(1-params(121));
T(144) = T(141)*T(143);
T(145) = T(144)^(-params(129));
T(146) = y(84)*((params(123)==0)+(params(123)==1)*params(20)+(params(123)==2)*params(56)+(params(123)==3)*params(92));
T(147) = y(84)*((params(124)==0)+(params(124)==1)*params(20)+(params(124)==2)*params(56)+(params(124)==3)*params(92));
T(148) = exp((-params(134))*(y(97)/y(106)+y(98)*(y(4)+y(3))/y(106)));
T(149) = T(4)*(params(120)*y(191)+T(2)*y(118))*(params(120)*y(182)+T(2)*y(85))*params(119);
T(150) = 1-(params(120)*y(189)+T(2)*y(103));
T(151) = (params(120)*y(183)+T(2)*y(88))/T(3);
T(152) = params(119)*T(151)^(-params(129));
T(153) = T(4)*(1+params(120)*y(188)+T(2)*y(100));
T(154) = T(152)/T(153);
T(155) = (params(120)*y(192)+T(2)*y(119))^2;
T(156) = T(6)*T(154)*T(155)/T(21);
T(157) = (y(94)/T(3))^2;
T(158) = (params(120)*y(192)+T(2)*y(119))/y(119);
T(159) = y(94)*T(158);
T(160) = T(159)/T(3)-1;
T(161) = exp(T(16)*T(160));
T(162) = exp(T(12)*T(160))-T(161);
T(163) = (params(120)*y(195)+T(2)*y(141))^2;
T(164) = T(7)*T(154)*T(163)/T(63);
T(165) = (params(120)*y(195)+T(2)*y(141))/y(141);
T(166) = y(94)*T(165);
T(167) = T(166)/T(3)-1;
T(168) = exp(T(12)*T(167))-exp(T(16)*T(167));
T(169) = (params(120)*y(198)+T(2)*y(163))^2;
T(170) = T(8)*T(154)*T(169)/T(103);
T(171) = (params(120)*y(198)+T(2)*y(163))/y(163);
T(172) = y(94)*T(171);
T(173) = T(172)/T(3)-1;
T(174) = exp(T(12)*T(173))-exp(T(16)*T(173));
T(175) = T(151)^(1-params(121));
T(176) = y(89)/T(3);
T(177) = T(176)^(params(121)-1);
T(178) = params(121)*T(175)*T(177);
T(179) = T(176)^params(121);
T(180) = (T(175)*T(179))^(-params(129));
T(181) = (params(120)*y(182)+T(2)*y(85))*params(119)*(1+params(120)*y(187)+T(2)*y(98));
T(182) = exp((-params(134))*((params(120)*y(187)+T(2)*y(98))*(y(96)+params(120)*y(95)+T(2)*y(3))/T(5)+(params(120)*y(186)+T(2)*y(97))/T(5)));

end
