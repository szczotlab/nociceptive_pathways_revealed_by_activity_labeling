function load_variables_from_mat_file(H)
% Prompts user for a .mat file and loads all variables in that file into
% the user data field of the current figure.
% If 'sequencing_data.mat' exists in the same folder as this script, it is
% loaded automatically instead of prompting the user.

% Get folder of the current script
scriptDir = fileparts(mfilename('fullpath'));
defaultFile = fullfile(scriptDir, 'deFaria_Carballo_Maidana_data.mat');

if exist(defaultFile, 'file') == 2
    % sequencing_data.mat found — load it directly
    disp('Loading sequencing_data.mat from script folder...');
    vars = load(defaultFile);
else
    % sequencing_data.mat not found — prompt user
    [file, path] = uigetfile('*.mat', 'Select .mat file');
    if isequal(file, 0)
        disp('No file selected');
        return;
    else
        vars = load(fullfile(path, file));
    end
end

% Store variables in user data of current figure
set(H, 'UserData', vars);
end