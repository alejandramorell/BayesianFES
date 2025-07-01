%% Lectura de ficheros y extracción de variables

filePath = 'C:\Users\alemo\IdeaProjects\getIMU\initialAngles_Channel_1.csv';
fid = fopen(filePath, 'r');
if fid < 0
    error('No se pudo abrir el fichero: %s', filePath);
end

roll_hand = [];
pitch_hand = [];
yaw_hand = [];
roll_arm = [];
pitch_arm = [];
yaw_arm = [];

while ~feof(fid)
    line = strtrim(fgetl(fid));
    if isempty(line), continue; end
    
    % Reemplazar comas decimales por puntos
    line = strrep(line, ',', '.');
    
    % Dividir por espacios
    parts = strsplit(line, ' ');
    
    % Convertir con str2double ya reconoce el punto
    roll_hand(end+1,1)  = str2double(parts{2});
    pitch_hand(end+1,1) = str2double(parts{3});
    yaw_hand(end+1,1)   = str2double(parts{4});
    roll_arm(end+1,1)   = str2double(parts{5});
    pitch_arm(end+1,1)  = str2double(parts{6});
    yaw_arm(end+1,1)    = str2double(parts{7});
end

fclose(fid);

fileFinal = 'C:\Users\alemo\IdeaProjects\getIMU\finalAngles_Channel_1.csv';
fid = fopen(fileFinal, 'r');
if fid < 0
    error('No se pudo abrir el fichero: %s', fileFinal);
end

roll_hand1 = [];
pitch_hand1 = [];
yaw_hand1 = [];
roll_arm1 = [];
pitch_arm1 = [];
yaw_arm1 = [];

while ~feof(fid)
    line1 = strtrim(fgetl(fid));
    if isempty(line1), continue; end
    
    % Reemplazar comas decimales por puntos
    line1 = strrep(line1, ',', '.');
    
    % Dividir por espacios
    parts1 = strsplit(line1, ' ');
    
    % Convertir con str2double ya reconoce el punto
    roll_hand1(end+1,1)  = str2double(parts1{2});
    pitch_hand1(end+1,1) = str2double(parts1{3});
    yaw_hand1(end+1,1)   = str2double(parts1{4});
    roll_arm1(end+1,1)   = str2double(parts1{5});
    pitch_arm1(end+1,1)  = str2double(parts1{6});
    yaw_arm1(end+1,1)    = str2double(parts1{7});
end

fclose(fid);

%% PARTE 2: Graficar con ejes alineados

nHand = numel(roll_hand);
nArm  = numel(roll_arm);
N = max(nHand, nArm);
idxHand = (1:nHand)';
idxArm  = (1:nArm)';

% Calcular rangos Y comunes para cada fila
yRoll  = [roll_hand;  roll_arm];
yPitch = [pitch_hand; pitch_arm];
yYaw   = [yaw_hand;   yaw_arm];

ylimRoll  = [min(yRoll),  max(yRoll)];
ylimPitch = [min(yPitch), max(yPitch)];
ylimYaw   = [min(yYaw),   max(yYaw)];

nHand1 = numel(roll_hand1);
nArm1  = numel(roll_arm1);
N1 = max(nHand1, nArm1);
idxHand1 = (1:nHand1)';
idxArm1  = (1:nArm1)';

% Calcular rangos Y comunes para cada fila
yRoll1  = [roll_hand1;  roll_arm1];
yPitch1 = [pitch_hand1; pitch_arm1];
yYaw1   = [yaw_hand1;   yaw_arm1];

ylimRoll1  = [min(yRoll1),  max(yRoll1)];
ylimPitch1 = [min(yPitch1), max(yPitch1)];
ylimYaw1   = [min(yYaw1),   max(yYaw1)];

figure;

subplot(3,2,1);
plot(idxHand, roll_hand, 'b-o','LineWidth',1);
title('Roll(x) Mano');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N]);
ylim(ylimRoll + [-0.1, +0.1]*(ylimRoll(2)-ylimRoll(1)));
grid on;

subplot(3,2,2);
plot(idxHand1, roll_hand1, 'r-o','LineWidth',1);
title('Roll(x) Final Mano');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N1]);
ylim(ylimRoll1 + [-0.1, +0.1]*(ylimRoll1(2)-ylimRoll1(1)));
grid on;

subplot(3,2,3);
plot(idxHand, pitch_hand, 'b-o','LineWidth',1);
title('Pitch(y) Mano');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N]);
ylim(ylimPitch + [-0.1, +0.1]*(ylimPitch(2)-ylimPitch(1)));
grid on;

subplot(3,2,4);
plot(idxHand1, pitch_hand1, 'r-o','LineWidth',1);
title('Pitch(y) Final Mano');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N1]);
ylim(ylimPitch1 + [-0.1, +0.1]*(ylimPitch1(2)-ylimPitch1(1)));
grid on;


subplot(3,2,5);
plot(idxHand, yaw_hand, 'b-o','LineWidth',1);
title('Yaw(z) Mano');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N]);
ylim(ylimYaw + [-0.1, +0.1]*(ylimYaw(2)-ylimYaw(1)));
grid on;

subplot(3,2,6);
plot(idxHand1, yaw_hand1, 'r-o','LineWidth',1);
title('Yaw(z) Final Mano');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N1]);
ylim(ylimYaw1 + [-0.1, +0.1]*(ylimYaw1(2)-ylimYaw1(1)));
grid on;

sgtitle('Ángulos de Euler para la mano (iniciales vs finales)');  


figure;

subplot(3,2,1);
plot(idxArm, roll_arm, 'b-o','LineWidth',1);
title('Roll(x) Brazo');
xlabel('N muestra'); ylabel('Ángulo (°)');
xlim([1 N]);
ylim(ylimRoll + [-0.1, +0.1]*(ylimRoll(2)-ylimRoll(1)));
grid on;

subplot(3,2,2);
plot(idxArm1, roll_arm1, 'r-o','LineWidth',1);
title('Roll(x) Final Brazo');
xlabel('Muestra'); ylabel('°');
xlim([1 N1]);
ylim(ylimRoll1 + [-0.1, +0.1]*(ylimRoll1(2)-ylimRoll1(1)));
grid on;


subplot(3,2,3);
plot(idxArm, pitch_arm, 'b-o','LineWidth',1);
title('Pitch(y) Brazo');
xlabel('Muestra'); ylabel('°');
xlim([1 N]);
ylim(ylimPitch + [-0.1, +0.1]*(ylimPitch(2)-ylimPitch(1)));
grid on;

subplot(3,2,4);
plot(idxArm1, pitch_arm1, 'r-o','LineWidth',1);
title('Pitch(y) Final Brazo');
xlabel('Muestra'); ylabel('°');
xlim([1 N1]);
ylim(ylimPitch1 + [-0.1, +0.1]*(ylimPitch1(2)-ylimPitch1(1)));
grid on;

subplot(3,2,5);
plot(idxArm, yaw_arm, 'b-o','LineWidth',1);
title('Yaw(z) Brazo');
xlabel('Muestra'); ylabel('°');
xlim([1 N]);
ylim(ylimYaw + [-0.1, +0.1]*(ylimYaw(2)-ylimYaw(1)));
grid on;

subplot(3,2,6);
plot(idxArm1, yaw_arm1, 'r-o','LineWidth',1);
title('Yaw(z) Final Brazo');
xlabel('Muestra'); ylabel('°');
xlim([1 N1]);
ylim(ylimYaw1 + [-0.1, +0.1]*(ylimYaw1(2)-ylimYaw1(1)));
grid on;

sgtitle('Ángulos de Euler para el brazo (iniciales vs finales)');  
 


% Mostrar todo el contenido para verificar
fprintf('roll_hand:\n');  disp(roll_hand);
fprintf('pitch_hand:\n'); disp(pitch_hand);
fprintf('yaw_hand:\n');   disp(yaw_hand);
fprintf('roll_arm:\n');   disp(roll_arm);
fprintf('pitch_arm:\n');  disp(pitch_arm);
fprintf('yaw_arm:\n');    disp(yaw_arm); 

fprintf('roll_hand:\n');  disp(roll_hand1);
fprintf('pitch_hand:\n'); disp(pitch_hand1);
fprintf('yaw_hand:\n');   disp(yaw_hand1);
fprintf('roll_arm:\n');   disp(roll_arm1);
fprintf('pitch_arm:\n');  disp(pitch_arm1);
fprintf('yaw_arm:\n');    disp(yaw_arm1); 
 