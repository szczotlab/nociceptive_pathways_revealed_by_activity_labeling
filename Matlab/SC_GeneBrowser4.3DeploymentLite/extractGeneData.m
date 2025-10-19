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
geneIndex=[];
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
