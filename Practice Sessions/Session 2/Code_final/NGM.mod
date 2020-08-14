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

    var c k lamb;
    varexo A;
    parameters alpha_p beta_p sigma_p delta_p;

    alpha_p = 0.5;
    beta_p = 0.95;
    sigma_p = 0.5;
    delta_p = 0.02;

// Part: The model block

    model;
    lamb = c^(-sigma_p);
    c + k = A*k(-1)^alpha_p + (1-delta_p)*k(-1);
    lamb = beta_p*lamb(+1)*(alpha_p*A(+1)*k^(alpha_p-1) + 1 - delta_p);
    end;

% -------------------------------------------------------------------------


% -------------------------------------------------------------------------

// Section: Perfect Foresight Setup in Dynare

initval;
A = 1;
end; 
steady;
check;


endval;
A = 1.1;
end;
steady;
check;


// Note: Deactivate this section if only the steady state should be computed.

// Conduct deterministic simulation using perfect foresight:

perfect_foresight_setup(periods=100);
perfect_foresight_solver;


// Optional: plot graphs

rplot c;
rplot k;
rplot A;
