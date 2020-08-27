# MTL-motor-learning
de Brouwer, Rashid, Flanagan, Poppenk, Gallivan. Variation in error-based and reward-based human motor learning is related and associated with entorhinal volume. [[preprint on biorxiv]](https://doi.org/10.1101/2020.05.27.119529)

_Under construction_

## Project description
We investigate the relation between error-based motor learning (using a visuomotor rotation task) and reward-based motor learning (using a path finding task) using correlational and principal component analyses. Next, we perform multiple linear regression analysis to relate motor learning performance with the volumes of areas in the medial temporal lobe (MTL) obtained through high-resolution structural MRI ('the ME(mory)MRI project'). 

All research was performed at Queen's University, Kingston, ON, Canada.

## Data processing, analysis, and visualization
Run **processAll_MEMRI** to perform all the data processing steps as follows.  

### Process VMR task data
1. Process the raw data with **processVMRtabletData**, which creates one .mat file per subject.
2. Calculate and/or plot individual subject results with **calcIndResultsVMRgaze** which creates one .mat file and several figures per subject.
3. Combine the individual subject results into a single datafile with **combineIndResultsVMRGaze** which creates one .mat file with all data and a figure with the individual learning curves. 

### Process RL task data
1. Process the raw data with **processRLtabletData** (in Analysis-tools/Tablet), which creates one .mat file per subject.
2. Calculate and/or plot individual subject results with **calcIndResultsRL** which creates one .mat file and several figures per subject.
3. Combine the individual subject results into a single datafile with **combineIndResultsRL** which creates one .mat file with all data and a figure with the individual learning curves. 

### Create table with VMR and RL scores
Create a single table with summary scores per subject and save to .csv file with **createBehaviouralResultsTable_MEMRI**.

### Get MRI data, residualize volumes, and create table
Load the MRI volumes and correct for total intracranial volume (i.e., residualize), add demographics and save values to .csv file with **createMRIresultsTable_MEMRI**.

### Relate tasks, and relate motor learning performance to structural brain data
_Coming soon_

Create .avi animations of both tasks with **createTaskAnimations_MEMRI**.

## Data structure
1. Raw data should be in "TaskFolder"/1_RawData, with a subfolder containing the data of each subject: a .txt control file containing the details of the experiment, and a .dat file for each trial.
2. Processed data is saved in "TaskFolder"/2_ProcessedData.
3. Group results are saved in "TaskFolder"/3_ProcessedData. Individual result figures are saved in "TaskFolder"/3_ProcessedData/Figures.

```
"TaskFolder" (e.g., VMR_MEMRI)
└───1_RawData
│   └───S01
│       │   controlFile.txt
│       │   trial1.dat
│       │   trial2.dat
│       │   ...
│   └───S02
│       │   controlFile.txt
│       │   trial1.dat
│       │   trial2.dat
│       │   ...
│   └───...
└───2_ProcessedData
    │   S01.mat
    │   S02.mat
    |   ...
└───3_Results
    |   results.mat
    └───Figures
        |   rawAngles_S01.pdf
        |   rawAngles_S02.pdf
        |   ...
```

For questions: ajdebrouwer@gmail.com
