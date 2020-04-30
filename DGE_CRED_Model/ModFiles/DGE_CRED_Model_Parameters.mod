% ================================
% === Set Model Parameters ===
% ================================
inbsectors_p = @{Sectors};
inbregions_p = @{Regions};
etaQ_p = 9;
tauC_p = 0.19;
tauN_p = 0.2;
tauK_p = 0.3;
beta_p = 0.95;
delta_p = 0.05;
sigmaL_p = 0.25;
sigmaC_p = 1;
rhoA_p = 0.9;
omegaNX0_p = 0.01;
omegaNX_p = omegaNX0_p; 
omegaNXT_p = 0.01;
rhoNX_p = 0.7;
rhoSL_p = 0.9;
PoP0_p = 95;
Y0_p = 1;
N0_p = 0.145;
NT_p = N0_p;
P0_p = 1;
PoPT_p = PoP0_p;
YT_p = Y0_p;
rhoPoP_p = 0.9;
rhoT_p = 0.9;
rhoWS_p = 0.9;
rhoPREC_p = 0.9;
rhoSL_p = 0.9;
phiB_p = 10;
phiK_p = 10;
SL0_p = 0;
SLT_p = 0;
@# for reg in 1:Regions
    T0_@{reg}_p = 0;
    TT_@{reg}_p = T0_@{reg}_p;
    PREC0_@{reg}_p = 0;
    PRECT_@{reg}_p = PREC0_@{reg}_p;
    WS0_@{reg}_p = 0;
    WST_@{reg}_p = WS0_@{reg}_p;
    DRO0_@{reg}_p = 0;
    CYC0_@{reg}_p = 0;
@# endfor

aT_1_mat = [0.0, 0.0; 0.0 0.0];
aT_2_mat = [0.01,0.005;  0.00236, 0.00236];
aT_3_mat = [2, 2; 2 2];

aSL_1_mat = [7 0; 0 0];
aSL_2_mat = [0 0; 0 0];
aSL_3_mat = [2, 2; 2 2];

@# for sec in 1:Sectors
    omegaQ_@{sec}_p = 1/inbsectors_p;
    etaQ_@{sec}_p = 2;
    @# for reg in 1:Regions
        tauK_@{sec}_@{reg}_p = 0.2;
        tauN_@{sec}_@{reg}_p = 0;
        A_@{sec}_@{reg}_p = 1;
        omegaA_@{sec}_@{reg}_p = 0.025;
        gY0_@{sec}_@{reg}_p = 1.06;
        gN0_@{sec}_@{reg}_p = 1.06;
        A_N_@{sec}_@{reg}_p = 1;
        A_K_@{sec}_@{reg}_p = 1;
        rhoA_@{sec}_@{reg}_p = 0;
        rhoA_N_@{sec}_@{reg}_p = 0;
        rhoA_K_@{sec}_@{reg}_p = 0;
        phiW_@{sec}_@{reg}_p = 0.5;
        GAT_@{sec}_@{reg}_p = 0;
        deltaKASL_@{sec}_@{reg}_p = 0.01; 
        deltaKAWS_@{sec}_@{reg}_p = 1; 
        deltaKAT_@{sec}_@{reg}_p = 1; 
        deltaKAPREC_@{sec}_@{reg}_p = 1; 
        deltaKADRO_@{sec}_@{reg}_p = 1; 
        deltaKACYC_@{sec}_@{reg}_p = 1; 
        phiGAT_@{sec}_@{reg}_p = 1;
        phiGASL_@{sec}_@{reg}_p = 0.15;
        phiGAWS_@{sec}_@{reg}_p = 1;
        phiGAPREC_@{sec}_@{reg}_p = 1;
        phiGADRO_@{sec}_@{reg}_p = 1;
        phiGACYC_@{sec}_@{reg}_p = 1;
        phiN_@{sec}_@{reg}_p = 1/(inbsectors_p*inbregions_p);
        phiY_@{sec}_@{reg}_p = 1/(inbsectors_p*inbregions_p);
        phiN0_@{sec}_@{reg}_p = phiN_@{sec}_@{reg}_p;
        phiY0_@{sec}_@{reg}_p = phiY_@{sec}_@{reg}_p;
        phiNT_@{sec}_@{reg}_p = phiN_@{sec}_@{reg}_p;
        phiYT_@{sec}_@{reg}_p = phiY_@{sec}_@{reg}_p;
        phiL_@{sec}_@{reg}_p = 1;
        alphaK_@{sec}_@{reg}_p = 0.5;
        alphaN_@{sec}_@{reg}_p = 0.5;
        omegaQ_@{sec}_@{reg}_p = 1/inbregions_p;
        etaNK_@{sec}_@{reg}_p = 0.95;
        // TFP coefficients
        a_T_1_@{sec}_@{reg}_p = 0;
        a_T_2_@{sec}_@{reg}_p = 0.00253;
        a_T_3_@{sec}_@{reg}_p = 2;
        a_SL_1_@{sec}_@{reg}_p = 0;
        a_SL_2_@{sec}_@{reg}_p = 0;
        a_SL_3_@{sec}_@{reg}_p = 2;
        a_W_1_@{sec}_@{reg}_p = 0;
        a_W_2_@{sec}_@{reg}_p = 0;
        a_W_3_@{sec}_@{reg}_p = 2;
        a_P_1_@{sec}_@{reg}_p = 0;
        a_P_2_@{sec}_@{reg}_p = 0;
        a_P_3_@{sec}_@{reg}_p = 2;
        a_DR_1_@{sec}_@{reg}_p = 0;
        a_DR_2_@{sec}_@{reg}_p = 0;
        a_DR_3_@{sec}_@{reg}_p = 2;
        a_CY_1_@{sec}_@{reg}_p = 0;
        a_CY_2_@{sec}_@{reg}_p = 0;
        a_CY_3_@{sec}_@{reg}_p = 2;
        // labour productvity coefficients
        aN_T_1_@{sec}_@{reg}_p = 0;
        aN_T_2_@{sec}_@{reg}_p = 0;
        aN_T_3_@{sec}_@{reg}_p = 2;
        aN_SL_1_@{sec}_@{reg}_p = 0;
        aN_SL_2_@{sec}_@{reg}_p = 0;
        aN_SL_3_@{sec}_@{reg}_p = 2;
        aN_W_1_@{sec}_@{reg}_p = 0;
        aN_W_2_@{sec}_@{reg}_p = 0;
        aN_W_3_@{sec}_@{reg}_p = 2;
        aN_P_1_@{sec}_@{reg}_p = 0;
        aN_P_2_@{sec}_@{reg}_p = 0;
        aN_P_3_@{sec}_@{reg}_p = 2;
        aN_DR_1_@{sec}_@{reg}_p = 0;
        aN_DR_2_@{sec}_@{reg}_p = 0;
        aN_DR_3_@{sec}_@{reg}_p = 2;
        aN_CY_1_@{sec}_@{reg}_p = 0;
        aN_CY_2_@{sec}_@{reg}_p = 0;
        aN_CY_3_@{sec}_@{reg}_p = 2;
        // capital stock coefficients
        aK_T_1_@{sec}_@{reg}_p = 0;
        aK_T_2_@{sec}_@{reg}_p = 0;
        aK_T_3_@{sec}_@{reg}_p = 2;
        aK_SL_1_@{sec}_@{reg}_p = 0;
        aK_SL_2_@{sec}_@{reg}_p = 0;
        aK_SL_3_@{sec}_@{reg}_p = 2;
        aK_W_1_@{sec}_@{reg}_p = 0;
        aK_W_2_@{sec}_@{reg}_p = 0;
        aK_W_3_@{sec}_@{reg}_p = 2;
        aK_P_1_@{sec}_@{reg}_p = 0;
        aK_P_2_@{sec}_@{reg}_p = 0;
        aK_P_3_@{sec}_@{reg}_p = 2;
        aK_DR_1_@{sec}_@{reg}_p = 0;
        aK_DR_2_@{sec}_@{reg}_p = 0;
        aK_DR_3_@{sec}_@{reg}_p = 2;
        aK_CY_1_@{sec}_@{reg}_p = 0;
        aK_CY_2_@{sec}_@{reg}_p = 0;
        aK_CY_3_@{sec}_@{reg}_p = 2;
    @# endfor
@# endfor

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Start');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Dynamics');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Structural Parameters');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Damage Functions TFP');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Damage Functions Labour');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Damage Functions Capital');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));



