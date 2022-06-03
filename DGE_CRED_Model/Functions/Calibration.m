function [fval_vec,strpar,strys] = Calibration(x,strys,strexo,strpar)
    % function [ys,check] = Calibration(strys,strexo,strpar)
    % calibrates the parameters of the DGE_CRED_Model.mod
    % Inputs: 
    %   - strys     [structure]  endogeonous variables of the model
    %   - strexo    [structure]  exogeonous variables of the model    
    %   - strpar    [structure]  parameters of the model
    %
    % Output: 
    %   - fval_vec  [numeric]    difference between demand and supply
    %                            for imports for a given national 
    %                            price level
    %   - strys     [structure]  see inputs
    %   - strpar    [structure]  see inputs
	

    % assign initial value for national price level
    strys.P = x;
    
    % update parameter value for initila price level
    strpar.P0_p = strys.P;

    %% calculate exogenous variables
    [strys,strpar, strexo] = AssignPredeterminedVariables(strys,strpar,strexo);
    
    
    % assign value for initial gross vlaue added
    strys.Y = strpar.Y0_p./strys.P; 
    
    % compute foreign interest rate
    strys.rf = 1/strpar.beta_p-1; 
    
    % compute foreeing interest rate
    strpar.rf0_p = 1/strpar.beta_p-1; 
    
    % assign value for effective exchange rate
    strys.Sf = 0;
    
    % population
    strys.PoP = strpar.PoP0_p * exp(strexo.exo_PoP);
    
    % housing area
    strys.H = strpar.H0_p * strys.PoP;
    
    % hours worked as share of total available hours
    strys.N = strpar.N0_p;
    
    if strpar.iGAH_p == 0
        % adaptation measures in the housing sector
        strys.G_A_DH = strexo.exo_G_A_DH * strpar.Y0_p / strpar.P0_p;
    end

    %% calculate sectoral and regional production factors and output
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
    
        % sectoral interat rate
        strys.(['r_' ssec]) = (1/strpar.beta_p - 1 ...
                               + strpar.delta_p)/(1 - strys.tauKH); 
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);    
        
            % subsectoral interat rate
            strys.(['r_' ssec '_' sreg]) = (1/strpar.beta_p - 1 + strpar.delta_p)/(1 - strys.tauKH);           
            
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);            
                
                % labour productivity
                strys.(['A_N_' ssubsec '_' sreg]) = strpar.(['A_N_' ssubsec '_' sreg '_p']);
                
                % sectoral productivity
                strys.(['A_' ssubsec '_' sreg]) = strpar.(['A_' ssubsec '_' sreg '_p']);
                
                % initial allocation of hours wotked 
                strys.(['N_' ssubsec '_' sreg]) = strpar.(['phiN0_' ssubsec '_' sreg '_p']) * strys.N;
            end
        end
    end
    
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        % intitialize sectoral capital stock
        strys.(['KH_' ssec]) = 0; 
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                % intitialize sectoral and regional capital stock
                strys.(['KH_' ssec '_' sreg]) = 0;
                
                for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                    ssubsec = num2str(icosubsec);                 
                    stemp = [ssubsec '_' sreg];
                    
                    % degree of substitutability beween capital and labour
                    rhotemp = ((strpar.(['etaNK_' ssubsec '_' sreg '_p'])-1)/strpar.(['etaNK_' stemp '_p']));
                    
                    % interest rate including taxes 
                    rkgross = strys.(['r_' ssec '_' sreg]) * (1 + strys.(['tauKF_' stemp]));
                    
                    %Differentiate between Cobb Douglas or CES
                    if strpar.(['etaNK_' stemp '_p']) == 1
                        % subsectoral and regional real labour costs
                        wtemp = (((1 - strys.(['D_' stemp])) * strys.(['A_' stemp])) / ...
                        (rkgross / ((1 - strpar.(['phiW_' stemp '_p']))...
                        * strys.(['A_K_' stemp])))^(1-strpar.(['phiW_' stemp '_p'])))^(1/strpar.(['phiW_' stemp '_p'])) * ...
                        strys.(['A_N_' stemp]) * (1 -  strys.(['D_N_' stemp]));
                    
                    else
                        % subsectoral and regional real labour costs
                        wtemp = ((((1 - strys.(['D_' stemp])) * strys.(['A_' stemp]))^(1/strpar.(['etaNK_' stemp '_p']))...
                        - (1 - strpar.(['phiW_' stemp '_p'])) * (rkgross/strys.(['A_K_' stemp]))^(strpar.(['etaNK_' stemp '_p'])-1))...
                        / strpar.(['phiW_' stemp '_p']))^(1/(strpar.(['etaNK_' stemp '_p'])-1))...
                        * strys.(['A_N_' stemp]) * (1 -  strys.(['D_N_' stemp]));                         
                    
                    end
                    % price level for gross value added
                    strys.(['P_' stemp]) = strpar.(['phiW_' stemp '_p'])/wtemp * strpar.(['phiY_' stemp '_p']) * strys.Y *strys.P /(strys.PoP * strys.(['N_' stemp]));
                                        
                    % distribtuion parameter for capital in production function
                    strpar.(['alphaK_' stemp '_p']) = (1 - strpar.(['phiW_' stemp '_p'])) * (rkgross/ ((1 - strys.(['D_' stemp])) * strys.(['A_' stemp]) * strys.(['A_K_' stemp]) * (1 - strys.(['D_K_' stemp]))))^(strpar.(['etaNK_' stemp '_p'])-1);
                    
                    % distribtuion parameter for labour in production function
                    strpar.(['alphaN_' stemp '_p']) = strpar.(['phiW_' stemp '_p']) *  (wtemp/(((1 - strys.(['D_N_' stemp])) * strys.(['A_N_' stemp]) * (1 - strys.(['D_' stemp])) * strys.(['A_' stemp]))))^(strpar.(['etaNK_' stemp '_p'])-1);
                    
                    % real gross value adde in the subsector and region
                    strys.(['Y_' stemp]) = strpar.(['phiY_' stemp '_p']) * strys.Y *strys.P / strys.(['P_' stemp]);
                    
                    % capital stock used in the subsector and region
                    strys.(['K_' stemp]) = (1 - strpar.(['phiW_' stemp '_p'])) * strys.(['Y_' stemp]) / rkgross;
                    
                    % compute TFP
                    if strpar.(['etaNK_' stemp '_p']) == 1
                        strys.(['A_' stemp]) = strys.(['Y_' stemp]) / ((1 - strys.(['D_' stemp])) *  (strys.(['A_K_' stemp]) * strys.(['K_' stemp]))^strpar.(['alphaK_' stemp '_p']) * (strys.PoP * strys.(['A_N_' stemp]) * (1 - strys.(['D_N_' stemp])) * strys.(['N_' stemp]))^strpar.(['alphaN_' stemp '_p']));
                    else
                        strys.(['A_' stemp]) = strys.(['Y_' stemp]) /((1 - strys.(['D_' stemp])) * (strpar.(['alphaK_' stemp '_p'])^(1/strpar.(['etaNK_' stemp '_p'])) * (strys.(['A_K_' stemp]) * strys.(['K_' stemp]))^rhotemp + strpar.(['alphaN_' stemp '_p'])^(1/strpar.(['etaNK_' stemp '_p'])) * (strys.PoP * strys.(['A_N_' stemp]) * (1 - strys.(['D_N_' stemp])) * strys.(['N_' stemp]))^rhotemp)^(1/rhotemp));
                    end
                    
                    % compute capital stock in the sector and region
                    strys.(['KH_' ssec '_' sreg]) = strys.(['KH_' ssec '_' sreg]) + strys.(['K_' stemp]) * strys.(['P_' stemp]) / strys.P;                   
                    
                    % wages in the subsector and region
                    strys.(['W_' stemp]) = strpar.(['phiW_' stemp '_p']) * strys.(['Y_' stemp]) * strys.(['P_' stemp]) / (strys.PoP * strys.(['N_' stemp]) * (1 + strys.(['tauNF_' stemp])));
                    
                    % demand for intermediate propducts in the subsector and region
                    strys.(['Q_I_' stemp]) = strys.(['Y_' stemp]) * strys.(['P_' stemp])  / strys.P * strpar.(['phiQI_' ssubsec '_p']) / (1 - strpar.(['phiQI_' ssubsec '_p']));          
                    
                    % auxiliary variable to compute distribution parameter
                    tempQI = strys.P^strpar.(['etaI_' ssubsec '_p']) * strys.(['Q_I_' stemp]);
                    
                    % auxiliary variable to compute distribution parameter
                    tempY = strys.(['P_' stemp])^strpar.(['etaI_' ssubsec '_p']) * strys.(['Y_' stemp]);
                    
                    % compute distribution parameter for production function for intermedate products
                    strpar.(['omegaQI_' stemp '_p']) = tempQI / (tempY + tempQI);
                    
                    % compute price of products produced in the region and subsector
                    strys.(['P_D_' stemp]) = (strpar.(['omegaQI_' stemp '_p']) * strys.P^(1 - strpar.(['etaI_' ssubsec '_p'])) + (1 - strpar.(['omegaQI_' stemp '_p']))...
                        * strys.(['P_' stemp])^(1 - strpar.(['etaI_' ssubsec '_p'])))^(1/(1 - strpar.(['etaI_' ssubsec '_p'])));
                                       
                    % compute output in the region and subsector
                    strys.(['Q_' stemp]) = (strys.(['P_' stemp]) * strys.(['Y_' stemp]) + strys.P * strys.(['Q_I_' stemp]))/strys.(['P_D_' stemp]);
                    
                end
                
                % Lagrange multiplier for investment
                strys.(['omegaI_' ssec '_' sreg]) = strys.P;
                
                
                % compute sectoral and regional investment
                strys.(['I_' ssec '_' sreg]) = (strpar.delta_p) * strys.(['KH_' ssec '_' sreg]) + strys.(['D_K_' ssec '_' sreg]);            
                
                % compute sectoral capital stock
                strys.(['KH_' ssec]) = strys.(['KH_' ssec]) + strys.(['KH_' ssec '_' sreg]);            
            end
    end
    
    %% calculate sectoral and regional price indices and sectoral aggregates
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);      
        iasubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p']);
        for icosubsec = iasubsec
            ssubsec = num2str(icosubsec);
            
            % initialize subsectoral aggregate of employment
            strys.(['N_' ssubsec]) = 0;
            
            % intitalize subsectoral price index
            strys.(['P_D_' ssubsec]) = 0;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                
                % compute distribution parameters across regions in one subsector sectors
                temp = 0;
                tempdenom = (strys.(['P_D_' ssubsec '_' sreg]) /((strys.(['Q_' ssubsec '_' sreg]))^(-1/strpar.(['etaQ_' ssubsec '_p']))))^(strpar.(['etaQ_' ssubsec '_p']));
                for icoregm = 1:strpar.inbregions_p
                    sregm = num2str(icoregm);
                    % compute numerator for distribution parameters across regions in one subsector
                    tempnum = (strys.(['P_D_' ssubsec '_' sregm]) / ((strys.(['Q_' ssubsec '_' sregm]))^(-1/strpar.(['etaQ_' ssubsec '_p']))))^(strpar.(['etaQ_' ssubsec '_p']));
                    
                    
                    temp = temp + tempnum / tempdenom;
                end
                % distribution parameters across regions in one subsector sectors
                strpar.(['omegaQ_' ssubsec '_' sreg '_p']) = 1/temp;
                
                % aggregate labour across region in one sbsector
                strys.(['N_' ssubsec]) = strys.(['N_' ssubsec]) + strys.(['N_' ssubsec '_' sreg]);               
                
                % aggregate price index across region in one sbsector
                strys.(['P_D_' ssubsec]) = strys.(['P_D_' ssubsec]) + strpar.(['omegaQ_' ssubsec '_' sreg '_p']) * strys.(['P_D_' ssubsec '_' sreg])^(1 - strpar.(['etaQ_' ssubsec '_p']));
            end
            
            % aggregate price index across region in one sbsector
            strys.(['P_D_' ssubsec]) = strys.(['P_D_' ssubsec])^(1/(1 - strpar.(['etaQ_' ssubsec '_p'])));
                        
            % update intital aggregate price index across region in one sbsector
            strpar.(['P_D_' ssubsec '_p']) = strys.(['P_D_' ssubsec]);

            if strpar.iGAH_p == icosubsec
                % adaptation measures in the housing sector
                strys.G_A_DH = strexo.exo_G_A_DH * strpar.Y0_p / (strpar.P0_p * strpar.(['P_D_' ssubsec '_p']));
            end            
            
            % inititlalize gross value added
            strys.(['Y_' ssubsec]) = 0;
            
            % inititlalize output
            strys.(['Q_' ssubsec]) = 0;

            % inititlalize gross vlaue added            
            strys.(['Q_I_' ssubsec]) = 0;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                % aggregate gross value added
                strys.(['Y_' ssubsec]) = strys.(['Y_' ssubsec]) + strys.(['P_' ssubsec '_' sreg]) * strys.(['Y_' ssubsec '_' sreg]);
                
                % aggregate output
                strys.(['Q_' ssubsec]) = strys.(['Q_' ssubsec]) + strys.(['P_D_' ssubsec '_' sreg]) / strys.(['P_D_' ssubsec]) * strys.(['Q_' ssubsec '_' sreg]);
                
                % aggregate inermediate input
                strys.(['Q_I_' ssubsec]) = strys.(['Q_I_' ssubsec]) + strys.(['Q_I_' ssubsec '_' sreg]);
            end
            
            % compute sub-sectoral exports 
            strys.(['X_' ssubsec]) = strys.(['Q_' ssubsec]) * strpar.(['phiX_' ssubsec '_p']);       

            strys.(['GA_direct_' ssubsec]) = 0;
            for icosecm = 1:strpar.inbsectors_p
                ssecm = num2str(icosecm);      
                iasubsecm = strpar.(['substart_' ssecm '_p']):strpar.(['subend_' ssecm '_p']);
                for icosubsecm = iasubsecm
                    ssubsecm = num2str(icosubsecm);
                    for icoreg = 1:strpar.inbregions_p
                        sreg = num2str(icoreg);
                        if strpar.(['iGA_' ssubsecm '_p']) == icosubsec
                            strys.(['K_A_' ssubsecm '_' sreg]) = strexo.(['exo_GA_' ssubsecm '_' sreg]) * strpar.Y0_p / (strys.P * strpar.(['P_D_' ssubsec '_p']));
                            strys.(['G_A_' ssubsecm '_' sreg]) = strpar.(['deltaKA_' ssubsecm '_' sreg '_p']) * strys.(['K_A_' ssubsecm '_' sreg]);
                        end
                        strys.(['GA_direct_' ssubsec]) = strys.(['GA_direct_' ssubsec]) + (strpar.(['iGA_' ssubsecm '_p'])==icosubsec) * strys.(['G_A_' ssubsecm '_' sreg]);
                    end
                end
            end            
            
            % compute sub-sectoral output used domestically
            strys.(['Q_D_' ssubsec]) = strys.(['Q_' ssubsec]) - strys.(['X_' ssubsec]) - strys.(['GA_direct_' ssubsec]) * strys.P - (strpar.iGAH_p == icosubsec) * strys.G_A_DH * strys.P;       
            
            % compute sub-sectoral exports share
            strys.(['D_X_' ssubsec]) = strys.(['X_' ssubsec]) / strys.(['Q_' ssubsec]);
            
            % update exports share parameter
            strpar.(['D_X_' ssubsec '_p']) = strys.(['X_' ssubsec]) * (strys.(['P_D_' ssubsec])/strys.(['P_M_' ssubsec]))^(strpar.etaX_p) ;
            

        end
    end
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        
        % initiliaze sectoral aggregate investment
        strys.(['I_' ssec]) = 0;
        
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            
            % aggregate sectoral aggregate investment
            strys.(['I_' ssec]) = strys.(['I_' ssec]) + strys.(['I_' ssec '_' sreg]) ;
        end
        
        % initialize sectoral aggregate output
        strys.(['Q_A_' ssec]) = 0;
        
        % initialize sectoral aggregate price level
        strys.(['P_A_' ssec]) = 0;
        
        
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            temp= 0;
            % compute auxiliary expression to compute distribution
            % parameters across subsectors in one sector (denominator)
            tempdenom = (strys.(['P_D_' ssubsec]) /((strys.(['Q_D_' ssubsec]))^(-1/strpar.(['etaQA' '_' ssec '_p']))))^(strpar.(['etaQA' '_' ssec '_p']));
            for icosubsecm = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                    ssubsecm = num2str(icosubsecm);
                    % compute auxiliary expression to compute distribution
                    % parameters across subsectors in one sector (numerator)
                    tempnum = (strys.(['P_D_' ssubsecm]) /((strys.(['Q_D_' ssubsecm]))^(-1/strpar.(['etaQA' '_' ssec '_p']))))^(strpar.(['etaQA' '_' ssec '_p']));
                    % compute inverse distribution parameters across subsectors in one sector
                    temp = temp + tempnum / tempdenom;
            end
            
            % compute distribution parameters across subsectors in one sector
            strpar.(['omegaQ_' ssubsec '_p']) = 1/temp;
            
            % initialize subsectoral capital stock
            strys.(['K_' ssubsec]) = 0;
            
            % initialize subsectoral wage level
            strys.(['W_' ssubsec]) = 0;
            
            for icoreg = 1:strpar.inbregions_p
                sreg = num2str(icoreg);
                % aggregate  subsectoral capital stock
                strys.(['K_' ssubsec]) = strys.(['K_' ssubsec]) + strys.(['P_' ssubsec '_' sreg]) / strys.P * strys.(['K_' ssubsec '_' sreg]) ;
                
                % aggregate  subsectoral wages
                strys.(['W_' ssubsec]) = strys.(['W_' ssubsec]) + strys.(['N_' ssubsec '_' sreg]) / strys.(['N_' ssubsec]) * strys.(['W_' ssubsec '_' sreg]) ;               
                
            end
            % aggregate  sectoral output
            strys.(['Q_A_' ssec]) = strys.(['Q_A_' ssec]) + strpar.(['omegaQ_' ssubsec '_p'])^(1/strpar.(['etaQA' '_' ssec '_p'])) * strys.(['Q_D_' ssubsec])^((strpar.(['etaQA' '_' ssec '_p'])-1)/strpar.(['etaQA' '_' ssec '_p']));
            
            % aggregate  sectoral price level
            strys.(['P_A_' ssec]) = strys.(['P_A_' ssec]) + strpar.(['omegaQ_' ssubsec '_p']) * strys.(['P_D_' ssubsec])^(1 - strpar.(['etaQA' '_' ssec '_p']));
        end
        
        % aggregate  sectoral price level
        strys.(['P_A_' ssec]) = strys.(['P_A_' ssec])^(1/(1 - strpar.(['etaQA' '_' ssec '_p'])));
        
        % aggregate  sectoral price level
        strys.(['Q_A_' ssec]) = strys.(['Q_A_' ssec])^(strpar.(['etaQA_' ssec '_p'])/(strpar.(['etaQA' '_' ssec '_p']) - 1));
        
        % initialize  subsectoral capital stock
        strys.(['K_' ssubsec]) = 0;
        
        % initialize  subsectoral wages
        strys.(['W_' ssubsec]) = 0;
        
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
            % aggregate  subsectoral capital stock
            strys.(['K_' ssubsec]) = strys.(['K_' ssubsec]) + strys.(['P_' ssubsec '_' sreg]) / strys.P * strys.(['K_' ssubsec '_' sreg]) ;

            % aggregate  subsectoral wages            
            strys.(['W_' ssubsec]) = strys.(['W_' ssubsec]) + strys.(['N_' ssubsec '_' sreg]) / strys.(['N_' ssubsec]) * strys.(['W_' ssubsec '_' sreg]) ;               
            
        end        
    end
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        % compute sectoral distribution parameters
        tempdenom = (strys.(['P_A_' ssec]) /((strys.(['Q_A_' ssec]))^(-1/strpar.etaQ_p)))^(strpar.etaQ_p);        
        
        temp= 0;
        
        for icosecm = 1:strpar.inbsectors_p
            ssecm = num2str(icosecm);
            % compute sectoral distribution parameters
            tempnum = (strys.(['P_A_' ssecm]) /((strys.(['Q_A_' ssecm]))^(-1/strpar.etaQ_p)))^(strpar.etaQ_p);
            
            % compute sectoral distribution parameters
            temp = temp + tempnum / tempdenom;
            
        end
        % compute sectoral distribution parameters
        strpar.(['omegaQA_' ssec '_p']) = 1/temp;
    end
    
    % compute domestic price level    
    strys.P_D = 0;
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        strys.P_D = strys.P_D + strpar.(['omegaQA_' ssec '_p']) * strys.(['P_A_' ssec])^(1 - strpar.etaQ_p) ;
    end
    strys.P_D = strys.P_D^(1/(1 - strpar.etaQ_p));
    
    % compute aggregates   
    [strys, strpar, strexo] = ComputeAggregates(strys, strpar, strexo);
    
    % compute import price level
    strys.P_M = strpar.P0_M_p;    
    
    % compute imports   
    strys.M = strpar.phiM_p * strys.Q * strys.P_D / strys.P_M;
    
    % compute used products
    strys.Q_U = (strys.M * strys.P_M + strys.Q_D * strys.P_D)/strys.P;

    % compute distribution parameter for imports
    strpar.omegaF_p = strys.M * strys.P_M^strpar.etaF_p / (strys.M * strys.P_M^strpar.etaF_p + strys.Q_D * strys.P_D^strpar.etaF_p);
    
    % compute subsector imports and import prices
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            
            if icosec == strpar.inbsectors_p && icosubsec == strpar.(['subend_' ssec '_p'])
                
                temp = strys.P_M^(strpar.etaM_p - 1);
                
                for icosecm = 1:strpar.inbsectors_p
                    ssecm = num2str(icosecm);
                    
                    if icosecm < strpar.inbsectors_p
                        for icosubsecm = strpar.(['substart_' ssecm '_p']):strpar.(['subend_' ssecm '_p'])
                            ssubsecm = num2str(icosubsecm);
                            
                            temp = temp - strpar.(['phiM_' ssubsecm '_p']) * strys.(['P_M_' ssubsecm])^(strpar.etaM_p-1);
                            
                        end
                    else
                        for icosubsecm = strpar.(['substart_' ssecm '_p']):(strpar.(['subend_' ssecm '_p'])-1)
                            ssubsecm = num2str(icosubsecm);
                            
                            temp = temp - strpar.(['phiM_' ssubsecm '_p']) * strys.(['P_M_' ssubsecm])^(strpar.etaM_p-1);
                            
                        end
                    end
                end
                strys.(['P_M_'  ssubsec]) = (temp / strpar.(['phiM_' ssubsec '_p']))^(1/(strpar.etaM_p-1));
                
            else
                strys.(['P_M_'  ssubsec]) = 0.9.*strys.P_M;%strpar.(['P_M_' ssec '_p']);
                
            end
            strpar.(['P_M_'  ssubsec '_p']) = strys.(['P_M_'  ssubsec]);
            
            strys.(['M_' ssubsec]) = strpar.(['phiM_' ssubsec '_p']) * strys.M * strys.P_M / strys.(['P_M_' ssubsec]);
        end
    end
    
    % compute distribution parameter for subsector imports
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
        for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
            ssubsec = num2str(icosubsec);
            
            temp = 0;
            
            tempdenom = strys.(['P_M_' ssubsec])^(strpar.etaM_p)  * strys.(['M_' ssubsec]);
            
            for icosecm = 1:strpar.inbsectors_p
                ssecm = num2str(icosecm);
                for icosubsecm = strpar.(['substart_' ssecm '_p']):strpar.(['subend_' ssecm '_p'])
                    ssubsecm = num2str(icosubsecm);
                    
                    tempnum = strys.(['P_M_' ssubsecm])^(strpar.etaM_p)  * strys.(['M_' ssubsecm]);
                    
                    temp = temp + tempnum / tempdenom;                   
                end
            end
            
            strpar.(['omegaM_' ssubsec '_p']) = 1/temp;
            
        end
    end
    
    % net exports 
    strys.NX = (strys.P_D * strys.X - strys.P_M * strys.M)/strys.P;
    
    strpar.NX0_p = strys.NX/strys.Y;
    
    % domesitcally used products 
    strys.Q_U = (strys.M * strys.P_M + strys.Q_D * strys.P_D)/strys.P;
    
    % compute tax income
    [strys,strpar, strexo] = TaxIncome(strys,strpar, strexo);  
    
    % foreign debt / (B > 0 debitor vs. B < 0 creditor)
    strys.B = -strys.NX/strys.rf - strys.BG;
    
    % lagrange multiplier for houses
    strys.omegaH = strys.PH * (1 + strys.tauH);
    
    % house prices
    strys.PH = strpar.sH_p * strys.P * strys.Y / (strpar.deltaH_p * strys.H * (1 + strys.tauH));
    
    % consumption
    strys.C = ((strys.P_D / strys.P * strys.Q - strys.NX - strys.Q_I  - strys.I - strys.wagetax  - strys.capitaltax - strys.PH / strys.P * strys.H * strpar.deltaH_p * (1 + strys.tauH) + strys.rf * strys.BG) / (1 + strys.tauC));
    
    % auxiliary variable to compute gamma
    tempgam = strys.H * strys.PH * (1 + strys.tauH) / (strys.C * strys.P * (1 + strys.tauC)) *  (1 - strpar.beta_p * (1 - strpar.deltaH_p)) / (strpar.beta_p);
    
    % preference parameter for houses to ensure housing share
    strpar.gamma_p = tempgam / (1 + tempgam);   
    
    % house price level
    strpar.PH0_p = strys.PH;
    
    % damages to houses induced by climate change
    strys.DH = strexo.exo_DH * strpar.Y0_p /strys.PH;
    
    % Lagrange multiplier of budget constraint HH
    strys.lambda = (1-strpar.gamma_p) * (strys.C/strys.PoP)^(-strpar.gamma_p) * (strys.H/strys.PoP)^strpar.gamma_p * ((strys.C/strys.PoP)^(1-strpar.gamma_p) * (strys.H/strys.PoP)^strpar.gamma_p)^(-strpar.sigmaC_p) / (strys.P * (1 + strys.tauC));
    
    % investment into housing 
    strys.IH = strpar.deltaH_p * strys.H;
    
    % government expenditure
    strys.G = (strys.wagetax + strys.capitaltax + strys.tauC * strys.C + strys.tauH * strys.PH/strys.P * strys.IH) - strys.rf * strys.BG - strys.adaptationcost;
    
    % public capital stock
    strys.KG = strys.G / strpar.deltaKG_p;
    
    %% compute labour disutlity parameters
    for icosec = 1:strpar.inbsectors_p
        ssec = num2str(icosec);
                
        for icoreg = 1:strpar.inbregions_p
            sreg = num2str(icoreg);
                       
            for icosubsec = strpar.(['substart_' ssec '_p']):strpar.(['subend_' ssec '_p'])
                ssubsec = num2str(icosubsec);
                
                strpar.(['phiL_' ssubsec '_' sreg '_p']) =  (1 - strys.tauNH) * strys.(['W_' ssubsec '_' sreg]) * strys.lambda / (strys.(['A_N_' ssubsec '_' sreg]) *strys.(['N_' ssubsec '_' sreg])^(strpar.sigmaL_p));
                
                strpar.(['A_' ssubsec '_' sreg '_p']) = strys.(['A_' ssubsec '_' sreg]) ./ (strys.KG^strpar.phiG_p * exp(strexo.(['exo_' ssubsec '_' sreg])));
                
            end
        end
    end
    % check initial guess for price levle and implied one
    fval_vec = 1 - strys.P / ((1 - strpar.omegaF_p) * strys.P_D^(1 - strpar.etaF_p) + (strpar.omegaF_p) * strys.P_M^(1 - strpar.etaF_p))^(1/(1 - strpar.etaF_p));
        
end