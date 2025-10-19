function plotGeneCategory(stimuli, stimuli_choice, n_genes, total_counts,categories, colorScale, dotSize, stim_name, plotOrder,app)
% plotGeneCategory(data, colorScale, dotSize, plotOrder)
% This function takes an input matrix `data` with the following structure:
% Column 1: Category number (integer)
% Column 2: Total number of genes (numeric)
% Column 3: Total number of reads (numeric)
% Additional inputs:
% - `colorScale`: a two-element vector [min, max] defining the range for color mapping.
% - `dotSize`: a scalar specifying the size of the dots in the plots.
% - `plotOrder`: a vector specifying the order of categories for plotting (optional).
%   If skipped, categories are plotted in ascending order.
% The function produces:
% 1. A dot plot of genes per category
% 2. A dot plot of reads per category
% 3. A violin plot of genes per category using a Gaussian kernel
% 4. A violin plot of reads per category using a Gaussian kernel

% Extract columns
if ~isempty(app.CellnumbersGCfilesEditField.Value)
    indices=parseStringToVector(app.CellnumbersGCfilesEditField.Value,app);
    n_genes=n_genes(:,indices);
    total_counts=total_counts(:,indices);
    categories=categories(indices);
elseif ~isempty(stimuli_choice)
    indices = find(ismember(stimuli, stimuli_choice));
    n_genes=n_genes(:,indices);
    total_counts=total_counts(:,indices);
    categories=categories(indices);
end



genes = n_genes;
reads = total_counts;

% Determine plotting order
if nargin < 8 || isempty(plotOrder)
    uniqueCategories = unique(categories,'stable');
else
    uniqueCategories = plotOrder;
end

% Map categories to colors using helper function
colors = mapColorsToCategories(uniqueCategories, colorScale);

%% Dot Plot: Genes per Category
figure;
groupedGenes = arrayfun(@(cat) genes(categories == cat), uniqueCategories, 'UniformOutput', false);
subplot(2, 2, 1);
hold on;
for i = 1:numel(uniqueCategories)
    if ~isempty(groupedGenes{i})
    jitter = calculateJitter(groupedGenes{i}, uniqueCategories(i)); 
    scatter(i + jitter, groupedGenes{i}, dotSize, colors(i, :), 'filled');
    end
end
hold off;
title('Dot Plot: Genes per Category');
xlabel('Category');
ylabel('Number of Genes');
grid on;

%% Dot Plot: Reads per Category
groupedReads = arrayfun(@(cat) reads(categories == cat), uniqueCategories, 'UniformOutput', false);
subplot(2, 2, 2);
hold on;
for i = 1:numel(uniqueCategories)
    if ~isempty(groupedReads{i})
    jitter = calculateJitter(groupedReads{i}, uniqueCategories(i)); 
    scatter(i + jitter, groupedReads{i}, dotSize, colors(i, :), 'filled');
    end
end
hold off;
title('Dot Plot: Reads per Category');
xlabel('Category');
ylabel('Number of Reads');
grid on;

%% Violin Plot Helper Function
function violinPlot(data, categories, plotTitle, yLabel, colors, dotSize,plotOrder)
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
        %jitter = (rand(size(catData)) - 0.5) * 0.4 + 0.2; % Shift points to the right
        jitter = calculateJitter_RightSided(catData, plotOrder(i));
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

%% Violin Plot: Genes per Category
subplot(2, 2, 3);
violinPlot(genes, categories, ['Violin Plot: Genes per Category', ' stimuli: ', stim_name], 'Number of Genes', colors, dotSize,plotOrder);

%% Violin Plot: Reads per Category
subplot(2, 2, 4);
violinPlot(reads, categories, ['Violin Plot: Reads per Category', ' stimuli: ', stim_name], 'Number of Reads', colors, dotSize,plotOrder);
H=gcf;
doubleFigureSize(H, 1.6)
stats_counts_genes = computeStatisticsByCategory(n_genes, total_counts, categories,'genes','counts')
H.UserData=stats_counts_genes;
notePosition = [0.905, 0.575]; % [right, top] in normalized coordinates
noteContent = sprintf([' Colors preserved \n numbers \nare describing \nclasses in \nbottom graphs\nStandard notation\n' ...
                        '\n0. Adm\n1. Mrgprd\n2. Th\n3. (Mrgprd)\n4. Krt79\n5. Abeta \n6. Mrgpra3 Mrgprb4 \n7. (Mrgprd)\n8. Smr2\n9. Adra2a \n10. Sstr2 \n11. (Mrgprd)\n12. Sst\n13. Oprk1\n14 Ntrk2\n15. (Mrgprd)\n16.PValb\n17.Unassigned']); 

% Add the note as a textbox annotation
annotation('textbox', ...
    [notePosition(1), notePosition(2), 0.1, 0.1], ... % [x, y, width, height] normalized
    'String', noteContent, ...
    'EdgeColor', 'none', ... % No border
    'FontSize', 8, ...
    'HorizontalAlignment', 'left', ...
    'VerticalAlignment', 'top', ...
    'FitBoxToText', 'on');
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

function colors = mapColorsToCategories(categories, colorScale)
% mapColorsToCategories maps category numbers to colors from the colorcube colormap
% scaled between the provided colorScale [min, max].
    B=load('C:\Users\marsz29\Desktop\Sciencetech\GeneBrowser\SC_GeneBrowser4.1-2-25\colormap_chosen.mat');
    cmap=B.rgb_matrix;
    for i=1:size(categories+1,2)
          colors(i,:)=cmap(categories(i)+1,:);
    end
% %cmap = colorcube(64); % Fixed colorcube with 64 colors
% minVal = colorScale(1);
% maxVal = colorScale(2);
% scaledCategories = (categories) / (max(colorScale) - min(colorScale));
% colors = cmap(round(scaledCategories * (size(cmap, 1) - 1)) + 1, :);
end