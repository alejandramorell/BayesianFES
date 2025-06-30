package org.example.auxiliar;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public abstract class Utilities {

    private static InputStreamReader isr = new InputStreamReader(System.in);
    private static BufferedReader br = new BufferedReader(isr);

    public static double readDouble(String question) {

        double num;
        String line;
        while (true) {
            try {
                System.out.print(question);
                line = br.readLine();
                num = Float.parseFloat(line);
                return num;

            } catch (IOException ioe) {
                System.out.println(" ERROR: Unable to read.");

            } catch (NumberFormatException nfe) {
                System.out.println(" ERROR: Must be a real number.");
            }
        }
    }

    public static String readString(String question) {

        String line;
        while (true) {
            try {
                System.out.print(question);
                line = br.readLine();
                return line;

            } catch (IOException ioe) {
                System.out.println(" ERROR: Unable to read.");
            }
        }
    }

    public static List<Double> readProbabilities(String filePath) {
            List<Double> probs = new ArrayList<>();
            try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
                String line;
                while ((line = br.readLine()) != null) {
                    probs.add(Double.parseDouble(line.trim()));
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
            return probs;
    }

    public static double[][] readMatrix(String csvPath){
        List<double[]> rows = new ArrayList<>();
        try(BufferedReader reader = new BufferedReader(new FileReader(csvPath))){

            String headerLine = reader.readLine();
            if(headerLine == null){
                System.out.println("Empty file");
                return new double[0][0];
            }
            String[] headerCols = headerLine.split(",");
            int nAngles = headerCols.length - 1;

            String line;
            int lineCount = 0;
            while ((line = reader.readLine()) != null) {
                if(line.isEmpty()) continue;
                String[] cols = line.split(",");
                if (cols.length != nAngles + 1) {
                    System.out.printf("Línea %d ignorada (columnas=%d, esperaba=%d)\n",
                            lineCount+2, cols.length, nAngles+1);
                    continue;
                }
                double[] row = new double[nAngles];
                for (int j = 1; j < cols.length; j++) {
                    row[j-1] = Double.parseDouble(cols[j].trim());
                }
                rows.add(row);
                lineCount++;
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        int nPads = rows.size();
        double[][] kTable = new double[nPads][];
        for (int i = 0; i < nPads; i++) {
            kTable[i] = rows.get(i);
        }
        return kTable;
    }

}

