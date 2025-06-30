clear all
close all
clc

load('Metrics2'); % carga Kflexion

subjectNames = {'Subject1' ,'Subject2', 'Subject3', 'Subject4','Subject5','Subject6','Subject7','Subject8', 'Subject9', 'Subject10'}; % Lista de sujetos

trial_index = [5, 9, 10];        % Nos interesan los trials 5, 9 y 10
angles      = [0,  90, -90];     % Ángulos asociados a esos trials
[angles_sorted, sort_idx] = sort(angles);  % Orden: -90, 0, 90

anglesQuery = -90 : 5 : 90;       % Ángulos para interpolar K
nQuery      = numel(anglesQuery);

for s = 1:numel(subjectNames)
    subj = subjectNames{s};
    fprintf('Procesando %s...\n\n', subj);
    
    % Variables para este sujeto
    initialK_values = zeros(15, 1);
    coeficcients    = zeros(15, 3);
    
    % Extraer datos de Kflexion para el sujeto actual
    KmatFull = Kflexion.(subj);  % dimensión [nTrials x 3 angulos oficiales x 15 pads]
    
    for pad = 1:15
        % 1) Extraer las filas correspondientes a este pad (size = nTrials × 3)
        Kvalues = squeeze(KmatFull(:, :, pad));  % e.g. 14×3 si hay 14 trials
        
        % 2) Seleccionar solo los trials 5, 9 y 10 → 3×3
        selected_trials = Kvalues(trial_index, :);
        trial_means     = mean(selected_trials, 2, 'omitnan');  % 3×1
        trial_means(trial_means < 0) = 0;
        
        % 3) Guardar initialK = media del trial 5 (primer elemento)
        %Valor incial de k por pad, media del trial 5 (0 grados)
        initialK_values(pad) = trial_means(1);
        
        % 4) Ordenar para ajustar la parábola
        tm_sorted  = trial_means(sort_idx);
        ang_sorted = angles_sorted(:);
        tm_sorted = tm_sorted(:);
        
        % 5) Ajuste cuadrático: K(θ) = a*θ^2 + b*θ + c
        p = polyfit(ang_sorted, tm_sorted, 2);
        coeficcients(pad, :) = p;
        
        
        figure;
        bar(angles_sorted, tm_sorted, 'FaceColor', [0.2 0.6 0.8]);
        xlabel('Angle (degrees)');
        ylabel('Kflexion');
        title(sprintf('%s - Pad %d', subj, pad));
        xticks(angles_sorted);
        grid on;
        hold on;
        
        x_fit = linspace(min(ang_sorted)-10, max(ang_sorted)+10, 300);
        y_fit = polyval(p, x_fit);
        plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
        
        angle_query = 45;
        K_interp = polyval(p, angle_query);
        plot(angle_query, K_interp, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
        text(angle_query, K_interp, sprintf('  K=%.2f', K_interp), 'Color', 'r', 'FontSize', 10);
        hold off;
        
    end
    
    % 6) Guardar initialK_values para este sujeto
    outInitFile = sprintf('InitialK_values_%s.csv', subj);
    writematrix(initialK_values, outInitFile);
    fprintf('  Guardado: %s\n', outInitFile);
    
    % 7) Interpolar para obtener Kstable (15×nQuery)
    % Los Ks que se guardan en la tabla sonlso valores del modelo de
    % observación
    kInterp = zeros(15, nQuery);  %para cada sujeto, y para los 15 pads de cada sujeto
    for pad = 1:15 %obtengo coefs de la ec que define al recta de cada punto  k de cada pad
        a = coeficcients(pad, 1);
        b = coeficcients(pad, 2);
        c = coeficcients(pad, 3);
        
        Ki = a*anglesQuery.^2 + b*anglesQuery + c;
        Ki(Ki < 0) = 0; %guardo el valor de k para cada ángulo comprendido entre -90 y 90
        kInterp(pad, :) = Ki;
    end
    
    % 8) Preparar encabezados para CSV de Kstable
    PadID  = (1:15)';
    header = cell(1, nQuery+1);
    header{1} = 'PadID';
    for j = 1:nQuery
        header{j+1} = sprintf('%+d°', anglesQuery(j));
    end
    dataCells = num2cell([PadID, kInterp]);
    outCell   = [header; dataCells];
    
    % 9) Guardar Kstable para este sujeto
    outKFile = sprintf('Kstable_%s.csv', subj);
    writecell(outCell, outKFile);
    fprintf('  Guardado: %s\n\n', outKFile);
end

fprintf('¡Todos los sujetos han sido procesados!\n');
