function sColumn = GetExcelColumn(ipos)
    % function sColumn = GetExcelColumn(ipos)
    % finds the corresponding alphanumerical repsentation of a column in excel for ipos
    %
    % Inputs: 
    %   - ipos 		[integer] 	column
    %
    % Output: 
    %   - sColumn 	[character] excel column
	%
	
    Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    ipostemp = ipos;
    sColumn = '';
    while (ipostemp-length(Alphabet))>0
        if ipostemp > length(Alphabet)
            iposletter = ipostemp - (ceil(ipostemp/length(Alphabet))-1) * length(Alphabet);
        else
            iposletter = ipostemp - (ceil(ipostemp/length(Alphabet))-1) * length(Alphabet);
        end
        sColumn = [Alphabet(iposletter) sColumn]; %#ok  
        ipostemp = ceil(ipostemp/length(Alphabet))-1;
    end
    sColumn = [Alphabet(ipostemp) sColumn];    
end