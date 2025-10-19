function doubleFigureSize(figHandle, scale)
    % Ensure the input is a valid figure handle
    if ~ishandle(figHandle) || ~strcmp(get(figHandle, 'Type'), 'figure')
        error('Input must be a valid figure handle.');
    end

    % Get the current position of the figure [left, bottom, width, height]
    currentPosition = figHandle.Position;

    % Calculate the center of the figure
    centerX = currentPosition(1) + currentPosition(3) / 2;
    centerY = currentPosition(2) + currentPosition(4) / 2;

    % Scale the figure dimensions by the scale factor
    newWidth = currentPosition(3) * scale;
    newHeight = currentPosition(4) * scale;

    % Update figure position for scaling
    newLeft = centerX - newWidth / 2;
    newBottom = centerY - newHeight / 2;
    figHandle.Position = [newLeft, newBottom, newWidth, newHeight];

    % Store the original axes sizes and positions
    axesHandles = findall(figHandle, 'Type', 'axes');
    originalAxesPositions = arrayfun(@(ax) ax.Position, axesHandles, 'UniformOutput', false);

    % Add 10% to the figure width
    finalWidth = newWidth * 1.1;
    newLeft = centerX - finalWidth / 2; % Adjust to maintain center alignment
    figHandle.Position = [newLeft, newBottom, finalWidth, newHeight];

    % Restore the original axes sizes and positions
    for i = 1:numel(axesHandles)
        axesHandles(i).Position = originalAxesPositions{i};
    end
end