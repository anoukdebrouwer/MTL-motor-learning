% createTaskAnimationsMEMRI

% MIT License
% Copyright (c) 2020 Anouk de Brouwer

projectPath = '/Users/anouk/Documents/ExpsTablet/';

%% Reinforcement learning task

task = 'RL_MEMRI';
exampleSubject = 'S01';
exampleTrials = [91 92 93 94];

dataPath = [projectPath task '/2_ProcessedData/'];
subjFolder = dir([dataPath exampleSubject '*.mat']);
if ~isempty(subjFolder)
    createRLanimation([dataPath subjFolder.name],exampleTrials)
end

%% Visuomotor rotation task

task = 'VMR_MEMRI';
exampleSubject = 'S06';
exampleTrials = [41 42 44 46];

dataPath = [projectPath task '/2_ProcessedData/'];
subjFolder = dir([dataPath exampleSubject '*.mat']);
if ~isempty(subjFolder)
    createVMRanimation([dataPath subjFolder.name],exampleTrials,false)
end
