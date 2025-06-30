clear all
close all
clc

%load the metrics of all subjects all trial and all repetitions
load Metrics2;
load Trials;

fp = [6,9,10];
apf = [5,6,7,8];
ape = [1,2,3,4];
hm = [10,11,12,13,14];


MediasExtension(1:10,1:14,1:15) = 0;
MediasFlexion(1:10,1:14,1:15) = 0;
MediasPronation(1:10,1:14,1:15) = 0;
MediasSupination(1:10,1:14,1:15) = 0;
MediasAdduction(1:10,1:14,1:15) = 0;
MediasAbduction(1:10,1:14,1:15) = 0;
StdExtension(1:10,1:14,1:15) = 0;
StdFlexion(1:10,1:14,1:15) = 0;


ind(1:10,1:14) = 1;
for s=1:10  % usuario
    for t= 1:14 % trial
        for p = 1:15 % pad
            
            if(t>=5)
                eval(['ve = find(Kflexion.Subject' int2str(s) '(' int2str(t) ',:,' int2str(p) ')>0);']);
                if(length(ve)>0)
                eval(['MediasFlexion(s,t,p) = mean(Kflexion.Subject' int2str(s) '(t,ve,p));']);
                eval(['StDFlexion(s,t,p) = std (Kflexion.Subject' int2str(s) '(t,ve,p));']);
                end
                
            end
            if(t<5)
                eval(['vv = find(Kextension.Subject' int2str(s) '(t,:,p)>0);']);
                if(length(vv)>0)
                eval(['MediasExtension(s,t,p) = mean(Kextension.Subject' int2str(s) '(t,vv,p));']);
                eval(['StdExtension(s,t,p) = std (Kextension.Subject' int2str(s) '(t,vv,p));']);
                end
            end
            
            eval(['vp = find(Kpronation.Subject' int2str(s) '(t,:,p)>0);']);
            if(length(vp)>0)
                eval(['MediasPronation(s,t,p) =  mean(Kpronation.Subject' int2str(s) '(t,vp,p));']);
                eval(['StdPronation(s,t,p) = std (Kpronation.Subject' int2str(s) '(t,vp,p));']);
            else
                MediasPronation(s,t,p) = 0;
                StdPronation(s,t,p) = 0;                
            end
            eval(['vs = find(Ksupination.Subject' int2str(s) '(t,:,p)>0);']);
            if(length(vs)>0)
                eval(['MediasSupination(s,t,p) =  mean(Ksupination.Subject' int2str(s) '(t,vs,p));']);
                eval(['StdSupination(s,t,p) = std (Ksupination.Subject' int2str(s) '(t,vs,p));']);
            else
                MediasSupination(s,t,p) = 0;
                StdSupination(s,t,p) = 0;
            end
            eval(['vd = find(Kadduction.Subject' int2str(s) '(t,:,p)>0);']);
            if(length(vd)>0)
                eval(['MediasAdduction(s,t,p) =  mean(Kadduction.Subject' int2str(s) '(t,vd,p));']);
                eval(['StdAdduction(s,t,p) = std (Kadduction.Subject' int2str(s) '(t,vd,p));']);
            else
                MediasAdduction(s,t,p) = 0;
                StdAdduction(s,t,p) = 0;
            end
            eval(['vb = find(Kabduction.Subject' int2str(s) '(t,:,p)>0);']);
            if(length(vb)>0)
                eval(['MediasAbduction(s,t,p) =  mean(Kabduction.Subject' int2str(s) '(t,vb,p));']);
                eval(['StdAbduction(s,t,p) = std (Kabduction.Subject' int2str(s) '(t,vb,p));']);
            else
                MediasAbduction(s,t,p) = 0;
                StdAbduction(s,t,p) = 0;
            end
        end
        
    end
end

save('Medias','MediasFlexion','MediasExtension','MediasPronation','MediasSupination','MediasAdduction','MediasAbduction');

MediasSupination

%% plot means forearm position
% figure; hold on;
% for s=1:10  % usuario
%     subplot(5,2,s); hold on;
%     errorbar(MediasFlexion(s,fp(1),1:15),StDFlexion(s,fp(1),1:15),'marker','o','linestyle','none','Color','blue');
%     errorbar(MediasFlexion(s,fp(2),1:15),StDFlexion(s,fp(2),1:15),'marker','o','linestyle','none','Color','red');
%     errorbar(MediasFlexion(s,fp(3),1:15),StDFlexion(s,fp(3),1:15),'marker','o','linestyle','none','Color','green');
%     axis([0 16 0 1])
% end

% plot means hydrogel membranes
figure; hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    errorbar(MediasFlexion(s,hm(1),1:15),StDFlexion(s,hm(1),1:15),'marker','.','linestyle','none','Color','blue');
    errorbar(MediasFlexion(s,hm(2),1:15),StDFlexion(s,hm(2),1:15),'marker','.','linestyle','none','Color','red');
    errorbar(MediasFlexion(s,hm(3),1:15),StDFlexion(s,hm(3),1:15),'marker','.','linestyle','none','Color','green');
    errorbar(MediasFlexion(s,hm(4),1:15),StDFlexion(s,hm(4),1:15),'marker','.','linestyle','none','Color','magenta');
    errorbar(MediasFlexion(s,hm(5),1:15),StDFlexion(s,hm(5),1:15),'marker','.','linestyle','none','Color','black');
    axis([0 16 0 1])
end
figure(1); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasFlexion(s,hm(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasFlexion(s,hm(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasFlexion(s,hm(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasFlexion(s,hm(4),1:15);
    plot(tmp,'m-*');
    tmp(1:15) = MediasFlexion(s,hm(5),1:15);
    plot(tmp,'k-*');
    axis([0 16 0 1])
end
figure(2); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasPronation(s,hm(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasPronation(s,hm(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasPronation(s,hm(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasPronation(s,hm(4),1:15);
    plot(tmp,'m-*');
    tmp(1:15) = MediasPronation(s,hm(5),1:15);
    plot(tmp,'k-*');
    axis([0 16 0 1])
end
figure(3); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasSupination(s,hm(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasSupination(s,hm(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasSupination(s,hm(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasSupination(s,hm(4),1:15);
    plot(tmp,'m-*');
    tmp(1:15) = MediasSupination(s,hm(5),1:15);
    plot(tmp,'k-*');
    axis([0 16 0 1])
end
figure(4); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasAdduction(s,hm(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasAdduction(s,hm(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasAdduction(s,hm(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasAdduction(s,hm(4),1:15);
    plot(tmp,'m-*');
    tmp(1:15) = MediasAdduction(s,hm(5),1:15);
    plot(tmp,'k-*');
    axis([0 16 0 1])
end
figure(5); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasAbduction(s,hm(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasAbduction(s,hm(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasAbduction(s,hm(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasAbduction(s,hm(4),1:15);
    plot(tmp,'m-*');
    tmp(1:15) = MediasAbduction(s,hm(5),1:15);
    plot(tmp,'k-*');
    axis([0 16 0 1])
end



% plot means anode position flexors
figure; hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    errorbar(MediasFlexion(s,apf(1),1:15),StDFlexion(s,apf(1),1:15),'marker','.','linestyle','none','Color','blue');
    errorbar(MediasFlexion(s,apf(2),1:15),StDFlexion(s,apf(2),1:15),'marker','.','linestyle','none','Color','red');
    errorbar(MediasFlexion(s,apf(3),1:15),StDFlexion(s,apf(3),1:15),'marker','.','linestyle','none','Color','green');
    errorbar(MediasFlexion(s,apf(4),1:15),StDFlexion(s,apf(4),1:15),'marker','.','linestyle','none','Color','magenta');
    axis([0 16 0 1])
end 
figure(1); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasFlexion(s,apf(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasFlexion(s,apf(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasFlexion(s,apf(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasFlexion(s,apf(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(2); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasPronation(s,apf(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasPronation(s,apf(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasPronation(s,apf(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasPronation(s,apf(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(3); hold on;
for s=1:10 % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasSupination(s,apf(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasSupination(s,apf(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasSupination(s,apf(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasSupination(s,apf(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(4); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasAdduction(s,apf(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasAdduction(s,apf(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasAdduction(s,apf(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasAdduction(s,apf(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(5); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasAbduction(s,apf(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasAbduction(s,apf(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasAbduction(s,apf(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasAbduction(s,apf(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end

% plot means anode position extensors
figure; hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    errorbar(MediasExtension(s,ape(1),1:15),StDExtension(s,ape(1),1:15),'marker','.','linestyle','none','Color','blue');
    errorbar(MediasExtension(s,ape(2),1:15),StDExtension(s,ape(2),1:15),'marker','.','linestyle','none','Color','red');
    errorbar(MediasExtension(s,ape(3),1:15),StDExtension(s,ape(3),1:15),'marker','.','linestyle','none','Color','green');
    errorbar(MediasExtension(s,ape(4),1:15),StDExtension(s,ape(4),1:15),'marker','.','linestyle','none','Color','magenta');
    axis([0 16 0 1])
end
figure(1); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasExtension(s,ape(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasExtension(s,ape(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasExtension(s,ape(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasExtension(s,ape(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(2); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasPronation(s,ape(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasPronation(s,ape(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasPronation(s,ape(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasPronation(s,ape(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(3); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasSupination(s,ape(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasSupination(s,ape(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasSupination(s,ape(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasSupination(s,ape(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(4); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasAdduction(s,ape(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasAdduction(s,ape(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasAdduction(s,ape(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasAdduction(s,ape(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end
figure(5); hold on;
for s=1:10  % usuario
    subplot(5,2,s); hold on;
    tmp(1:15) = MediasAbduction(s,ape(1),1:15); 
    plot(tmp,'b-*');
    tmp(1:15) = MediasAbduction(s,ape(2),1:15);
    plot(tmp,'r-*');
    tmp(1:15) = MediasAbduction(s,ape(3),1:15);
    plot(tmp,'g-*');
    tmp(1:15) = MediasAbduction(s,ape(4),1:15);
    plot(tmp,'m-*');
    axis([0 16 0 1])
end

