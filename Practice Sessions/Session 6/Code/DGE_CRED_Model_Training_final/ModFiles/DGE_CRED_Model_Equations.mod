% ===============================
% === Declare Model Equations ===
% ===============================
model;
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        [name = 'sector specific TFP growth rate']
        gA_@{sec}_@{reg} = A_@{sec}_@{reg} / A_@{sec}_@{reg}(-1);
        
        [name = 'sector specific corporate tax rate paid by firms']
        tauKF_@{sec}_@{reg} = tauKF_@{sec}_@{reg}_p + exo_tauKF_@{sec}_@{reg};
        
        [name = 'sector specific labour tax rate paid by firms']
        tauNF_@{sec}_@{reg} = tauNF_@{sec}_@{reg}_p + exo_tauNF_@{sec}_@{reg};

        [name = 'sector specific TFP']
        A_@{sec}_@{reg} = rhoA_@{sec}_@{reg}_p * A_@{sec}_@{reg}(-1) + (1 - rhoA_@{sec}_@{reg}_p) * (A_@{sec}_@{reg}_p * KG^phiG_p * exp(exo_@{sec}_@{reg}));

        [name = 'sector and capital specific productivity shock']
        A_K_@{sec}_@{reg} = rhoA_K_@{sec}_@{reg}_p * A_K_@{sec}_@{reg}(-1) + (1 - rhoA_K_@{sec}_@{reg}_p) * (A_K_@{sec}_@{reg}_p * exp(exo_K_@{sec}_@{reg}));

        [name = 'sector and labour specific productivity shock']
        A_N_@{sec}_@{reg} = rhoA_N_@{sec}_@{reg}_p * A_N_@{sec}_@{reg}(-1) + (1 - rhoA_N_@{sec}_@{reg}_p) * (A_N_@{sec}_@{reg}_p * exp(exo_N_@{sec}_@{reg}));

        [name = 'sector specific damage function']
        D_@{sec}_@{reg} = min(0.7,
                          @# for z in ClimateVars
                            @# if z == "SL"
                                + (a_@{z}_1_@{sec}_@{reg}_p * @{z} + a_@{z}_2_@{sec}_@{reg}_p * @{z}^(a_@{z}_3_@{sec}_@{reg}_p)) * (SL > (K_A_SL_@{sec}_@{reg}(-1) / phiGASL_@{sec}_@{reg}_p))
                            @# else
                                + (a_@{z}_1_@{sec}_@{reg}_p * @{z}_@{reg} + a_@{z}_2_@{sec}_@{reg}_p * @{z}_@{reg}^(a_@{z}_3_@{sec}_@{reg}_p)) * exp(-phiGA@{z}_@{sec}_@{reg}_p*K_A_@{z}_@{sec}_@{reg}(-1)) 
                            @# endif
                          @# endfor
                        );

        [name = 'sector specific damage function on labour productivity']
        D_N_@{sec}_@{reg} = min(1,
                          @# for z in ClimateVars
                            @# if z == "SL"
                                + (aN_@{z}_1_@{sec}_@{reg}_p * @{z} + aN_@{z}_2_@{sec}_@{reg}_p * @{z}^(aN_@{z}_3_@{sec}_@{reg}_p)) 
                            @# else
                                + (aN_@{z}_1_@{sec}_@{reg}_p * @{z}_@{reg} + aN_@{z}_2_@{sec}_@{reg}_p * @{z}_@{reg}^(aN_@{z}_3_@{sec}_@{reg}_p)) 
                            @# endif
                          @# endfor
                        );

        [name = 'sector specific damage function on capital formation']
        D_K_@{sec}_@{reg} = min(1,
                          @# for z in ClimateVars
                            @# if z == "SL"
                                + (aK_@{z}_1_@{sec}_@{reg}_p * @{z} + aK_@{z}_2_@{sec}_@{reg}_p * @{z}^(aK_@{z}_3_@{sec}_@{reg}_p)) 
                            @# else
                                + (aK_@{z}_1_@{sec}_@{reg}_p * @{z}_@{reg} + aK_@{z}_2_@{sec}_@{reg}_p * @{z}_@{reg}^(aK_@{z}_3_@{sec}_@{reg}_p)) 
                            @# endif
                          @# endfor
                        );

        @# for z in ClimateVars
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
        r_@{sec}_@{reg} * (1 + tauKF_@{sec}_@{reg}) = alphaK_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * ((1 - D_@{sec}_@{reg}) * A_@{sec}_@{reg})^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * A_K_@{sec}_@{reg}^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * (K_@{sec}_@{reg}(-1) / Y_@{sec}_@{reg})^(-1/etaNK_@{sec}_@{reg}_p);

        [name = 'Firms FOC labour',mcp = 'N_@{sec}_@{reg} > 0']
        W_@{sec}_@{reg} * (1 + tauNF_@{sec}_@{reg})/P_@{sec}_@{reg} = alphaN_@{sec}_@{reg}_p^(1/etaNK_@{sec}_@{reg}_p) * ((1 - D_N_@{sec}_@{reg}) * A_N_@{sec}_@{reg} * (1 - D_@{sec}_@{reg}) * A_@{sec}_@{reg})^((etaNK_@{sec}_@{reg}_p-1)/(etaNK_@{sec}_@{reg}_p)) * ((PoP * N_@{sec}_@{reg}) / Y_@{sec}_@{reg})^(-1/etaNK_@{sec}_@{reg}_p);

        [name = 'HH FOC labour',mcp = 'N_@{sec}_@{reg}>0']
        (1 - tauNH) * W_@{sec}_@{reg} * (C/PoP)^(-sigmaC_p) / (P * (1 + tauC)) = A_N_@{sec}_@{reg} * phiL_@{sec}_@{reg}_p * (N_@{sec}_@{reg})^(sigmaL_p);

        [name = 'HH FOC capital',mcp = 'K_@{sec}_@{reg}>0']
        (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1) * (1 + tauC(+1))) * beta_p * r_@{sec}_@{reg}(+1) * P_@{sec}_@{reg}(+1) * (1 - tauKH) + (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC(+1))) * omegaI_@{sec}_@{reg}(+1) * beta_p * (1 - delta_p - D_K_@{sec}_@{reg}(+1)) = omegaI_@{sec}_@{reg} * (C/PoP)^(-sigmaC_p)/(P*(1 + tauC));

        [name = 'HH FOC investment',mcp = 'I_@{sec}_@{reg} > 0']       
        (C/PoP)^(-sigmaC_p)/(P*(1 + tauC))*P_@{sec}_@{reg} = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC)) * omegaI_@{sec}_@{reg} * (1 -  (exp(sqrt(phiK_p / 2)*(I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) + exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - 2) - I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1) * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)) - exp(-sqrt(phiK_p / 2) * (I_@{sec}_@{reg}/I_@{sec}_@{reg}(-1)-1)))) + beta_p * (C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC(+1))) * omegaI_@{sec}_@{reg}(+1) * I_@{sec}_@{reg}(+1)^2/(I_@{sec}_@{reg})^2 * sqrt(phiK_p / 2) * (exp(sqrt(phiK_p / 2) * (I_@{sec}_@{reg}(+1)/I_@{sec}_@{reg}-1)) 
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

    @# for z in ClimateVars
        @# if  z != "SL"
            [name = '@{z}']
            @{z}_@{reg} = @{z}0_@{reg}_p + exo_@{z}_@{reg};
        @# endif
    @# endfor
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
        @# for z in ClimateVars
            + G_A_@{z}_@{sec}_@{reg}
        @# endfor
    @# endfor
@# endfor
;

[name = 'Net Exports']
NX = (B - (1 + rf) * exp(-phiB_p*((Sf*rf*B(-1)/Y+NX/Y))) * Sf * B(-1));

[name = 'LOM Net Exports']
NX = rhoNX_p * NX(-1) + (1 - rhoNX_p) * omegaNX_p * Y * P0_p + exo_NX;

[name = 'World interest rate']
rf = rf0_p + exo_rf;


[name = 'Foreign Assets']
(C(+1)/PoP(+1))^(-sigmaC_p)/(P(+1)*(1 + tauC(+1))) * beta_p * Sf(+1) * exp(-phiB_p*((Sf(+1)*rf(+1)*B/Y(+1)+NX(+1)/Y(+1)))) * (1 + rf(+1)) = (C/PoP)^(-sigmaC_p)/(P*(1 + tauC(+1)));

[name = 'taxes on household labour income']
tauNH = tauNH_p + exo_tauNH;

[name = 'taxes on household capital income']
tauKH = tauKH_p + exo_tauKH;

[name = 'taxes on consumption']
tauC = tauC_p + exo_tauC;

[name = 'Government Budget Constraint']
G + BG
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        @# for z in ClimateVars
            + G_A_@{z}_@{sec}_@{reg}
        @# endfor
    @# endfor
@# endfor
= (1 + rf) * Sf * exp(-phiB_p*((Sf*rf*B(-1)/Y+NX/Y))) * BG (-1) + tauC * C
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        + (tauNH + tauNF_@{sec}_@{reg}) * W_@{sec}_@{reg} * N_@{sec}_@{reg} * PoP/P + (tauKH + tauKF_@{sec}_@{reg}) * P_@{sec}_@{reg} /P * r_@{sec}_@{reg} * K_@{sec}_@{reg} 
    @# endfor
@# endfor
;

[name = 'public good capital stock']
KG = (1 - deltaKG_p) * KG(-1) + G;

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
