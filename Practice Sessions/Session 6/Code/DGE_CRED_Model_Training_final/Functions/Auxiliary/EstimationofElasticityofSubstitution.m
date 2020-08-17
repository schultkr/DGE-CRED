% ================================================================
% === Estimation of elasticity of substitution between sectors ===
% ================================================================

sFileName = 'Regression Data.xlsx';
sSheetNameDependent = 'Dependent';
temp = readtable(sFileName, 'Sheet', 'Dependent');
temp = table2array(temp(:,2:end));
temp = temp(2:end,1:(end-1))./temp(2:end,end);
[iTime,iSectors] = size(temp);
Y_vec = log(temp(:));
temp = readtable(sFileName, 'Sheet', 'Independent');
temp = table2array(temp(:,2:end));
temp = temp(2:end,1:(end-1))./temp(2:end,end);
timefe = repmat(ones(iTime,1),1,iSectors)';
X_vec = [kron(eye(iSectors), ones(iTime,1)) log(temp(:))];
%
% beta_vec = (X_vec' * X_vec) \ X_vec' * Y_vec;
% resid_vec = Y_vec - X_vec * beta_vec;
% 
% sd_beta_vec = X_vec' * X_vec \ eye(iSec+1) * var(resid_vec);

[beta_vec,int_beta_vec, r, rint, stats] = regress(Y_vec, X_vec);

close;plot([r rint])
disp(['Elasticity of substitution is: ' num2str(-1/beta_vec(end), '%.2f') '[' num2str(-1/int_beta_vec(end,1),'%.2f') ', ' num2str(-1/int_beta_vec(end,2),'%.2f') ']' ])