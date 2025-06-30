package org.example.simulation;

import java.util.List;

//Calcula el desplazamiento de cada pad
public class DisplacementModel {

    public DisplacementModel() {

    }

    //s_i = r_i * thetaRad (en cm)
    public void upadteDisplacementDistance(double angleDiff, List<Pad> pads){
        double theta = Math.toRadians(angleDiff);
        for(Pad pad: pads){
            double radius = pad.getRadiusFromAxis();
            double displacement = radius * theta; //si thetha > 0, displacement < 0
            pad.setDisplacementDistance(-displacement);
        }
    }
}
