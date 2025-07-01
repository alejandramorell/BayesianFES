# resultsPlot.m
This MATLAB script processes the results of the algorithm performance for a specific subject. Each subject has a series of files, one per rotation angle (-90º, 10º, 30º, 45º, 60º, 90º) and generates 3 heatmaps of initial, predicted, and corrected pad activation probabilities for each angle, tracking how the probabilities change across the different phases of the algorithm. It also highlights the final selected pads by the algorithm.


## Usage
The script expects in the directory the files of the resutls of each subject. Each subject must have 6 files of results, one for each angle.

## Output
1. Console tables listing each pad’s ID, initial probability, displacement, predicted probability, and corrected probability.
2. Figures: For each angle, a 1×3 heatmap figure showing: InitialProb, PredictedProb, CorrectedProb with Top 3 pads highlighted.


## Configuration
Modify sprintf('results_Subject8_angle_%.1f.csv', angle) if you want to change the results for different subjects or if your CSV filer differ.
