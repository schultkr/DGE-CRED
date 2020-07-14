% Climate Change Scenarios for the DGE-CRED Model
% First Step: Mapping between regions and provinces.          

%% Mapping:

% Upload data:
[num,DATA_mapping,raw] = xlsread('Input_Climate_Change_Scenarios.xlsx', 'define regions');

% Settings:
max_provinces = size(DATA_mapping,1) - 1;
REGIONS = size(DATA_mapping,2) - 1;
% Create logical:
logical = NaN(size(DATA_mapping));
for i = 1:size(DATA_mapping,1)
  for ii = 1:size(DATA_mapping,2)
      logical(i,ii) = isempty(DATA_mapping{i,ii});
  end
end
% Conduct mapping:
for i = 1:(size(DATA_mapping,2) - 1)
    region(i).name = char(DATA_mapping{1,1+i});
    region(i).number_of_provinces = 0;
    for ii = 1:max_provinces
        if  logical(1+ii,1+i) == 0
            region(i).number_of_provinces = region(i).number_of_provinces + 1;
        end
    end
    region(i).provinces = cell(1,region(i).number_of_provinces);
    for z = 1:region(i).number_of_provinces
        region(i).provinces{1,z} = char(DATA_mapping{1+z,1+i});
    end
end
PROVINCES = sum([region(:).number_of_provinces]); 
          