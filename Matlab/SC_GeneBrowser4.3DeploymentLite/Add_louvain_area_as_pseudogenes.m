function Add_louvain_area_as_pseudogenes(AppHandle)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if isfield(AppHandle.UserData,'sparse_matrix')
    AppHandle.UserData.sparse_matrix=[AppHandle.UserData.sparse_matrix AppHandle.UserData.louvain];
    else
    AppHandle.UserData.sparse_matrix=[AppHandle.UserData.louvain];
    end
for i=1:size(AppHandle.UserData.louvain_name,1)
%a=[AppHandle.UserData.louvain_name(i,:), '        '] %change from 12 to 20 to kalisto new data (6 blank spaces for kalisto data)
a=[AppHandle.UserData.louvain_name(i,:), '   '] %change from 12 to 15 to start aligned new data (3 blank spaces for kalisto data)
%AppHandle.UserData.louvain_name(i,:)=[];
%AppHandle.UserData.louvain_name(i,:)=a;

if isfield(AppHandle.UserData,'gene_name')
    AppHandle.UserData.gene_name=[AppHandle.UserData.gene_name; a];
else
    AppHandle.UserData.gene_name=[a];
end

if ~isfield(AppHandle.UserData,'stimuli')
    AppHandle.UserData.stimuli=zeros(size(AppHandle.UserData.umap,1),1);
end

if ~isfield(AppHandle.UserData,'red_intesity')
    AppHandle.UserData.red_intesity=ones(size(AppHandle.UserData.umap,1),1);
    AppHandle.UserData.green_intesity=ones(size(AppHandle.UserData.umap,1),1);
end
end

