// Introduction to Dynare

// This mod-file is designed as supplementary material for part 1 of the slides
// "Dynamic General Equilibrium Model for Climate Resilient Economic Development".

// Parts of the code can be activated (deactivated) by removing (inserting) 
// the commands: (i) % (ii) // (iii) /* ... */

// Make sure that conflicting parts of the code are not activated simultanously.

% -------------------------------------------------------------------------

// Basic Settings:

// Declare variables and parameters:

    var c k;
    varexo A;
    parameters alpha_p beta_p sigma_p delta_p;

// Assign the parameter values:

    alpha_p = 0.5;
    beta_p = 0.95;
    sigma_p = 0.5;
    delta_p = 0.02;

// Declare the model inside the model block:

    model;
    c + k = A*k(-1)^alpha_p + (1-delta_p)*k(-1);
    c^(-sigma_p) = beta_p*c(+1)^(-sigma_p)*(alpha_p*A(+1)*k^(alpha_p-1) + 1 - delta_p);
    end;

// Alternatively, use model-local variables:
/*
    model;
    # lambda1 = c^(-sigma_p);
    # lambda2 = beta_p*c(+1)^(-sigma_p);
    c + k = A*k(-1)^alpha_p + (1-delta_p)*k(-1);
    lambda1 = lambda2 * (alpha_p*A(+1)*k^(alpha_p-1) + 1 - delta_p); 
    end;
*/

% -------------------------------------------------------------------------

// This section examines the most relevant application in the DGE-CRED
// framework: "Transition from an initial to a different terminal Steady State".

// The steady state file "Introduction_Dynare_steadystate.m" is used for the
// computation of the initial and terminal steady state. Make sure that this
// file is ON your MATLAB path.


    initval;
    A = 1;
    end; 
    steady;

    endval;
    A = 1.1;
    end;
    steady;


% -------------------------------------------------------------------------

// This section examines the three approaches to determine the steady 
// state in Dynare.

// Approach 1: initial guess for steady state
/*
    initval;
    c = 2;
    k = 30;
    A = 1;
    end;
    steady;
*/
// Note: Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is NOT on your MATLAB path. Otherwise it will be used for the steady state
// computation.

// Approach 2: Steady State Model Block
/*
    initval;
    A = 1;
    end;

    steady_state_model;
    k = ((1-beta_p*(1-delta_p))/(beta_p*alpha_p*A))^(1/(alpha_p-1));
    c = A*k^alpha_p-delta_p*k;
    end;
    steady;
*/
// Again: Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is NOT on your MATLAB path. Otherwise it will be used for the steady state
// computation.

// Approach 3: Use steady state file "Introduction_Dynare_steadystate.m"
/*
    initval;
    A = 1;
    end;
    steady;
*/
// This time: Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is ON your MATLAB path.

% -------------------------------------------------------------------------

// The purpose of the following three example is solely to illustated the usage 
// of the initval block. They do not necessarily adress meaningful questions.

// Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is NOT on your MATLAB path. Otherwise it will be used for the steady state
// computation.

// Only an initval block: Initial and terminal condition are the same.
/*
    initval;
    c = 4;
    k = 20;
    A = 1;
    end;
*/

// Initval and enval block: Different initial and terminal conditions.
/*
    endval;
    c = 4;
    k = 20;
    A = 1;
    end;

    endval;
    c = 6;
    k = 30;
    A = 1;
    end;
*/

// Initval and histval block: Different initial and terminal conditions. In 
// this case this is the same as having an initval and endval block.
/*
    initval;
    c = 4;
    k = 20;
    A = 1;
    end;

    endval;
    c = 6;
    k = 30;
    A = 1;
    end;
*/

% -------------------------------------------------------------------------

// More examples (same as on the slides):

// Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is ON your MATLAB path before running the examples.

// Scenario 1: transition to steady state
/*
    initval;
    A = 1;
    end;
    steady;

    ik = varlist_indices('k',M_.endo_names);
    ic = varlist_indices('c',M_.endo_names);
    kstar = oo_.steady_state(ik);
    cstar = oo_.steady_state(ic);

    histval;
    A(0) = 1;
    k(0) = kstar/2;
    c(0) = cstar/2;
    end;
*/

// Scenario 2: temporary shock in period 1
/*
    initval;
    A = 1;
    end;
    steady;

    shocks;
    var A;
    periods 1;
    values 1.1;
    end;
*/

// Scenario 3: sequence of shocks
/*
    initval;
    A = 1;
    end;
    steady;

    shocks;
    var A;
    periods 5, 6:9;
    values 1.1, 1.05;
    end;
*/

// Scenario 4: permanent shock in period 6
/*
    initval;
    A = 1;
    end; 
    steady;

    endval;
    A = 1.1;
    end;
    steady;

    shocks;
    var A;
    periods 1:5;
    values 1;
    end;
*/

% -------------------------------------------------------------------------

// Conduct deterministic simulation using perfect foresight:

    perfect_foresight_setup(periods=100);
    perfect_foresight_solver;

// Alternatively use "simul":

    % simul(periods=1000);

% -------------------------------------------------------------------------

// Optional: plot graphs

    rplot c;
    rplot k;
    rplot A;
