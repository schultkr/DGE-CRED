function sAddress = FindExcelCell(iCol)
    iColUpdate = iCol+1;
    casletters = 'A':'Z';
    iLetter = length(casletters);
    sAddress = '';
    while iColUpdate > 0
        ipos = iColUpdate - iLetter * (ceil(iColUpdate/iLetter)-1);
        iColUpdate = ceil(iColUpdate/iLetter)-1;
        sLetter = casletters(ipos); 
        sAddress = [sLetter sAddress];%#ok
    end
end