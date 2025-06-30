clear all
close all
clc

% Kflexion = struct('Subject1',[],'Subject2',[],'Subject3',[],'Subject4',[],'Subject5',[],'Subject6',[],'Subject7',[],'Subject8',[],'Subject9',[],'Subject10',[]);
% Kflexion.Subject1 = zeros(14,3,15);
% Kflexion.Subject2 = zeros(14,3,15);
% Kflexion.Subject3 = zeros(14,3,15);
% Kflexion.Subject4 = zeros(14,3,15);
% Kflexion.Subject5 = zeros(14,3,15);
% Kflexion.Subject6 = zeros(14,3,15);
% Kflexion.Subject7 = zeros(14,3,15);
% Kflexion.Subject8 = zeros(14,3,15);
% Kflexion.Subject9 = zeros(14,3,15);
% Kflexion.Subject10 = zeros(14,3,15);
load GetMaxMoves;
load Trials;
load MaxFingerAngles;


for s=1:10  % usuario
    
    %load initial angles
    eval(['load ./Subject' int2str(s) '.mat;']);
    
    TarFlexion   =  maxFlexion(s);
    TarExtension =  maxExtension(s);
    TarAdduction =  maxAdduction(s);
    TarAbduction =  maxAbduction(s);
    TarPronation =  maxPronation(s);
    TarSupination = maxSupination(s);
    
%     maxFin1 = Initial_angles(3,1) - Initial_angles(1,1);
%     maxFin2 = Initial_angles(3,2) - Initial_angles(1,2);
%     maxFin3 = Initial_angles(3,3) - Initial_angles(1,3);
%     maxFin4 = Initial_angles(3,4) - Initial_angles(1,4);
%     
%     minFin1 = Initial_angles(2,1) - Initial_angles(3,1);
%     minFin2 = Initial_angles(2,2) - Initial_angles(3,2);
%     minFin3 = Initial_angles(2,3) - Initial_angles(3,3);
%     minFin4 = Initial_angles(2,4) - Initial_angles(3,4);
%     
%     if(minFin1 == 0)
%         minFin1 = 0.01;
%     end
    
    for t= 1:14 % trial
        for r=1:3
            if(Trials(s,t,r)==true)
                
                
                eval(['load ./Trials/Subject' int2str(s) 'Trial' int2str(t) '_rep' int2str(r) '.mat']);
                for p = 1:15 % pad
                    angleEF = Final_angles(p,9);
                    anglePS = Final_angles(p,10);
                    angleAA = Final_angles(p,11);
                    fing1 = abs(Final_angles(p,1) - Final_angles(p,2));
                    fing2 = abs(Final_angles(p,3) - Final_angles(p,4));
                    fing3 = abs(Final_angles(p,5) - Final_angles(p,6));
                    fing4 = abs(Final_angles(p,7) - Final_angles(p,8));
                    
                    if(angleEF<0)
                        maxFLEEXT = Initial_angles(4,2);
                    else
                        maxFLEEXT = Initial_angles(4,1);
                    end
                    if(anglePS>0)
                        maxPROSUP = Initial_angles(5,1);
                    else
                        maxPROSUP = Initial_angles(5,2);
                    end
                    if(angleAA<0)
                        maxABDADD = Initial_angles(4,4);
                    else
                        maxABDADD = Initial_angles(4,3);
                    end
                    
                    if(t>=5)
                        tmp = ( ( abs(angleEF) )/ abs(TarFlexion) ) - 0.166 * ( (( angleAA * angleAA ) / ( maxABDADD * maxABDADD )) + (( anglePS * anglePS ) / ( maxPROSUP * maxPROSUP )) + ((fing1*fing1)/(maxFin1*maxFin1)) + ((fing2*fing2)/(maxFin2*maxFin2)) + ((fing3*fing3)/(maxFin3*maxFin3)) + ((fing4*fing4)/(maxFin4*maxFin4)));
                        eval(['Kflexion.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp = ( ( abs(anglePS) )/ abs(TarPronation) ) - 0.166 * ( (( angleAA * angleAA ) / ( maxABDADD * maxABDADD )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT )) + ((fing1*fing1)/(maxFin1*maxFin1)) + ((fing2*fing2)/(maxFin2*maxFin2)) + ((fing3*fing3)/(maxFin3*maxFin3)) + ((fing4*fing4)/(maxFin4*maxFin4)));
                        eval(['Kpronation.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( ( abs(anglePS) )/ abs(TarSupination) ) - 0.166 * ( (( angleAA * angleAA ) / ( maxABDADD * maxABDADD )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT )) + ((fing1*fing1)/(maxFin1*maxFin1)) + ((fing2*fing2)/(maxFin2*maxFin2)) + ((fing3*fing3)/(maxFin3*maxFin3)) + ((fing4*fing4)/(maxFin4*maxFin4)));
                        eval(['Ksupination.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( ( abs(angleAA) )/ abs(TarAdduction) ) - 0.166 * ( (( anglePS * anglePS ) / ( maxPROSUP * maxPROSUP )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT ))+ ((fing1*fing1)/(maxFin1*maxFin1)) + ((fing2*fing2)/(maxFin2*maxFin2)) + ((fing3*fing3)/(maxFin3*maxFin3)) + ((fing4*fing4)/(maxFin4*maxFin4)));
                        eval(['Kadduction.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( (abs(angleAA) )/ abs(TarAbduction) ) - 0.166 * ( (( anglePS * anglePS ) / ( maxPROSUP * maxPROSUP )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT )) + ((fing1*fing1)/(maxFin1*maxFin1)) + ((fing2*fing2)/(maxFin2*maxFin2)) + ((fing3*fing3)/(maxFin3*maxFin3)) + ((fing4*fing4)/(maxFin4*maxFin4)));
                        eval(['Kabduction.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                    else
                        tmp  = 	( abs(angleEF) / abs(TarExtension) ) - 0.166 * ( (( angleAA * angleAA ) / ( maxABDADD * maxABDADD )) + (( anglePS * anglePS ) / ( maxPROSUP * maxPROSUP )) + ((fing1*fing1)/(minFin1*minFin1)) + ((fing2*fing2)/(minFin2*minFin2)) + ((fing3*fing3)/(minFin3*minFin3)) + ((fing4*fing4)/(minFin4*minFin4)));
                        eval(['Kextension.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( ( abs(anglePS) )/ abs(TarPronation) ) - 0.166 * ( (( angleAA * angleAA ) / ( maxABDADD * maxABDADD )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT )) + ((fing1*fing1)/(minFin1*minFin1)) + ((fing2*fing2)/(minFin2*minFin2)) + ((fing3*fing3)/(minFin3*minFin3)) + ((fing4*fing4)/(minFin4*minFin4)));
                        eval(['Kpronation.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( ( abs(anglePS) )/ abs(TarSupination) ) - 0.166 * ( (( angleAA * angleAA ) / ( maxABDADD * maxABDADD )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT )) + ((fing1*fing1)/(minFin1*minFin1)) + ((fing2*fing2)/(minFin2*minFin2)) + ((fing3*fing3)/(minFin3*minFin3)) + ((fing4*fing4)/(minFin4*minFin4)));
                        eval(['Ksupination.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( ( abs(angleAA) )/ abs(TarAdduction) ) - 0.166 * ( (( anglePS * anglePS ) / ( maxPROSUP * maxPROSUP )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT ))+ ((fing1*fing1)/(minFin1*minFin1)) + ((fing2*fing2)/(minFin2*minFin2)) + ((fing3*fing3)/(minFin3*minFin3)) + ((fing4*fing4)/(minFin4*minFin4)));
                        eval(['Kadduction.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                        
                        tmp  = 	( (abs(angleAA) )/ abs(TarAbduction) ) - 0.166 * ( (( anglePS * anglePS ) / ( maxPROSUP * maxPROSUP )) + (( angleEF * angleEF ) / ( maxFLEEXT * maxFLEEXT )) + ((fing1*fing1)/(minFin1*minFin1)) + ((fing2*fing2)/(minFin2*minFin2)) + ((fing3*fing3)/(minFin3*minFin3)) + ((fing4*fing4)/(minFin4*minFin4)));
                        eval(['Kabduction.Subject' int2str(s) '(' int2str(t) ',' int2str(r) ',' int2str(p) ') = tmp;']);
                    end
                    
                end
            end
        end
    end
end


%save('Metrics','Kabduction', 'Kadduction', 'Kflexion', 'Kextension', 'Kpronation', 'Ksupination');


