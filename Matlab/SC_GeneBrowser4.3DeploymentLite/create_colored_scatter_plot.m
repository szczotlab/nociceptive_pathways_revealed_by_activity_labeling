function create_colored_scatter_plot(app)
F=app.UIFigure.UserData.Handles(1);
F.Color=[1 1 1];
H=app.UIFigure.UserData.Handles(2);
axis off
T1=app.UIFigure.UserData.Handles(3);
T2=app.UIFigure.UserData.Handles(4);
HM=app.UIFigure.UserData.Handles(5);
HMLLim=app.UIFigure.UserData.Handles(6);
HMRLim=app.UIFigure.UserData.Handles(7);
HMinfo=app.UIFigure.UserData.Handles(8);

[UMapExp,UMapCtr,top,Bott]=map_stim(app);
if isnan(UMapExp);
    return
end
if isempty(UMapExp)
    %errordlg('No cells in this category');
    if app.CampariExpressionButton.Value;
        HMinfo.String=sprintf(strcat(app.CampariExpressionButton.Text,'\n',app.CampariColor.Value,'\n',app.CampariChoice.Value)); 
    elseif app.SingleNormalization.Value | app.Raw_counts.Value 
        HMinfo.String=sprintf(strcat(app.SingleNormalization.Text,'\n',app.GeneEditField.Value,'\n',app.CampariChoice.Value,...
        '\nscale\n ',app.ScaleType.Value)); 
    elseif app.LouvainButton.Value
        HMinfo.String=sprintf(strcat('Louvain')); 
    elseif app.AreaButton.Value
        HMinfo.String=sprintf(strcat('Cell area pixels \n','\nscale\n ','app.ScaleType.Value')); 
    end
    HMinfo.String='No cells in this category CHANGE PARAMETERS';
    %return
end
hold(H,'on');
if (strcmp(app.Heatmap.Value,'RGB'))
   % TopRgb=hsv2rgb(app.HueEditField.Value,app.SatEditField.Value,app.ValEditField.Value)
   % BottRgb=hsv2rgb(app.HueEditField_2.Value,app.SatEditField_2.Value,app.ValEditField_2.Value)
    TopRgb=[app.HueEditField.Value,app.SatEditField.Value,app.ValEditField.Value];
   BottRgb=[app.HueEditField_2.Value,app.SatEditField_2.Value,app.ValEditField_2.Value];
   % cmap=[flip(linspace(BottRgb(1),TopRgb(1),64)); flip(linspace(BottRgb(2),TopRgb(2),64)); flip(linspace(BottRgb(3),TopRgb(3),64))]';
    cmap=[flip(linspace(BottRgb(1),TopRgb(1),64)); flip(linspace(BottRgb(2),TopRgb(2),64)); flip(linspace(BottRgb(3),TopRgb(3),64))]';
    cmap=(cmap);
elseif strcmp(app.Heatmap.Value,'Parula');
    cmap = (parula(64));
elseif strcmp(app.Heatmap.Value,'Jet');
    cmap = (jet(64));
elseif strcmp(app.Heatmap.Value,'Hsv');
    cmap = (hsv(64));
elseif strcmp(app.Heatmap.Value,'Hot');
    cmap = (hot(64));
elseif strcmp(app.Heatmap.Value,'Lines');
    cmap = (lines(64));
elseif strcmp(app.Heatmap.Value,'Colorcube');
    cmap = (colorcube(64));

elseif strcmp(app.Heatmap.Value,'Prism');
    cmap = (prism(64));
elseif strcmp(app.Heatmap.Value,'Louvain_vis');
    % A=fullfile(fileparts(mfilename('fullpath')),'colormap_chosen.mat');
    % A=fullfile(fileparts(mfilename('fullpath')),'colormap_chosen.mat');
    % B = load(A);
    % cmap=flipud(B.colormap_rgb([2:17 18:52 53:60],:));
    % cmap=B.cmap;
    thisDir   = fileparts(mfilename('fullpath'));
    matFile   = fullfile(thisDir, 'colormap_chosen.mat'); 
    B = load(matFile);   
    cmap=B.rgb_matrix;
end

saturation = 0.5;
if ~isempty(UMapExp)
[RGB,RGB_log,map]=assign_colors(UMapExp(:,3),cmap,top,Bott,0);
     
 if strcmp(app.Heatmap.Value,'Louvain_vis');  
        for i=1:size(UMapExp(:,3),1)
            RGB(i,:)=cmap(UMapExp(i,3)+1,:);
        end
 end

axes(HM);
hold on;
%figure
%imagesc(linspace(Bott,top,200),[Bott top]);
colormap(map);
%imagesc(linspace(Bott,top,200),[min(UMapExp(:,3)) max(UMapExp(:,3))]);
space=linspace(min(UMapExp(:,3)),max(UMapExp(:,3)),200);
if Bott == 0 && top == 0
    errordlg('For this set of parameters, the requested graphics do not contain any cells. Graph was not updated.', ...
              'No Cells Found');
    return; % Exit the current function
else
    imagesc(space,[Bott top]);
end

HM.XLim=[0 size(space,2)];
end
axes(H);
if app.ShownegativesCheckBox.Value==0;
    hold(H,'on');
    H.XLimMode='manual';
    H.YLimMode='manual';
    T2.Visible='off';
    hold(H,'on');
else
    hold(H,'on');
    H.XLimMode='manual';
    H.YLimMode='manual';
    T2.Visible='on';
    hold(H,'on');
end
T2.XData=UMapCtr(:,1);
T2.YData=UMapCtr(:,2);
T2.CData=[0.9 0.9 0.9];
T2.SizeData=app.MarkerSize.Value;
if ~isempty(UMapExp)
    T1.XData=UMapExp(:,1);
    T1.YData=UMapExp(:,2);
    T1.CData=RGB;
    T1.SizeData=app.MarkerSize.Value;
else
    T1.CData=[0.9 0.9 0.9];
end
set(gca,'Children',[T1 T2]);
hold(H,'on');
if ~isempty(UMapExp)
    HMLLim.String=num2str(round(Bott,5,'significant'));
    %HMRLim.String=num2str(round(top,5,'significant'));
    % HMLLim.String=num2str(round(min(UMapExp(:,3)),5,'significant'));
    HMRLim.String=num2str(round(max(UMapExp(:,3)),5,'significant'));
    if app.CampariExpressionButton.Value;
        HMinfo.String=sprintf(strcat(app.CampariExpressionButton.Text,'\n',app.CampariColor.Value,'\n',app.CampariChoice.Value,...
        '\n','max min \n', num2str(max(UMapExp(:,3))),'\n', num2str(min(UMapExp(:,3))))); 
    elseif app.Raw_counts.Value | app.SingleNormalization.Value
        HMinfo.String=sprintf(strcat(app.GeneEditField.Value,'\n',app.CampariChoice.Value,...
        '\n','max min \n', num2str(max(UMapExp(:,3))),'\n', num2str(min(UMapExp(:,3))))); 
    elseif app.LouvainButton.Value
        HMinfo.String=sprintf(strcat('Louvain\n',app.CampariChoice.Value)); 
    elseif app.AreaButton.Value
        HMinfo.String=sprintf(strcat('Cell area pixels \n','\nscale\n ',...
            'max min \n', num2str(max(UMapExp(:,3))),'\n', num2str(min(UMapExp(:,3))))); 
    end
slider_adjust(app,(round(max(UMapExp(:,3)),5,'significant')));
% if  ~isempty (app.GeneratetableandviolinButton.UserData) & isvalid(app.GeneratetableandviolinButton.UserData) 
%    ViolinTable(app);
% else
%     app.GeneratetableandviolinButton.UserData=[];
% end
end
axesObjs = findall(F, 'type', 'axes');    % find all axes in figure F
set(axesObjs, 'Visible', 'off');          % hide axes, ticks, labels, etc.
end

