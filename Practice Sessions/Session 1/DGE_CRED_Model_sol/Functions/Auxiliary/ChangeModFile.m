function ChangeModFile(sScenario,sSubsecstart,sSubsecend,sRegions)
    % function ChangeModFile(sScenario,sSubsecstart,sSubsecend,sRegions) to change the macroprocessor
    % variable YEndogenous
    % Inputs: 
    %   - sScenario    [character]  name of current scenario simulated
    %   - sSubsecstart [character]  first subsectors belonging to one aggregate sector
    %   - sSubsecend   [character]  last  subsector belonging to one aggregate sector
    %   - sRegions     [character]  number of regions in the model
	


    temp = fileread('DGE_CRED_Model.mod');
    temp = strsplit(temp, '\n');
    iposline = find(cellfun(@(x) contains(x,"@# define YEndogenous"), temp));
    if length(iposline) == 1 && iposline > 0 
        if isequal(sScenario, 'Baseline')
            temp{iposline} = '@# define YEndogenous = 0';
        else
            temp{iposline} = '@# define YEndogenous = 1';
        end
        [fid] = fopen('DGE_CRED_Model.mod', 'w');
        fwrite(fid, strjoin(temp, '\n'));
        fclose(fid);    
    else
        error('No unique match for @# define YEndogenous' )
    end
    

    iposline = find(cellfun(@(x) contains(x,"@# define Subsecstart"), temp));
    if length(iposline) == 1 && iposline > 0 
        temp{iposline} = ['@# define Subsecstart = ' sSubsecstart];
        [fid] = fopen('DGE_CRED_Model.mod', 'w');
        fwrite(fid, strjoin(temp, '\n'));
        fclose(fid);    
    else
        error('No unique match for @# define Subsecstart')
    end
    
    iposline = find(cellfun(@(x) contains(x,"@# define Subsecend"), temp));
    if length(iposline) == 1 && iposline > 0 
        temp{iposline} = ['@# define Subsecend = ' sSubsecend];
        [fid] = fopen('DGE_CRED_Model.mod', 'w');
        fwrite(fid, strjoin(temp, '\n'));
        fclose(fid);    
    else
        error('No unique match for @# define Subsecend')
    end    
    
    
    
    

    
    iposline = find(cellfun(@(x) contains(x,"@# define Regions"), temp));
    if length(iposline) == 1 && iposline > 0 
        temp{iposline} = ['@# define Regions = ' sRegions];
        [fid] = fopen('DGE_CRED_Model.mod', 'w');
        fwrite(fid, strjoin(temp, '\n'));
        fclose(fid);    
    else
        error('No unique match for @# define Regions')
    end    
    
    
    
    

end