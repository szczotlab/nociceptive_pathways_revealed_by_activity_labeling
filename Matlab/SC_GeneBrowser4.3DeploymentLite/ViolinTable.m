function ViolinTable(app)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Gene_string=strings;
[UMapExp,UMapCtr,top,bottom,ind] = map_stim(app);
H=app.GeneEditField.Parent;
Data=H.UserData;
Louv_number=app.LouvainChoice.ValueIndex;
louv_vector=Data.louvain(ind,Louv_number)';

if app.Raw_counts.Value
   Data.gene_name=Data.gene_name;
   WorkingMatrix=Data.sparse_matrix(ind,:);
elseif app.GeneExpressionButton.Value
   Data.gene_name=Data.gene_name_matrix;
   WorkingMatrix=Data.matrix(ind,:);
elseif app.SingleNormalization.Value
   Data.gene_name=Data.gene_name;
   WorkingMatrix=Data.normed_matrix(ind,:);
end

if app.GeneExpressionButton.Value | app.Raw_counts.Value | app.SingleNormalization.Value
    for i=1:size(Data.gene_name,1)
        Gene_string(i)=convertCharsToStrings(Data.gene_name(i,1:size(Data.gene_name,2)));
    end
    t1 = strfind(Gene_string, app.GeneEditField.Value);
    index = find(~cellfun(@isempty, t1)); % Find indices of non-empty matches

    if isempty(index)
        error('The gene entered is either incorrect or not present in the list. Please try again.'); 
    end

    if numel(index) > 1 % Handle multiple matches
        for i = 1:numel(index)
            Tmp = Gene_string{index(i)}(1:length(app.GeneEditField.Value) + 1);
            Tmp2 = strcat(app.GeneEditField.Value, ' d');
            if strcmp(Tmp, Tmp2(1:end-1))
                index = index(i); % Update index to the disambiguated value
                break;
            end
        end
        % If no disambiguation is found, retain all matching indices
    end
    MatchVector=WorkingMatrix(:,index);
elseif app.CampariExpressionButton.Value
   if strcmp(app.CampariColor.Value,'Red')
       MatchVector=Data.red_intesity;
   elseif strcmp(app.CampariColor.Value,'Green')
       MatchVector=Data.green_intensity;
   elseif strcmp(app.CampariColor.Value,'Ratio')  
       MatchVector=Data.red_intesity./Data.green_intensity;
   end
elseif app.AreaButton.Value
    MatchVector=Data.area;
elseif app.LouvainButton.Value
    MatchVector=ones(size(Data.area));
end
% Determine unique Louv_number values
unique_louv = unique(louv_vector);

% Preallocate a matrix with NaNs (optional: adjust size based on data)
max_count = max(histcounts(louv_vector));
sorted_matrix = NaN(max_count, length(unique_louv));

% Loop through unique Louv_number values and sort UMapExp
for i = 1:length(unique_louv)
    % Get indices of current Louv_number
    current_indices = louv_vector == unique_louv(i);
    
    % Extract corresponding UMapExp values
    current_values = MatchVector(current_indices);
    
    % Place the values into the matrix column
    sorted_matrix(1:length(current_values), i) = current_values;
end
a=1;

% Get the number of rows and columns
[rows, cols] = size(sorted_matrix);

% Create figure
if ishandle(app.GeneratetableandviolinButton.UserData)
    Test=isvalid(app.GeneratetableandviolinButton.UserData);
end
if  isempty (app.GeneratetableandviolinButton.UserData)|~Test
    figure;
    app.GeneratetableandviolinButton.UserData=gcf;
else
    figure(app.GeneratetableandviolinButton.UserData)
    H=gcf;
    delete(findobj(H, 'type', 'Scatter'));
    %H.Children.Visible='on';
end
% Loop through each column to plot the data points
hold on; % Keep adding to the same figure
for col = 1:cols
    % Extract data for the current column
    data = sorted_matrix(:, col);
    
    % Add jitter to x-coordinates for better visualization
    jitter = (rand(size(data)) - 0.5) * 0.3;

    % Scatter plot for the column
    cmap = (colorcube(64));
    this_color_num=col*floor(size(cmap,1)/(app.UpEditField.Value-app.DownEditField.Value))-1;
    scatter(col + jitter, data, 50, cmap(this_color_num,:),'filled'); % Customize marker size and color
end

% Customize the plot
set(gca, 'XTick', 1:cols, 'XTickLabel', {'Column 1', 'Column 2', 'Column 3'}); % Replace with dynamic labels if needed
xlabel('Columns');
ylabel('Values');
title(strcat(app.GeneEditField.Value,'---',app.CampariChoice.Value));
hold off; 
set(gca, 'YLim', [min(min(sorted_matrix))-0.1*max(max(sorted_matrix)) 1.1*max(max(sorted_matrix))]);
A=gca;
A.Visible='on';
end