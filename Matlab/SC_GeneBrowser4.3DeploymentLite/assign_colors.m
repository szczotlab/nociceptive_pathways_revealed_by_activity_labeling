function [rgb_values,rgb_values_log, cmap] = assign_colors(values, cmap, top,bottom,LogFlag)
% ASSIGN_COLORS assigns a color value to each point in a vector based on its value within a specified range
% INPUTS:
%   values: a vector of values to assign colors to
%   cmap: a colormap (or heatmap) to use for assigning colors
%   saturation: a value between 0 and 1 that determines how saturated the colors should be outside of the specified range
% OUTPUTS:
%   rgb_values: a 3-column matrix with RGB color values for each point
%   A scatter plot of the normalized values with color corresponding to value

% Define range of values
min_value = bottom;
max_value = top;
if strcmp(LogFlag,'Log');
    values=values/min(values);
    min_value=bottom/min(values);
    max_value=top/min(values);
    values=log2(values);
    min_value=log2(min_value);
    max_value=log2(max_value);
end
% Normalize values to be between 0 and 1
normalized_values = (values - min_value) / (max_value - min_value);

% Set color values outside of range based on saturation value

    % If saturation is 0, set color to black for values outside of range
normalized_values(normalized_values < 0) = 0;
normalized_values(normalized_values > 1) = 1;


% Convert normalized values to RGB color values using the specified colormap
rgb_values = interp1(linspace(0, 1, size(cmap, 1)), cmap, normalized_values);
normalized_values(normalized_values == 0) = NaN;
rgb_values_log = interp1(linspace(0, 1, size(cmap, 1)), cmap, log2(normalized_values)/min(log2(normalized_values)));
% Create scatter plot of normalized values with color corresponding to value
% scatter(1:length(values), zeros(size(values)), 100, normalized_values, 'filled');
% colormap(cmap);
       

end
