function [fval_vec,strys, strexo] = FindA(x,strys,strexo,strpar)
    % function [fval_vec,strys] = FindK(x,strys,strexo,strpar)
    % finds exogenous variables to fulfill output growth and 
    % labour supply.
    % Inputs: 
    %   - x         [vector]     vector of initial values for the steady state of
    %                            the regional and sctoral productivity shocks
    %   - strys     [structure]  structure containing all endogeonous variables of the model
    %   - strexo    [structure]  structure containing all exogeonous variables of the model    
    %   - strpar    [structure]  structure containing all parameters of the model
    %
    % Output: 
    %   - fval_vec  [vector] residuals of regional and sector specific for
    %                        FOC of Households with respect to regional labour
    %   - strys     [structure] see inputs
    x_1 = real(x(1:strpar.inbsectors_p.*strpar.inbregions_p));
    x_2 = real(x((strpar.inbsectors_p.*strpar.inbregions_p+1):(2.*strpar.inbsectors_p.*strpar.inbregions_p)));
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            icovec = icoreg + (icosec-1)*strpar.inbregions_p;
            strys.(['A_' ssec '_' sreg]) = real(x_1(icovec));
            strexo.(['exo_' ssec '_' sreg]) = log(strys.(['A_' ssec '_' sreg])/strpar.(['A_' ssec '_' sreg '_p']));
            strys.(['K_' ssec '_' sreg]) = real(x_2(icovec));
        end
    end

    %% find steady state
    options = optimset('Display', 'off', 'TolFun', 1e-20, 'TolX', 1e-20, 'MaxFunEval', 10000);
    xstart_vec = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            icovec = icoreg + (icosec-1)*strpar.inbregions_p;
            xstart_vec(icovec) = strys.(['K_' ssec '_' sreg]);
        end
    end
%     FindKtemp = @(x)FindK(x,strys,strexo,strpar);
%     [xopt, ~, ~, ~, ~] = fsolve(FindKtemp, xstart_vec, options);%, strys, strexo, strpar);
    [fval_vec_2,strys,strexo] = FindK(real(xstart_vec), strys, strexo, strpar);
    
    %% evaluate residuals of HH FOC w.r.t. labour in each region and sector
    fval_vec_1 = nan(strpar.inbsectors_p*strpar.inbregions_p,1);
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            icovec = icoreg + strpar.inbregions_p * (icosec-1);
            if icosec == 1 && icoreg == 1
                lhs_1 = strpar.YT_p;
                rhs_1 = strys.Y*strys.P;
            else
                lhs_1 = strpar.(['phiY_' ssec '_' sreg '_p']);
                rhs_1 = strys.(['Y_' ssec '_' sreg]) * strys.(['P_' ssec '_' sreg])./(strys.Y * strys.P);
            end           
            fval_vec_1(icovec) = 1 - lhs_1 ./ rhs_1;
        end
    end
    fval_vec = [fval_vec_1; fval_vec_2];
end