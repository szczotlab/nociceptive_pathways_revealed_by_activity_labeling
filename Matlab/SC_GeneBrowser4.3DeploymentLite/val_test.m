function [err] = val_test(app)
err=0;
if or(app.TopGEEditField.Value-app.BottomGEEditField.Value<0,app.Slider_2.Value-app.Slider.Value<0);
    f = errordlg( 'bottom can''t be above top graph not updated' );
    err=1;
end
end

