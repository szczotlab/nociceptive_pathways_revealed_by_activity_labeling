function [UMapExp,UMapCtr,top,bottom,ind] = map_stim(app)
ind=[];
UMapH2=[];
chosenStim=app.CampariChoice.ValueIndex-2;
H=app.GeneEditField.Parent;
Data=H.UserData;
top=app.TopGEEditField.Value;
bottom=app.BottomGEEditField.Value;
if top==bottom
    top=bottom+0.01*abs(bottom);
end
if app.Raw_counts.Value
   Data.gene_name=Data.gene_name;
   Data.sparse_matrix=Data.sparse_matrix;
elseif app.SingleNormalization.Value
   Data.gene_name=Data.gene_name;
   Data.sparse_matrix=Data.normed_matrix;
end

for i=1:size(Data.gene_name,1)
    Gene_string(i)=convertCharsToStrings(Data.gene_name(i,1:size(Data.gene_name,2)));
end
if app.Raw_counts.Value | app.SingleNormalization.Value
    t1 = strfind(Gene_string,app.GeneEditField.Value);
    index=find(~cellfun(@isempty,t1));
    if isempty(index)
        errordlg('Wrong gene name, graph not updated')
        UMapExp=[NaN];
        UMapCtr=[Data.umap zeros(size(Data.umap,1),1)];
        return
    end
    if size(index,2)>1
        for i=1:size(index,2)
            Tmp=Gene_string{index(i)}(1:size(app.GeneEditField.Value,2)+1);
            Tmp2=strcat(app.GeneEditField.Value,' d');
            if strcmp(Tmp,Tmp2(1:end-1));
                indx=index(i);
            end
            i;
        end
        index=indx;
    end
    UMapExp=[Data.umap full(Data.sparse_matrix(:,index))];
    if app.CampariChoice.ValueIndex==1
        ind=[1:max(size(Data.stimuli))];
    else
        [~,ind]=find(Data.stimuli==(chosenStim));
    end
    UMapExp=[UMapExp(ind,:)];
      
elseif app.CampariExpressionButton.Value
   if strcmp(app.CampariColor.Value,'Red')
       choice=Data.red_intesity;
   elseif strcmp(app.CampariColor.Value,'Green')
       choice=Data.green_intensity;
   elseif strcmp(app.CampariColor.Value,'Ratio')  
       choice=Data.red_intesity./Data.green_intensity;
   end
   
if app.CampariChoice.ValueIndex==1
        ind=[1:size(Data.stimuli,2)];
   else
        [~,ind]=find(Data.stimuli==(chosenStim));
   end
   UMapExp=[Data.umap(ind,:) choice(ind)'];

elseif app.AreaButton.Value
    if app.CampariChoice.ValueIndex==1
        ind=[1:max(size(Data.stimuli))];
    else
        [~,ind]=find(Data.stimuli==(chosenStim));
    end
    UMapExp=[Data.umap(ind,:) Data.area(ind)'];

elseif app.LouvainButton.Value
    if app.CampariChoice.ValueIndex==1
        ind=[1:max(size(Data.stimuli))];
    else
        [~,ind]=find(Data.stimuli==(chosenStim));
    end
 
    UMapExp=[Data.umap(ind,:) Data.louvain(ind,1)];
    if  ~app.Heatmap.ValueIndex==9
        app.Heatmap.ValueIndex=7;
        app.ManualCheckBox.Value=1;
        app.AutoscaleCheckBox.Value=0;
    end
    %app.BottomGEEditField.Value=0;
end

if app.AutoscaleCheckBox.Value==1
    perc=str2num(app.Transparency_2.Value);
    range=max(UMapExp(:,3))-min(UMapExp(:,3));
    top=max(UMapExp(:,3))-perc/100*range;
    bottom=min(UMapExp(:,3))+perc/100*range;
    app.TopGEEditField.Value=double(top);
    app.BottomGEEditField.Value=double(bottom);
end
UMapH1=UMapExp(find(UMapExp(:,3)<bottom),:);
UMapExp=UMapExp(find(UMapExp(:,3)>=bottom),:);
if ~isempty(ind)
    if app.CampariExpressionButton.Value
    UMapH2=[Data.umap(setdiff(1:end,ind),:) choice(setdiff(1:end,ind))'];
    else 
    UMapH2=[Data.umap(setdiff(1:end,ind),:), zeros(1,size(Data.umap(setdiff(1:end,ind),:),1))'];
    end
end
UMapCtr=[UMapH1; UMapH2];
size(UMapH1);
size(UMapH2);
size(UMapExp);
size([UMapExp; UMapH1; UMapH2]);
end


