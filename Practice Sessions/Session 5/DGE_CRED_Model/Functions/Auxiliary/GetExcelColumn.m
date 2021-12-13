function sColumn = GetExcelColumn(ipos)
% Function finds the alphabetical escel column for an integer.
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