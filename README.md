# MTL-motor-learning
_Under construction_

## Project description
We investigate the relation between error-based motor learning (using a visuomotor rotation task) and reward-based motor learning (using a path finding task) using correlational and principal component analyses. Next, we perform multiple linear regression analysis to relate motor learning performance with the volumes of areas in the medial temporal lobe (MTL) obtained through high-resolution structural MRI (by Jordan Poppenk's lab; the ME(mory)MRI project). This research was performed at Queen's University, Kingston, ON, Canada.

For details see the preprint on biorxiv: de Brouwer, Rashid, Flanagan, Poppenk, Gallivan. Variation in error-based and reward-based human motor learning is related and associated with entorhinal volume. 

## Data processing, analysis, and visualization
The analysis code specific to this project is in this repo, to perform the full analysis and visualization we also need code in the Analysis-tools and Plotting-tools repo's.

### VMR task
1. Process the raw data with **processVMRtabletData.m** (in Analysis-tools/Tablet), which creates one .mat file per subject.
2.

### RL task
1. Process the raw data with **processRLtabletData.m** (in Analysis-tools/Tablet), which creates one .mat file per subject.
2.

Create .avi animations of both tasks with **createTaskAnimations_MEMRI.m**.

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
