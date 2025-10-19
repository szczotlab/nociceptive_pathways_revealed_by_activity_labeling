function spread
% SPREAD moves all figures in the foreground and tries to arrange them in a
% pleasant way.

figHandles = findall(0,'Type','figure'); % Get handle to all figures
n = length(figHandles);
if n==0
    return
end
figureIDs = sort([figHandles(:).Number]); % Sort figure IDs

% Screen resolution
screensize = get( groot, 'Screensize' );
taskbarSize = 75;
heightScreen =screensize(4)-taskbarSize; % Leave space at the border of the screen
widthScreen = screensize(3)-taskbarSize;

% Number of rows and cols. Think of this as in subplot.
nCols = ceil(sqrt(n)); % Try to use sqrt(n) rows and cols.
nRows = ceil(n/nCols);


percentageSize = 0.95; % Percentage of figure size w.r.t. the size of the corresponding space in the grid
heightFigure =  percentageSize*heightScreen/nRows; % The space used by the figure
widthFigure  =  percentageSize*widthScreen/nCols;

widthBuffer = (1-percentageSize)*widthScreen/nCols; % The remaining size
heightBuffer = (1-percentageSize)*heightScreen/nRows;


startWidth = widthBuffer/2+taskbarSize/2; % From where to start possitioning the figures
startHeight = heightScreen+taskbarSize/2+heightBuffer/2;

count = 0;
for i=1:nRows
    for j=1:nCols
        count = count+1;
        if (count<=n)
            figureID =  figureIDs(count);
            figure(figureID);
            set(gcf,'OuterPosition',[...
                startWidth+(j-1)*widthScreen/nCols,... % widht counts from left to right
                startHeight-i*heightScreen/nRows,... % height counts from top to bottom
                widthFigure...
                heightFigure]) ;

        end
    end
end

