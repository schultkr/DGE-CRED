% Climate Change Scenarios for the DGE-CRED Model
% Required settings for Octave.

% Content of this file: 

% Part 1: Install packages
% Part 2: Load packages

%% Part 1: Install packages

if (isoctave() == 1) && (strcmp(install_packages, 'yes') == 1)
    pkg install -forge io
    pkg install -forge optim
    pkg install -forge statistics
    pkg install -forge struct
end

%% Part 2: Load packages

if (isoctave() == 1) && (strcmp(load_packages, 'yes') == 1)
    pkg load io
    pkg load optim
    pkg load statistics
    pkg load struct
end
