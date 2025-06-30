
clear; 
close all; 
clc;

angles = [-90.0, 10.0, 30.0, 45.0, 60.0, 90.0];

% 1) Nombre del archivo CSV a leer
for a = 1:numel(angles)
    angle = angles(a);
    filename = sprintf('results_Subject8_angle_%.1f.csv', angle);
    
    % 2) Leer los datos principales (líneas 2 a 16)
    opts = detectImportOptions(filename, 'NumHeaderLines', 0);
    opts.DataLines = [2, 16];
    opts.SelectedVariableNames = {'PadID','InitialProb','Displacement','PredictedProb','CorrectedProb'};
    T = readtable(filename, opts);
    
    %Guarda cada columna en un array para poder plotearlo luego
    padIDs       = T.PadID;          % 15×1
    initialProb  = T.InitialProb;    % 15×1
    probPred     = T.PredictedProb;  % 15×1
    displacement = T.Displacement;   % 15×1
    probPost     = T.CorrectedProb;  % 15×1
    
    %Imprime por pantalla los resultados leidos del csv
    fprintf(filename);
    fprintf('\n');
    
    fprintf('PadID  InitialProb  Displacement  PredictedProb  CorrectedProb\n');
    for idx = 1:numel(padIDs)
        fprintf('%5d  %11.6f  %11.6f  %13.8f  %13.8f\n', ...
            padIDs(idx), initialProb(idx), displacement(idx), probPred(idx), probPost(idx));
    end
    
    % 4) Leer la línea “TopPad1,TopPad2,TopPad3” al final del archivo
    fid = fopen(filename, 'r');
    topIDs = nan(1,3);
    while ~feof(fid)
        line = fgetl(fid);
        if ischar(line) && startsWith(line, 'TopPad1')
            nextLine = fgetl(fid);
            tokens = strsplit(strtrim(nextLine), ',');
            for k = 1:numel(tokens)
                if ~isempty(tokens{k})
                    topIDs(k) = str2double(tokens{k});
                end
            end
            break;
        end
    end
    fclose(fid);
    validTop = topIDs(~isnan(topIDs));
    
    % Mostrar top pads por pantalla
    fprintf('\nSelected pads (TopPads):\n');
    if isempty(validTop)
        fprintf('  (ningún pad seleccionado)\n');
    else
        for k = 1:numel(validTop)
            fprintf('  TopPad%d = %d\n', k, validTop(k));
        end
    end
    
    %% 5) Construir matrices 5×3 para cada variable de probabilidad
    nRows = 5;
    nCols = 3;
    initMat  = nan(nRows, nCols); %Matriz que acumula la probabilidad incial de cada pad
    predMat  = nan(nRows, nCols); %Matriz que acumula la probabilidad predecida de cada pad
    postMat  = nan(nRows, nCols); %Matriz que acumula la probabilidad corregida de cada pad
    
    for idx = 1:numel(padIDs)
        id = padIDs(idx);
        col = ceil(id / nRows);             % columna 1..3 (cada 5 pads)
        rowFromBottom = mod(id-1, nRows) + 1; % 1..5 (1 = fila inferior)
        row = nRows - rowFromBottom + 1;      % convierte bottom→top
        
        initMat(row, col) = initialProb(idx);
        predMat(row, col) = probPred(idx);
        postMat(row, col) = probPost(idx);
    end
    
    % 6) Crear figura con 3 subplots (1×3)
    figure('Name', sprintf('Pads configuration for Subject 5_%.1f degrees', angle'), 'NumberTitle','off');
    
    % --- Subplot 1: InitialProb (heatmap) + texto "id = X; k = Y" ---
    subplot(1,3,1);
    imagesc(initMat);
    colormap(subplot(1,3,1), parula);
    cb = colorbar;
    cb.Label.String = 'Probability';
    cb.Label.FontSize = 16; 
    title('Initial Probability','FontSize',16);
    axis equal tight;
    set(gca, 'XTick', 1:nCols, 'YTick', 1:nRows);
    xlabel('Cols','FontSize',16);
    ylabel('Rows','FontSize',16);
    set(gca,'XTickLabel', {'1','2','3'}, 'FontSize', 16);
    set(gca,'YTickLabel', {'5','4','3','2','1'}, 'FontSize', 16); % fila de abajo arriba
    hold on;
    for r = 1:nRows
        for c = 1:nCols
            val = initMat(r, c);
            if ~isnan(val)
                padID = (nRows - r) + (c-1)*nRows + 1; % reconstruye ID bottom→top
                text(c, r, sprintf('id=%d\nprob=%.4f', padID, val), ...
                    'HorizontalAlignment','center', ...
                    'Color','w', 'FontWeight','bold', 'FontSize', 11);
            end
        end
    end
    hold off;
    
    % --- Subplot 2: PredictedProb (heatmap) + texto "id = X; k = Y" ---
    subplot(1,3,2);
    imagesc(predMat);
    colormap(subplot(1,3,2), parula);
    cb = colorbar;
    cb.Label.String = 'Probability';
    cb.Label.FontSize = 16; 

    title('Predicted Probability','FontSize',16);
    axis equal tight;
    set(gca, 'XTick', 1:nCols, 'YTick', 1:nRows);
    xlabel('Cols','FontSize',16);
    ylabel('Rows','FontSize',16);
    set(gca,'XTickLabel', {'1','2','3'},  'FontSize', 16);
    set(gca,'YTickLabel', {'5','4','3','2','1'},  'FontSize', 16);
    hold on;
    for r = 1:nRows
        for c = 1:nCols
            val = predMat(r, c);
            if ~isnan(val)
                padID = (nRows - r) + (c-1)*nRows + 1;
                text(c, r, sprintf('id=%d\nprob=%.4f', padID, val), ...
                    'HorizontalAlignment','center', ...
                    'Color','w', 'FontWeight','bold', 'FontSize', 11);
            end
        end
    end
    hold off;
    
    % --- Subplot 3: CorrectedProb (heatmap) + texto "id = X; k = Y" + sombrear TopPads ---
    subplot(1,3,3);
    imagesc(postMat);
    colormap(subplot(1,3,3), parula);
    cb = colorbar;
    cb.Label.String = 'Probability';
    cb.Label.FontSize = 16; 

    title('Corrected Probability + Selected pads', 'FontSize',16);
    axis equal tight;
    set(gca, 'XTick', 1:nCols, 'YTick', 1:nRows);
    xlabel('Cols','FontSize',16);
    ylabel('Rows', 'FontSize',16);
    set(gca,'XTickLabel', {'1','2','3'},  'FontSize', 16);
    set(gca,'YTickLabel', {'5','4','3','2','1'},  'FontSize', 16);
    hold on;
    for r = 1:nRows
        for c = 1:nCols
            val = postMat(r, c);
            if ~isnan(val)
                padID = (nRows - r) + (c-1)*nRows + 1;
                text(c, r, sprintf('id=%d\nprob=%.4f', padID, val), ...
                    'HorizontalAlignment','center', ...
                    'Color','w', 'FontWeight','bold', 'FontSize', 11);
            end
        end
    end
    % Sombrear TopPads
    for k = 1:numel(validTop)
        id = validTop(k);
        col = ceil(id / nRows);
        rowFromBottom = mod(id-1, nRows) + 1;
        row = nRows - rowFromBottom + 1;
        rectangle('Position',[col-0.5, row-0.5, 1, 1], ...
                  'EdgeColor','r', 'LineWidth',2);
    end
    hold off;
    
    % 7) Ajustes finales
    sgt = sgtitle(sprintf('Subject 5-Rotation %.1f degrees\nBayesian algorithm prediction', angle));
    sgt.FontSize = 20;
end