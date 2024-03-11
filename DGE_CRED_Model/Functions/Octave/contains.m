function res = contains(str, sub)
res = 0;

strCharsCount = length(str);
subCharsCount = length(sub);

startCharSub = sub(1);

% loop over character of main straing
for ic = 1:strCharsCount
    currentChar = str(ic);
    % if a substring starts from current character
    if (currentChar == startCharSub)
        %fprintf('Match! %s = %s\n', currentChar, startCharSub);

        matchedCharsCount = 1;
        % loop over characters of substring
        for ics = 2:subCharsCount
            nextCharIndex = ic + (ics - 1);
            % if there's enough chars in the main string
            if (nextCharIndex <= strCharsCount)
                nextChar = str(nextCharIndex);
                nextCharSub = sub(ics);
                if (nextChar == nextCharSub)
                    matchedCharsCount = matchedCharsCount + 1;
                end
            end
        end

        %fprintf('Matched chars = %d / %d\n', matchedCharsCount, subCharsCount);

        % the substring is inside the main one
        if (matchedCharsCount == subCharsCount)
            res = 1;
        end
    end
end

