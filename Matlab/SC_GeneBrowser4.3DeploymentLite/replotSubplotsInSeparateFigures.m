function newFig=replotSubplotsInSeparateFigures(figHandle)
% replotSubplotsInSeparateFigures extracts all subplots from a MATLAB figure
% and replots each subplot in a separate new figure.
%
% Input:
% - figHandle: Handle to the MATLAB figure containing the subplots.

    % Check if the input is a valid figure handle
    if ~isgraphics(figHandle, 'figure')
        error('Input must be a valid figure handle.');
    end

    % Find all axes objects (subplots) in the figure
    axesHandles = findall(figHandle, 'Type', 'axes');

    % Loop through each axes handle
   % for i = 1:numel(axesHandles)
   for i =2
        % Create a new figure
        newFig = figure;

        % Copy the axes (subplot) to the new figure
        newAxes = copyobj(axesHandles(i), newFig);

        % Adjust position to fill the new figure
        set(newAxes, 'Position', get(0, 'DefaultAxesPosition'));

        % Preserve the title, labels, and legend
        title(newAxes, get(get(axesHandles(i), 'Title'), 'String'));
        xlabel(newAxes, get(get(axesHandles(i), 'XLabel'), 'String'));
        ylabel(newAxes, get(get(axesHandles(i), 'YLabel'), 'String'));
        %legend(newAxes, findobj(axesHandles(i), 'Type', 'legend'));
    end
end