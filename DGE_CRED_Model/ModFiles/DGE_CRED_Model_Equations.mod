% ===============================
% === Declare Model Equations ===
% ===============================
model(bytecode);
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        [name = 'sector specific TFP growth rate']
        gA_@{sec}_@{reg} = A_@{sec}_@{reg} / A_@{sec}_@{reg}(-1);
        
        [name = 'sector specific corporate tax rate paid by firms']
        tauK_@{sec}_@{reg} = tauK_@{sec}_@{reg}_p + exo_tauK_@{sec}_@{reg};
        
        [name = 'sector specific labour tax rate paid by firms']
        tauN_@{sec}_@{reg} = tauN_@{sec}_@{reg}_p + exo_tauN_@{sec}_@{reg};

        [name = 'sector specific TFP']
        A_@{sec}_@{reg} = rhoA_@{sec}_@{reg}_p * A_@{sec}_@{reg}(-1) + (1 - rhoA_@{sec}_@{reg}_p) * (A_@{sec}_@{reg}_p * exp(exo_@{sec}_@{reg}));

        [name = 'sector and capital specific productivity shock']
        A_K_@{sec}_@{reg} = rhoA_K_@{sec}_@{reg}_p * A_K_@{sec}_@{reg}(-1) + (1 - rhoA_K_@{sec}_@{reg}_p) * (A_K_@{sec}_@{reg}_p * exp(exo_K_@{sec}_@{reg}));

        [name = 'sector and labour specific productivity shock']
        A_N_@{sec}_@{reg} = rhoA_N_@{sec}_@{reg}_p * A_N_@{sec}_@{reg}(-1) + (1 - rhoA_N_@{sec}_@{reg}_p) * (A_N_@{sec}_@{reg}_p * exp(exo_N_@{sec}_@{reg}));

        [name = 'sector specific damage function']
        D_@{sec}_@{reg} = min(0.7,
                          (a_T_1_@{sec}_@{reg}_p * T_@{reg} + a_T_2_@{sec}_@{reg}_p * T_@{reg}^(a_T_3_@{sec}_@{reg}_p)) * exp(-phiGAT_@{sec}_@{reg}_p*K_A_T_@{sec}_@{reg}(-1)) + 
                          (a_SL_1_@{sec}_@{reg}_p * SL + a_SL_2_@{sec}_@{reg}_p * SL^(a_SL_3_@{sec}_@{reg}_p)) * (SL > (K_A_SL_@{sec}_@{reg}(-1) / phiGASL_@{sec}_@{reg}_p)) + 
                          (a_W_1_@{sec}_@{reg}_p * WS_@{reg} + a_W_2_@{sec}_@{reg}_p * WS_@{reg}^(a_W_3_@{sec}_@{reg}_p)) * exp(-phiGAWS_@{sec}_@{reg}_p*K_A_WS_@{sec}_@{reg}(-1)) + 
                          (a_P_1_@{sec}_@{reg}_p * PREC_@{reg} + a_P_2_@{sec}_@{reg}_p * PREC_@{reg}^(a_P_3_@{sec}_@{reg}_p)) * exp(-phiGAPREC_@{sec}_@{reg}_p*K_A_PREC_@{sec}_@{reg}(-1)) +
                          (a_DR_1_@{sec}_@{reg}_p * DRO_@{reg} + a_DR_2_@{sec}_@{reg}_p * DRO_@{reg}^(a_DR_3_@{sec}_@{reg}_p)) * exp(-phiGADRO_@{sec}_@{reg}_p*K_A_DRO_@{sec}_@{reg}(-1)) +
                          (a_CY_1_@{sec}_@{reg}_p * CYC_@{reg} + a_CY_2_@{sec}_@{reg}_p * CYC_@{reg}^(a_CY_3_@{sec}_@{reg}_p)) * exp(-phiGACYC_@{sec}_@{reg}_p*K_A_CYC_@{sec}_@{reg}(-1))
                        );

        [name = 'sector specific damage function on labour productivity']
        D_N_@{sec}_@{reg} = min(1,aN_T_1_@{sec}_@{reg}_p * T_@{reg} + aN_T_2_@{sec}_@{reg}_p * T_@{reg}^(aN_T_3_@{sec}_@{reg}_p) + 
                          aN_SL_1_@{sec}_@{reg}_p * SL + aN_SL_2_@{sec}_@{reg}_p * SL^(aN_SL_3_@{sec}_@{reg}_p) +
                          aN_W_1_@{sec}_@{reg}_p * WS_@{reg} + aN_W_2_@{sec}_@{reg}_p * WS_@{reg}^(aN_W_3_@{sec}_@{reg}_p) + 
                          aN_P_1_@{sec}_@{reg}_p * PREC_@{reg} + aN_P_2_@{sec}_@{reg}_p * PREC_@{reg}^(aN_P_3_@{sec}_@{reg}_p) + 
                          aN_DR_1_@{sec}_@{reg}_p * DRO_@{reg} + aN_DR_2_@{sec}_@{reg}_p * DRO_@{reg}^(aN_DR_3_@{sec}_@{reg}_p) +
                          aN_CY_1_@{sec}_@{reg}_p * CYC_@{reg} + aN_CY_2_@{sec}_@{reg}_p * CYC_@{reg}^(aN_CY_3_@{sec}_@{reg}_p)
                        );

        [name = 'sector specific damage function on labour productivity']
        D_K_@{sec}_@{reg} = min(1,aK_T_1_@{sec}_@{reg}_p * T_@{reg} + aK_T_2_@{sec}_@{reg}_p * T_@{reg}^(aK_T_3_@{sec}_@{reg}_p) + 
                          aK_SL_1_@{sec}_@{reg}_p * SL + aK_SL_2_@{sec}_@{reg}_p * SL^(aK_SL_3_@{sec}_@{reg}_p) +
                          aK_W_1_@{sec}_@{reg}_p * WS_@{reg} + aK_W_2_@{sec}_@{reg}_p * WS_@{reg}^(aK_W_3_@{sec}_@{reg}_p) + 
                          aK_P_1_@{sec}_@{reg}_p * PREC_@{reg} + aK_P_2_@{sec}_@{reg}_p * PREC_@{reg}^(aK_P_3_@{sec}_@{reg}_p) +
                          aK_DR_1_@{sec}_@{reg}_p * DRO_@{reg} + aK_DR_2_@{sec}_@{reg}_p * DRO_@{reg}^(aK_DR_3_@{sec}_@{reg}_p) +
                          aK_CY_1_@{sec}_@{reg}_p * CYC_@{reg} + aK_CY_2_@{sec}_@{reg}_p * CYC_@{reg}^(aK_CY_3_@{sec}_@{reg}_p)
                        );

        @# for z in ["T", "WS", "PREC", "SL", "CYC", "DRO"]
            [name = 'sector specific adaptation expenditures by the government against sea level rise']
            K_A_@{z}_@{sec}_@{reg} = exo_GA_@{z}_@{sec}_@{reg};

            [name = 'sector specific adaptation capital against sea level rise']
            K_A_@{z}_@{sec}_@{reg} = (1 - deltaKA@{z}_@{sec}_@{reg}_p) * K_A_@{z}_@{sec}_@{reg}(-1) + G_A_@{z}_@{sec}_@{reg};
        @# endfor

        [name = 'demand for regional sector output',mcp = 'Y_@{sec}_@{reg} > 0']
        P_@{sec}_@{reg}  = omegaQ_@{sec}_@{reg}_p^(1/etaQ_@{sec}_p) * ((Y_@{sec}_@{reg})/Y_@{sec})^(-1/etaQ_@{sec}_p) * P_@{sec};

        [name = 'sector specific output']
        Y_@{sec}_@{reg} = (1 - D_@{sec}_@{reg}) * A_@{sec}_@{reg} * (alphaK_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * (A_K_@{sec}_@{reg} * K_@{sec}_@{reg}(-1))^((etaNK_@{sec}_@{reg}_p-1)/etaNK_@{sec}_@{reg}_p) + (alphaN_@{sec}_@{reg}_p)^(1/etaNK_@{sec}_@{reg}_p) * ((1 - D_N_@{sec}_@{reg}) * A_N_@{sec}_@{reg} * PoP * N_@{sec}_@{reg})^((etaNK_@{sec}_@{reg}_p-1)/etaNK_@{sec}_@{reg}_p))^(etaNK_@{sec}_@{reg}_p/(etaNK_@{sec}_@{reg}_p - 1));

        [name = 'Firms FOC capital',mcp = 'K_@{sec}_@{reg} > 0']
        r_@{sec}_@{reg} * (1 + tauK_@{sec}_@{reg}) = alphaK_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * ((1 - D_@{sec}_@{reg}) * A_@{sec}_@{reg})^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * A_K_@{sec}_@{reg}^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * (K_@{sec}_@{reg}(-1) / Y_@{sec}_@{reg})^(-1/etaNK_@{sec}_@{reg}_p);

        [name = 'Firms FOC labour',mcp = 'N_@{sec}_@{reg} > 0']
        W_@{sec}_@{reg} * (1 + tauN_@{sec}_@{reg})/P_@{sec}_@{reg} = alphaN_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * ((1 - D_N_@{sec}_@{reg}) * A_N_@{sec}_@{reg} * (1 - D_@{sec}_@{reg}) * A_@{sec}_@{reg})^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * ((PoP * N_@{sec}_@{reg}) / Y_@{sec}_@{reg})^(-1/etaNK_@{sec}_@{reg}_p);

        [name = 'HH FOC labour',mcp = 'N_@{sec}_@{reg}>0']
        (1 - tauN_p) * W_@{sec}_@{reg} * (P * C/PoP)^(-sigmaC_p) / (1 + tauC_p) = A_N_@{sec}_@{reg} * phiL_@{sec}_@{reg}_p * (N_@{sec}_@{reg})^(sigmaL_p);

        [name = 'HH FOC capital',mcp = 'K_@{sec}_@{reg}>0']
        (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1) * (1 + tauC_p)) * beta_p * r_@{sec}_@{reg}(+1) * P_@{sec}_@{reg}(+1) * (1 - tauK_p) + (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC_p)) * omegaI_@{sec}_@{reg}(+1) * beta_p * (1 - delta_p - D_K_@{sec}_@{reg}(+1)) = omegaI_@{sec}_@{reg} * (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p));

        [name = 'HH FOC investment',mcp = 'I_@{sec}_@{reg} > 0']       
        (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p))*P_@{sec}_@{reg} = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p)) * omegaI_@{sec}_@{reg} * (1 -  (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - 2) - I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)))) + beta_p * (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC_p)) * omegaI_@{sec}_@{reg}(+1) * I_@{sec}_@{reg}(+1)^2/(I_@{sec}_@{reg})^2 * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}(+1)/I_@{sec}_@{reg}-1)) 
          - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}(+1)/I_@{sec}_@{reg}-1)));
      
        [name = 'LOM capital',mcp = 'I_@{sec}_@{reg} > 0']
        K_@{sec}_@{reg} = (1 - delta_p - D_K_@{sec}_@{reg}) * K_@{sec}_@{reg}(-1) + I_@{sec}_@{reg} * (1 - (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - 2));

    @# endfor
    
    [name = 'demand for sector output']
    P_@{sec} / P = omegaQ_@{sec}_p^(1/etaQ_p) * (Y_@{sec}/Y)^(-1/etaQ_p);

    [name = 'sector aggregate specific output']
    Y_@{sec} = (
            @# for reg in 1:Regions
                + omegaQ_@{sec}_@{reg}_p^(1/etaQ_@{sec}_p) * ((Y_@{sec}_@{reg}))^((etaQ_@{sec}_p - 1) / etaQ_@{sec}_p)
            @# endfor
                )^(etaQ_@{sec}_p / (etaQ_@{sec}_p - 1));



    [name = 'aggergate sector labour']
    N_@{sec} = 
            @# for reg in 1:Regions
                + N_@{sec}_@{reg}
            @# endfor
            ;

    [name = 'aggergate sector labour income']
    W_@{sec} * N_@{sec} = 
            @# for reg in 1:Regions
                + W_@{sec}_@{reg} * N_@{sec}_@{reg}
            @# endfor
            ;

    [name = 'aggregate sector investment']
    P_@{sec} * I_@{sec} = 
                    @# for reg in 1:Regions
                        + P_@{sec}_@{reg} * I_@{sec}_@{reg}
                    @# endfor
                    ;
    
    [name = 'aggregate capital']
    P_@{sec} * K_@{sec} = 
                        @# for reg in 1:Regions
                            + P_@{sec}_@{reg} * K_@{sec}_@{reg}
                        @# endfor
                        ;

@# endfor

@# for reg in 1:Regions
    [name = 'Temperature']
    T_@{reg} = T0_@{reg}_p + exo_T_@{reg};

    [name = 'Wind speed']
    WS_@{reg} = WS0_@{reg}_p + exo_WS_@{reg};

    [name = 'Percipitation']
    PREC_@{reg} = PREC0_@{reg}_p + exo_PREC_@{reg};

    [name = 'Cyclone']
    CYC_@{reg} = CYC0_@{reg}_p + exo_CYC_@{reg};

    [name = 'Drought']
    DRO_@{reg} = DRO0_@{reg}_p + exo_DRO_@{reg};

@# endfor
[name = 'Sea level']
SL = SL0_p + exo_SL;

[name = 'national price level']
P = P0_p * exp(exo_P);

[name = 'Population']
PoP = PoP0_p + exo_PoP;

[name = 'aggregate gross value added']
P * Y = 
    @# for sec in 1:Sectors
            + P_@{sec} * Y_@{sec}
    @# endfor
    ;

[name = 'Resource Constraint']
Y = C + I + G + NX
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        + G_A_SL_@{sec}_@{reg}  + G_A_PREC_@{sec}_@{reg} + G_A_T_@{sec}_@{reg} + G_A_WS_@{sec}_@{reg} + G_A_CYC_@{sec}_@{reg} + G_A_DRO_@{sec}_@{reg} 
    @# endfor
@# endfor
;

[name = 'Net Exports']
NX = (B - (1 + rf) * exp(-phiB_p*((Sf*rf*B(-1)/Y+NX/Y))) * Sf * B(-1));

[name = 'LOM Net Exports']
NX = rhoNX_p * NX(-1) + (1 - rhoNX_p) * exp(exo_NX) * omegaNX_p * Y * P;

[name = 'World interest rate']
rf = (1/beta_p-1);


[name = 'Foreign Assets']
(C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC_p)) * beta_p * Sf(+1) * exp(-phiB_p*((Sf(+1)*rf(+1)*B/Y(+1)+NX(+1)/Y(+1)))) * (1 + rf(+1)) = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p));

[name = 'Government Budget Constraint']
G + (1 + rf) * Sf * exp(-phiB_p*((Sf*rf*B(-1)/Y+NX/Y))) * BG (-1)
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        + G_A_SL_@{sec}_@{reg}  + G_A_PREC_@{sec}_@{reg} + G_A_T_@{sec}_@{reg} + G_A_WS_@{sec}_@{reg} + G_A_CYC_@{sec}_@{reg} + G_A_DRO_@{sec}_@{reg} 
    @# endfor
@# endfor
= BG + tauC_p * C
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        + (tauN_p + tauN_@{sec}_@{reg}) * W_@{sec}_@{reg} * N_@{sec}_@{reg} * PoP/P + (tauK_p + tauK_@{sec}_@{reg}) * P_@{sec}_@{reg} /P * r_@{sec}_@{reg} * K_@{sec}_@{reg} 
    @# endfor
@# endfor
;
[name = 'Government Budget Constraint']
BG = exo_BG;

[name = 'aggregate investment']
P * I = 
@# for sec in 1:Sectors
 + P_@{sec} * I_@{sec}
@# endfor
;

[name = 'aggregate capital']
P * K = 
@# for sec in 1:Sectors
 + P_@{sec} * K_@{sec}(-1)
@# endfor
;

[name = 'aggregate labour']
N = 
@# for sec in 1:Sectors
    + N_@{sec}
@# endfor
;
end;
