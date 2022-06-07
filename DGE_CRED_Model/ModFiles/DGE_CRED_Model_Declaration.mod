% ====================================
% === Declare Endogenous Variables ===
% ====================================
var 
// contemporanous equations/variables defined by others
K $K$ (long_name = 'capital stock')
N $N$ (long_name = 'labour')
@# for z in ClimateVarsNational
    @{z} ${@{z}}$ (long_name = '@{z}')
@# endfor
@# for reg in 1:Regions
    @# for z in ClimateVarsRegional
        @{z}_@{reg} ${@{z}_{r}}$ (long_name = '@{z}')
    @# endfor
@# endfor
@# for sec in 1:Sectors
    I_@{sec} ${I_k}$ (long_name = 'sector private investment')
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        Y_@{subsec} ${Y_s}$ (long_name = 'sector GDP')
        Q_D_@{subsec} ${Q^{D}_s}$ (long_name = 'domesitcally used sector output')
        Q_I_@{subsec} ${Q^{I}_s}$ (long_name = 'sector intermediate inputs')
        M_@{subsec} ${M_s}$ (long_name = 'sector imports')
        X_@{subsec} ${X_s}$ (long_name = 'sector exports')
        D_X_@{subsec} ${D^{X}_s}$ (long_name = 'world demand for sector exports')
        K_@{subsec} ${K_s}$ (long_name = 'sector capital')
        N_@{subsec} ${N_s}$ (long_name = 'sector employment')
        P_D_@{subsec} ${P^{D}_s}$ (long_name = 'domestic sector price index')
        P_M_@{subsec} ${P^{M}_s}$ (long_name = 'imports sector price index')
        W_@{subsec} ${W_s}$ (long_name = 'sector wage index')        
        @# for reg in 1:Regions
            Q_@{subsec}_@{reg} ${Q_{k,r}}$ (long_name = 'regional sector Output')
            W_@{subsec}_@{reg} ${W_{k,r}}$ (long_name = 'regional wage rate for sector labour')
            tauKF_@{subsec}_@{reg} ${\tau^{K}_{k,r}}$ (long_name = 'regional sector corporate tax rate on capital')
            tauNF_@{subsec}_@{reg} ${\tau^{N}_{k,r}}$ (long_name = 'regional sector labour tax rate on capital')
            P_D_@{subsec}_@{reg} ${P_{k,r}}$ (long_name = 'regional sector price index')
        @# endfor
    @# endfor
@# endfor

// actual variables
P $P$ (long_name = 'price level')
lambda $\lambda$ (long_name = 'budget constraint lagrange multiplier')
P_D ${P^{D}}$ (long_name = 'domestic price level')
P_M ${P^{M}}$ (long_name = 'foreign  price level')
C $C$ (long_name = 'consumption')
H $H$ (long_name = 'houses')
IH $I^H$ (long_name = 'investment in houses')
PH $P^H$ (long_name = 'prices for houses')
DH $D^H$ (long_name = 'damages to the housing stock')
omegaH $\omega^H$ (long_name = 'lagrnage multiplier for the law of motion of houses')
PoP $PoP$ (long_name = 'population')
B $B$ (long_name = 'international traded bonds')
BG $BG$ (long_name = 'government debt')
NX $NX$ (long_name = 'net exports')
rf ${r^{f}}$ (long_name = 'foreign interest rate')
G $G$ (long_name = 'government expenditure')
tauC  ${\tau^{C}}$ (long_name = 'consumption tax')
tauH  ${\tau^{C}}$ (long_name = 'tax on housing')
tauNH ${\tau^{N,H}}$ (long_name = 'labour tax')
tauKH  ${\tau^{K,H}}$ (long_name = 'capital tax')
KG $K^G$ (long_name = 'public good capital stock')
I $I$ (long_name = 'private investment')
Y $Y$ (long_name = 'GDP')
Q_U $Q^{U}$ (long_name = 'domestic used output')
Q_D $Q^{D}$ (long_name = 'domestic produced and used products')
Q_I $Q^{I}$ (long_name = 'demand for intermediate products')
Q $Q$ (long_name = 'total production')
M $M$ (long_name = 'Imports')
X $X$ (long_name = 'Exports')
G_A_DH ${G^{A,D^H}}$ (long_name = 'adaptation government expenditure for housing')       
G_AP_DH ${G^{A,P,D^H}}$ (long_name = 'private adaptation expenditure for housing')       
@# for sec in 1:Sectors
    Q_A_@{sec} ${Q^A_k}$ (long_name = 'sector aggregate output')
    P_A_@{sec} ${P^A_k}$ (long_name = 'sector aggregate price level')

    @# for reg in 1:Regions
        KH_@{sec}_@{reg} ${K_{k,r}}$ (long_name = 'regional sector capital')
        r_@{sec}_@{reg} ${r_{k,r}}$ (long_name = 'regional rentqal rate for sector capital')
        I_@{sec}_@{reg} ${I_{k,r}}$ (long_name = 'regional sector investment')
        omegaI_@{sec}_@{reg} ${\omega^I_{k,r}}$ (long_name = 'shadow value of regional private sector investment')
    @# endfor
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        Q_@{subsec} ${Q_s}$ (long_name = 'sector output')
        @# for reg in 1:Regions
            D_@{subsec}_@{reg} ${D_{s,r}}$ (long_name = 'regional subsector damages')
            D_N_@{subsec}_@{reg} ${D_{s,r}}$ (long_name = 'regional subsector damages to labour productivity')
            D_K_@{subsec}_@{reg} ${D_{s,r}}$ (long_name = 'regional subsector destuction of capital stock')
            K_@{subsec}_@{reg} ${K_{s,r}}$ (long_name = 'regional subsector capital')
			G_AP_@{subsec}_@{reg} ${G^{A,P}_{s,r}}$ (long_name = 'regional subsector private adaptation government expenditure')       
            K_AP_@{subsec}_@{reg} ${K^{A,P}_{s,r}}$ (long_name = 'regional subsector private adaptation capital stock')
            G_A_@{subsec}_@{reg} ${G^{A}_{s,r}}$ (long_name = 'regional subsector adaptation government expenditure')       
            K_A_@{subsec}_@{reg} ${K^{A}_{s,r}}$ (long_name = 'regional subsector adaptation capital stock')
            P_@{subsec}_@{reg} ${P_{s,r}}$ (long_name = 'regional subsector price index')
            Y_@{subsec}_@{reg} ${Y_{s,r}}$ (long_name = 'regional subsector GDP')
            N_@{subsec}_@{reg} ${N_{s,r}}$ (long_name = 'regional subsector employment')
            Q_I_@{subsec}_@{reg} ${Q^{I}_{s,r}}$ (long_name = 'regional subsector intermediate inputs')
            A_@{subsec}_@{reg} ${A_{s,r}}$ (long_name = 'regional subsector TFP')
            A_N_@{subsec}_@{reg} ${A^{N}_{s,r}}$ (long_name = 'regional subsector labour specific TFP')
            A_K_@{subsec}_@{reg} ${A^{K}_{s,r}}$ (long_name = 'regional subsector capital specific TFP')
        @# endfor
    @# endfor
@# endfor
;


% ====================================
% === Declare Exogenous Variables ===
% ====================================
varexo 
exo_tauC ${\eta_{\tau^C}}$ (long_name = 'exogeneous consumption tax')
exo_tauH ${\eta_{\tau^C}}$ (long_name = 'exogeneous housing tax')
exo_tauNH ${\eta_{\tau^{N,H}}}$ (long_name = 'exogeneous labour income tax paid by households')
exo_tauKH ${\eta_{\tau^{K,H}}}$ (long_name = 'exogeneous capital income tax paid by households')
exo_H ${\eta_{H}$ (long_name = 'exogeneous housing area to population ratio')
exo_DH ${\eta_{D^{H}}}$ (long_name = 'exogeneous damage to housing stock')
exo_PoP ${\eta_{PoP}}$ (long_name = 'exogeneous population')
exo_BG ${\eta_{BG}}$ (long_name = 'exogenous structural balance')
exo_rf ${\eta_{r^f}}$ (long_name = 'exogenous world interest rate')
exo_P ${\eta_{P}}$ (long_name = 'exogenous price level')
@# if YEndogenous == 0
    exo_NX ${\eta_{NX}}$ (long_name = 'exogenous net exports')        
@# else
    exo_M ${\eta_{M}}$ (long_name = 'exogenous import shock')    
@# endif

@# for sec in 1:Sectors
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        exo_X_@{subsec} ${\eta_{X,s}}$ (long_name = 'exogenus demand for subsector exports')
        @# if subsec > 1
            exo_M_@{subsec} ${\eta_{M,s}}$ (long_name = 'exogenus price development of sector imports')
        @# endif
        @# for reg in 1:Regions
            exo_@{subsec}_@{reg} ${\eta_{A,s,r}}$ (long_name = 'exogenus TFP')
            exo_N_@{subsec}_@{reg} ${\eta_{A^{N},s,r}}$ (long_name = 'exogenous labour specific TFP')
            exo_K_@{subsec}_@{reg} ${\eta_{A^{K},s,r}}$ (long_name = 'exogenous capital specific TFP')
            exo_D_@{subsec}_@{reg} ${\eta_{D,s,r}}$ (long_name = 'exogenus damage induced by climate change for the subsector')
            exo_D_N_@{subsec}_@{reg} ${\eta_{D^{N},s,r}}$ (long_name = 'exogenus damage induced by climate change for labour productivity in the subsector')
            exo_D_K_@{subsec}_@{reg} ${\eta_{D^{K},s,r}}$ (long_name = 'exogenus damage induced by climate change for capital productivity in the subsector')
            exo_tauKF_@{subsec}_@{reg} ${\eta_{\tau^{K},s,r}}$ (long_name = 'exogenous sector and region corporate tax rate')
            exo_tauNF_@{subsec}_@{reg} ${\eta_{\tau^{N},s,r}}$ (long_name = 'exogenous sector and region labour tax rate')
            exo_GA_@{subsec}_@{reg} ${\eta_{G^{A,@{z}},s,r}}$ (long_name = 'exogenous sector adaptation expenditure against @{z}')
			exo_GAP_@{subsec}_@{reg} ${\eta_{G^{A,P,@{z}},s,r}}$ (long_name = 'exogenous sector private adaptation expenditure against @{z}')
        @# endfor
    @# endfor
@# endfor
exo_G_A_DH ${\eta_{G^{A,H}}$ (long_name = 'exogenous sector adaptation expenditure for housing')
exo_G_AP_DH ${\eta_{G^{A,P,H}}$ (long_name = 'exogenous sector private adaptation expenditure for housing')
@# for z in ClimateVarsNational
    exo_@{z} ${\eta_{@{z},r}}$ (long_name = 'exogenus @{z}')
@# endfor

@# for reg in 1:Regions
    @# for z in ClimateVarsRegional
        exo_@{z}_@{reg} ${\eta_{@{z},r}}$ (long_name = 'exogenus regional @{z}')
    @# endfor
@# endfor
;

% ==========================
% === Declare Parameters ===
% ==========================
parameters 
% =======================
% === meta parameters ===
% =======================
inbsectors_p  ${K}$ (long_name = 'number of sectors')
inbregions_p  ${R}$ (long_name = 'number of regions')
lEndogenousY_p ${l^{Y}}$ (long_name = 'logical indicator for endogenous or exogenous production')
lCalibration_p  ${l^{Calib}}$ (long_name = 'logical indiactor whether model is calibrated or not')
@# for sec in 1:Sectors
    substart_@{sec}_p
    subend_@{sec}_p
@# endfor

% ========================
% === model parameters ===
% ========================
@# for sec in 1:Sectors
    omegaQA_@{sec}_p ${\omega^{Q^A}_{k}}$ (long_name = 'distribution parameter for aggregate output from one sector')
    etaQA_@{sec}_p ${\eta^{Q^A}_{k}}$ (long_name = 'elasticity of substitution between products from different subsectors in one sector')
    @# for subsec in Subsecstart[sec]:Subsecend[sec]
        iGA_@{subsec}_p ${i^{G^A}_s}$ (long_name = 'subsector which provides goods for adaptation measures in the respective sub-sector')
        iGAP_@{subsec}_p ${i^{G^{A,P}}_s}$ (long_name = 'subsector which provides goods for private adaptation measures in the respecitve sub-sector')		
        phiM_@{subsec}_p $\frac{M_{s,0} \, P^{M}_{k,0}}{P_{0} \, Q_{0}}$ (long_name = 'share of sector imports on total output')
        phiX_@{subsec}_p $\frac{X_{s,0} \, P_{k,0}}{P_{k,0} \, Y_{s,0}}$ (long_name = 'share of exports on gross value added')
        phiQI_@{subsec}_p $\frac{Q^{I}_{s,0} \, P_{0}}{P_{s,0} \, Q_{s,0}}$ (long_name = 'share of intermediate inputs on total subsectoral prodcution')
        D_X_@{subsec}_p ${D^{X}_{s}}$ (long_name = 'long-run demand for exports')
        P_M_@{subsec}_p ${P^{M}_{s}}$ (long_name = 'long-run price of sector imports')
        P_D_@{subsec}_p ${P^{D}_{s}}$ (long_name = 'initial price of sector output')
        omegaM_@{subsec}_p ${\omega^{M}_{k}}$ (long_name = 'distribution parameter for imports from one sector')
        omegaQ_@{subsec}_p ${\omega^{Q}_{k}}$ (long_name = 'distribution parameter for output from one sector')
        etaQ_@{subsec}_p ${\eta^{C}_{k}}$ (long_name = 'elasticity of substitution between regional production')
        etaI_@{subsec}_p ${\eta^{M}_{k}}$ (long_name = 'elasticity of substitution between value added and intermediate products')
        @# for reg in 1:Regions
            tauKF_@{subsec}_@{reg}_p ${\tau^{K,F}_{k,r}}$ (long_name = 'region and subsector specific tax rate on capital paid by firms')
            tauNF_@{subsec}_@{reg}_p ${\tau^{N,F}_{k,r}}$ (long_name = 'region and subsector specific tax rate on labour paid by firms')
            phiY_@{subsec}_@{reg}_p $\frac{P_{k,n,0} \, Y_{k,n,0}}{P_{0} \, Y_{0}}$ (long_name = 'share of regional and subsectoral output')
            phiYT_@{subsec}_@{reg}_p $\frac{P_{k,n,T} \, Y_{k,n,T}}{P_{T} \, Y_{T}}$ (long_name = 'terminal share of regional and subsectoral output')
            phiY0_@{subsec}_@{reg}_p $\frac{P_{k,n,0} \, Y_{k,n,0}}{P_{0} \, Y_{0}}$ (long_name = 'initial share of regional and subsectoral output')
            phiN_@{subsec}_@{reg}_p ${N_{k,n,0}}$ (long_name = 'long-run share of regional and subsectoral employment')
            phiNT_@{subsec}_@{reg}_p ${N_{k,n,T}}$ (long_name = 'terminal share of regional and subsectoral employment')
            phiN0_@{subsec}_@{reg}_p ${N_{k,n,0}}$ (long_name = 'initial share of regional and subsectoral employment')
            phiW_@{subsec}_@{reg}_p $\frac{W_{k,n,0} \, N_{k,n,0}}{P_{k,n,0} \, Y_{k,n,0}}$ (long_name = 'share of regional and subsectoral employment')
            phiL_@{subsec}_@{reg}_p ${\phi^{L}_{k,r}}$ (long_name = 'coefficient of disutility to work')
            omegaQ_@{subsec}_@{reg}_p ${\omega^{Q}_{k,r}}$ (long_name = 'distribution parameter for regional production')
            omegaQI_@{subsec}_@{reg}_p ${\omega^{Q^{I}}_{k,r}}$ (long_name = 'distribution parameter for intermeditate products')
            alphaK_@{subsec}_@{reg}_p ${\alpha^{K}_{k,r}}$ (long_name = 'distribution parameter capital share')
            alphaN_@{subsec}_@{reg}_p ${\alpha^{N}_{k,r}}$ (long_name = 'distribution parameter labour share')
            etaNK_@{subsec}_@{reg}_p ${\eta^{N,K}_{k,r}}$ (long_name = 'elasticity of substitution between labour and capital')
            A_@{subsec}_@{reg}_p ${A_{k,r}}$ (long_name = 'subsector long-run TFP')
            deltaKA_@{subsec}_@{reg}_p ${\delta^{K^{A}_{k,r}}$ (long_name = 'depreciation rate of adaptation capital stock against @{z}')
            gY0_@{subsec}_@{reg}_p ${\frac{Y_{2,k,r}}{Y_{1,k,r}}}$ (long_name = 'initial subsector growth')
            gN0_@{subsec}_@{reg}_p ${\frac{\frac{N_{2,k,r}{N_{2}}}}{\frac{N_{1,k,r}}{N_{1}}}$ (long_name = 'initial subsector labour growth')
            omegaA_@{subsec}_@{reg}_p ${\omega^{A}_{k,r}}$ (long_name = 'exponent for productivity growth')
            // coefficients for damage functions to TFP
            A_N_@{subsec}_@{reg}_p ${A^{N}_{k,r}}$ (long_name = 'subsector labour specific TFP')
            A_K_@{subsec}_@{reg}_p ${A^{K}_{k,r}}$ (long_name = 'subsector capital specific TFP')
        @# endfor
    @# endfor
@# endfor
iGAH_p ${i^{G^{A,H}}$ (long_name = 'sub sector output used for government housing adaptation')
iGAPH_p ${i^{G^{A,P,H}}$ (long_name = 'sub sector output used for private housing adaptation expenditure')
beta_p ${\beta}$ (long_name = 'discount factor')
omegaP_p ${\omega^{P}}$ (long_name = 'share of rational agents')
gamma_p ${\gamma}$ (long_name = 'preferences for housing in utility function')
delta_p ${\delta}$ (long_name = 'capital depreciation rate')
deltaH_p ${\delta^H}$ (long_name = 'housing depreciation rate')
deltaKG_p ${\delta^{K^{G}}}$ (long_name = 'public capital depreciation rate')
phiG_p ${\phi^{G}}$ (long_name = 'elasticity of TFP to public capital')
sigmaL_p ${\sigma^{L}}$ (long_name = 'inverse Frisch elasticity')
sigmaC_p ${\sigma^{C}}$ (long_name = 'intertemporal elasticity of substitution')
etaQ_p ${\eta^{Q}}$ (long_name = 'elasticity of substitution between sectoral production')
etaM_p ${\eta^{M}}$ (long_name = 'elasticity of substitution between sectoral imports')
etaF_p ${\eta^{F}}$ (long_name = 'elasticity of substitution between foreign and domestic products')
omegaF_p ${\omega^{F}}$ (long_name = 'distribution parameter between foreign and domestic products')
phiB_p ${\phi^{B}}$ (long_name = 'coefficient of foreign adjustment cost')
phiK_p ${\phi^{K}}$ (long_name = 'coefficient of investment adjustment cost')
tauC_p  ${\tau^{C}}$ (long_name = 'consumption tax')
tauH_p  ${\tau^{H}}$ (long_name = 'tax on housing')
tauNH_p ${\tau^{N,H}}$ (long_name = 'labour tax')
tauKH_p  ${\tau^{K,H}}$ (long_name = 'capital tax')
etaX_p   ${\eta^{X}}$ (long_name = 'export price elasticity')
@# for reg in 1:Regions
    @# for z in ClimateVarsRegional
        @{z}0_@{reg}_p ${T_{0,r}}$ (long_name = 'initial regional @{z}')
    @# endfor
@# endfor
% === initial values ===
phiQDD_p $\frac{Q^{I}_{0} \, P_{0}}{P_{0} \, Q_{0}}$ (long_name = 'share of domestically used and produced on total prodcution')
phiM_p $\frac{M_{0} \, P^{M}_{0}}{P_{0} \, Q_{0}}$ (long_name = 'share of imports on total prodcution')
@# for z in ClimateVarsNational
    @{z}0_p ${@{z}_{0}}$ (long_name = 'initial @{z}')
@# endfor
PoP0_p ${POP_0}$ (long_name = 'initial population')
H0_p ${H_0}$ (long_name = 'initial stocks of houses')
PH0_p ${P^H_0}$ (long_name = 'initial price of houses')
Y0_p ${Y_0}$ (long_name = 'initial output')
NX0_p ${NX_0}$ (long_name = 'initial net export to value added ratio')
P0_p ${P_0}$ (long_name = 'initial price level')
P0_M_p ${P_0}$ (long_name = 'initial price level')
N0_p ${Y_0}$ (long_name = 'initial employment')
rf0_p ${r^f_0}$ (long_name = 'initial world interest rate')
% === terminal values ===
PoPT_p ${PoP_0}$ (long_name = 'terminal population')
YT_p ${Y_T}$ (long_name = 'terminal output')
PT_p ${P_T}$ (long_name = 'terminal price level')
NT_p ${N_T}$ (long_name = 'terminal employment')
sH_p ${s^H}$ (long_name = 'share for housing investments')
;
