clear;
close all;
clc;

% 1) Nombre del CSV
filename = 'Kstable_Subject1.csv';

% 2) Detectar import options y quedarnos sólo con las columnas 1, 2 y 38
opts = detectImportOptions(filename);
opts.DataLines = [2 Inf];                   % desde línea 2 hasta el final
opts.SelectedVariableNames = opts.VariableNames([1, 2, 38]);
T = readtable(filename, opts);

% 3) Extraer vectores
padIDs    = T{:,1};   % columna 1 → PadID
k_minus90 = T{:,2};   % columna 2 → k para −90°
k_plus90  = T{:,3};   % columna 38 → k para +90° (ahora es la 3ª en T)

% 4) Parámetros de la rejilla
nRows = 5;
nCols = 3;

% 5) Función anónima para crear matriz 5×3 a partir de vectores (ids, ks)
makeMat = @(ids, ks) arrayfun(@(idx) deal( ...
    ceil(ids(idx)/nRows), ...                % col
    nRows - mod(ids(idx)-1,nRows) ...        % row
), 1:numel(ids), 'UniformOutput', false);
% (abajo la usamos en bucle explícito para mayor claridad)

% 6) Loop sobre los dos ángulos
for ang = {'-90°','+90°'}
    angleStr = ang{1};
    if strcmp(angleStr,'-90°')
        kVec = k_minus90;
        figTitle = '-90°';
    else
        kVec = k_plus90;
        figTitle = '90°';
    end

    % 7) Construir la matriz kMat
    kMat = nan(nRows,nCols);
    for i = 1:numel(padIDs)
        id = padIDs(i);
        col = ceil(id / nRows);
        rowFromBottom = mod(id-1,nRows) + 1;
        row = nRows - rowFromBottom + 1;
        kMat(row,col) = kVec(i);
    end
    % 8) Dibujar heatmap y anotar
    figure('Name',sprintf('Subject 2_%s\n',figTitle),'NumberTitle','off');
    imagesc(kMat);
    colormap(parula);
    cb = colorbar;
    cb.Label.String = 'Probability';
    title(sprintf('Subject 2 Kvalues for %s\nElectrode array configuration',figTitle));
    axis equal tight;
    set(gca,'XTick',1:nCols,'XTickLabel',{'1','2','3'});
    set(gca,'YTick',1:nRows,'YTickLabel',{'5','4','3','2','1'});
    xlabel('Cols');
    ylabel('Rows');
    hold on;

    % 9) Anotar cada celda con id y k
    for r = 1:nRows
        for c = 1:nCols
            v = kMat(r,c);
            if ~isnan(v)
                padID = (nRows - r) + (c-1)*nRows + 1;
                text(c, r, sprintf('id=%d\nprob=%.4f', padID, v), ...
                     'HorizontalAlignment','center', ...
                     'Color','w', 'FontWeight','bold', 'FontSize',9);
            end
        end
    end
    hold off;
end
