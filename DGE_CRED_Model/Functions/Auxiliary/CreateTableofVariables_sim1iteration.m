tabvars = array2table(reshape(y, [ny periods])');
tabvars.Properties.VariableNames = cellstr(M.endo_names);
open tabvars

tabdvars = array2table(reshape(dy, [ny periods])');
tabdvars.Properties.VariableNames = cellstr(M.endo_names);
open tabdvars