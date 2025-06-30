\# realTimeExecution



This package contains the Java code that reads data from two IMU devices (in quaternion format) via serial ports, controls the TEREFES stimulator, and saves the results to text and CSV files.



Before the execution, you must connect the Arduinos to the inertial sensors following the wiring configuration, and then connect the Arduinos to the PC. Connect also de stimulator to the PC.



\## Dependencies



1\. \*\*Java 11+\*\*  

2\. \*\*\[jSerialComm](https://fazecast.github.io/jSerialComm/)\*\*  

&nbsp;  Add to your `pom.xml` (Maven) or `build.gradle` (Gradle), for example:

&nbsp;  ```xml

&nbsp;  <dependency>

&nbsp;    <groupId>com.fazecast</groupId>

&nbsp;    <artifactId>jSerialComm</artifactId>

&nbsp;    <version>2.9.3</version>

&nbsp;  </dependency>

&nbsp;  ```

3\. \*\*`org.example.auxiliary.Utilities` package\*\*  

&nbsp;  Ensure the `Utilities` class (for data filtering, etc.) is included in your project.



\## Configuration



1\. \*\*Serial Ports\*\*  

&nbsp;  In `Main.java`, adjust the port descriptors:

&nbsp;  ```java

&nbsp;  String portHand  = "COM3";        // Hand IMU port

&nbsp;  String portArm   = "COM4";        // Arm IMU port

&nbsp;  String portFES   = "COM5";        // TEREFES stimulator port

&nbsp;  ```

&nbsp;  Change these to match your system



2\. \*\*Baud Rate \& Parameters\*\*  

&nbsp;  By default, `SerialReaderQuaternion` uses 115200-8-1-N. If your IMU or stimulator requires different settings, update the constructor accordingly.



3\. \*\*Output Paths\*\*  

&nbsp;  - Text file: `Final\_position.txt` (in working directory).  

&nbsp;  - CSV file for plotting: change to a relative or absolute path valid on your machine.





\## Output



\- \*\*Final\_position.txt\*\*  

&nbsp; Contains statistics (averages and Euler angles) of each IMU’s readings.  

\- \*\*final\_angles.csv\*\*  

&nbsp; CSV with columns `\[timestamp, qHandW, qHandX, …, rollHand, pitchHand, yawHand, qArmW, …]` for external plotting.











