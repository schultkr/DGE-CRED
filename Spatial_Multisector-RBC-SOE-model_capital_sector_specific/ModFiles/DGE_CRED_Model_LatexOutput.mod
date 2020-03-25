% ===========================
% === Create Latex Output ===
% ===========================
write_latex_original_model;
movefile([M_.fname '_original.tex'], ['LatexFiles/' M_.fname '_original.tex']);
movefile([M_.fname '_original_content.tex'], ['LatexFiles/' M_.fname '_original_content.tex']);
write_latex_dynamic_model(write_equation_tags);
movefile([M_.fname '_dynamic.tex'], ['LatexFiles/' M_.fname '_dynamic.tex']);
movefile([M_.fname '_dynamic_content.tex'], ['LatexFiles/' M_.fname '_dynamic_content.tex']);
write_latex_definitions;
movefile([M_.fname '_latex_definitions.tex'], ['LatexFiles/' M_.fname '_latex_definitions.tex']);
