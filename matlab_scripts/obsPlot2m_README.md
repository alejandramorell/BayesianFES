# obsPlot2.m
This MATLAB script loads a “K matrix” from a CSV file, extracts specific pad IDs and their corresponding k-values at multiple rotation angles, and visualizes the observation model as annotated heatmaps for each angle.
This Kmatrix are the values of the k-values for each subject of the constructed observation model. This matrix contains, the k-metric for each pad, for eahc rotation angle within the range [-90º 90º]

## Usage
The script expects in the directory the Kstable for each subject.

##
1. Figure 1: Six-panel subplot comparing initial vs. final euler angles for the hand sensor
2. Figure 2: Six-panel subplot comparing initial vs. final euler angles for the arm sensor
3. Console display: Prints all loaded vectors (roll_hand, pitch_hand, …, yaw_arm1) for verification.
## Configuration
Ensure the CSV files are accessible and that your MATLAB current folder matches their location, or update the full file paths accordingly.
This approach plot the effects produced by the activation of each channel independently; since TEREFES activates channel by channel, each channel produces different rotations, reflecting the unique effect of stimulation on each muscle group. 
