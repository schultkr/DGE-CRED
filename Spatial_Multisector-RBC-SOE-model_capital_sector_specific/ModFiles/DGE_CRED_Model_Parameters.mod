% ================================
% === Set Model Parameters ===
% ================================
inbsectors_p = @{Sectors};
inbregions_p = @{Regions};
etaC_p = 9;
tauC_p = 0.19;
tauN_p = 0.2;
tauK_p = 0.3;
beta_p = 0.95;
delta_p = 0.05;
sigmaL_p = 0.25;
sigmaC_p = 1;
rhoA_p = 0.9;
omegaNX0_p = 0.03;
omegaNX_p = omegaNX0_p; 
omegaNXT_p = 0.03;
rhoNX_p = 0.9;
rhoSL_p = 0.9;
PoP0_p = 95;
Y0_p = 1;
N0_p = 0.5;
NT_p = N0_p;
P0_p = 1;
PoPT_p = PoP0_p;
YT_p = Y0_p;
rhoPoP_p = 0.9;
rhoT_p = 0.9;
rhoWS_p = 0.9;
rhoPERC_p = 0.9;
rhoSL_p = 0.9;
phiB_p = 10;
phiK_p = 10;
SL0_p = 0;
SLT_p = 0;
@# for reg in 1:Regions
    T0_@{reg}_p = 0;
    TT_@{reg}_p = T0_@{reg}_p;
    PERC0_@{reg}_p = 0;
    PERCT_@{reg}_p = PERC0_@{reg}_p;
    WS0_@{reg}_p = 0;
    WST_@{reg}_p = WS0_@{reg}_p;
@# endfor

aT_1_mat = [0.0, 0.0; 0.0 0.0];
aT_2_mat = [0.01,0.005;  0.00236, 0.00236];
aT_3_mat = [2, 2; 2 2];

aSL_1_mat = [7 0; 0 0];
aSL_2_mat = [0 0; 0 0];
aSL_3_mat = [2, 2; 2 2];

@# for sec in 1:Sectors
    omega_@{sec}_p = 1/inbsectors_p;
    etaC_@{sec}_p = 2;
    @# for reg in 1:Regions
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
        phiP_@{sec}_@{reg}_p = 1;
        GAT_@{sec}_@{reg}_p = 0;
        phiGA_@{sec}_@{reg}_p = 1;
        phiN_@{sec}_@{reg}_p = 1/(inbsectors_p*inbregions_p);
        phiY_@{sec}_@{reg}_p = 1/(inbsectors_p*inbregions_p);
        phiL_@{sec}_@{reg}_p = 1;
        alphaK_@{sec}_@{reg}_p = 0.5;
        alphaN_@{sec}_@{reg}_p = 0.5;
        omega_@{sec}_@{reg}_p = 1/inbregions_p;
        etaNK_@{sec}_@{reg}_p = 0.95;
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

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Climate Damage Functions');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));


