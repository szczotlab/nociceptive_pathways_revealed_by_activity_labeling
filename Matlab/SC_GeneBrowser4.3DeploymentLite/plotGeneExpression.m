function plotGeneExpression(stimuli, stimuli_choice, normedMatrix, sparseMatrix, categories, geneNames, colorScale, dotSize, stim_names, plotOrder, geneName,app)
% plotGeneExpression(normedMatrix, sparseMatrix, categories, geneNames, colorScale, dotSize, plotOrder, geneName)
% This function takes an input matrix `data` with the following structure:
% Column 1: Category number (integer)
% Column 2: Total number of genes (numeric)
% Column 3: Total number of reads (numeric)
% Additional inputs:
% - `colorScale`: a two-element vector [min, max] defining the range for color mapping.
% - `dotSize`: a scalar specifying the size of the dots in the plots.
% - `plotOrder`: a vector specifying the order of categories for plotting (optional).
%   If skipped, categories are plotted in ascending order.
% - `geneName`: an optional string specifying the gene name to include in plot titles.
% The function produces:
% 1. A dot plot of normalized gene expression per category
% 2. A dot plot of raw gene expression per category
% 3. A violin plot of normalized gene expression per category using a Gaussian kernel
% 4. A violin plot of raw gene expression per category using a Gaussian kernel
% 5. A box-and-whisker plot of normalized gene expression per category
% 6. A box-and-whisker plot of raw gene expression per category

% Find indices where stimuli is equal to any value in stimuli_choice

% NOTE THOSE ARE HARDWIRED FOR A PARTICULAR COLOR SCHEME ENCODED IN COLORMAP
% VAIRABLE
% B=load('C:\Users\marsz29\Desktop\Sciencetech\SC_GeneBrowser4.0-1-25\colormap_chosen.mat');

whisker_line_width=3

if ~isempty(stimuli_choice)
    indices = find(ismember(stimuli, stimuli_choice));
    normedMatrix=normedMatrix(indices,:);
    sparseMatrix=sparseMatrix(indices,:);
    categories=categories(indices);
end

outputMatrix = extractGeneData(geneName, geneNames, normedMatrix, sparseMatrix, categories);
data = outputMatrix;

% Extract columns
categories = data(:, 1);
genes = data(:, 2);
reads = data(:, 3);

% Determine plotting order
if nargin < 12 || isempty(plotOrder)
    uniqueCategories = unique(categories,'stable');
else
    [~, idx] = ismember(categories, plotOrder);
    if any(idx == 0)
        warning('Some categories in plotOrder are not found in data; they will be ignored.');
        %idx = idx(idx > 0); % Remove unmatched categories
    end
    [~, sortIdx] = sort(idx);
    categories = categories(sortIdx);
    genes = genes(sortIdx);
    reads = reads(sortIdx);
    uniqueCategories = plotOrder;
end

% Set default gene name if not provided
if nargin < 10 || isempty(geneName)
    geneName = 'Genes';
end

% Map categories to colors using helper function
colors = mapColorsToCategories(uniqueCategories, colorScale);

%% Dot Plot: Normalized Gene Expression per Category
figure;
groupedGenes = arrayfun(@(cat) genes(categories == cat), uniqueCategories, 'UniformOutput', false);
subplot(3, 2, 1);
hold on;
for i = 1:numel(uniqueCategories)
    if ~isempty(groupedGenes{i})
        jitter = calculateJitter(groupedGenes{i}, uniqueCategories(i)); % Calculate jitter based on violin shape
        scatter(i + jitter, groupedGenes{i}, dotSize, colors(i, :), 'filled');
    end
end
hold off;
title(['Dot Plot: ', geneName, ' Expression per Category in', app.CampariChoice.Value]);
xlabel('Category');
ylabel(['Normalized ', geneName, ' Expression']);
grid on;

%% Dot Plot: Raw Gene Expression per Category
groupedReads = arrayfun(@(cat) reads(categories == cat), uniqueCategories, 'UniformOutput', false);
subplot(3, 2, 2);
hold on;
for i = 1:numel(uniqueCategories)
    if ~isempty(groupedReads{i})
        jitter = calculateJitter(groupedReads{i}, uniqueCategories(i)); % Calculate jitter based on violin shape
        scatter(i + jitter, groupedReads{i}, dotSize, colors(i, :), 'filled');
    end
end
hold off;
title(['Dot Plot: Raw ', geneName, ' Expression per Category in ', app.CampariChoice.Value]);
xlabel('Category');
ylabel(['Raw ', geneName, ' Expression']);
grid on;

%% Violin Plot Helper Function
function violinPlot(data, categories, plotTitle, yLabel, colors, dotSize, plotOrder)
    uniqueCats = unique(categories,'stable');
    x = 1:numel(plotOrder);
    hold on;
    for i = 1:numel(plotOrder)
        catData = data(categories == plotOrder(i));
        if ~isempty(catData)
            % Kernel density estimation with Gaussian kernel
            [f, xi] = ksdensity(catData, 'Kernel', 'normal');
            f = f / max(f) * 0.4; % Normalize and scale for plotting
            fill([x(i) - f, x(i) * ones(size(xi))], [xi, xi], colors(i, :), 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Only left half
            jitter = calculateJitter_RightSided(catData, uniqueCategories(i)); % Calculate jitter based on violin shape
            scatter(x(i) + jitter, catData, dotSize, colors(i, :), 'filled'); % Adjust dot size in violin plot
        end
    end
    hold off;
    set(gca, 'XTick', x, 'XTickLabel', plotOrder);
    title(plotTitle);
    xlabel('Category');
    ylabel(yLabel);
    grid on;
end

%% Violin Plot: Normalized Gene Expression per Category
subplot(3, 2, 3);
violinPlot(genes, categories, ['Violin Plot: Normalized ', geneName, ' Expression in ', app.CampariChoice.Value], ['Normalized ', geneName, ' Expression in ', app.CampariChoice.Value], colors, dotSize, plotOrder);

%% Violin Plot: Raw Gene Expression per Category
subplot(3, 2, 4);
violinPlot(reads, categories, ['Violin Plot: Raw ', geneName, ' Expression in ', app.CampariChoice.Value], ['Raw ', geneName, ' Expression in ', app.CampariChoice.Value], colors, dotSize, plotOrder);

H=gcf;
doubleFigureSize(H, 1.6);
stats_counts_genes = computeStatisticsByCategory(genes, reads, categories,'genes','reads');
stats_counts_genes.Gene=geneName;
H.UserData=stats_counts_genes;
notePosition = [0.905, 0.575]; % [right, top] in normalized coordinates
noteContent = sprintf([' Colors preserved relative \n to figures for constant 0 to 32 scaling \n class numbers use standarized notation:\n' ...
                        '\n0. PEP3(Adm)\n1. NP1(Mrgprd)\n2. Ab-LTMR (Calb1)\n3. (none)\n4. C-LTMR(Th)\n5. NP2(Mrgpra3/b4) \n6. (none) \n7. PEP1(Oprk1)\n8. PEP3(S100a16) \n9. PEP1(Adra2a) \n10. PEP2(Smr2) \n11. NP3 (Sst)\n12. (none)\n13. Ad-LTMR(Ntrk2h)\n14 (none)\n15. (none)\n16.PEP1 (Sstr2)\n17.Unassigned\n18. Prop.(Pvalb)']); 

% Add the note as a textbox annotation
annotation('textbox', ...
    [notePosition(1), notePosition(2), 0.1, 0.1], ... % [x, y, width, height] normalized
    'String', noteContent, ...
    'EdgeColor', 'none', ... % No border
    'FontSize', 8, ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', ...
    'FitBoxToText', 'on');

%% Box-and-Whisker Plot: Normalized Gene Expression per Category
subplot(3, 2, 5);
hold on;
for i = 1:numel(plotOrder)
    catData = genes(categories == plotOrder(i));
    if ~isempty(catData)
        % Calculate basic statistics for box-and-whisker
        q1 = quantile(catData, 0.25);
        q3 = quantile(catData, 0.75);
        medianVal = median(catData);
        iqr = q3 - q1;
        whiskerLow = max(min(catData), q1 - 1.5 * iqr);
        whiskerHigh = min(max(catData), q3 + 1.5 * iqr);
        % Plot box with transparent fill
        fill([i - 0.2, i + 0.2, i + 0.2, i - 0.2], [q1, q1, q3, q3], colors(i, :), 'FaceAlpha', 0, 'EdgeColor', colors(i, :), 'LineWidth', whisker_line_width);
        % Plot median
        plot([i - 0.2, i + 0.2], [medianVal, medianVal], 'Color', colors(i, :), 'LineWidth', whisker_line_width);
        % Plot whiskers
        plot([i, i], [whiskerLow, q1], 'Color', colors(i, :), 'LineWidth', whisker_line_width);
        plot([i, i], [q3, whiskerHigh], 'Color', colors(i, :), 'LineWidth', whisker_line_width);
        % Scatter plot for category
        %jitter = (rand(size(catData)) - 0.5) * 0.4;
        jitter = calculateJitter(catData, plotOrder(i)); 
        scatter(i + jitter, catData, dotSize, colors(i, :), 'filled','MarkerFaceAlpha',0.5);
    end
end
hold off;
title(['Box-and-Whisker Plot: ', geneName, ' Normalized Expression in ', app.CampariChoice.Value]);
xlabel('Category');
ylabel(['Normalized ', geneName, ' Expression']);
x = 1:numel(plotOrder);
set(gca, 'XTick', x, 'XTickLabel', plotOrder);
set(gca, 'XTick', x, 'XTickLabel', plotOrder);
grid off;

%% Box-and-Whisker Plot: Raw Gene Expression per Category
subplot(3, 2, 6);
hold on;
for i = 1:numel(plotOrder)
    catDataRaw = reads(categories == plotOrder(i));
    if ~isempty(catDataRaw)
        % Calculate basic statistics for box-and-whisker
        q1 = quantile(catDataRaw, 0.25);
        q3 = quantile(catDataRaw, 0.75);
        medianVal = median(catDataRaw);
        iqr = q3 - q1;
        whiskerLow = max(min(catDataRaw), q1 - 1.5 * iqr);
        whiskerHigh = min(max(catDataRaw), q3 + 1.5 * iqr);
        % Plot box with transparent fill
        fill([i - 0.2, i + 0.2, i + 0.2, i - 0.2], [q1, q1, q3, q3], colors(i, :), 'FaceAlpha', 0, 'EdgeColor', colors(i, :), 'LineWidth', whisker_line_width);
        % Plot median
        plot([i - 0.2, i + 0.2], [medianVal, medianVal], 'Color', colors(i, :), 'LineWidth', whisker_line_width);
        % Plot whiskers
        plot([i, i], [whiskerLow, q1], 'Color', colors(i, :), 'LineWidth', whisker_line_width);
        plot([i, i], [q3, whiskerHigh], 'Color', colors(i, :), 'LineWidth', whisker_line_width);
        % Scatter plot for category
        jitter = (rand(size(catDataRaw)) - 0.5) * 0.4;
        scatter(i + jitter, catDataRaw, dotSize, colors(i, :), 'filled','MarkerFaceAlpha',0.5);
    end
end
%comment out when not needed anymore
hold off;
title(['Box-and-Whisker Plot: ', geneName, ' Raw Expression in ', app.CampariChoice.Value]);
xlabel('Category');
ylabel(['Raw ', geneName, ' Expression']);
x = 1:numel(plotOrder);
set(gca, 'XTick', x, 'XTickLabel', plotOrder);
grid off;

end


function jitter = calculateJitter(data, category)
% calculateJitter calculates the x-axis jitter for points in a category
% such that the points approximate the shape of a violin plot.

% Perform kernel density estimation
[f, xi] = ksdensity(data, 'Kernel', 'normal');

% Normalize the density to define the width of the violin
f = f / max(f) * 0.4;

% Generate random x-axis offsets proportional to the density
jitter = zeros(size(data));
for i = 1:numel(data)
    % Find the nearest xi value
    [~, idx] = min(abs(xi - data(i)));
    % Assign a random jitter within the density at this point
    jitter(i) = (rand - 0.5) * 2 * f(idx);
end
end

function jitter = calculateJitter_RightSided(data, category)
% calculateJitter_RightSided calculates the x-axis jitter for points in a category
% such that the points appear only on the right side of the violin plot.

% Perform kernel density estimation
[f, xi] = ksdensity(data, 'Kernel', 'normal');

% Normalize the density to define the width of the violin
f = f / max(f) * 0.4;

% Generate random x-axis offsets proportional to the density
jitter = zeros(size(data));
for i = 1:numel(data)
    % Find the nearest xi value
    [~, idx] = min(abs(xi - data(i)));
    % Assign a random jitter on the right side within the density at this point
    jitter(i) = rand * f(idx);
end
end


function outputMatrix = extractGeneData(geneString, geneNames, normedMatrix, sparseMatrix, categories)
% extractGeneData finds a gene by its name, retrieves its index, and constructs an output matrix.
% Inputs:
% - geneString: A string representing the gene to be found.
% - geneNames: A cell array of gene names.
% - normedMatrix: A matrix of normalized gene counts.
% - sparseMatrix: A matrix of raw gene counts.
% Outputs:
% - outputMatrix: A three-column matrix with the following structure:
%   Column 1: Category numbers (1, 2, ... N)
%   Column 2: Normalized gene counts for the specified gene.
%   Column 3: Raw gene counts for the specified gene.

% Find the index of the gene
for i = 1:size(geneNames, 1)
    if ~isempty(strfind(string(geneNames(i, :)), geneString))
        geneIndex = i;
        break;
    end
end
if isempty(geneIndex)
    error('Gene not found in the provided gene names.');
end

% Retrieve the normalized and raw counts for the gene
normedCounts = normedMatrix(:, geneIndex);
rawCounts = sparseMatrix(:, geneIndex);

% Create the output matrix
outputMatrix = [categories, normedCounts, rawCounts];
end

function colors = mapColorsToCategories(categories, colorScale)
% mapColorsToCategories maps category numbers to colors from the colorcube colormap
% scaled between the provided colorScale [min, max].
    B=load('colormap_chosen.mat');
    cmap=B.rgb_matrix;
    for i=1:size(categories+1,2)
        if categories(i)+1<=size(cmap,1);
          colors(i,:)=cmap(categories(i)+1,:);
        end
    end
% %cmap = colorcube(64); % Fixed colorcube with 64 colors
% minVal = colorScale(1);
% maxVal = colorScale(2);
% scaledCategories = (categories) / (max(colorScale) - min(colorScale));
% colors = cmap(round(scaledCategories * (size(cmap, 1) - 1)) + 1, :);
end
