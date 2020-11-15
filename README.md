# MTL-motor-learning
Anouk J. de Brouwer, Mohammad R. Rashid, J. Randall Flanagan, Jordan Poppenk, Jason P. Gallivan. Variation in error-based and reward-based human motor learning is related and associated with entorhinal volume. Under review. [[preprint on biorxiv]](https://doi.org/10.1101/2020.05.27.119529)

All research was performed at Queen's University, Kingston, ON, Canada.

## Project summary
Humans vary greatly in their ability to learn and refine motor skills, but little is known about potential differences in brain anatomy and function that underlie this variability. In this research project, we studied individual differences in two types of motor learning: 
1. Reward-based learning - the type of learning that occurs in response to success and failure, such as when learning to swing on a playground swing
2. Error-based learning - the type of learning that occurs in response to observable errors, such as when missing the bullseye in archery

We simulated these types of learning in a laboratory setting, where 34 participants performed two tasks in which they hit visual targets on a computer screen by moving a pen across a large drawing tablet. In the reward-based learning task, participants learned to copy an invisible and unknown curved path through trial and error. After each movement, they got a score between 0 and 100 points to indicate how closely their drawn path corresponded to the invisible path. Participants were presented with six different paths with a ‘single’ curve, and six different paths with a ‘double’ curve, and got 20 attempts for each curve. For the error-based learning task, we used the classic visuomotor rotation learning paradigm. In this task, participants learned to adjust their movements to a 45° rotation of the cursor movement on the screen. That is, when moving the pen forward on the tablet, the cursor moved 45° clockwise of the pen movement, resulting in an error between the target and cursor position. Participants performed two rotation blocks (‘Rotation 1’ and ‘Rotation 2’) with a ‘normal’ block in between. In some trials, we showed participants a ring of numbers, and asked which number they were aiming their movement towards (‘Aim’) to measure their strategy to counter the rotation. We also obtained high-resolution anatomical images (MRI) of each participant’s brain in a separate session. 

<img src="/Figures/Tasks_readme.png" width="480">

We first showed that performance in the reward-based and error-based motor learning tasks is related: individuals who showed higher scores in the reward-based learning task (‘Single’ and ‘Double’ score), often also showed higher scores in the error-based learning task (‘Rotation 1’, ‘Rotation 2’, and ‘Aim’ score). A principal component analysis on the learning scores returned a first principal component (PC1) with positive loadings for all learning scores, suggesting that this component captures overall learning performance.

<img src="/Figures/Correlations_PCA_readme.png" width="726">

We then tested the hypothesis that regions in the medial temporal lobe (MTL) of the brain, traditionally implied in cognition, declarative memory, and navigation, are associated with motor learning. A multiple linear regression analysis showed that larger entorhinal cortex (EC) volume in the MTL in the right half of the brain is a significant predictor of better overall learning (PC1) score. 

<img src="/Figures/HC_EC_regression_readme.png" width="667">

We propose that the variability in motor learning performance across individuals is driven by how well people implement strategies, i.e., to explore paths in the reward-based learning task and to counter the rotation in the error-based learning task. The ability to use strategies may be linked to anatomical differences in the medial temporal lobe of the brain. Beyond advancing the field of neuroscience, understanding the cognitive and neural mechanisms underlying motor learning could help motivate new approaches to rehabilitation of patients with motor disabilities following neurological disease, such as stroke. 

## Data processing pipeline
Run **processAll_MEMRI** to perform the data processing steps:  
* Process error-based task data (visuomotor rotation; VMR)
* Process reward-based task data (reward learning; RL)
* Create table with VMR and RL scores
* Get MRI data, residualize volumes, and create table with relevant data

Run **finalResults_MEMRI** to calculate the final results.
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

## Contact
ajdebrouwer@gmail.com
