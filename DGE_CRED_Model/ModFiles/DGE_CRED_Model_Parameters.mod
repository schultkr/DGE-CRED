% ================================
% === Set Model Parameters ===
% ================================
inbsectors_p = @{Sectors};
lEndogenousY_p = @{YEndogenous};
@# for sec in 1:Sectors
    substart_@{sec}_p = @{Subsecstart[sec]};
    subend_@{sec}_p = @{Subsecend[sec]};
@# endfor
inbregions_p = @{Regions};
@# if ForwardLooking == 1
    omegaP_p = 1;
@# else
    omegaP_p = 0.5; // 0.5 is lower bound for simulation to work
@# endif

etaX_p = 0.61;
etaQ_p = 1.04;
tauC_p = 0.1;
tauH_p = 0.05;
tauNH_p = 0.2;
tauKH_p = 0.2;
beta_p = 0.95;
delta_p = 0.05;
deltaH_p = 0.05;
gamma_p = 0.05;
deltaKG_p = 0.1;
phiG_p = 0;
sigmaL_p = 0.25;
sigmaC_p = 1;
rhoA_p = 0.9;
omegaF_p = 0.5;
etaF_p = 0.75; 
etaM_p = 1.01;
PoP0_p = 95;
Y0_p = 1;
H0_p = 23;
PH0_p = 1;
P0_M_p = 1;
NX0_p = 0;
N0_p = 0.15;
NT_p = N0_p;
P0_p = 1;
PoPT_p = PoP0_p;
YT_p = Y0_p;
PT_p = Y0_p;
phiB_p = 10;
phiK_p = 10;
phiM_p = 0.45;
phiQDD_p = 0.5;
iGAH_p = 0;      
iIAPH_p = 0;        
@# for z in ClimateVarsNational
    @{z}0_p = 0;
    @{z}T_p = @{z}0_p;
@# endfor
@# for reg in 1:Regions
    @# for z in ClimateVarsRegional
        @{z}0_@{reg}_p = 0;
        @{z}T_@{reg}_p = @{z}0_@{reg}_p;
    @# endfor
@# endfor

@# for sec in 1:Sectors
    omegaQA_@{sec}_p = 1/(subend_@{sec}_p - substart_@{sec}_p + 1);
    etaQA_@{sec}_p = 0.01;
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        iGA_@{subsec}_p = 0; 
        iIAP_@{subsec}_p = 0;  
        omega_@{subsec}_p = 1/inbsectors_p;
        omegaM_@{subsec}_p = 1/2;
        D_X_@{subsec}_p = 1;
        P_M_@{subsec}_p = 1;
        P_D_@{subsec}_p = 1;
        etaI_@{subsec}_p = 1.05;
        etaQ_@{subsec}_p = 2;
        omegaM_@{subsec}_p = 1/inbsectors_p;
        omegaQ_@{subsec}_p = 1/inbsectors_p;
        phiQI_@{subsec}_p = 1/2;
        phiX_@{subsec}_p = 1/2;
        @# for reg in 1:Regions
            tauKF_@{subsec}_@{reg}_p = 0;
            tauNF_@{subsec}_@{reg}_p = 0;
            A_@{subsec}_@{reg}_p = 1;
            omegaA_@{subsec}_@{reg}_p = 0.025;
            gY0_@{subsec}_@{reg}_p = 1.06;
            gN0_@{subsec}_@{reg}_p = 1.06;
            A_N_@{subsec}_@{reg}_p = 1;
            A_K_@{subsec}_@{reg}_p = 1;
            phiW_@{subsec}_@{reg}_p = 0.5;
            phiN_@{subsec}_@{reg}_p = 1/(inbsectors_p*inbregions_p);
            phiN0_@{subsec}_@{reg}_p = phiN_@{subsec}_@{reg}_p;
            phiNT_@{subsec}_@{reg}_p = phiN_@{subsec}_@{reg}_p;
            phiY_@{subsec}_@{reg}_p = 1/(inbsectors_p*inbregions_p);
            phiY0_@{subsec}_@{reg}_p = phiY_@{subsec}_@{reg}_p;
            phiYT_@{subsec}_@{reg}_p = phiY_@{subsec}_@{reg}_p;
            phiX_@{subsec}_@{reg}_p = 1/2;
            phiL_@{subsec}_@{reg}_p = 1;
            alphaK_@{subsec}_@{reg}_p = 0.5;
            alphaN_@{subsec}_@{reg}_p = 0.5;
            omegaQ_@{subsec}_@{reg}_p = 1/inbregions_p;
            omegaQI_@{subsec}_@{reg}_p = 1/2;
            etaNK_@{subsec}_@{reg}_p = 0.95;
            deltaKA_@{subsec}_@{reg}_p = 1;
        @# endfor
    @# endfor
@# endfor

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Start','Range','A:C');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

TempValues = readtable(sWorkbookNameInput, 'Sheet', 'Structural Parameters','Range','A:C');
[lParams,iaMparams] = ismember(cellstr(M_.param_names), TempValues.Parameter);
M_.params(lParams) = TempValues.Value(iaMparams(iaMparams>0));

