# euler_angles.m
This MATLAB script reads two CSV files containing roll, pitch and yaw (Euler angles) for hand and arm sensors—one with initial measurements and one with final measurements—and generates plots comparing initial vs. final angles for both hand and arm.
Therefore, you can clearly see the changes that occurred in the hand and arm before and after stimulation, identifying which axis experienced rotation and by what magnitude.
## Usage
The script expects two files in the working directory, or you can edit the paths to match where your files are
## Output
1. Figure 1: Six-panel subplot comparing initial vs. final euler angles for the hand sensor
2. Figure 2: Six-panel subplot comparing initial vs. final euler angles for the arm sensor
3. Console display: Prints all loaded vectors (roll_hand, pitch_hand, …, yaw_arm1) for verification.
## Configuration
Ensure the CSV files are accessible and that your MATLAB current folder matches their location, or update the full file paths accordingly.
