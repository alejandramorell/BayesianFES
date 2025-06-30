package org.example.simulation;


//Atributos y métodos relacionados a un pad individual
public class Pad {
    private final int id;
    private final int row;
    private final int col;
    private double radiusFromAxis; //distancia en cm del centro de cada pad al eje de rotacion del antebraxo
    private double displacementDistance;
    private double probability;
    private double initialProb; //kflexion en la posición inicial (0 grados)


    public Pad(int id, double radiusFromAxis) {
        this.id = id;
        this.col = (id - 1)/5;
        this.row = (id - 1)%5;
        this.radiusFromAxis = radiusFromAxis;
        this.displacementDistance = 0;
        this.probability = 0;
        this.initialProb = 0;

    }


    public int getId() {
        return id;
    }
    public int getRow() {
        return row;
    }
    public int getCol() {
        return col;
    }
    public double getRadiusFromAxis() {
        return radiusFromAxis;
    }

    public double getDisplacementDistance() {
        return displacementDistance;
    }

    public double getInitialProb() { return initialProb; }
    public double getProbability() { return probability; }

    public void setDisplacementDistance(double displacementDistance) {
        this.displacementDistance = displacementDistance;
    }

    public void setProbability(double probability) {
        this.probability = probability;
    }

    //Asumimos que la probabilidad empieza siendo igual a la inicial
    public void setInitialProb(double initialProb) {
        this.initialProb = initialProb;
        this.probability = initialProb;
    }

    public static void main(String[] args) {
        System.out.println("Pad ID | Row | Distance to Radius (cm)");
        System.out.println("-------------------------------------");

        for (int id = 1; id <= 15; id++) {
            Pad pad = new Pad(id,2.86);
            int row = (id - 1) % 5;
            System.out.printf("  %2d   |  %d  |        %.2f cm\n", pad.getId(), row, pad.getRadiusFromAxis());
        }
    }
}


