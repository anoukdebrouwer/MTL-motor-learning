function createMRIresultsTable_MEMRI(dataPath,saveToPath)
% createMRIresultsTable_MEMRI Create table with MRI results of MEMRI project
%
% createMRIresultsTable_MEMRI(dataPath,saveToPath) residualizes the MRI
% data in dataPath, adds demographics, and saves a table as .csv file in
% saveToPath.

% MIT License
% Copyright (c) 2020 Anouk de Brouwer

if nargin==0
    dataPath = '/Users/anouk/dropbox/MTL_Individual_Diffs_SHARED/';
    saveToPath = '/Users/anouk/dropbox/MTL_Individual_Diffs_SHARED/';
end

%% Residualize MRI data
% Correct volumes for total intracranial volume

% raw MRI data
T_MRI = readtable([dataPath 'table_MRI_noresid.csv'],'ReadRowNames',true);
rowInMRItable = T_MRI.rowInMRItable; % row in original MRI table

% residualize: correct for total intracranial volume
T_MRI_resid = residualizeMRIdata(T_MRI);

%% Add demographics to table

% load demographics
load([dataPath 'MEMRI tables/datatab_scoreDemographics.mat'])

% select and order subjects who performed motor learning tasks
D = result(rowInMRItable,:);

% add age and gender to MRI table
T_MRI_resid.age = D.General_Age;
m = cellfun(@(x) ~isempty(x),regexp(D.General_Gender,'Man'));
w = cellfun(@(x) ~isempty(x),regexp(D.General_Gender,'Woman'));
gender(m,1) = {'M'};
gender(w,1) = {'W'};
T_MRI_resid.gender = gender;

%% Save results table

% check if file exists
fileName = ['table_MRI_resid_' datestr(now,'yyyymm') '.csv'];
if exist([saveToPath fileName],'file') == 2 % check if file does not exist yet
    disp(['A file named ' fileName ' already exists.'])
    overwrite = input('Do you want to overwrite it? Yes(1) or no(0): ');
else
    overwrite = 1;
end

% save file
if overwrite == 1
    writetable([saveToPath fileName],'WriteRowNames',true);
    disp(['Saved ' saveToPath fileName])
else
    disp('Table has not been saved')
    keyboard
end
