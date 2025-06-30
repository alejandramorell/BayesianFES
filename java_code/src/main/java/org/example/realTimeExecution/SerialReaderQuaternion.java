package org.example.realTimeExecution;

import com.fazecast.jSerialComm.SerialPort;
import org.example.auxiliar.Utilities;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class SerialReaderQuaternion implements Runnable{
    private SerialPort serialPort;
    private String portName;
    private List<Quaternion> data;
    private Quaternion meanQuaternion;

    public SerialReaderQuaternion(String portName) {
        this.portName = portName;
        this.serialPort = SerialPort.getCommPort(portName);
        this.serialPort.setBaudRate(115200);
        this.serialPort.setComPortTimeouts(SerialPort.TIMEOUT_READ_SEMI_BLOCKING, 1000, 0);
        this.data = new ArrayList<Quaternion>();
        this.meanQuaternion = new Quaternion();
    }

    public boolean openPort() {
        if (serialPort.openPort()) {
            System.out.println("Conectado al puerto: " + serialPort.getSystemPortName());
            return true;
        } else {
            System.out.println("No se pudo abrir el puerto " + serialPort.getSystemPortName());
            return false;
        }
    }

    public void readData(long durationMillis) {
        long startTime = System.currentTimeMillis();  // Inicio del temporizador

        try (Scanner scanner = new Scanner(serialPort.getInputStream())) {
            while (System.currentTimeMillis() - startTime < durationMillis) {
                if (scanner.hasNextLine()) {
                    String line = scanner.nextLine().trim();
                    //System.out.println("Datos recibidos del puerto: " + serialPort.getSystemPortName() + ", " + line);


                    // Verificar si la línea contiene datos en formato quaternion
                    if (line.startsWith("Q")) {
                        String[] parts = line.substring(1).split(","); // Eliminar "Q" y dividir por comas

                        if (parts.length == 5) {  // Esperamos exactamente 5 elementos (ID, w, x, y, z)
                            try {
                                int sensorId = Integer.parseInt(parts[0]);  // ID del sensor (1 o 2)
                                double w = Double.parseDouble(parts[1]);
                                double x = Double.parseDouble(parts[2]);
                                double y = Double.parseDouble(parts[3]);
                                double z = Double.parseDouble(parts[4]);

                                // Crear el quaternion y agregarlo a la lista
                                Quaternion q = new Quaternion(w, x, y, z);
                                data.add(q);
                            } catch (NumberFormatException e) {
                                System.out.println("Error al convertir los valores de quaternion: " + line);
                            }
                        }

                    }
                }
            }
        }catch (Exception e) {
            e.printStackTrace();
        }
    }



    public void calculateMeanQuaternion() {
        int size = data.size();
        System.out.println("Number of samples recieved from  port "+ serialPort.getSystemPortName() + ": " + data.size());
        Quaternion q;
        if (size == 0 || size < 20) {
            System.out.println("No hay datos disponibles para calcular la media");

        } else {
            double[] sum = {0, 0, 0, 0};

            for (int i = 0; i < data.size(); i++) {

                q = data.get(i);
                // double[] values = data[i].get;
                sum[0] += q.getW();
                sum[1] += q.getX();
                sum[2] += q.getY();
                sum[3] += q.getZ();
            }
            meanQuaternion.setW(sum[0] / data.size());
            meanQuaternion.setX(sum[1] / data.size());
            meanQuaternion.setY(sum[2] / data.size());
            meanQuaternion.setZ(sum[3] / data.size());
        }
    }
    public static void saveData(String fileName, SerialReaderQuaternion handReader, SerialReaderQuaternion armReader, Quaternion handMean, Quaternion armMean, Coord eulerAngle, Coord pronSupAngle) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(fileName))) {

            if(eulerAngle != null && pronSupAngle != null){ //para que solo guarde al final
                writer.write("Euler Angles for hand rotation relative to Arm:");
                writer.write(String.format("Mean values: X: %.2f, Y: %.2f, Z: %.2f\n", eulerAngle.getX(), eulerAngle.getY(), eulerAngle.getZ()));

                writer.write("Euler Angles for arm pronation-supination rotation):");
                writer.write(String.format("Mean values: X: %.2f, Y: %.2f, Z: %.2f\n", pronSupAngle.getX(), pronSupAngle.getY(), pronSupAngle.getZ()));
            }



            writer.write("Hand data:\n");
            writer.write("Mean quaternion for the hand position:\n");
            writer.write(String.format("W: %.2f, X: %.2f, Y: %.2f, Z: %.2f\n", handMean.getW(), handMean.getX(), handMean.getY(), handMean.getZ()));
            Coord c = handMean.toEulerAngles();
            writer.write("Mean euler angle for the hand position:\n");
            writer.write(String.format("X: %.2f, Y: %.2f, Z: %.2f\n", c.getX(), c.getY(), c.getZ()));

            writer.write("Samples:\n");
            for(Quaternion q : handReader.getData()){
                Coord euler = q.toEulerAngles();
                writer.write(String.format("Roll (x-axis): %.2f°, Pitch (y-axis): %.2f°, Yaw (z-axis): %.2f°\n", euler.getX(), euler.getY(), euler.getZ()));
            }

            writer.write("\n********************************************************\n\n");

            writer.write("\nArm data:\n");
            writer.write("Mean quaternion for the arm position:\n");
            writer.write(String.format("W: %.2f, X: %.2f, Y: %.2f, Z: %.2f\n", armMean.getW(), armMean.getX(), armMean.getY(), armMean.getZ()));
            Coord q = armMean.toEulerAngles();
            writer.write("Mean euler angle for the arm position:\n");
            writer.write(String.format("X: %.2f, Y: %.2f, Z: %.2f\n", q.getX(), q.getY(), q.getZ()));

            writer.write("Samples:\n");
            for(Quaternion k: armReader.getData()){
                Coord euler = k.toEulerAngles();
                writer.write(String.format("Roll (x-axis): %.2f°, Pitch (y-axis): %.2f°, Yaw (z-axis): %.2f°\n", euler.getX(), euler.getY(), euler.getZ()));

            }


            System.out.println("Data saved to " + fileName);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public static void saveDataToPlot(String simpleFileName, SerialReaderQuaternion handReader, SerialReaderQuaternion armReader) {
        try (BufferedWriter simpleWriter = new BufferedWriter(new FileWriter(simpleFileName))) {

            // Escribir la cabecera del archivo simplificado
            simpleWriter.write("timestamp roll_hand pitch_hand yaw_hand roll_arm pitch_arm yaw_arm\n");

            // Guardar las muestras de la mano y del brazo en el mismo archivo
            saveSimplifiedSampleData(simpleWriter, handReader, armReader);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void saveSimplifiedSampleData(BufferedWriter br, SerialReaderQuaternion handReader, SerialReaderQuaternion armReader) throws IOException {
        long startTime = System.currentTimeMillis();  // Marca de tiempo de inicio

        // Suponemos que ambos lectores tienen el mismo número de datos, de lo contrario necesitaríamos manejar el caso donde uno tiene más datos que el otro
        int handDataSize = handReader.getData().size();
        int armDataSize = armReader.getData().size();
        int dataSize = Math.min(handDataSize, armDataSize);  // Aseguramos que no tratemos de acceder a datos fuera de rango

        for (int i = 0; i < dataSize; i++) {
            // Convertir el cuaternión de la mano a ángulos de Euler
            Quaternion handQuaternion = handReader.getData().get(i);
            Coord handEuler = handQuaternion.toEulerAngles();

            // Convertir el cuaternión del brazo a ángulos de Euler
            Quaternion armQuaternion = armReader.getData().get(i);
            Coord armEuler = armQuaternion.toEulerAngles();

            long currentTime = System.currentTimeMillis();
            double time = (currentTime - startTime) / 1000.0; // Convertir a segundos

            // Escribir los datos simplificados en el archivo CSV
            br.write(String.format("%.4f %.2f %.2f %.2f %.2f %.2f %.2f\n",
                    time, handEuler.getX(), handEuler.getY(), handEuler.getZ(), armEuler.getX(), armEuler.getY(), armEuler.getZ()));
        }
    }


    

    public List<Quaternion> getData() {
        return data;
    }

    public Quaternion getMeanQuartenion() {
        return meanQuaternion;
    }

    //sobreescribo el método que ejecuta el hilo
    @Override
    public void run() {
        readData(7000);
        if (!data.isEmpty()) {
            calculateMeanQuaternion();

        }

    }

    public void closePort() {
        if (serialPort.isOpen()) {
            serialPort.closePort();
            System.out.println("Puerto cerrado.");
        }
    }

    public void clearData() {
        data.clear();  // Limpiar la lista de datos recibidos
        meanQuaternion = new Quaternion();  // Restablecer la media de los ángulos a 0
    }

    public static void main(String[] args) {
        String folderPath = "C:/Users/alemo/IdeaProjects/getIMU/data/";
        SerialReaderQuaternion handReader = new SerialReaderQuaternion("COM10");
        SerialReaderQuaternion armReader = new SerialReaderQuaternion("COM13");


        if (armReader.openPort() && handReader.openPort()) {
            Thread handThread = new Thread(handReader);
            Thread armThread = new Thread(armReader);

            armThread.start();
            handThread.start();

            try {
                armThread.join();
                handThread.join(); // Espera a que el hilo termine
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            Quaternion Qglobal1 = handReader.getMeanQuartenion();
            Quaternion Qglobal2 = armReader.getMeanQuartenion();

            saveData( "Initial_position.txt", handReader, armReader, Qglobal1, Qglobal2, null, null);
            saveDataToPlot("C:\\Users\\alemo\\IdeaProjects\\getIMU\\initial_angles.csv", handReader, armReader);

            System.out.println("Mean quaternion for the initial hand position:");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Qglobal1.getW(), Qglobal1.getX(), Qglobal1.getY(), Qglobal1.getZ());

            System.out.println("Mean quaternion for the initial arm position:");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Qglobal2.getW(), Qglobal2.getX(), Qglobal2.getY(), Qglobal2.getZ());

            String space = Utilities.readString("Introduzca un espacio para empezar la segunda medicion");


            handReader.clearData();
            armReader.clearData();

            handThread = new Thread(handReader);
            armThread = new Thread(armReader);

            handThread.start();
            armThread.start();

            try {
                handThread.join();
                armThread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }

            Quaternion Q1 = handReader.getMeanQuartenion();
            Quaternion Q2 = armReader.getMeanQuartenion();



            System.out.println("Mean quaternion for the hand after movement:");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Q1.getW(), Q1.getX(), Q1.getY(), Q1.getZ());

            System.out.println("Mean quaternion for the arm after movement:");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Q2.getW(), Q2.getX(), Q2.getY(), Q2.getZ());

            //calibracion de los quartenios
            Q1 = Q1.multiplication(Qglobal1.inversion());
            Q2 = Q2.multiplication(Qglobal2.inversion());

            System.out.println("Calibrated quaternion for the hand:");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Q1.getW(), Q1.getX(), Q1.getY(), Q1.getZ());

            System.out.println("Calibrated quaternion for the arm:");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Q2.getW(), Q2.getX(), Q2.getY(), Q2.getZ());

            Quaternion Q1_2 = Q1.multiplication(Q2.inversion());
            System.out.println("Hand relative to Arm rotation (Q1-2): ");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Q1_2.getW(), Q1_2.getX(), Q1_2.getY(), Q1_2.getZ());

            Coord angles = Q1_2.toEulerAngles();
            System.out.println("Euler Angles (Hand rotation relative to Arm):");
            System.out.printf("Roll (x-axis): %.2f degrees\n", angles.getX());
            System.out.printf("Pitch (y-axis): %.2f degrees\n", angles.getY());
            System.out.printf("Yaw (z-axis): %.2f degrees\n", angles.getZ());




            Quaternion Q2_calibrated = Q2.multiplication(Qglobal2.inversion());
            System.out.println("Arm rotation: ");
            System.out.printf("W: %.5f, X: %.5f, Y: %.5f, Z: %.5f\n",
                    Q2_calibrated.getW(), Q2_calibrated.getX(),
                    Q2_calibrated.getY(), Q2_calibrated.getZ());

            Coord pronSupAngles = Q2_calibrated.toEulerAngles();
            System.out.println("Euler Angles (Arm rotation):");
            System.out.printf("Roll (x-axis): %.2f degrees\n", pronSupAngles.getX());
            System.out.printf("Pitch (y-axis): %.2f degrees\n", pronSupAngles.getY());
            System.out.printf("Yaw (z-axis): %.2f degrees\n", pronSupAngles.getZ());

            saveData("Final_position.txt", handReader, armReader, Q1, Q2, angles, pronSupAngles);
            saveDataToPlot("C:\\Users\\alemo\\IdeaProjects\\getIMU\\final_angles.csv", handReader, armReader);

            handReader.closePort();
            armReader.closePort();
            
        } else{
            System.out.println("Error al abrir el puerto");
        }
    }
}
