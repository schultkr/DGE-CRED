% ====================================
% === Declare Endogenous Variables ===
% ====================================
var 
P $P$ (long_name = 'price level')
K $K$ (long_name = 'capital stock')
C $C$ (long_name = 'consumption')
PoP $PoP$ (long_name = 'population')
B $B$ (long_name = 'international traded bonds')
Sf $S^{f}$ (long_name = 'effective exchange rate with the rest of the world')
BG $BG$ (long_name = 'government debt')
NX $NX$ (long_name = 'net exports')
rf ${r^{f}}$ (long_name = 'foreign interest rate')
G $G$ (long_name = 'government expenditure')
I $I$ (long_name = 'private investment')
Y $Y$ (long_name = 'GDP')
N $N$ (long_name = 'labour')
SL ${SL}$ (long_name = 'sea level')
@# for reg in 1:Regions
    PREC_@{reg} ${PREC_{r}}$ (long_name = 'regional percipitation')
    T_@{reg} ${T_{r}}$ (long_name = 'regional temperature')
    WS_@{reg} ${W_{r}^{S}}$ (long_name = 'regional wind speed')
    CYC_@{reg} ${CY_{r}^{S}}$ (long_name = 'regional intensity of cyclones')
    DRO_@{reg} ${DR_{r}^{S}}$ (long_name = 'regional intensity of drought')
@# endfor
@# for sec in 1:Sectors
    Y_@{sec} ${Y_k}$ (long_name = 'sector GDP')
    K_@{sec} ${K_k}$ (long_name = 'sector capital')
    N_@{sec} ${N_k}$ (long_name = 'sector employment')
    I_@{sec} ${I_k}$ (long_name = 'sector private investment')
    P_@{sec} ${P_k}$ (long_name = 'sector price index')
    W_@{sec} ${W_k}$ (long_name = 'sector wage index')
    @# for reg in 1:Regions
        Y_@{sec}_@{reg} ${Y_{k,n}}$ (long_name = 'regional sector GDP')
        D_@{sec}_@{reg} ${D_{k,n}}$ (long_name = 'regional sector damages')
        D_N_@{sec}_@{reg} ${D^{N}_{k,n}}$ (long_name = 'regional sector damages to labour productivity')
        D_K_@{sec}_@{reg} ${D^{K}_{k,n}}$ (long_name = 'regional sector destuction of capital stock')
        K_@{sec}_@{reg} ${K_{k,n}}$ (long_name = 'regional sector capital')
        N_@{sec}_@{reg} ${N_{k,n}}$ (long_name = 'regional sector employment')
        W_@{sec}_@{reg} ${W_{k,n}}$ (long_name = 'regional sector wages')
        A_@{sec}_@{reg} ${A_{k,n}}$ (long_name = 'regional sector TFP')
        @# for z in ["T", "WS", "PREC", "SL", "CYC", "DRO"]
            G_A_@{z}_@{sec}_@{reg} ${G^{A,@{z}}_{k,n}}$ (long_name = 'regional sector adaptation government expenditure @{z}')       
            K_A_@{z}_@{sec}_@{reg} ${K^{A,@{z}}_{k,n}}$ (long_name = 'regional sector adaptation capital stock @{z}')
        @# endfor
        gA_@{sec}_@{reg} ${g^{A}_{k,n}}$ (long_name = 'regional growth rate of sector TFP')
        A_N_@{sec}_@{reg} ${A^{N}_{k,n}}$ (long_name = 'regional sector labour specific TFP')
        A_K_@{sec}_@{reg} ${A^{K}_{k,n}}$ (long_name = 'regional sector capital specific TFP')
        I_@{sec}_@{reg} ${I_{k,n}}$ (long_name = 'regional sector private investment')
        P_@{sec}_@{reg} ${P_{k,n}}$ (long_name = 'regional sector price index')
        omegaI_@{sec}_@{reg} ${\omega^I_{k,n}}$ (long_name = 'shadow value of regional private sector investment')
        r_@{sec}_@{reg} ${r_{k,n}}$ (long_name = 'regional sector rental rate on capital')
        tauK_@{sec}_@{reg} ${\tau^{K}_{k,n}}$ (long_name = 'regional sector corporate tax rate on capital')
        tauN_@{sec}_@{reg} ${\tau^{N}_{k,n}}$ (long_name = 'regional sector labour tax rate on capital')
    @# endfor
@# endfor
;

% ====================================
% === Declare Exogenous Variables ===
% ====================================
varexo 
exo_P ${\eta_{P}}$ (long_name = 'exogeneous price index evolution')
exo_PoP ${\eta_{PoP}}$ (long_name = 'exogeneous population')
exo_SL ${\eta_{SL}}$ (long_name = 'exogeneous sea level')
exo_NX ${\eta_{NX}}$ (long_name = 'exogenous net exports')
exo_BG ${\eta_{BG}}$ (long_name = 'exogenous structural balance')
@# for sec in 1:Sectors
    @# for reg in 1:Regions
        exo_tauK_@{sec}_@{reg} ${\eta_{\tau^{K},k,n}}$ (long_name = 'exogenous sector and region corporate tax rate')
        exo_tauN_@{sec}_@{reg} ${\eta_{\tau^{N},k,n}}$ (long_name = 'exogenous sector and region labour tax rate')
        exo_@{sec}_@{reg} ${\eta_{A,k,n}}$ (long_name = 'exogenus TFP')
        exo_N_@{sec}_@{reg} ${\eta_{A^{N},k,n}}$ (long_name = 'exogenous labour specific TFP')
        exo_K_@{sec}_@{reg} ${\eta_{A^{K},k,n}}$ (long_name = 'exogenous capital specific TFP')
        @# for z in ["T", "WS", "PREC", "SL", "CYC", "DRO"]
            exo_GA_@{z}_@{sec}_@{reg} ${\eta_{G^{A,@{z}},k,n}}$ (long_name = 'exogenous sector adaptation expenditure against @{z}')
        @# endfor

    @# endfor
@# endfor

@# for reg in 1:Regions
    exo_T_@{reg} ${\eta_{T,n}}$ (long_name = 'exogenous regional temperature')
    exo_PREC_@{reg} ${\eta_{PREC,n}}$ (long_name = 'exogenous regional percipitation')
    exo_WS_@{reg} ${\eta_{W^{S},n}}$ (long_name = 'exogenous regional wind speed')
    exo_DRO_@{reg} ${\eta_{DR^{S},n}}$ (long_name = 'exogenous regional intnsity of drought')
    exo_CYC_@{reg} ${\eta_{CY^{S},n}}$ (long_name = 'exogenous regional intnsity of cyclone')
@# endfor
;

% ==========================
% === Declare Parameters ===
% ==========================
parameters 
@# for sec in 1:Sectors
    omegaQ_@{sec}_p ${\omega^{Q}_{k}}$ (long_name = 'distribution parameter for output from one sector')
    etaQ_@{sec}_p ${\eta^{C}_{k}}$ (long_name = 'elasticity of substitution between regional production')
    @# for reg in 1:Regions
        tauK_@{sec}_@{reg}_p ${\tau^{K}_{k,n}}$ (long_name = 'region and sector specific tax rate on capital')
        tauN_@{sec}_@{reg}_p ${\tau^{N}_{k,n}}$ (long_name = 'region and sector specific tax rate on labour')
        rhoA_@{sec}_@{reg}_p ${\rho^{A}_{k,n}}$ (long_name = 'persistence productivity shock')
        rhoA_N_@{sec}_@{reg}_p ${\rho^{A,N}_{k,n}}$ (long_name = 'persistence labour specific productivity shock')
        rhoA_K_@{sec}_@{reg}_p ${\rho^{A,K}_{k,n}}$ (long_name = 'persistence capital specific productivity shock')
        phiY_@{sec}_@{reg}_p $\frac{P_{k,n,0} \, Y_{k,n,0}}{P_{0} \, Y_{0}}$ (long_name = 'long-run share of regional and sectoral output')
        phiN_@{sec}_@{reg}_p ${N_{k,n,0}}$ (long_name = 'long run share of regional and sectoral employment')
        phiY0_@{sec}_@{reg}_p $\frac{P_{k,n,0} \, Y_{k,n,0}}{P_{0} \, Y_{0}}$ (long_name = 'terminal share of regional and sectoral output')
        phiN0_@{sec}_@{reg}_p ${N_{k,n,0}}$ (long_name = 'initial share of regional and sectoral employment')
        phiYT_@{sec}_@{reg}_p $\frac{P_{k,n,0} \, Y_{k,n,0}}{P_{0} \, Y_{0}}$ (long_name = 'terminal share of regional and sectoral output')
        phiNT_@{sec}_@{reg}_p ${N_{k,n,0}}$ (long_name = 'terminal share of regional and sectoral employment')
        phiW_@{sec}_@{reg}_p $\frac{W_{k,n,0} \, N_{k,n,0}}{P_{k,n,0} \, Y_{k,n,0}}$ (long_name = 'share of regional and sectoral employment')
        phiL_@{sec}_@{reg}_p ${\phi^{L}_{k,n}}$ (long_name = 'coefficient of disutility to work')
        omegaQ_@{sec}_@{reg}_p ${\omega^{Q}_{k,n}}$ (long_name = 'distribution parameter for regional production')
        alphaK_@{sec}_@{reg}_p ${\alpha^{K}_{k,n}}$ (long_name = 'distribution parameter capital share')
        alphaN_@{sec}_@{reg}_p ${\alpha^{N}_{k,n}}$ (long_name = 'distribution parameter labour share')
        etaNK_@{sec}_@{reg}_p ${\eta^{N,K}_{k,n}}$ (long_name = 'elasticity of substitution between labour and capital')
        A_@{sec}_@{reg}_p ${A_{k,n}}$ (long_name = 'sector long-run TFP')
        @# for z in ["T", "WS", "PREC", "SL", "CYC", "DRO"]
            phiGA@{z}_@{sec}_@{reg}_p ${\phi^{G^{A,@{z}}}_{k,n}}$ (long_name = 'coefficient of effectiveness of government expenditure on adaptation measures in a specific region and sector @{z}')
            deltaKA@{z}_@{sec}_@{reg}_p ${\delta^{K^{A,@{z}}_{k,n}}$ (long_name = 'depreciation rate of adaptation capital stock against @{z}')
        @# endfor
        gY0_@{sec}_@{reg}_p ${\frac{Y_{2,k,n}}{Y_{1,k,n}}}$ (long_name = 'initial sector growth')
        gN0_@{sec}_@{reg}_p ${\frac{\frac{N_{2,k,n}{N_{2}}}}{\frac{N_{1,k,n}}{N_{1}}}$ (long_name = 'initial sector labour growth')
        omegaA_@{sec}_@{reg}_p ${\omega^{A}_{k,n}}$ (long_name = 'exponent for productivity growth')
        A_N_@{sec}_@{reg}_p ${A^{N}_{k,n}}$ (long_name = 'sector labour specific TFP')
        A_K_@{sec}_@{reg}_p ${A^{K}_{k,n}}$ (long_name = 'sector capital specific TFP')
        // coefficients for damage functions to TFP
        a_T_1_@{sec}_@{reg}_p ${a_{1,k,n}}$ (long_name = 'intercept of damage function temperature')
        a_T_2_@{sec}_@{reg}_p ${a_{2,k,n}}$ (long_name = 'slope of damage function temperature')
        a_T_3_@{sec}_@{reg}_p ${a_{3,k,n}}$ (long_name = 'exponent of damage function temperature')
        a_P_1_@{sec}_@{reg}_p ${a_{1,k,n}}$ (long_name = 'intercept of damage function percipitation')
        a_P_2_@{sec}_@{reg}_p ${a_{2,k,n}}$ (long_name = 'slope of damage function percipitation')
        a_P_3_@{sec}_@{reg}_p ${a_{3,k,n}}$ (long_name = 'exponent of damage function percipitation')
        a_W_1_@{sec}_@{reg}_p ${a_{1,k,n}}$ (long_name = 'intercept of damage function wind speed')
        a_W_2_@{sec}_@{reg}_p ${a_{2,k,n}}$ (long_name = 'slope of damage function wind speed')
        a_W_3_@{sec}_@{reg}_p ${a_{3,k,n}}$ (long_name = 'exponent of damage function wind speed')
        a_SL_1_@{sec}_@{reg}_p ${a_{1,k,n}}$ (long_name = 'intercept of damage function sea level')
        a_SL_2_@{sec}_@{reg}_p ${a_{2,k,n}}$ (long_name = 'slope of damage function sea level')
        a_SL_3_@{sec}_@{reg}_p ${a_{3,k,n}}$ (long_name = 'exponent of damage function sea level')
        a_DR_1_@{sec}_@{reg}_p ${a_{1,k,n}}$ (long_name = 'intercept of damage function drought')
        a_DR_2_@{sec}_@{reg}_p ${a_{2,k,n}}$ (long_name = 'slope of damage function drought')
        a_DR_3_@{sec}_@{reg}_p ${a_{3,k,n}}$ (long_name = 'exponent of damage function drought')
        a_CY_1_@{sec}_@{reg}_p ${a_{1,k,n}}$ (long_name = 'intercept of damage function cyclone')
        a_CY_2_@{sec}_@{reg}_p ${a_{2,k,n}}$ (long_name = 'slope of damage function cyclone')
        a_CY_3_@{sec}_@{reg}_p ${a_{3,k,n}}$ (long_name = 'exponent of damage function cyclone')
        // coefficients for damage functions to labour productivity
        aN_T_1_@{sec}_@{reg}_p ${a^{N}_{1,k,n}}$ (long_name = 'intercept of damage function temperature')
        aN_T_2_@{sec}_@{reg}_p ${a^{N}_{2,k,n}}$ (long_name = 'slope of damage function temperature')
        aN_T_3_@{sec}_@{reg}_p ${a^{N}_{3,k,n}}$ (long_name = 'exponent of damage function temperature')
        aN_P_1_@{sec}_@{reg}_p ${a^{N}_{1,k,n}}$ (long_name = 'intercept of damage function percipitation')
        aN_P_2_@{sec}_@{reg}_p ${a^{N}_{2,k,n}}$ (long_name = 'slope of damage function percipitation')
        aN_P_3_@{sec}_@{reg}_p ${a^{N}_{3,k,n}}$ (long_name = 'exponent of damage function percipitation')
        aN_W_1_@{sec}_@{reg}_p ${a^{N}_{1,k,n}}$ (long_name = 'intercept of damage function wind speed')
        aN_W_2_@{sec}_@{reg}_p ${a^{N}_{2,k,n}}$ (long_name = 'slope of damage function wind speed')
        aN_W_3_@{sec}_@{reg}_p ${a^{N}_{3,k,n}}$ (long_name = 'exponent of damage function wind speed')
        aN_SL_1_@{sec}_@{reg}_p ${a^{N}_{1,k,n}}$ (long_name = 'intercept of damage function sea level')
        aN_SL_2_@{sec}_@{reg}_p ${a^{N}_{2,k,n}}$ (long_name = 'slope of damage function sea level')
        aN_SL_3_@{sec}_@{reg}_p ${a^{N}_{3,k,n}}$ (long_name = 'exponent of damage function sea level')
        aN_DR_1_@{sec}_@{reg}_p ${a^{N}_{1,k,n}}$ (long_name = 'intercept of damage function drought')
        aN_DR_2_@{sec}_@{reg}_p ${a^{N}_{2,k,n}}$ (long_name = 'slope of damage function drought')
        aN_DR_3_@{sec}_@{reg}_p ${a^{N}_{3,k,n}}$ (long_name = 'exponent of damage function drought')
        aN_CY_1_@{sec}_@{reg}_p ${a^{N}_{1,k,n}}$ (long_name = 'intercept of damage function cyclone')
        aN_CY_2_@{sec}_@{reg}_p ${a^{N}_{2,k,n}}$ (long_name = 'slope of damage function cyclone')
        aN_CY_3_@{sec}_@{reg}_p ${a^{N}_{3,k,n}}$ (long_name = 'exponent of damage function cyclone')
        // coefficients for damage functions to capital stock
        aK_T_1_@{sec}_@{reg}_p ${a^{K}_{1,k,n}}$ (long_name = 'intercept of damage function temperature')
        aK_T_2_@{sec}_@{reg}_p ${a^{K}_{2,k,n}}$ (long_name = 'slope of damage function temperature')
        aK_T_3_@{sec}_@{reg}_p ${a^{K}_{3,k,n}}$ (long_name = 'exponent of damage function temperature')
        aK_P_1_@{sec}_@{reg}_p ${a^{K}_{1,k,n}}$ (long_name = 'intercept of damage function percipitation')
        aK_P_2_@{sec}_@{reg}_p ${a^{K}_{2,k,n}}$ (long_name = 'slope of damage function percipitation')
        aK_P_3_@{sec}_@{reg}_p ${a^{K}_{3,k,n}}$ (long_name = 'exponent of damage function percipitation')
        aK_W_1_@{sec}_@{reg}_p ${a^{K}_{1,k,n}}$ (long_name = 'intercept of damage function wind speed')
        aK_W_2_@{sec}_@{reg}_p ${a^{K}_{2,k,n}}$ (long_name = 'slope of damage function wind speed')
        aK_W_3_@{sec}_@{reg}_p ${a^{K}_{3,k,n}}$ (long_name = 'exponent of damage function wind speed')
        aK_SL_1_@{sec}_@{reg}_p ${a^{K}_{1,k,n}}$ (long_name = 'intercept of damage function sea level')
        aK_SL_2_@{sec}_@{reg}_p ${a^{K}_{2,k,n}}$ (long_name = 'slope of damage function sea level')
        aK_SL_3_@{sec}_@{reg}_p ${a^{K}_{3,k,n}}$ (long_name = 'exponent of damage function sea level')
        aK_DR_1_@{sec}_@{reg}_p ${a^{K}_{1,k,n}}$ (long_name = 'intercept of damage function drought')
        aK_DR_2_@{sec}_@{reg}_p ${a^{K}_{2,k,n}}$ (long_name = 'slope of damage function drought')
        aK_DR_3_@{sec}_@{reg}_p ${a^{K}_{3,k,n}}$ (long_name = 'exponent of damage function drought')
        aK_CY_1_@{sec}_@{reg}_p ${a^{K}_{1,k,n}}$ (long_name = 'intercept of damage function cyclone')
        aK_CY_2_@{sec}_@{reg}_p ${a^{K}_{2,k,n}}$ (long_name = 'slope of damage function cyclone')
        aK_CY_3_@{sec}_@{reg}_p ${a^{K}_{3,k,n}}$ (long_name = 'exponent of damage function cyclone')
    @# endfor
@# endfor
beta_p ${\beta}$ (long_name = 'discount factor')
delta_p ${\delta}$ (long_name = 'capital depreciation rate')
sigmaL_p ${\sigma^{L}}$ (long_name = 'inverse Frisch elasticity')
sigmaC_p ${\sigma^{C}}$ (long_name = 'intertemporal elasticity of substitution')
etaQ_p ${\eta^{Q}}$ (long_name = 'elasticity of substitution between sectoral production')
phiB_p ${\phi^{B}}$ (long_name = 'coefficient of foreign adjustment cost')
phiK_p ${\phi^{K}}$ (long_name = 'coefficient of investment adjustment cost')
tauC_p  ${\tau^{C}}$ (long_name = 'consumption tax')
tauN_p ${\tau^{N}}$ (long_name = 'labour tax')
tauK_p  ${\tau^{K}}$ (long_name = 'capital tax')
omegaNX_p  ${\omega^{NX}}$ (long_name = 'share of net exports relative to domestic GDP')
omegaNX0_p  ${\omega^{NX,0}}$ (long_name = 'initial share of net exports relative to domestic GDP')
omegaNXT_p  ${\omega^{NX,T}}$ (long_name = 'terminal share of net exports relative to domestic GDP')
rhoNX_p  ${\rho^{NX}}$ (long_name = 'persistency in net exports')
rhoA_p ${\rho^{A}}$ (long_name = 'persistency in TFP')
rhoPoP_p  ${\rho^{PoP}}$ (long_name = 'persistency in population')
rhoSL_p  ${\rho^{SL}}$ (long_name = 'persistency in sea level')
rhoT_p  ${\rho^{T}}$ (long_name = 'persistency in temperature')
rhoWS_p  ${\rho^{T}}$ (long_name = 'persistency in wind speed')
rhoPREC_p  ${\rho^{T}}$ (long_name = 'persistency in percipitation')
inbsectors_p  ${K}$ (long_name = 'number of sectors')
inbregions_p  ${R}$ (long_name = 'number of regions')
lCalibration_p  ${l^{Calib}}$ (long_name = 'logical indiactor whether model is calibrated or not')
@# for reg in 1:Regions
    T0_@{reg}_p ${T_{0,n}}$ (long_name = 'initial regional temperature')
    PREC0_@{reg}_p ${PREC_{0,n}}$ (long_name = 'initial regional percipitation')
    WS0_@{reg}_p ${W^{S}_{0,n}}$ (long_name = 'initiial regional wind speed')
    CYC0_@{reg}_p ${CY_{0,n}}$ (long_name = 'initiial cyclone index')
    DRO0_@{reg}_p ${DR_{0,n}}$ (long_name = 'initiial drought index')
    TT_@{reg}_p ${T_{T,n}}$ (long_name = 'terminal regional temperature')
    PRECT_@{reg}_p ${PREC_{T,n}}$ (long_name = 'terminal regional percipitation')
    WST_@{reg}_p ${W^{S}_{T,n}}$ (long_name = 'terminal regional wind speed')
@# endfor
% === initial values ===
SL0_p ${SL_0}$ (long_name = 'initial sea level')
PoP0_p ${POP_0}$ (long_name = 'initial population')
Y0_p ${Y_0}$ (long_name = 'initial output')
P0_p ${P_0}$ (long_name = 'initial price level')
N0_p ${Y_0}$ (long_name = 'initial employment')
% === terminal values ===
SLT_p ${SL_0}$ (long_name = 'terminal sea level')
PoPT_p ${PoP_0}$ (long_name = 'terminal population')
YT_p ${Y_0}$ (long_name = 'terminal output')
NT_p ${Y_0}$ (long_name = 'terminal employment')
;
