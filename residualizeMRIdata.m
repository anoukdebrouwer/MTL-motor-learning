function T_resid = residualizeMRIdata(T)
% residualizeMRIdata

% MIT License
% Copyright (c) 2020 Anouk de Brouwer

showPlots = false; % set to true for visual inspection of correlation between
% the volume of each area and intracranial volume

%% Residualize

% Correct MRI volumes according to:
% adjusted volume = raw volume - b × (ICV - mean ICV)
% where b is the slope of a regression of a region of interest volume on ICV.

% calculate b
T_resid = T;
IC = T.intracranial_vol; % intracranial volume
beta = NaN(size(T,2),2);
for col = 2 : size(T,2)
    % select column
    x = T{:,col};
    % calculate relation with intracranial volume
    if ~showPlots
        [b,~,~,~] = scatterWithLinearFit(IC,x,[],[],true);
    else % plot
        clf
        [b,~,~,~] = scatterWithLinearFit(IC,x);
        ylabel(T.Properties.VariableNames{col},'interpreter','none')
        xlabel('intracranial volume');
        disp('Press continue to go to next column')
        keyboard
    end
    beta(col,:) = b;
    % calculate adjusted volume
    x_adj = x - beta(col,1)*(IC-mean(IC));
    T_resid{:,col} = x_adj;
end

% add original intracranial volumes back into table
T_resid.intracranial_vol = IC;

if showPlots
    % plot correlations between residualizedvolumes
    clf
    plotCorrelationMatrix(T_resid{:,2:end},T_resid.Properties.VariableNames(2:end));
    title('Correlations between residualized volumes')
end
