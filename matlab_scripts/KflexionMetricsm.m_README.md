# KflexionMetricsm.m
This MATLAB script loads precomputed K-flexion metrics for multiple subjects, fits quadratic models to selected trials, and generates both visualizations and CSV outputs of the initial and interpolated K-values. Therefore, this is the script responsible for the construction of the observation model.

## What it does to construct the model
1. Iterates over each subject (`Subject1`…`Subject10`):  
   - Selects trials 5, 9, and 10 corresponding to angles `[0°, 90°, -90°]`.  
   - Computes the mean K-values for each pad and trial, setting negative means to zero.  
   - Takes the mean at 0° as the “initial K” for each pad and saves it to `InitialK_values_<Subject>.csv`.  
   - Sorts the three mean values by angle and fits a quadratic curve \(K(θ)=aθ^2+bθ+c\) for each pad.
   -  Plots a bar chart of the three K-values and overlays the fitted curve and an interpolation point at 45°.
2. Interpolates each pad’s quadratic model over angles from –90° to 90° in 5° increments, clamps negatives to zero, and saves the full 15×nQuery table to `Kstable_<Subject>.csv`.  

## Usage
The script expects the file `Metrics2.mat` in your MATLAB path or current folder. `Metrics2.mat`
Must contain a struct `Kflexion` with fields Subject1, Subject2, … Subject10.
Each field is a 3D array of size 15 × 3 × 15 (`trials × repetitions × pads`). Rows correspond to trials (15 total), columns to the three repetitions of the trial, and the third dimension to the 15 pads. In our analysis we only use rows 5, 9, and 10 (trials at 0°, 90°, and –90°).
## Output
For each subject
1. `InitialK_values_Subj.csv`: 15×1 CSV of initial K-values (mean at 0°) for pads 1–15.
2. `Kstable_Subj.csv`: k-values at angles within the range -90º to 90º. OBSERVATION MODEL
3. For each pad 1–15: a bar chart of K-values at –90°, 0°, 90° plus the fitted quadratic curve and interpolation point at 45°.
## Configuration
Modify subjectNames array to process a different set.

