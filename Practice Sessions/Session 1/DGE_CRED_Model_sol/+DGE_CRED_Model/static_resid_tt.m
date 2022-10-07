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

assert(length(T) >= 124);

T(1) = params(120)*y(77)+(1-params(120))*y(77);
T(2) = y(96)*((params(123)==0)+(params(123)==1)*y(25)+(params(123)==2)*y(42)+(params(123)==3)*y(59))+y(111)*((params(13)==0)+y(25)*(params(13)==1)+y(42)*(params(13)==2)+y(59)*(params(13)==3))+y(133)*((params(49)==0)+y(25)*(params(49)==1)+y(42)*(params(49)==2)+y(59)*(params(49)==3))+y(155)*((params(85)==0)+y(25)*(params(85)==1)+y(42)*(params(85)==2)+y(59)*(params(85)==3));
T(3) = params(11)^(1/params(130));
T(4) = (-1)/params(130);
T(5) = 1-(params(120)*y(86)+(1-params(120))*y(86));
T(6) = sqrt(params(135)/2);
T(7) = (params(120)*y(71)+(1-params(120))*y(71))/T(1);
T(8) = params(119)*T(7)^(-params(129));
T(9) = (params(120)*y(67)+(1-params(120))*y(67))*(1+params(120)*y(83)+y(83)*(1-params(120)));
T(10) = T(8)/T(9);
T(11) = (params(120)*y(102)+(1-params(120))*y(102))^2;
T(12) = y(102)^2;
T(13) = (y(77)/T(1))^2;
T(14) = T(6)*(params(120)*y(103)+(1-params(120))*y(103))*T(10)*T(11)/T(12)*T(13);
T(15) = y(77)*(params(120)*y(102)+(1-params(120))*y(102))/y(102)/T(1)-1;
T(16) = exp(T(6)*T(15))-exp((-T(6))*T(15));
T(17) = y(87)^params(127);
T(18) = params(35)^(1/params(23));
T(19) = T(18)*(y(28)/y(104))^((-1)/params(23));
T(20) = (1-params(36))^(1/params(24));
T(21) = (-1)/params(24);
T(22) = T(20)*(y(114)/y(28))^T(21);
T(23) = params(36)^(1/params(24));
T(24) = T(23)*(y(116)/y(28))^T(21);
T(25) = (y(108)*y(119))^params(37);
T(26) = y(117)*(params(39)==1)*(1-y(105))*T(25);
T(27) = (y(118)*y(77)*(1-y(106))*y(115))^params(38);
T(28) = params(37)^(1/params(39));
T(29) = (params(39)-1)/params(39);
T(30) = params(38)^(1/params(39));
T(31) = T(28)*(y(108)*y(119))^T(29)+T(30)*(y(118)*y(77)*(1-y(106))*y(115))^T(29);
T(32) = T(31)^(params(39)/(params(39)-1+(params(39)==1)*1000));
T(33) = T(28)*(y(119)*y(117)*(1-y(105)))^T(29);
T(34) = (-1)/params(39);
T(35) = (y(108)/y(114))^T(34);
T(36) = T(30)*(y(117)*(1-y(105))*y(118)*(1-y(106)))^T(29);
T(37) = (y(77)*y(115)/y(114))^T(34);
T(38) = y(115)^params(128);
T(39) = (params(24)-1)/params(24);
T(40) = T(23)*y(116)^T(39)+T(20)*y(114)^T(39);
T(41) = params(21)^(1/params(131));
T(42) = (-1)/params(131);
T(43) = params(22)^(1/params(12));
T(44) = params(47)^(1/params(130));
T(45) = (params(120)*y(124)+(1-params(120))*y(124))^2;
T(46) = y(124)^2;
T(47) = T(6)*T(13)*(params(120)*y(125)+(1-params(120))*y(125))*T(10)*T(45)/T(46);
T(48) = y(77)*(params(120)*y(124)+(1-params(120))*y(124))/y(124)/T(1)-1;
T(49) = exp(T(6)*T(48))-exp((-T(6))*T(48));
T(50) = params(71)^(1/params(59));
T(51) = T(50)*(y(45)/y(126))^((-1)/params(59));
T(52) = (1-params(72))^(1/params(60));
T(53) = (-1)/params(60);
T(54) = T(52)*(y(136)/y(45))^T(53);
T(55) = params(72)^(1/params(60));
T(56) = T(55)*(y(138)/y(45))^T(53);
T(57) = (y(130)*y(141))^params(73);
T(58) = y(139)*(params(75)==1)*(1-y(127))*T(57);
T(59) = (y(140)*y(77)*(1-y(128))*y(137))^params(74);
T(60) = params(73)^(1/params(75));
T(61) = (params(75)-1)/params(75);
T(62) = params(74)^(1/params(75));
T(63) = T(60)*(y(130)*y(141))^T(61)+T(62)*(y(140)*y(77)*(1-y(128))*y(137))^T(61);
T(64) = T(63)^(params(75)/(params(75)-1+1000*(params(75)==1)));
T(65) = T(60)*(y(141)*y(139)*(1-y(127)))^T(61);
T(66) = (-1)/params(75);
T(67) = (y(130)/y(136))^T(66);
T(68) = T(62)*(y(139)*(1-y(127))*y(140)*(1-y(128)))^T(61);
T(69) = (y(77)*y(137)/y(136))^T(66);
T(70) = y(137)^params(128);
T(71) = (params(60)-1)/params(60);
T(72) = T(55)*y(138)^T(71)+T(52)*y(136)^T(71);
T(73) = params(57)^(1/params(131));
T(74) = params(58)^(1/params(48));
T(75) = params(83)^(1/params(130));
T(76) = (params(120)*y(146)+(1-params(120))*y(146))^2;
T(77) = y(146)^2;
T(78) = T(6)*T(13)*(params(120)*y(147)+(1-params(120))*y(147))*T(10)*T(76)/T(77);
T(79) = y(77)*(params(120)*y(146)+(1-params(120))*y(146))/y(146)/T(1)-1;
T(80) = exp(T(6)*T(79))-exp((-T(6))*T(79));
T(81) = params(107)^(1/params(95));
T(82) = T(81)*(y(62)/y(148))^((-1)/params(95));
T(83) = (1-params(108))^(1/params(96));
T(84) = (-1)/params(96);
T(85) = T(83)*(y(158)/y(62))^T(84);
T(86) = params(108)^(1/params(96));
T(87) = T(86)*(y(160)/y(62))^T(84);
T(88) = (y(152)*y(163))^params(109);
T(89) = y(161)*(params(111)==1)*(1-y(149))*T(88);
T(90) = (y(162)*y(77)*(1-y(150))*y(159))^params(110);
T(91) = params(109)^(1/params(111));
T(92) = (params(111)-1)/params(111);
T(93) = params(110)^(1/params(111));
T(94) = T(91)*(y(152)*y(163))^T(92)+T(93)*(y(162)*y(77)*(1-y(150))*y(159))^T(92);
T(95) = T(94)^(params(111)/(params(111)-1+1000*(params(111)==1)));
T(96) = T(91)*(y(163)*y(161)*(1-y(149)))^T(92);
T(97) = (-1)/params(111);
T(98) = (y(152)/y(158))^T(97);
T(99) = T(93)*(y(161)*(1-y(149))*y(162)*(1-y(150)))^T(92);
T(100) = (y(77)*y(159)/y(158))^T(97);
T(101) = y(159)^params(128);
T(102) = (params(96)-1)/params(96);
T(103) = T(86)*y(160)^T(102)+T(83)*y(158)^T(102);
T(104) = params(93)^(1/params(131));
T(105) = params(94)^(1/params(84));
T(106) = params(133)^(1/params(132));
T(107) = (-1)/params(132);
T(108) = (1-params(133))^(1/params(132));
T(109) = y(71)/y(77);
T(110) = (1-params(121))*T(109)^(-params(121));
T(111) = y(72)/y(77);
T(112) = T(111)^params(121);
T(113) = T(110)*T(112);
T(114) = T(109)^(1-params(121));
T(115) = T(112)*T(114);
T(116) = T(115)^(-params(129));
T(117) = T(7)^(1-params(121));
T(118) = y(72)/T(1);
T(119) = T(118)^(params(121)-1);
T(120) = T(118)^params(121);
T(121) = (T(117)*T(120))^(-params(129));
T(122) = (params(120)*y(68)+(1-params(120))*y(68))*params(119)*(1+params(120)*y(81)+(1-params(120))*y(81));
T(123) = exp((-params(134))*((params(120)*y(81)+(1-params(120))*y(81))*(params(120)*y(78)+(1-params(120))*y(78)+y(79))/(params(120)*y(89)+(1-params(120))*y(89))+(params(120)*y(80)+(1-params(120))*y(80))/(params(120)*y(89)+(1-params(120))*y(89))));
T(124) = exp((-params(134))*(y(80)/y(89)+y(81)*(y(78)+y(79))/y(89)));

end
