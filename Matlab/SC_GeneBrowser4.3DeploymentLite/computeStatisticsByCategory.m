function stats = computeStatisticsByCategory(data1, data2, categories, data1Name, data2Name)
% computeStatisticsByCategory computes median, quartiles, and cell counts for each category.
%
% Inputs:
% - `data1`: First data input (e.g., number of genes)
% - `data2`: Second data input (e.g., total counts)
% - `categories`: Category labels for the samples
% - `data1Name`: Name for the first data input (string)
% - `data2Name`: Name for the second data input (string)
%
% Output:
% - `stats`: A structure containing median, quartiles, and cell counts for `data1` and `data2` by category,
%            as well as global statistics (pooled data), and a tabular representation of the results.

    % Define the full range of categories starting from 0 to the max category
    minCategory = 0;
    maxCategory = max(categories);
    allCategories = minCategory:maxCategory; % Ensure all categories exist in the range

    categoryStats = struct();
    tableData = [];

    for i = 1:numel(allCategories)
        cat = allCategories(i);

        % Data for the current category
        data1Cat = data1(categories == cat);
        data2Cat = data2(categories == cat);
        cellCount = numel(data1Cat);

        % Store statistics for current category
        categoryStats(i).Category = cat;
        categoryStats(i).NumberOfCells = cellCount;
        
        % Compute statistics safely, handling empty categories
        if cellCount > 0
            categoryStats(i).(data1Name).Median = median(data1Cat);
            categoryStats(i).(data1Name).Q1 = prctile(data1Cat, 25);
            categoryStats(i).(data1Name).Q3 = prctile(data1Cat, 75);

            categoryStats(i).(data2Name).Median = median(data2Cat);
            categoryStats(i).(data2Name).Q1 = prctile(data2Cat, 25);
            categoryStats(i).(data2Name).Q3 = prctile(data2Cat, 75);
        else
            categoryStats(i).(data1Name).Median = NaN;
            categoryStats(i).(data1Name).Q1 = NaN;
            categoryStats(i).(data1Name).Q3 = NaN;

            categoryStats(i).(data2Name).Median = NaN;
            categoryStats(i).(data2Name).Q1 = NaN;
            categoryStats(i).(data2Name).Q3 = NaN;
        end

        % Add data to tableData for tabular output
        tableData = [tableData; ...
            cat, cellCount, ...
            categoryStats(i).(data1Name).Q1, categoryStats(i).(data1Name).Median, categoryStats(i).(data1Name).Q3, ...
            categoryStats(i).(data2Name).Q1, categoryStats(i).(data2Name).Median, categoryStats(i).(data2Name).Q3];
    end

    % Compute global statistics
    globalStats = struct();
    globalStats.NumberOfCells = numel(data1);
    globalStats.(data1Name).Median = median(data1);
    globalStats.(data1Name).Q1 = prctile(data1, 25);
    globalStats.(data1Name).Q3 = prctile(data1, 75);
    globalStats.(data2Name).Median = median(data2);
    globalStats.(data2Name).Q1 = prctile(data2, 25);
    globalStats.(data2Name).Q3 = prctile(data2, 75);

    % Convert the table data into a table format
    tableHeaders = {'Category', 'NumberOfCells', ...
                    [data1Name, '_Q1'], [data1Name, '_Median'], [data1Name, '_Q3'], ...
                    [data2Name, '_Q1'], [data2Name, '_Median'], [data2Name, '_Q3']};
    
    stats.Table = array2table(tableData, 'VariableNames', tableHeaders);

    % Display structure results
    % disp('Statistics as a structure:');
    % disp(stats);
    % 
    % % Display results as a table
    % fprintf('\nStatistics as a table:\n');
    % disp(stats.Table);

    % Display global statistics
    % fprintf('\nGlobal Statistics:\n');
    % fprintf('Total Cells: %d\n', globalStats.NumberOfCells);
    % fprintf('%s (Q1-Median-Q3): %.2f-%.2f-%.2f\n', data1Name, ...
    %         globalStats.(data1Name).Q1, globalStats.(data1Name).Median, globalStats.(data1Name).Q3);
    % fprintf('%s (Q1-Median-Q3): %.2f-%.2f-%.2f\n', data2Name, ...
    %         globalStats.(data2Name).Q1, globalStats.(data2Name).Median, globalStats.(data2Name).Q3);
end
