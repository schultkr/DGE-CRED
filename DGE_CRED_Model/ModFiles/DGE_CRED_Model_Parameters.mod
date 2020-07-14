% ================================
% === Set Model Parameters ===
% ================================
inbsectors_p = @{Sectors};
inbregions_p = @{Regions};
etaQ_p = 9;
tauC_p = 0.19;
tauNH_p = 0.2;
tauKH_p = 0.3;
beta_p = 0.95;
delta_p = 0.05;
deltaKG_p = 0.10;
phiG_p = 0;
sigmaL_p = 0.25;
sigmaC_p = 1;
rhoA_p = 0.9;
omegaNX0_p = 0.01;
omegaNX_p = omegaNX0_p; 
omegaNXT_p = 0.01;
rhoNX_p = 0.7;
rhoSL_p = 0.9;
rf0_p = 1/beta_p - 1;
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

@# for sec in 1:Sectors
    omegaQ_@{sec}_p = 1/inbsectors_p;
    etaQ_@{sec}_p = 2;
    @# for reg in 1:Regions
        tauKF_@{sec}_@{reg}_p = 0.2;
        tauNF_@{sec}_@{reg}_p = 0;
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
        @# for z in ["T", "WS", "PREC", "SL", "CYC", "DRO"]
            // TFP coefficients
            a_@{z}_1_@{sec}_@{reg}_p = 0;
            a_@{z}_2_@{sec}_@{reg}_p = 0;
            a_@{z}_3_@{sec}_@{reg}_p = 2;
            // labour productvity coefficients
            aN_@{z}_1_@{sec}_@{reg}_p = 0;
            aN_@{z}_2_@{sec}_@{reg}_p = 0;
            aN_@{z}_3_@{sec}_@{reg}_p = 2;
            // capital stock coefficients
            aK_@{z}_1_@{sec}_@{reg}_p = 0;
            aK_@{z}_2_@{sec}_@{reg}_p = 0;
            aK_@{z}_3_@{sec}_@{reg}_p = 2;
        @# endfor

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



