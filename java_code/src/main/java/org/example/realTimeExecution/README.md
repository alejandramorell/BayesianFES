#realTimeExecution

This package contains the Java code that reads data from two IMU devices (in quaternion format) via serial ports, controls the TEREFES stimulator, and saves the results to text and CSV files.

Before the execution, you must connect the Arduinos to the inertial sensors following the wiring configuration, and then connect the Arduinos to the PC. Connect also de stimulator to the PC.

##Dependencies
1. Java 11+  
2. [jSerialComm](https://fazecast.github.io/jSerialComm/) 
   Add to your `pom.xml` (Maven) or `build.gradle` (Gradle):

   ```xml
   <dependency>
     <groupId>com.fazecast</groupId>
     <artifactId>jSerialComm</artifactId>
     <version>2.9.3</version>
   </dependency>

3. Ensure the `Utilities` class is included in your project.

## Configuration
1. Configuration of the serial ports in Main.java.
2. Baud Rate for SerialReaderQuaternion is 115200-8-1-N, change if needed.
3. Baud Rate for FESController is 9600-8-1-N, change if needed.
4. Change output paths to save results for plotting in MATLAB
5. 











