clear all
close all
AppHandle = MainWindow2; 
Fig=findall(0,'Type', 'figure');
load_variables_from_mat_file(Fig);
%Add_louvain_area_as_pseudogenes(AppHandle);
stimDD = AppHandle.CampariChoice;
stimDD.Items={'X: All Cells', '0:control','1: Peri-anal brush','2: Tail brush','3: Tail pinch','4: Colo-rectum stroke','5: Hair pull','6: Ano-rectum distension', ...
'7: Colo-rectum distension','8: Bladder distension','9: AAV Tracing colon','10: AAV Tracing skin'}; 
figure;
H=axes;
axis off;
F=H.Parent;
T1=scatter(H,Fig.UserData.umap(:,1),Fig.UserData.umap(:,2),'filled');
hold(H,'on');
T2=scatter(H,Fig.UserData.umap(:,1),Fig.UserData.umap(:,2),'filled');
T2.CData=[0.9 0.9 0.9];
HM=axes;
HM.Position=[H.Position(1) H.Position(2)-H.Position(4)*0.1-0.01 0.5*H.Position(3) H.Position(4)*0.05];
H.XTickLabels=[];
H.YTickLabels=[];
HM.YTickLabels=[];
HM.XTickLabels=[];
HMLLim = annotation("textbox");
HMLLim.Position=[HM.Position(1)-0.16*H.Position(3) HM.Position(2) 0.1*H.Position(3) H.Position(4)*0.05];
HMRLim = annotation("textbox");
HMRLim.Position=[HM.Position(1)+HM.Position(3)+0.01 HM.Position(2) 0.1*H.Position(3) H.Position(4)*0.05];
HMLLim.LineStyle='none';
HMRLim.LineStyle='none';
HMinfo = annotation("textbox");
HMinfo.Position=[0 0.7 0.2 0.3];
HMinfo.LineStyle='none';
Fig.UserData.Handles=[F H T1 T2 HM HMLLim HMRLim HMinfo];
AppHandle.triggerGeneEditFieldValueChanged();
figure(Fig)
drawnow;
