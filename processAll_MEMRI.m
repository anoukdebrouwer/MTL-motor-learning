% processAll_MEMRI

% MIT License
% Copyright (c) 2020 Anouk de Brouwer

tabletPath = '/Users/anouk/Documents/ExpsTablet/';
sharedPath = '/Users/anouk/dropbox/MTL_Individual_Diffs_SHARED/';

%% Process VMR task data

% define path
projectPath = [tabletPath 'VMR_MEMRI/'];

% process raw data 
plotTrials = false; % set to true to plot each trial separately for visual inspection
processVMRtabletData(projectPath,plotTrials);

% calculate and plot individual subject results
processData = true;
createPlots = true;
savePlots = true;
calcIndResultsVMRgaze(projectPath,processData,createPlots,savePlots)

% combine individual subject results into a single datafile
meanOrMedian = 1;
createPlots = true;
savePlots = true;
combineIndResultsVMRGaze(projectPath,meanOrMedian,createPlots,savePlots)

%% Process RL task data

% define path
projectPath = [tabletPath 'RL_MEMRI/'];

% process raw data
processRLtabletData(projectPath,plotTrials)

% calculate and plot individual subject results
processData = true;
createPlots = true;
savePlots = true;
calcIndResultsRL(projectPath,processData,createPlots,savePlots)

% combine individual subject results into a single datafile
meanOrMedian = 2;
createPlots = true;
savePlots = true;
combineIndResultsRL(projectPath,meanOrMedian,createPlots,savePlots)

%% Create table with VMR and RL scores

dataPath = tabletPath;
saveToPath = sharedPath;
createBehaviouralResultsTable_MEMRI(dataPath,saveToPath)

%% Get MRI data, residualize volumes, and create table

dataPath = sharedPath;
saveToPath = sharedPath;
createMRIresultsTable_MEMRI(dataPath,saveToPath)
