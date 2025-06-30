package org.example.simulation;

import org.example.auxiliar.Utilities;

import java.util.List;

public class ObservationModel {
    private double[][] kTable;
    private final int nPads;
    private final int nAngles;
    private static final int MIN_ANGLE = -90;
    private static final int MAX_ANGLE = 90;
    private static final int ANGLE_STEP= 5;


    public ObservationModel() {
        this.kTable = new double[15][37];
        this.nPads = kTable.length; //filas
        this.nAngles = kTable[0].length; //columnas

    }

    public double[] getAngleColumn(double angleDiff){ //para un ángulo, extrae los valores de
        if(angleDiff < MIN_ANGLE || angleDiff > MAX_ANGLE){
            System.out.println("ángulo debe estar en el rango de -90 a 90 grados");
        }

        int a = (int)Math.round(angleDiff); //redondea el angulo al entero más cercano
        int index = (a-MIN_ANGLE) / ANGLE_STEP; //indice de la columna que nos interesa

        double[] column = new double[nPads];
        for (int i = 0; i < nPads; i++) {
            column[i] = kTable[i][index];
        }
        return column;

    }

    public void applyCorrectionPhase(List<Pad> pads, double angleDiff){
        int n = pads.size();
        double[] Ks = getAngleColumn(angleDiff); //extrae las ks para todos los pads del ángulo que nos inetresa
        //k_i: que tan bien hace match el pad i con el angulo que nos interesa
        double sumK = 0;
        for(double k: Ks){
            sumK += k;
        }
        //modelo obs: prob de observar ese ángulo z si estuviermos en el pad i
        //p(z|xi) = ki/sum(kj)
        double[] l = new double[n];
        if(sumK > 0){
            for(int i = 0; i < n; i++){
                l[i] = Ks[i] / sumK;  //p(z|x_i) = k_i/sumK_j
            }
        }


        //p(x_i|z) = p(z|x_i) x p(x_i)
        double sumPost = 0;
        for(int i = 0; i < n; i++){
            Pad p = pads.get(i);
            double prior = p.getProbability();
            double post = prior * l[i];
            p.setProbability(post);
            sumPost += post;

        }

        if(sumPost > 0){
            for(Pad p: pads){
                p.setProbability(p.getProbability() / sumPost);
            }
        }
    }


    public void loadkTable(String subject) {
        String fileName = "Kstable_" + subject + ".csv";
        double[][] table = Utilities.readMatrix(fileName);
        this.kTable = table;


    }

    public double[][] getkTable() {
        return kTable;
    }


    public static void main(String[] args) {
        ObservationModel model = new ObservationModel();
        double[][] kTable = model.getkTable();
        for (int i = 0; i < kTable.length; i++) {
            System.out.print("Pad " + (i+1) + ": ");
            for (int j = 0; j < kTable[i].length; j++) {
                System.out.printf("%.6f ", kTable[i][j]);
            }
            System.out.println();
        }

        }
    }


