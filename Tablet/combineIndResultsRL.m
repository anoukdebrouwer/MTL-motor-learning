function combineIndResultsRL(projectPath,meanOrMedian,createPlots,savePlots)
% combineIndResultsRL Process individual data of RL experiments and
% combine into a group data file.
%
% in progress, not on Github yet

% MIT License
% Copyright (c) 2020 Anouk de Brouwer

if nargin==0
    projectPath = [];
    meanOrMedian = 2;
    createPlots = false;
    savePlots = false;
end

% select project data path
if isempty(projectPath)
    projectPath = '/Users/anouk/Documents/ExpsTablet/';
    expFolder = selectFiles([projectPath '*RL*'],'folders');
    projectPath = [projectPath expFolder.name '/'];
end
% check if we are at the right level
while ~exist([projectPath '/1_RawData/'],'dir');
    expFolder = selectFiles(projectPath,'folders'); % look in subfolders
    projectPath = [projectPath expFolder.name '/'];
end
expName = getFolderName(projectPath);
% define input and output data path
dataPath = [projectPath '/3_Results/'];
saveToPath = [projectPath '/3_Results/'];
cd(dataPath)

% select subject data files
subjFiles = selectFiles('S*.mat');
nSubj = length(subjFiles);
subj = cell(nSubj,1);

% load experiment details - TO DO: create details file
nTrials = 20;
nBlocks = 13;

% set parameters for analysis
iScore = 11:20; % attempts over which median score is taken
scoreBins = [0,50,75,101]; % edges of bins in which score is binned
nBins = length(scoreBins)-1;

% open figure
fig1 = scaledFigure(1.5,1);
matlabcolors = get(gca,'colororder');

% preallocate
avgLearning_single = NaN(nTrials,nSubj);
avgLearning_double = NaN(nTrials,nSubj);
mScore_block = NaN(nSubj,nBlocks);
%linfit_blocks_single = NaN(nSubj,2);
%linfit_blocks_double = NaN(nSubj,2);
%linfit_blocks_all = NaN(nSubj,2);
scoreBins_path = NaN(nSubj,length(scoreBins));
count_scoreBin = NaN(nSubj,nBins);
mPathChange_scoreBin = NaN(nSubj,nBins);

%% Loop over subjects

for s = 1 : nSubj
    
    load(subjFiles(s).name)
    disp(['Loaded ' subjFiles(s).name])
    subj{s} = subjFiles(s).name(1:end-4);
    
    %% Compute mean/median scores for each block
    
    % target path specs
    targetPathCurvature = Results.targetPathCurvature';
    targetPathNumberOfCurves = Results.targetPathNumberOfCurves';
    
    % get conditions
    amp0 = targetPathCurvature==0; % straight line (baseline)
    amp02 = abs(targetPathCurvature)==0.2;
    amp05 = abs(targetPathCurvature)==0.5;
    amp08 = abs(targetPathCurvature)==0.8;
    single = targetPathNumberOfCurves==1 & ~amp0;
    double = targetPathNumberOfCurves==2;
    
    % all scores
    score = Results.score;
    
    % calculate average learning curves for single and double curves
    avgLearning_single(:,s) = nanmean(score(single,:));
    avgLearning_double(:,s) = nanmean(score(double,:));
    
    % calculate mean or median scores for each block
    if meanOrMedian==1
        mScore_block(s,:) = nanmean(score(:,iScore),2);
    elseif meanOrMedian==2
        mScore_block(s,:) = nanmedian(score(:,iScore),2);
    end
    
    %% Check for learning across blocks: compute slopes of median score
    
    % to do: get original block order
    %linfit_blocks_single(s,:) = polyfit(1:sum(single),mScore_block(s,single),1);
    %linfit_blocks_double(s,:) = polyfit(1:sum(double),mScore_block(s,double),1);
    %linfit_blocks_all(s,:) = polyfit(1:sum([single double]),mScore_block(s,single|double),1);
    
    %% Relate path changes to binned scores
    
    scoreAndPathChange = Results.score_pathChange;
    % extend bin if maximum path change is larger than 100
    maxPathChange = max(scoreAndPathChange(:,2));
    scoreBins_path(s,:) = scoreBins;
    if maxPathChange>scoreBins_path(s,end)
        scoreBins_path(s,end) = maxPathChange+1;
    end
    % sort scores in bins
    [count,~,bin] = histcounts(scoreAndPathChange(:,1),scoreBins_path(s,:)); % get bin counts
    count_scoreBin(s,:) = count;
    pathChange_scoreBin = NaN(max(count),nBins); % pre-allocate
    for b = 1 : nBins
        currBin = bin==b;
        if count(b)>1
            pathChange_scoreBin(1:sum(currBin),b) = scoreAndPathChange(currBin,2);
        else
            disp(['Only 1 trial in bin ' num2str(b) ', not included'])
        end
    end
    % calculate median path change per bin
    mPathChange_scoreBin(s,:) = nanmedian(pathChange_scoreBin);
    
    %% Plot individual data
    
    if createPlots
        
        % plot scores per condition
        figure(fig1); clf;
        % single curves
        subplot(1,2,1); hold on
        p02 = plot(Results.score(single&amp02,:)','-','color',matlabcolors(1,:));
        %plot([iScore(1) iScore(end)],[mScore(s,1) mScore(s,1)],...
        %    'color',p02(1).Color,'linewidth',1)
        p05 = plot(Results.score(single&amp05,:)','-','color',matlabcolors(2,:));
        %plot([iScore(1) iScore(end)],[mScore(s,2) mScore(s,2)],...
        %    'color',p05(1).Color,'linewidth',1)
        p08 = plot(Results.score(single&amp08,:)','-','color',matlabcolors(3,:));
        %plot([iScore(1) iScore(end)],[mScore(s,3) mScore(s,3)],...
        %    'color',p08(1).Color,'linewidth',1)
        ylim([0 100])
        legend([p02(1) p05(1) p08(1)],{'ampl. 0.2','ampl. 0.5','ampl. 0.8'},'location','southeast')
        legend('boxoff')
        xlabel('Trial'); ylabel('Score')
        title('Single curves')
        % double curves
        subplot(1,2,2); hold on
        p02 = plot(Results.score(double&amp02,:)','-','color',matlabcolors(1,:));
        %plot([iScore(1) iScore(end)],[mScore(s,4) mScore(s,4)],...
        %    'color',p02(1).Color,'linewidth',1)
        p05 = plot(Results.score(double&amp05,:)','-','color',matlabcolors(2,:));
        %plot([iScore(1) iScore(end)],[mScore(s,5) mScore(s,5)],...
        %    'color',p05(1).Color,'linewidth',1)
        p08 = plot(Results.score(double&amp08,:)','-','color',matlabcolors(3,:));
        %plot([iScore(1) iScore(end)],[mScore(s,6) mScore(s,6)],...
        %    'color',p08(1).Color,'linewidth',1)
        ylim([0 100])
        xlabel('Trial'); ylabel('Score')
        title('Double curves')
        %
        suplabel(['RL scores - ' subj{s}],'t');
        if savePlots
            saveFigAsPDF([saveFigsToPath 'RL_scores_' subj{s}],12)
        end
        
        % plot effect of score on path changes
        figure(fig1); clf
        % plot histogram of scores
        % each bin includes the left edge but does not include the right edge
        subplot(1,3,1);
        h = histogram(scoreAndPathChange(:,1),scoreBins);
        set(gca,'xtick',scoreBins)
        xlim([scoreBins(1) scoreBins(end)])
        ylim([0 max([100 h.Values])])
        xlabel('Score')
        ylabel('Frequency')
        % plot histogram of path changes
        subplot(1,3,2)
        h = histogram(scoreAndPathChange(:,2),scoreBins_path(s,:));
        h.FaceColor = matlabcolors(2,:);
        set(gca,'xtick',scoreBins)
        set(gca,'xticklabel',scoreBins_path(s,:))
        xlim([scoreBins(1) scoreBins(end)])
        ylim([0 max([100 h.Values])])
        xlabel('Path change')
        ylabel('Frequency')
        % plot boxplot of path change per bin
        subplot(1,3,3);
        boxplot(pathChange_scoreBin,'boxstyle','filled','color',matlabcolors(1,:),...
            'medianstyle','target','outliersize',4,'symbol','ko')
        set(gca,'xtick',0.5:1:(nBins+0.5))
        set(gca,'xticklabel',scoreBins_path(s,:))
        ylim([0 max([100 max(scoreAndPathChange(:,2))+1])])
        xlabel('Score')
        ylabel('Path change')
        %
        suplabel([subj{s} ' - relation between score and path change'],'t');
        if savePlots
            saveFigAsPDF([saveFigsToPath_shared '/RL_ind/RLpathChanges_'...
                num2str(nBins) 'bins_' subj{s}],11)
        end
        
    end
    
end % loop over subjects

%% Save data file

fileName = ['Results_' expFolder.name '_' datestr(now,'yyyymmdd') '.mat'];

% check if file does not exist yet
if exist([saveToPath fileName],'file') == 2
    disp(['A file named ' fileName ' already exists.'])
    overwrite = input('Do you want to overwrite it? Yes(1) or no(0): ');
else
    overwrite = 1;
end

% save file
if overwrite == 1
    scoreBins = scoreBins_path;
    save([saveToPath fileName],'subj','avgLearning_single','avgLearning_double',...
        'targetPathCurvature','targetPathNumberOfCurves','meanOrMedian','iScore','mScore_block',...
        'mPathChange_scoreBin','count_scoreBin','scoreBins');
    disp(['Saved ' saveToPath fileName])
    
    % save copy of Matlab code used to process data
    mFilePath = mfilename('fullpath');
    saveCopyOfCode(mFilePath,saveToPath)
else
    disp('Results not been saved')
end

%% Plot individual learning curves

%avgLearning_single
%avgLearning_double