function createBehaviouralResultsTable_MEMRI(projectPath,saveToPath)
% createBehaviouralResultsTable_MEMRI
%
% Create table with behavioural results of VMR and RL task in MEMRI project,
% and save table in .csv file.

% MIT License
% Copyright (c) 2020 Anouk de Brouwer

if nargin==0
    projectPath = '/Users/anouk/Documents/ExpsTablet/';
    saveToPath = '/Users/anouk/dropbox/MTL_Individual_Diffs_SHARED/';
end
saveFigsToPath = [saveToPath '/Anouk/Figures/'];

%% RL: load results file

expName = 'RL_MEMRI';

% load results
dataPath = [projectPath expName '/3_Results/'];
resultsFiles = selectFiles([dataPath 'Results*.mat'],'files');
load([dataPath resultsFiles.name])
disp(['Loaded ' resultsFiles.name])
RL_subj = subj;

%% RL: calculate scores per condition

% get conditions
amp0 = targetPathCurvature==0; % straight line (baseline)
amp02 = abs(targetPathCurvature)==0.2;
amp05 = abs(targetPathCurvature)==0.5;
amp08 = abs(targetPathCurvature)==0.8;
single = targetPathNumberOfCurves==1 & ~amp0;
double = targetPathNumberOfCurves==2;

% score per condition, average leftward and rightward curves
mScore(:,1) = mean(mScore_block(:,single&amp02),2);
mScore(:,2) = mean(mScore_block(:,single&amp05),2);
mScore(:,3) = mean(mScore_block(:,single&amp08),2);
mScore(:,4) = mean(mScore_block(:,double&amp02),2);
mScore(:,5) = mean(mScore_block(:,double&amp05),2);
mScore(:,6) = mean(mScore_block(:,double&amp08),2);

% create results table
RL_varNames = {'RL_single_02','RL_single_05','RL_single_08',...
    'RL_double_02','RL_double_05','RL_double_08'};
RL = array2table(mScore,'RowNames',RL_subj,'VariableNames',RL_varNames);

%% RL: plot group data (Fig 1C)

% plot average scores across trials of all subjects
scaledFigure(1.5,1);
% single curves
subplot(1,2,1); hold on
plot(avgLearning_single,'color',[0.5 0.5 0.5])
plot(mean(avgLearning_single,2),'k','linewidth',2)
axis square
xlim([1 20]); ylim([0 100])
set(gca,'xtick',[0:5:20])
set(gca,'ytick',[0:25:100])
xlabel('Trial'); ylabel('Score')
title('Single curves')
% double curves
subplot(1,2,2); hold on
plot(avgLearning_double,'color',[0.5 0.5 0.5])
plot(mean(avgLearning_double,2),'k','linewidth',2)
axis square
xlim([1 20]); ylim([0 100])
set(gca,'xtick',[0:5:20])
set(gca,'ytick',[0:25:100])
xlabel('Trial'); ylabel('Score')
title('Double curves')
%
suplabel('RL scores - all subjects','t');
keyboard

%% VMR: load experiment details and results file

expName = 'VMR_MEMRI';

% load experiment details
detailsFile = dir([projectPath expName '/ExpDetails*.mat']);
load([projectPath expName '/' detailsFile.name])

% load results
dataPath = [projectPath expName '/3_Results/'];
resultsFiles = selectFiles([dataPath 'Results*.mat'],'files');
load([dataPath resultsFiles.name])
disp(['Loaded ' resultsFiles.name])
VMR_subj = subj;
nBins = length(iBin);

% baseline, rotation and washout bins
iRotationOnOff = [iBin(find(diff([0; cursorRotation])))-0.5; nTrials+0.5];
baseBins = iBin<iRotationOnOff(1);
rotBins1 = iBin>iRotationOnOff(1) & iBin<iRotationOnOff(2);
rotBins2 = iBin>iRotationOnOff(3) & iBin<iRotationOnOff(4);
woBins = iBin>iRotationOnOff(2) & iBin<iRotationOnOff(3);

%% VMR: calculate early and late learning scores

% early and late hand angles (average across bins 2-3 and bins 9-10)
i = find(rotBins1);
angles(:,1) = nanmean(handAngle(i+1:i+2,:));
angles(:,2) = nanmean(handAngle(i+8:i+9,:));
i = find(woBins);
angles(:,3) = nanmean(handAngle(i+1:i+2,:));
angles(:,4) = nanmean(handAngle(i+8:i+9,:));
i = find(rotBins2);
angles(:,5) = nanmean(handAngle(i+1:i+2,:));
angles(:,6) = nanmean(handAngle(i+8:i+9,:));
angles(:,7) = nanmean(reportAngle);
if any(isnan(angles))
    disp('Check angles'); keyboard
end

% transform angles to errors
errors(:,[1,2,5,6,7]) = -45 - angles(:,[1,2,5,6,7]); % rotation - hand target at -45 deg
errors(:,3:4) = angles(:,3:4); % washout - hand target at 0 deg

% create results table, mirror errors so that greater scores are better
VMR_varNames = {'VMR_early_rot1','VMR_late_rot1','VMR_early_wo','VMR_late_wo',...
    'VMR_early_rot2','VMR_late_rot2','VMR_explicit'};
VMR = array2table(errors,'RowNames',VMR_subj,'VariableNames',VMR_varNames);
note = {'early = bin 2-3';'late = bin 9-10';...
    'errors are computed from mean median hand angles'};

%% VMR: plot group data (Fig 1E)

iMidBin = iBin+3;

% plot average hand angles across all subjects
scaledFigure(1.5,1);
subplot(1,4,1:3); hold on
plot(iMidBin,-handAngle','color',[0.5 0.5 0.5])
plot(iMidBin,nanmean(-handAngle,2),'k','linewidth',2)
xlim([0 nTrials]); ylim([-30 75])
set(gca,'xtick',0:80:nTrials)
set(gca,'ytick',-30:15:75)
horline([0 45],'k-')
vertline(iRotationOnOff)
xlabel('Trial')
ylabel('Angle (deg)')
title('Hand angle')
% plot average reported angle across all subjects
subplot(1,4,4); hold on
mReportAngle = nanmean(reportAngle); % average 2 bins
plotMeansWithDataPoints(-mReportAngle(:),[],nanstd(-mReportAngle));
xlim([0 2]); ylim([-30 75])
set(gca,'xtick',[])
set(gca,'ytick',-30:15:75)
horline([0 45],'k-')
title('Report angle')
%
suplabel('VMR learning - all subjects','t');
keyboard

%% Create and save table (.csv file) with scores of both behavioural experiments

% join tables
B = join(RL,VMR,'Keys','RowNames');

% check if file exists
fileName = ['table_behav_' datestr(now,'yyyymm') '.csv'];
if exist([saveToPath fileName],'file') == 2 % check if file does not exist yet
    disp(['A file named ' fileName ' already exists.'])
    overwrite = input('Do you want to overwrite it? Yes(1) or no(0): ');
else
    overwrite = 1;
end

% save file
if overwrite == 1
    writetable(B,[saveToPath fileName],'WriteRowNames',true)
    disp(['Saved ' saveToPath fileName])
else
    disp('Results not been saved')
end
