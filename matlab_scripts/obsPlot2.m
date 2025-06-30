clear;
close all;
clc;

% 1) Nombre del CSV
filename = 'Kstable_Subject8.csv';

% 2) Detectar import options y quedarnos sólo con las columnas 1, 2 y 38
opts = detectImportOptions(filename);
opts.DataLines = [2 Inf];
cols = [1, 2, 22, 26, 29, 32, 38];
opts.SelectedVariableNames = opts.VariableNames(cols);
T = readtable(filename, opts);

% 3) Extraer vectores
padIDs   = T{:,1};
kMatrix  = T{:, 2:end};  % cada columna un ángulo
angleLabels = [-90, 10, 30, 45, 60, 90];      % etiquetas para títulos
varNames    = opts.SelectedVariableNames(2:end);  % nombres de columna (opcional)

% 4) Parámetros de la rejilla
nRows = 5;
nCols = 3;

for iAng = 1:numel(angleLabels)
    kVec    = kMatrix(:, iAng);
    ang     = angleLabels(iAng);
    nameCol = varNames{iAng};  % si quieres usar el nombre real de la columna

     [kSorted, sortIdx] = sort(kVec, 'descend');
    fprintf('\n=== Angle %d° ===\n', ang);
    fprintf(' PadID    k-value\n');
    for ii = 1:numel(sortIdx)
        pid = padIDs(sortIdx(ii));
        kv  = kSorted(ii);
        fprintf('%5d    %8.4f\n', pid, kv);
    end

    % 5.1) Construir la matriz 5×3
    kMat = nan(nRows, nCols);
    for j = 1:numel(padIDs)
        id = padIDs(j);
        col = ceil(id / nRows);
        % fila contado desde abajo
        rowFromBottom = mod(id-1, nRows) + 1;
        % convertimos a índice de matriz (1 arriba, 5 abajo)
        row = nRows - rowFromBottom + 1;
        kMat(row, col) = kVec(j);
    end

    % 5.2) Dibujar heatmap
    figure('Name', sprintf('Subject 8-Rotation %.1f degrees\nObservation model', ang), 'NumberTitle','off');
    imagesc(kMat);
    colormap(parula);
    cb = colorbar;
    cb.Label.String   = 'Probability';
    cb.Label.FontSize = 16;

    title(sprintf('Subject 8-Rotation %.1f degrees\nObservation model', ang), 'FontSize', 16);
    axis equal tight;
    set(gca, 'XTick', 1:nCols, 'YTick', 1:nRows);
    xlabel('Cols', 'FontSize', 16);
    ylabel('Rows',    'FontSize', 16);
    set(gca,'XTickLabel', {'1','2','3'},  'FontSize', 16);
    set(gca,'YTickLabel', {'5','4','3','2','1'},  'FontSize', 16);
  
    hold on;

    % 5.3) Anotar cada celda con id y k
    for r = 1:nRows
        for c = 1:nCols
            v = kMat(r,c);
            if ~isnan(v)
                padID = (nRows - r) + (c-1)*nRows + 1;
                text(c, r, sprintf('id=%d\nk=%.4f', padID, v), ...
                     'HorizontalAlignment','center', ...
                     'Color','w', ...
                     'FontWeight','bold', ...
                     'FontSize',12);
            end
        end
    end
    hold off;
end