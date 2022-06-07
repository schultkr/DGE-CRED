% ===============================
% === Declare Model Equations ===
% ===============================

predetermined_variables B;

model;
// Expectations
# tauCEXP =  omegaP_p * tauC(+1) + (1 - omegaP_p) * tauC;
# tauKHEXP = omegaP_p * tauKH(+1) + (1 - omegaP_p) * tauKH;
# CEXP = omegaP_p * C(+1) + (1 - omegaP_p) * C;
# PoPEXP = omegaP_p * PoP(+1) + (1 - omegaP_p) * PoP;
# PEXP = omegaP_p * P(+1) + (1 - omegaP_p) * P;
# BEXP = omegaP_p * B(+1) + (1 - omegaP_p) * B;
# rfEXP = omegaP_p * rf(+1) + (1 - omegaP_p) * rf;
# YEXP = omegaP_p * Y(+1) + (1 - omegaP_p) * Y;
# NXEXP = omegaP_p * NX(+1) + (1 - omegaP_p) * NX;
# lambdaEXP = omegaP_p * lambda(+1) + (1 - omegaP_p) * lambda;
# omegaHEXP = omegaP_p * omegaH(+1) + (1 - omegaP_p) * omegaH;
@# for sec in 1:Sectors
    @# for reg in 1:Regions
            # r_@{sec}_@{reg}EXP = omegaP_p * r_@{sec}_@{reg}(+1) + (1 - omegaP_p) * r_@{sec}_@{reg};
            # omegaI_@{sec}_@{reg}EXP = omegaP_p * omegaI_@{sec}_@{reg}(+1) + (1 - omegaP_p) * omegaI_@{sec}_@{reg};
            # I_@{sec}_@{reg}EXP = omegaP_p * I_@{sec}_@{reg}(+1) + (1 - omegaP_p) * I_@{sec}_@{reg};
            # P_@{sec}_@{reg}EXP = omegaP_p * P_@{sec}_@{reg}(+1) + (1 - omegaP_p) * P_@{sec}_@{reg};
    @# endfor
@# endfor
# GAexpend = G_A_DH * ((iGAH_p == 0)*1
                @# for sec in 1:Sectors
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        + (iGAH_p == @{subsec}) * P_D_@{subsec}
                    @# endfor
                @# endfor
                ) + 
                @# for sec in 1:Sectors
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        @# for reg in 1:Regions
                            + G_A_@{subsec}_@{reg} * ((iGA_@{subsec}_p == 0) * 1
                            @# for secm in 1:Sectors
                                @# for subsecm in Subsecstart[secm]:Subsecend[secm]
                                    + (iGA_@{subsec}_p == @{subsecm}) * P_D_@{subsecm}
                                @# endfor
                            @# endfor
                            )
                        @# endfor
                    @# endfor
                @# endfor
;

# GAPexpend = G_AP_DH * ((iGAPH_p == 0)*1
                @# for sec in 1:Sectors
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        + (iGAPH_p == @{subsec}) * P_D_@{subsec}
                    @# endfor
                @# endfor
                ) + 
                @# for sec in 1:Sectors
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        @# for reg in 1:Regions
                            + G_AP_@{subsec}_@{reg} * ((iGAP_@{subsec}_p == 0) * 1
                            @# for secm in 1:Sectors
                                @# for subsecm in Subsecstart[secm]:Subsecend[secm]
                                    + (iGAP_@{subsec}_p == @{subsecm}) * P_D_@{subsecm}
                                @# endfor
                            @# endfor
                            )
                        @# endfor
                    @# endfor
                @# endfor
;

@# for sec in 1:Sectors   
    [name = 'domestic aggregate sector output']
    P_A_@{sec} * Q_A_@{sec} = 
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + P_D_@{subsec} * Q_D_@{subsec}
    @# endfor
    ;

    [name = 'domestic demand for aggregate sector output']
    P_A_@{sec} / P_D = omegaQA_@{sec}_p^(1/etaQ_p) * (Q_A_@{sec}/Q_D)^(-1/etaQ_p);


    @# for reg in 1:Regions
        [name = 'HH FOC capital',mcp = 'K_@{sec}_@{reg}>0']
        lambdaEXP * beta_p * r_@{sec}_@{reg}EXP * PEXP * (1 - tauKHEXP) + lambdaEXP * omegaI_@{sec}_@{reg}EXP * beta_p * (1 - delta_p) = omegaI_@{sec}_@{reg} * lambda;

        [name = 'HH FOC investment',mcp = 'I_@{sec}_@{reg} > 0']
        lambda * P = lambda * omegaI_@{sec}_@{reg} * (1 -  (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)*PoP(-1)/PoP -1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * PoP(-1)/PoP-1)) - 2) - I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * PoP(-1)/PoP * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)*PoP(-1)/PoP-1)))) + beta_p * (CEXP/PoPEXP)^(-sigmaC_p)/(PEXP * (1 + tauCEXP)) * omegaI_@{sec}_@{reg}EXP * I_@{sec}_@{reg}EXP^2/(I_@{sec}_@{reg})^2 * (PoP/PoPEXP)^2 * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}EXP/I_@{sec}_@{reg} * PoP/PoPEXP-1)) 
                 - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}EXP/I_@{sec}_@{reg}*PoP/PoPEXP-1)));

        [name = 'LOM capital',mcp = 'I_@{sec}_@{reg} > 0']
        KH_@{sec}_@{reg} / PoP = (1 - delta_p) * KH_@{sec}_@{reg}(-1) / PoP(-1) + I_@{sec}_@{reg} / PoP * (1 -  (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * PoP(-1) / PoP -1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * PoP(-1) / PoP -1)) - 2)) - (
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        + D_K_@{subsec}_@{reg} / PoP
                    @# endfor
                    );

        [name = 'households aggregate capital',mcp = 'I_@{sec}_@{reg} > 0']
        P * KH_@{sec}_@{reg}(-1) = 
                                @# for subsec in Subsecstart[sec]:Subsecend[sec]
                                    + P_@{subsec}_@{reg} * K_@{subsec}_@{reg}
                                @# endfor
                                ;
        @# for subsec in Subsecstart[sec]:Subsecend[sec]
            [name = 'subsector specific corporate tax rate paid by firms']
            tauKF_@{subsec}_@{reg} = tauKF_@{subsec}_@{reg}_p + exo_tauKF_@{subsec}_@{reg};

            [name = 'subsector specific labour tax rate paid by firms']
            tauNF_@{subsec}_@{reg} = tauNF_@{subsec}_@{reg}_p + exo_tauNF_@{subsec}_@{reg};
            @# if YEndogenous == 1
                [name = 'subsector specific TFP']
                A_@{subsec}_@{reg} = A_@{subsec}_@{reg}_p * KG^phiG_p * exp(exo_@{subsec}_@{reg});
            @# else
                [name = 'subsector specific TFP']
                Y_@{subsec}_@{reg} * P_@{subsec}_@{reg} / P = phiY0_@{subsec}_@{reg}_p * Y0_p /P0_p * exp(exo_@{subsec}_@{reg});
            @# endif


            [name = 'subsector and capital specific productivity shock']
            A_K_@{subsec}_@{reg} = exp(exo_K_@{subsec}_@{reg});

            @# if YEndogenous == 1
                [name = 'subsector and labour specific productivity shock']
                A_N_@{subsec}_@{reg} = exp(exo_N_@{subsec}_@{reg});

            @# else
                [name = 'subsector and labour specific productivity shock']
                N_@{subsec}_@{reg} = phiN0_@{subsec}_@{reg}_p * N0_p * exp(exo_N_@{subsec}_@{reg});

            @# endif


            [name = 'subsector specific damage function']
            D_@{subsec}_@{reg} = exo_D_@{subsec}_@{reg};

            [name = 'subsector specific damage function on labour productivity']
            D_N_@{subsec}_@{reg} = exo_D_N_@{subsec}_@{reg};

            [name = 'subsector specific damage function on capital formation']
            D_K_@{subsec}_@{reg} = exo_D_K_@{subsec}_@{reg} * Y0_p;
            
			[name = 'subsector specific adaptation expenditures by households against climate change']
            K_AP_@{subsec}_@{reg} = exo_GAP_@{subsec}_@{reg} * Y0_p /(P * ((iGAP_@{subsec}_p == 0) * 1                        
                        @# for secm in 1:Sectors                         
                            @# for subsecm in Subsecstart[secm]:Subsecend[secm]
                                    + (iGAP_@{subsec}_p == @{subsecm}) * P_D_@{subsecm}_p
                            @# endfor
                        @# endfor
                        ));

            [name = 'subsector specific private adaptation capital against climate change']
            K_AP_@{subsec}_@{reg} = (1 - deltaKA_@{subsec}_@{reg}_p) * K_AP_@{subsec}_@{reg}(-1) + G_AP_@{subsec}_@{reg};

            [name = 'subsector specific adaptation expenditures by the government against climate change']
            K_A_@{subsec}_@{reg} = exo_GA_@{subsec}_@{reg} * Y0_p /(P * ((iGA_@{subsec}_p == 0) * 1                        
                        @# for secm in 1:Sectors                         
                            @# for subsecm in Subsecstart[secm]:Subsecend[secm]
                                    + (iGA_@{subsec}_p == @{subsecm}) * P_D_@{subsecm}_p
                            @# endfor
                        @# endfor
                        ));

            [name = 'subsector specific adaptation capital against climate change']
            K_A_@{subsec}_@{reg} = (1 - deltaKA_@{subsec}_@{reg}_p) * K_A_@{subsec}_@{reg}(-1) + G_A_@{subsec}_@{reg};

			[name = 'subsector specific adaptation expenditures by the government against climate change']
            K_A_@{subsec}_@{reg} = exo_GA_@{subsec}_@{reg} * Y0_p /(P0_p * ((iGA_@{subsec}_p == 0) * 1                        
            @# for secm in 1:Sectors                         
                @# for subsecm in Subsecstart[secm]:Subsecend[secm]
                        + (iGA_@{subsec}_p == @{subsecm}) * P_D_@{subsecm}_p
                @# endfor
            @# endfor
            ));

            [name = 'subsector specific adaptation capital against climate change']
            K_A_@{subsec}_@{reg} = (1 - deltaKA_@{subsec}_@{reg}_p) * K_A_@{subsec}_@{reg}(-1) + G_A_@{subsec}_@{reg};

            [name = 'demand for regional subsector output']
            P_D_@{subsec}_@{reg}  = omegaQ_@{subsec}_@{reg}_p^(1/etaQ_@{subsec}_p) * ((Q_@{subsec}_@{reg})/Q_@{subsec})^(-1/etaQ_@{subsec}_p) * P_D_@{subsec};

            [name = 'demand for regional subsector value added']
            P_@{subsec}_@{reg}  = (1 - omegaQI_@{subsec}_@{reg}_p)^(1/etaI_@{subsec}_p) * ((Y_@{subsec}_@{reg})/Q_@{subsec}_@{reg})^(-1/etaI_@{subsec}_p) * P_D_@{subsec}_@{reg};

            [name = 'regional subsector demand for intermediates']
            P  = omegaQI_@{subsec}_@{reg}_p^(1/etaI_@{subsec}_p) * ((Q_I_@{subsec}_@{reg})/Q_@{subsec}_@{reg})^(-1/etaI_@{subsec}_p) * P_D_@{subsec}_@{reg};
            
            [name = 'subsector specific output']
            Y_@{subsec}_@{reg} = (etaNK_@{subsec}_@{reg}_p == 1) * (1 - D_@{subsec}_@{reg}) * A_@{subsec}_@{reg} * (A_K_@{subsec}_@{reg} * K_@{subsec}_@{reg})^alphaK_@{subsec}_@{reg}_p * (PoP * (1 - D_N_@{subsec}_@{reg}) * A_N_@{subsec}_@{reg} * N_@{subsec}_@{reg})^alphaN_@{subsec}_@{reg}_p
            + (etaNK_@{subsec}_@{reg}_p != 1) * (1 - D_@{subsec}_@{reg}) * A_@{subsec}_@{reg} * (alphaK_@{subsec}_@{reg}_p^(1/etaNK_@{subsec}_@{reg}_p) * (A_K_@{subsec}_@{reg} * K_@{subsec}_@{reg})^((etaNK_@{subsec}_@{reg}_p-1)/etaNK_@{subsec}_@{reg}_p) + alphaN_@{subsec}_@{reg}_p^(1/etaNK_@{subsec}_@{reg}_p) * (PoP * (1 - D_N_@{subsec}_@{reg}) * A_N_@{subsec}_@{reg} * N_@{subsec}_@{reg})^((etaNK_@{subsec}_@{reg}_p-1)/etaNK_@{subsec}_@{reg}_p))^(etaNK_@{subsec}_@{reg}_p/(etaNK_@{subsec}_@{reg}_p - 1 + (etaNK_@{subsec}_@{reg}_p == 1) * 1000));

            [name = 'Firms FOC capital',mcp = 'K_@{subsec}_@{reg} > 0']
            r_@{sec}_@{reg} * (1 + tauKF_@{subsec}_@{reg}) = alphaK_@{subsec}_@{reg}_p^(1/etaNK_@{subsec}_@{reg}_p) * ((1 - D_@{subsec}_@{reg}) * A_@{subsec}_@{reg} * A_K_@{subsec}_@{reg})^((etaNK_@{subsec}_@{reg}_p-1)/(etaNK_@{subsec}_@{reg}_p)) * (K_@{subsec}_@{reg} / Y_@{subsec}_@{reg})^(-1/etaNK_@{subsec}_@{reg}_p);
            
            [name = 'Firms FOC labour',mcp = 'N_@{subsec}_@{reg} > 0']
            W_@{subsec}_@{reg} * (1 + tauNF_@{subsec}_@{reg})/P_@{subsec}_@{reg} - alphaN_@{subsec}_@{reg}_p^(1/etaNK_@{subsec}_@{reg}_p) * ((1 - D_N_@{subsec}_@{reg}) * A_N_@{subsec}_@{reg} * (1 - D_@{subsec}_@{reg}) * A_@{subsec}_@{reg})^((etaNK_@{subsec}_@{reg}_p-1)/(etaNK_@{subsec}_@{reg}_p)) * ((PoP * N_@{subsec}_@{reg}) / Y_@{subsec}_@{reg})^(-1/etaNK_@{subsec}_@{reg}_p);

            [name = 'HH FOC labour',mcp = 'N_@{sec}_@{reg}>0']
            (1 - tauNH) * W_@{subsec}_@{reg} * lambda = phiL_@{subsec}_@{reg}_p * A_N_@{subsec}_@{reg} * (N_@{subsec}_@{reg})^(sigmaL_p);

            [name = 'subsector region specific output']
            Q_@{subsec}_@{reg} = (omegaQI_@{subsec}_@{reg}_p^(1/etaI_@{subsec}_p) * Q_I_@{subsec}_@{reg}^((etaI_@{subsec}_p-1)/etaI_@{subsec}_p) + (1 - omegaQI_@{subsec}_@{reg}_p)^(1/etaI_@{subsec}_p) * Y_@{subsec}_@{reg}^((etaI_@{subsec}_p-1)/etaI_@{subsec}_p))^(etaI_@{subsec}_p/(etaI_@{subsec}_p-1));
        @# endfor
    @# endfor

    
    [name = 'aggregate sectoral investment']
    I_@{sec} = 
            @# for reg in 1:Regions
                + I_@{sec}_@{reg}
            @# endfor
            ;


    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        @# if subsec > 1
            [name = 'subsectoral price for imports']
            P_M_@{subsec} / P_M = P_M_@{subsec}_p / P0_M_p + exo_M_@{subsec};
        @# endif

        [name = 'demand for subsector imports']
        P_M_@{subsec} / P_M  = omegaM_@{subsec}_p^(1/etaM_p) * (M_@{subsec}/M)^(-1/etaM_p);

        [name = 'use of domestic subsector produced products']
        Q_@{subsec} = Q_D_@{subsec} + X_@{subsec} + (iGAH_p == @{subsec}) * G_A_DH * P + (iGAPH_p == @{subsec}) * G_AP_DH * P
                        @# for secm in 1:Sectors                         
                            @# for subsecm in Subsecstart[secm]:Subsecend[secm]
                                @# for reg in 1:Regions                        
                                    + (iGA_@{subsecm}_p == @{subsec}) * G_A_@{subsecm}_@{reg} * P
                                    + (iGAP_@{subsecm}_p == @{subsec}) * G_AP_@{subsecm}_@{reg} * P
                                @# endfor
                            @# endfor
                        @# endfor
                       ;

        [name = 'domestic subsector produced products']
        P_D_@{subsec} * Q_@{subsec} = 
                @# for reg in 1:Regions
                    + P_D_@{subsec}_@{reg} * Q_@{subsec}_@{reg}
                @# endfor
        ;

        [name = 'intermediate products demanded from subsector']
        P * Q_I_@{subsec} = 
                @# for reg in 1:Regions
                    + P * Q_I_@{subsec}_@{reg}
                @# endfor
        ;

        [name = 'domestic demand for subsector output']
        P_D_@{subsec} / P_A_@{sec} = omegaQ_@{subsec}_p^(1/etaQA_@{sec}_p) * (Q_D_@{subsec}/Q_A_@{sec})^(-1/etaQA_@{sec}_p);

        [name = 'subsector aggregate specific value added']
        Y_@{subsec} = 
                @# for reg in 1:Regions
                    + P_@{subsec}_@{reg} * Y_@{subsec}_@{reg}
                @# endfor
        ;

        [name = 'aggergate subsector labour']
        N_@{subsec} = 
                @# for reg in 1:Regions
                    + N_@{subsec}_@{reg}
                @# endfor
                ;

        [name = 'aggergate subsector labour income']
        W_@{subsec} * N_@{subsec} = 
                @# for reg in 1:Regions
                    + W_@{subsec}_@{reg} * N_@{subsec}_@{reg}
                @# endfor
                ;


        [name = 'aggregate subsector capital']
        P * K_@{subsec} = 
                        @# for reg in 1:Regions
                            + P_@{subsec}_@{reg} * K_@{subsec}_@{reg}
                        @# endfor
                        ;

        [name = 'domestic subsector exports']
        X_@{subsec} = (D_X_@{subsec}_p +  exo_X_@{subsec}) * (P_D_@{subsec}/P_M_@{subsec})^(-etaX_p);

        [name = 'demand for domestic subsector exports']
        D_X_@{subsec} = X_@{subsec} / Q_@{subsec};
    @# endfor
@# endfor

@# for reg in 1:Regions
    @# for z in ClimateVarsRegional
        [name = '@{z}']
        @{z}_@{reg} = @{z}0_@{reg}_p + exo_@{z}_@{reg};
    @# endfor
@# endfor

@# for z in ClimateVarsNational
    [name = '@{z}']
    @{z} = @{z}0_p + exo_@{z};
@# endfor

[name = 'aggregate output']
P_D * Q = 
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + P_D_@{subsec} * Q_@{subsec}
    @# endfor
@# endfor
;

[name = 'domestic output used domestically']
P_D * Q_D = 
@# for sec in 1:Sectors
    + P_A_@{sec} * Q_A_@{sec}
@# endfor
;

[name = 'output used domestically']
P * Q_U = P_D * Q_D + P_M * M;

[name = 'aggregate gross value added']
P * Y = 
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        @# for subsec in Subsecstart[sec]:Subsecend[sec]
            + P_@{subsec}_@{reg} * Y_@{subsec}_@{reg}
        @# endfor
    @# endfor
@# endfor
;

[name = 'aggregate intermediate input']
P * Q_I = 
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + P * Q_I_@{subsec}
    @# endfor
@# endfor
;

[name = 'aggregate investment']
P * I = 
@# for sec in 1:Sectors
    + P * I_@{sec} 
@# endfor
;

[name = 'Exports']
P_D * X = 
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + P_D_@{subsec} * X_@{subsec}
    @# endfor
@# endfor
;

[name = 'Imports']
P_M * M = 
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + P_M_@{subsec} * M_@{subsec}
    @# endfor
@# endfor
;

[name = 'aggregate capital']
P * K = 
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + P * K_@{subsec}
    @# endfor
@# endfor
;

[name = 'aggregate labour']
N = 
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        + N_@{subsec}
    @# endfor
@# endfor
;

[name = 'demand for imports']
P_M / P = omegaF_p^(1/etaF_p) * (M/Q_U)^(-1/etaF_p);


[name = 'demand for domestic produced products']
P_D / P = (1 - omegaF_p)^(1/etaF_p) * (Q_D/Q_U)^(-1/etaF_p);

[name = 'Resource Constraint']
P_D / P * Q = C + PH/P * IH + I + G + NX + Q_I
+ GAexpend + GAPexpend;

[name = 'taxes on household labour income']
tauNH = tauNH_p + exo_tauNH;

[name = 'taxes on household capital income']
tauKH = tauKH_p + exo_tauKH;

[name = 'taxes on consumption']
tauC = tauC_p + exo_tauC;

[name = 'taxes on housing']
tauH = tauH_p + exo_tauH;

[name = 'national price level']
P = P0_p * exp(exo_P);

@# if YEndogenous == 0
    [name = 'net exports to GDP ratio']
    NX/Y = NX0_p + exo_NX;
@# else
    [name = 'import price']
    P_M = P0_M_p + exo_M;
@# endif

[name = 'net exports']
P * NX = P_D * X - P_M * M;

[name = 'world interest rate']

rf = rf0_p + exo_rf;

[name = 'FOC HH consumption']
lambda * P * (1 + tauC) = (1-gamma_p) * (C/PoP)^(-gamma_p) * (H/PoP)^gamma_p * ((C/PoP)^(1-gamma_p) * (H/PoP)^gamma_p)^(-sigmaC_p);

[name = 'law of motion for houses']
(H/PoP) = (1 - deltaH_p) * (H(-1)/PoP(-1)) + (IH/PoP) - DH/PoP;

@# if YEndogenous == 0
    [name = 'exogenous development of housing area']
    H/PoP = H0_p + exo_H;
@# else
    [name = 'exogenous development of housing prices']
    PH = PH0_p * exp(exo_H);
@# endif

[name = 'damages to houses']
DH = exo_DH  * Y * P / PH;

[name = 'FOC HH houses']
lambda*omegaH = beta_p*(lambdaEXP*omegaHEXP*(1 - deltaH_p) + ((CEXP/PoPEXP)^(1 - gamma_p)*(H/PoPEXP)^(gamma_p - 1)*gamma_p)*((CEXP/PoPEXP)^(1 - gamma_p)*(H/PoPEXP)^gamma_p)^(-sigmaC_p));

[name = 'FOC HH investment in houses']
lambda * omegaH = PH * (1 + tauH) * lambda;

[name = 'Foreign Assets']
lambdaEXP * beta_p * (1 + rfEXP) * exp(-phiB_p*((rfEXP*(BEXP+BG)/YEXP+NXEXP/YEXP))) = lambda;

[name = 'adaptation measures for housing stock']
G_A_DH = exo_G_A_DH * Y0_p / (P0_p * ((iGAH_p == 0)*1
                @# for sec in 1:Sectors
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        + (iGAH_p == @{subsec}) * P_D_@{subsec}_p
                    @# endfor
                @# endfor
                ));
				
[name = 'private adaptation measures for housing stock']
G_AP_DH = exo_G_AP_DH * Y0_p / (P * ((iGAPH_p == 0)*1
                @# for sec in 1:Sectors
                    @# for subsec in Subsecstart[sec]:Subsecend[sec]
                        + (iGAPH_p == @{subsec}) * P_D_@{subsec}_p
                    @# endfor
                @# endfor
                ));
[name = 'Government Budget Constraint']
G + BG + GAexpend
= (1 + rf) * BG(-1) * exp(-phiB_p*((rf*(B+BG(-1))/Y+NX/Y))) + tauC * C +  tauH * PH / P * IH
@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        @# for reg in 1:Regions
            + (tauNH + tauNF_@{subsec}_@{reg}) * W_@{subsec}_@{reg} * N_@{subsec}_@{reg} * PoP /P
            + (tauKH + tauKF_@{subsec}_@{reg}) * P_@{subsec}_@{reg} /P * r_@{sec}_@{reg} * K_@{subsec}_@{reg} 
        @# endfor
    @# endfor
@# endfor
;

[name = 'public goods capital stock']
KG = (1 - deltaKG_p) * KG(-1) + G;

[name = 'Government foreign debt']
BG = exo_BG;

[name = 'Population']
PoP = PoP0_p * exp(exo_PoP);

end;
