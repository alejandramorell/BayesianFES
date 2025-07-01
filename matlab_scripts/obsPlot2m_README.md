# obsPlot2.m
This MATLAB script loads a “K matrix” from a CSV file, extracts specific pad IDs and their corresponding k-values at multiple rotation angles, and visualizes the observation model as annotated heatmaps for each angle.
This Kmatrix are the values of the k-values for each subject of the constructed observation model. This matrix is specific for each subject and it contains, the k-metric for each pad and for each of the rotation angles (within the range [-90º 90º] with a step of 5)

## Usage
The script expects in the directory the Kstable for each subject.

## Output
1. Console printout: For anles -90º, 10º, 30º, 45º, 60º and 90º, a sorted list of pad IDs and their k‐values.
2. Figures: Six heatmap windows (one per angle) showing a 5x3 grid and with the corresponding k-values for each pad of the grid.


## Configuration
Change the filename variable at the top to point to your CSV. This script only plots the Kmatrix of one subject, so you need to change the file name to change to the desired subject.
