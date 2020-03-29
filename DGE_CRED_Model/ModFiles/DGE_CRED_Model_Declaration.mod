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
    PERC_@{reg} ${PERC_{r}}$ (long_name = 'regional percipitation')
    T_@{reg} ${T_{r}}$ (long_name = 'regional temperature')
    WS_@{reg} ${W_{r}^{S}}$ (long_name = 'regional wind speed')
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
        K_@{sec}_@{reg} ${K_{k,n}}$ (long_name = 'regional sector capital')
        N_@{sec}_@{reg} ${N_{k,n}}$ (long_name = 'regional sector employment')
        W_@{sec}_@{reg} ${W_{k,n}}$ (long_name = 'regional sector wages')
        A_@{sec}_@{reg} ${A_{k,n}}$ (long_name = 'regional sector TFP')
        G_A_@{sec}_@{reg} ${G^{A}_{k,n}}$ (long_name = 'regional sector adaptation government expenditure')
        gA_@{sec}_@{reg} ${g^{A}_{k,n}}$ (long_name = 'regional growth rate of sector TFP')
        A_N_@{sec}_@{reg} ${A^{N}_{k,n}}$ (long_name = 'regional sector labour specific TFP')
        A_K_@{sec}_@{reg} ${A^{K}_{k,n}}$ (long_name = 'regional sector capital specific TFP')
        I_@{sec}_@{reg} ${I_{k,n}}$ (long_name = 'regional sector private investment')
        P_@{sec}_@{reg} ${P_{k,n}}$ (long_name = 'regional sector price index')
        omegaI_@{sec}_@{reg} ${\omega^I_{k,n}}$ (long_name = 'shadow value of regional private sector investment')
        r_@{sec}_@{reg} ${r_{k,n}}$ (long_name = 'regional sector rental rate on capital')
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
        exo_@{sec}_@{reg} ${\eta_{A,k,n}}$ (long_name = 'exogenus TFP')
        exo_N_@{sec}_@{reg} ${\eta_{A^{N},k,n}}$ (long_name = 'exogenous labour specific TFP')
        exo_K_@{sec}_@{reg} ${\eta_{A^{K},k,n}}$ (long_name = 'exogenous capital specific TFP')
        exo_GA_@{sec}_@{reg} ${\eta_{G^{A},k,n}}$ (long_name = 'exogenous sector adaptation expenditure')
    @# endfor
@# endfor

@# for reg in 1:Regions
    exo_T_@{reg} ${\eta_{T,n}}$ (long_name = 'exogenus regional temperature')
    exo_PERC_@{reg} ${\eta_{PERC,n}}$ (long_name = 'exogenus regional percipitation')
    exo_WS_@{reg} ${\eta_{W^{S},n}}$ (long_name = 'exogenus regional wind speed')
@# endfor
;

% ==========================
% === Declare Parameters ===
% ==========================
parameters 
@# for sec in 1:Sectors
    omega_@{sec}_p ${\omega_{k}}$ (long_name = 'sector capital share')
    etaC_@{sec}_p ${\eta^{C}}$ (long_name = 'intratemporal elasticity of substitution')
    @# for reg in 1:Regions
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
        phiP_@{sec}_@{reg}_p $\frac{P_{k,n,0}}{P_{0}}$ (long_name = 'share of regional and sectoral employment')
        phiL_@{sec}_@{reg}_p ${\phi^{L}_{k,n}}$ (long_name = 'coefficient of disutility to work')
        omega_@{sec}_@{reg}_p ${\omega_{k,n}}$ (long_name = 'sector capital share')
        alphaK_@{sec}_@{reg}_p ${\alpha^{K}_{k,n}}$ (long_name = 'distribution parameter capital share')
        alphaN_@{sec}_@{reg}_p ${\alpha^{N}_{k,n}}$ (long_name = 'distribution parameter labour share')
        etaNK_@{sec}_@{reg}_p ${\eta^{N,K}_{k,n}}$ (long_name = 'elasticity of substitution between labour and capital')
        A_@{sec}_@{reg}_p ${A_{k,n}}$ (long_name = 'sector long-run TFP')
        GAT_@{sec}_@{reg}_p ${G^{A}_{T,k,n}}$ (long_name = 'sector region specific government expenditure for adaptation')
        phiGA_@{sec}_@{reg}_p ${\phi^{G^{A}}_{k,n}}$ (long_name = 'coefficient of effectiveness of government expenditure on adaptation measures in a specific region and sector')
        gY0_@{sec}_@{reg}_p ${\frac{Y_{2,k,n}}{Y_{1,k,n}}}$ (long_name = 'initial sector growth')
        gN0_@{sec}_@{reg}_p ${\frac{\frac{N_{2,k,n}{N_{2}}}}{\frac{N_{1,k,n}}{N_{1}}}$ (long_name = 'initial sector labour growth')
        omegaA_@{sec}_@{reg}_p ${\omega^{A}_{k,n}}$ (long_name = 'exponent for productivity growth')
        A_N_@{sec}_@{reg}_p ${A^{N}_{k,n}}$ (long_name = 'sector labour specific TFP')
        A_K_@{sec}_@{reg}_p ${A^{K}_{k,n}}$ (long_name = 'sector capital specific TFP')
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

    @# endfor
@# endfor
beta_p ${\beta}$ (long_name = 'discount factor')
delta_p ${\delta}$ (long_name = 'capital depreciation rate')
sigmaL_p ${\sigma^{L}}$ (long_name = 'inverse Frisch elasticity')
sigmaC_p ${\sigma^{C}}$ (long_name = 'intertemporal elasticity of substitution')
etaC_p ${\eta^{C}}$ (long_name = 'intratemporal elasticity of substitution')
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
rhoPERC_p  ${\rho^{T}}$ (long_name = 'persistency in percipitation')
inbsectors_p  ${K}$ (long_name = 'number of sectors')
inbregions_p  ${R}$ (long_name = 'number of regions')
lCalibration_p  ${l^{Calib}}$ (long_name = 'logical indiactor whether model is calibrated or not')
@# for reg in 1:Regions
    T0_@{reg}_p ${T_{0,n}}$ (long_name = 'initial regional temperature')
    PERC0_@{reg}_p ${PERC_{0,n}}$ (long_name = 'initial regional percipitation')
    WS0_@{reg}_p ${W^{S}_{0,n}}$ (long_name = 'initiial regional wind speed')
    TT_@{reg}_p ${T_{T,n}}$ (long_name = 'terminal regional temperature')
    PERCT_@{reg}_p ${PERC_{T,n}}$ (long_name = 'terminal regional percipitation')
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
