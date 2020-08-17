// Title: Introduction to Dynare

// Content: This mod-file is designed as supplementary material for the part 
// "Introduction to Dynare" of the slides "Dynamic General Equilibrium Model 
// for Climate Resilient Economic Development".

// Parts of the code can be activated (deactivated) by removing (inserting) 
// the commands: (i) % (ii) // (iii) /* ... */

// Make sure that conflicting parts of the code are not activated simultanously.

% -------------------------------------------------------------------------

@# define ClimateVariable = 2
@# define ClimateCoefficient = [0.1054, 0]
// Section: Implementing a Model in Dynare

// Part: Variables and Parameters

    var c k 
    @# if ClimateVariable > 0
    D
    @# endif
    ;
    varexo A
    @# if ClimateVariable > 0
        @# for z in 1:ClimateVariable
            CV_@{z}
        @# endfor
    @# endif
    ;
    parameters alpha_p beta_p sigma_p delta_p inbCV_p
    @# if ClimateVariable > 0
        @# for z in 1:ClimateVariable
            theta_@{z}_p
        @# endfor
    @# endif
    ;

    alpha_p = 0.5;
    beta_p = 0.95;
    sigma_p = 0.5;
    delta_p = 0.02;
    inbCV_p = @{ClimateVariable};
    @# for z in 1:ClimateVariable
        theta_@{z}_p = @{ClimateCoefficient[z]};
    @# endfor
// Part: The model block

    model;
    #lamb = c^(-sigma_p);
    #lambp1 = c(+1)^(-sigma_p);
    @# if ClimateVariable > 0
        D = 1 - exp(-(
            @# for z in 1:ClimateVariable
                + CV_@{z} * theta_@{z}_p
            @# endfor
            ));
    @# endif
    c + k = A*(1 - D)*k(-1)^alpha_p + (1-delta_p)*k(-1);
        lamb = beta_p*lambp1*(alpha_p*A(+1)*(1 - D(+1))*k^(alpha_p-1) + 1 - delta_p);
    end;

% -------------------------------------------------------------------------


% -------------------------------------------------------------------------

// Section: Perfect Foresight Setup in Dynare
initval;
A = 1;
CV_1 = 0;
end; 
steady;
check;


endval;
A = 1;
CV_1 = 1;
end;
steady;
check;

shocks;
var CV_1;
periods 1:9 10:19 20:29 30:39 40:49 50:59 60:69 70:79 80:89 90:99;
values 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9;
end;
// Note: Deactivate this section if only the steady state should be computed.

// Conduct deterministic simulation using perfect foresight:

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

dyn2vec(M_,oo_,options_);
// Optional: plot graphs
rplot c;
rplot k;
