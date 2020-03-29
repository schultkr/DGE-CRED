% ===============================
% === Declare Model Equations ===
% ===============================
model(bytecode);
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        [name = 'sector specific TFP growth rate']
        gA_@{sec}_@{reg} = A_@{sec}_@{reg} / A_@{sec}_@{reg}(-1);
        
        [name = 'sector specific TFP']
        A_@{sec}_@{reg} = rhoA_@{sec}_@{reg}_p * A_@{sec}_@{reg}(-1) + (1 - rhoA_@{sec}_@{reg}_p) * (A_@{sec}_@{reg}_p * exp(exo_@{sec}_@{reg}));

        [name = 'sector and capital specific productivity shock']
        A_K_@{sec}_@{reg} = rhoA_K_@{sec}_@{reg}_p * A_K_@{sec}_@{reg}(-1) + (1 - rhoA_K_@{sec}_@{reg}_p) * (A_K_@{sec}_@{reg}_p * exp(exo_K_@{sec}_@{reg}));

        [name = 'sector and labour specific productivity shock']
        A_N_@{sec}_@{reg} = rhoA_N_@{sec}_@{reg}_p * A_N_@{sec}_@{reg}(-1) + (1 - rhoA_N_@{sec}_@{reg}_p) * (A_N_@{sec}_@{reg}_p * exp(exo_N_@{sec}_@{reg}));

        [name = 'sector specific damage function']
        D_@{sec}_@{reg} = min(1,a_T_1_@{sec}_@{reg}_p * T_@{reg} + a_T_2_@{sec}_@{reg}_p * T_@{reg}^(a_T_3_@{sec}_@{reg}_p) + 
                          a_SL_1_@{sec}_@{reg}_p * SL + a_SL_2_@{sec}_@{reg}_p * SL^(a_SL_3_@{sec}_@{reg}_p) +
                          a_W_1_@{sec}_@{reg}_p * WS_@{reg} + a_W_2_@{sec}_@{reg}_p * WS_@{reg}^(a_W_3_@{sec}_@{reg}_p) + 
                          a_P_1_@{sec}_@{reg}_p * PERC_@{reg} + a_P_2_@{sec}_@{reg}_p * PERC_@{reg}^(a_P_3_@{sec}_@{reg}_p)) * exp(-phiGA_@{sec}_@{reg}_p*G_A_@{sec}_@{reg});

        [name = 'sector specific adaptation expenditures by the government']
        G_A_@{sec}_@{reg} = exo_GA_@{sec}_@{reg};

        [name = 'demand for regional sector output',mcp = 'Y_@{sec}_@{reg} > 0']
        P_@{sec}_@{reg}  = omega_@{sec}_@{reg}_p^(1/etaC_@{sec}_p) * ((Y_@{sec}_@{reg})/Y_@{sec})^(-1/etaC_@{sec}_p) * P_@{sec};

        [name = 'sector specific output']
        Y_@{sec}_@{reg} = (1 - D_@{sec}_@{reg}) * A_@{sec}_@{reg} * (alphaK_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * (A_K_@{sec}_@{reg} * K_@{sec}_@{reg}(-1))^((etaNK_@{sec}_@{reg}_p-1)/etaNK_@{sec}_@{reg}_p) + alphaN_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * (PoP * A_N_@{sec}_@{reg} * N_@{sec}_@{reg})^((etaNK_@{sec}_@{reg}_p-1)/etaNK_@{sec}_@{reg}_p))^(etaNK_@{sec}_@{reg}_p/(etaNK_@{sec}_@{reg}_p - 1));

        [name = 'Firms FOC capital',mcp = 'K_@{sec}_@{reg} > 0']
        r_@{sec}_@{reg} = alphaK_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * A_K_@{sec}_@{reg}^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * (K_@{sec}_@{reg}(-1) / Y_@{sec}_@{reg})^(-1/etaNK_@{sec}_@{reg}_p);

        [name = 'Firms FOC labour',mcp = 'N_@{sec}_@{reg} > 0']
        W_@{sec}_@{reg}/P_@{sec}_@{reg} = alphaN_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * ((PoP * A_N_@{sec}_@{reg} * N_@{sec}_@{reg}) / Y_@{sec}_@{reg})^(-1/etaNK_@{sec}_@{reg}_p);

        [name = 'HH FOC labour',mcp = 'N_@{sec}_@{reg}>0']
        (1 - tauN_p) * W_@{sec}_@{reg} * (P * C/PoP)^(-sigmaC_p) / (1 + tauC_p) = phiL_@{sec}_@{reg}_p * (N_@{sec}_@{reg})^(sigmaL_p);

        [name = 'HH FOC capital',mcp = 'K_@{sec}_@{reg}>0']
        (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1) * (1 + tauC_p)) * beta_p * r_@{sec}_@{reg}(+1) * P_@{sec}_@{reg}(+1) * (1 - tauK_p) + (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC_p)) * omegaI_@{sec}_@{reg}(+1) * beta_p * (1 - delta_p) = omegaI_@{sec}_@{reg} * (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p));

        [name = 'HH FOC investment',mcp = 'I_@{sec}_@{reg} > 0']
        
        (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p))*P_@{sec}_@{reg} = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p)) * omegaI_@{sec}_@{reg} * (1 -  (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - 2) - I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)))) + beta_p * (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC_p)) * omegaI_@{sec}_@{reg}(+1) * I_@{sec}_@{reg}(+1)^2/(I_@{sec}_@{reg})^2 * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}(+1)/I_@{sec}_@{reg}-1)) 
                 - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}(+1)/I_@{sec}_@{reg}-1)));
        //(C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p))*P_@{sec}_@{reg} = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p)) * omegaI_@{sec}_@{reg} * (1 -  phiK_p/2 * (I_@{sec}_@{reg}/K_@{sec}_@{reg}(-1) - delta_p)^2 - I_@{sec}_@{reg} * phiK_p * (I_@{sec}_@{reg}/K_@{sec}_@{reg}(-1) - delta_p));


        [name = 'LOM capital',mcp = 'I_@{sec}_@{reg} > 0']
        K_@{sec}_@{reg} = (1 - delta_p) * K_@{sec}_@{reg}(-1) + I_@{sec}_@{reg} * (1 -  (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - 2));
        //K_@{sec}_@{reg} = (1 - delta_p) * K_@{sec}_@{reg}(-1) + I_@{sec}_@{reg} * (1 -  phiK_p/2 * (I_@{sec}_@{reg}/K_@{sec}_@{reg}(-1) - delta_p)^2);
    @# endfor
    
    [name = 'demand for sector output']
    P_@{sec} / P = omega_@{sec}_p^(1/etaC_p) * (Y_@{sec}/Y)^(-1/etaC_p);

    [name = 'sector aggregate specific output']
    Y_@{sec} = (
            @# for reg in 1:Regions
                + omega_@{sec}_@{reg}_p^(1/etaC_@{sec}_p) * ((Y_@{sec}_@{reg}))^((etaC_@{sec}_p - 1) / etaC_@{sec}_p)
            @# endfor
                )^(etaC_@{sec}_p / (etaC_@{sec}_p - 1));



    [name = 'aggergate sector labour']
    N_@{sec} = 
            @# for reg in 1:Regions
                + N_@{sec}_@{reg}
            @# endfor
            ;

    [name = 'aggergate sector labour']
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
    PERC_@{reg} = PERC0_@{reg}_p + exo_PERC_@{reg};
@# endfor
[name = 'Sea level']
SL = SL0_p + exo_SL;

[name = 'national price level']
P = P0_p * exp(exo_P);

[name = 'Population']
PoP = rhoPoP_p * PoP(-1) + (1 - rhoPoP_p) * PoP0_p * exp(exo_PoP);

[name = 'aggregate gross value added']
P * Y = 
    @# for sec in 1:Sectors
            + P_@{sec} * Y_@{sec}
    @# endfor
    ;

[name = 'Resource Constraint']
Y = C + I + G - NX;

[name = 'Net Exports']
NX = (B - (1 + rf) * Sf * B(-1));

[name = 'LOM Net Exports']
NX = rhoNX_p * NX(-1) + (1 - rhoNX_p) * exp(exo_NX) * omegaNX_p * Y;

[name = 'World interest rate']
rf = (1/beta_p-1);


[name = 'Foreign Assets']
(C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC_p)) * beta_p * Sf(+1) * exp(-phiB_p*((Sf(+1)*rf(+1)*B/Y(+1)+NX/Y))) * (1 + rf(+1)) = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC_p));

[name = 'Government Budget Constraint']
G + (1 + rf) * Sf * BG (-1)
= BG + tauC_p * C
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        + tauN_p * W_@{sec}_@{reg} * N_@{sec}_@{reg} /P + tauK_p * P_@{sec}_@{reg} /P * r_@{sec}_@{reg} * K_@{sec}_@{reg} 
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
