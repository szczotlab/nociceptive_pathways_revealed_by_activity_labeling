
function cmap = desaturate_colormap(cmap, saturation)
% DESATURATE_COLORMAP desaturates a colormap by a specified amount
% INPUTS:
%   cmap: the colormap to desaturate
%   saturation: a value between 0 and 1 that determines how much to desaturate the colormap
% OUTPUTS:
%   cmap: the desaturated colormap

% Convert colormap to HSV color space
cmap = rgb2hsv(cmap);

% Set saturation to specified value
cmap(:, 2) = cmap(:, 2) * (1 - saturation);

% Convert back to RGB color space
cmap = hsv2rgb(cmap);
end