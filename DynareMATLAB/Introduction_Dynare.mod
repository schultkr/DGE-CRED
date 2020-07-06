// Title: Introduction to Dynare

// Content: This mod-file is designed as supplementary material for the part 
// "Introduction to Dynare" of the slides "Dynamic General Equilibrium Model 
// for Climate Resilient Economic Development".

// Parts of the code can be activated (deactivated) by removing (inserting) 
// the commands: (i) % (ii) // (iii) /* ... */

// Make sure that conflicting parts of the code are not activated simultanously.

% -------------------------------------------------------------------------

// Section: Implementing a Model in Dynare

// Part: Variables and Parameters

    var c k;
    varexo A;
    parameters alpha_p beta_p sigma_p delta_p;

    alpha_p = 0.5;
    beta_p = 0.95;
    sigma_p = 0.5;
    delta_p = 0.02;

// Part: The model block

    model;
    c + k = A*k(-1)^alpha_p + (1-delta_p)*k(-1);
    c^(-sigma_p) = beta_p*c(+1)^(-sigma_p)*(alpha_p*A(+1)*k^(alpha_p-1) + 1 - delta_p);
    end;

// Alternatively, model block with model-local variables:
/*
    model;
    # lambda1 = c^(-sigma_p);
    # lambda2 = beta_p*c(+1)^(-sigma_p);
    c + k = A*k(-1)^alpha_p + (1-delta_p)*k(-1);
    lambda1 = lambda2 * (alpha_p*A(+1)*k^(alpha_p-1) + 1 - delta_p); 
    end;
*/

% -------------------------------------------------------------------------

// Section: Steady State in Dynare 

// Note: Deactivated the last section of this code if only the steady state 
// should be computed.

// Approach 1: Initial guess for Steady State

// Note: Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is NOT on your MATLAB path. Otherwise it will be used for the steady state
// computation.
/*
    initval;
    c = 2;
    k = 30;
    A = 1;
    end;
    steady;
*/

// Approach 2: Steady State Model Block

// Again: Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is NOT on your MATLAB path. Otherwise it will be used for the steady state
// computation.
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

// Approach 3: Use steady state file "Introduction_Dynare_steadystate.m"

// This time: Make sure that the steady state file "Introduction_Dynare_steadystate.m"
// is ON your MATLAB path.
/*
    initval;
    A = 1;
    end;
    steady;
*/

% -------------------------------------------------------------------------

// Section: Perfect Foresight Setup in Dynare

// The steady state file "Introduction_Dynare_steadystate.m" is used for 
// the computation of the steady state. Make sure that this file is ON your 
// MATLAB path.

// Part: Transition from an Initial to a Terminal Steady State
/*
    initval;
    A = 1;
    end; 
    steady;

    endval;
    A = 1.1;
    end;
    steady;
*/

// Part: The initval block
/*
    initval;
    c = 4;
    k = 20;
    A = 1;
    end;
*/

// Part: The endval block
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

// Part: The histval block
/*
    histval;
    c(0) = 4;
    k(0) = 20;
    A(0) = 1;
    end;

    initval;
    c = 6;
    k = 30;
    A = 1;
    end;
*/

// Part: Shocks on Exogenous Variables - Example No. 1
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

// Part: Shocks on Exogenous Variables - Example No. 2
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

% -------------------------------------------------------------------------

// Section: Remarks and Examples

// The steady state file "Introduction_Dynare_steadystate.m" is used for 
// the computation of the steady state. Make sure that this file is ON your 
// MATLAB path.

// Part: Example No. 1
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
// Part: Example No. 2
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

// Note: Deactivate this section if only the steady state should be computed.

// Conduct deterministic simulation using perfect foresight:

    perfect_foresight_setup(periods=100);
    perfect_foresight_solver;

// Alternatively use "simul":

    % simul(periods=100);

// Optional: plot graphs

    rplot c;
    rplot k;
    rplot A;
