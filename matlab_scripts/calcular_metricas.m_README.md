# calcular_metricas.m
This MATLAB script computes normalized “K‐metrics” for six hand movements (flexion, extension, pronation, supination, adduction, abduction) across multiple subjects, trials, repetitions, and sensor pads. 
## What it does to ccompute the k-metrics
1. Loads global parameters:  
   - `GetMaxMoves.mat` (maximum target angles per movement)  
   - `Trials.mat` (logical array indicating which trials × reps are valid)  
   - `MaxFingerAngles.mat` (maximum finger angle differences for normalization).
2. Applies the formulas  

## Usage
The script expects the files
  -`GetMaxMoves.mat`  
  - `Trials.mat`
  - `MaxFingerAngles.mat`
  -  `Subject1.mat` … `Subject10.mat`
  -  `Trials/Subject<s>Trial<t>_rep<r>.mat` files for each subject, trial, and repetition.
## Output
K-metrics for flexion/extension, pronation/supination, adduction/abduction
## Configuration
Ensure all the needed files are in your directory


