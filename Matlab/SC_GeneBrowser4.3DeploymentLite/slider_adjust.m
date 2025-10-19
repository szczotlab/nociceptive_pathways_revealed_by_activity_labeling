function [] = slider_adjust(app,maximum)
bottom_limit=0;
if app.BottomGEEditField.Value<0
    bottom_limit=app.BottomGEEditField.Value;
end
 %   if app.ScaleType.Value=='Lin';
        if app.TopGEEditField.Value<maximum;
        app.Slider.Limits=double([bottom_limit ceil(maximum)]);
        app.Slider_2.Limits=double([bottom_limit ceil(maximum)]);
        app.Slider.MajorTicks=(round(maximum,3,'significant'))*[0 0.3 0.6 1];
        app.Slider.MajorTickLabels=...
        {num2str((round(maximum,3,'significant'))*0) num2str((round(maximum,3,'significant'))*0.3) ...
        num2str((round(maximum,3,'significant'))*0.6) num2str((round(maximum,3,'significant'))*1)};

        else
        app.Slider.Limits=double([bottom_limit app.TopGEEditField.Value]);
        app.Slider_2.Limits=double([bottom_limit app.TopGEEditField.Value]);
        app.Slider.MajorTicks=(round(app.TopGEEditField.Value,3,'significant'))*[0 0.3 0.6 1];
        app.Slider.MajorTickLabels=...
        {num2str((round(app.TopGEEditField.Value,3,'significant'))*0) num2str((round(app.TopGEEditField.Value,3,'significant'))*0.3) ...
        num2str((round(app.TopGEEditField.Value,3,'significant'))*0.6) num2str((round(app.TopGEEditField.Value,3,'significant'))*1)};
        end  
        app.Slider_2.MajorTicks=app.Slider.MajorTicks;
        app.Slider_2.MajorTickLabels=app.Slider.MajorTickLabels;
        app.Slider.Value=app.BottomGEEditField.Value;
        app.Slider_2.Value=app.TopGEEditField.Value;
        
 %   elseif app.ScaleType=='Log';
        
 %   end
end

