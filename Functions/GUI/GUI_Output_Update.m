function GUI_Output_Update(app,input)
% input : 1 se stock1, 2 se mod1, 3 se stock2, 4 se mod2

switch input
    case 1
        %stock1
        app.WheelBase_stock_1.Text = num2str(app.Output1.Wheelbase);
        app.RakeAngle_stock_1.Text = num2str(app.Output1.caster_angle);
        app.Trail_stock_1.Text = num2str(app.Output1.Trail);
        app.NormTrail_stock_1.Text = num2str(app.Output1.NormalTrail);

        app.TransfAngle_stock_1.Text = num2str(app.Output1.TransferAngle);
        app.SquatAngle_stock_1.Text = num2str(app.Output1.SquatAngle);
        app.SquatRatio_stock_1.Text = num2str(app.Output1.SquatRatio);

        app.EffSteerAngle_stock_1.Text = num2str(app.Output1.EffectiveSteeringAngle);
        app.ChainElong_stock_1.Text = num2str(app.Output1.ChainElong);
        app.SwingarmAngle_stock_1.Text = num2str(app.Output1.SwingarmAngle);
        app.COG_stock_1.Text = num2str(app.Output1.COG');
        app.WDistr_stock_1.Text = num2str(app.Output1.distr);
        app.Eff_Rear_stock_1.Text = num2str(app.Output1.RearEffectiveRadius);
        app.Eff_Front_stock_1.Text = num2str(app.Output1.FrontEffectiveRadius);
        %riempire i mancanti inserendo funzioni di calcolo in output
        %multibody

        if str2num(app.SquatRatio_stock_1.Text) >= 1
            app.SquatRatio_stock_1.FontColor = 'r';
        else
            app.SquatRatio_stock_1.FontColor = 'g';
        end

    case 2
        %mod1
        app.WheelBase_mod_1.Text = num2str(app.Output1mod.Wheelbase);
        app.RakeAngle_mod_1.Text = num2str(app.Output1mod.caster_angle);
        app.Trail_mod_1.Text = num2str(app.Output1mod.Trail);
        app.NormTrail_mod_1.Text = num2str(app.Output1mod.NormalTrail);

        app.TransfAngle_mod_1.Text = num2str(app.Output1mod.TransferAngle);
        app.SquatAngle_mod_1.Text = num2str(app.Output1mod.SquatAngle);
        app.SquatRatio_mod_1.Text = num2str(app.Output1mod.SquatRatio);

        app.EffSteerAngle_mod_1.Text = num2str(app.Output1mod.EffectiveSteeringAngle);
        app.ChainElong_mod_1.Text = num2str(app.Output1mod.ChainElong);
        app.SwingarmAngle_mod_1.Text = num2str(app.Output1mod.SwingarmAngle);
        app.COG_mod_1.Text = num2str(app.Output1mod.COG');
        app.WDistr_mod_1.Text = num2str(app.Output1mod.distr);
        app.Eff_Rear_mod_1.Text = num2str(app.Output1mod.RearEffectiveRadius);
        app.Eff_Front_mod_1.Text = num2str(app.Output1mod.FrontEffectiveRadius);
        %riempire i mancanti inserendo funzioni di calcolo in output
        %multibody

        if str2num(app.SquatRatio_mod_1.Text) >= 1
            app.SquatRatio_mod_1.FontColor = 'r';
        else
            app.SquatRatio_mod_1.FontColor = 'g';
        end

    case 3
        %stock2
        app.WheelBase_stock_2.Text = num2str(app.Output2.Wheelbase);
        app.RakeAngle_stock_2.Text = num2str(app.Output2.caster_angle);
        app.Trail_stock_2.Text = num2str(app.Output2.Trail);
        app.NormTrail_stock_2.Text = num2str(app.Output2.NormalTrail);

        app.TransfAngle_stock_2.Text = num2str(app.Output2.TransferAngle);
        app.SquatAngle_stock_2.Text = num2str(app.Output2.SquatAngle);
        app.SquatRatio_stock_2.Text = num2str(app.Output2.SquatRatio);

        app.EffSteerAngle_stock_2.Text = num2str(app.Output2.EffectiveSteeringAngle);
        app.ChainElong_stock_2.Text = num2str(app.Output2.ChainElong);
        app.SwingarmAngle_stock_2.Text = num2str(app.Output2.SwingarmAngle);
        app.COG_stock_2.Text = num2str(app.Output2.COG');
        app.WDistr_stock_2.Text = num2str(app.Output2.distr);
        app.Eff_Rear_stock_2.Text = num2str(app.Output2.RearEffectiveRadius);
        app.Eff_Front_stock_2.Text = num2str(app.Output2.FrontEffectiveRadius);
        %riempire i mancanti inserendo funzioni di calcolo in output
        %multibody

        if str2num(app.SquatRatio_stock_2.Text) >= 1
            app.SquatRatio_stock_2.FontColor = 'r';
        else
            app.SquatRatio_stock_2.FontColor = 'g';
        end

    case 4
        %mod2
        app.WheelBase_mod_2.Text = num2str(app.Output2mod.Wheelbase);
        app.RakeAngle_mod_2.Text = num2str(app.Output2mod.caster_angle);
        app.Trail_mod_2.Text = num2str(app.Output2mod.Trail);
        app.NormTrail_mod_2.Text = num2str(app.Output2mod.NormalTrail);

        app.TransfAngle_mod_2.Text = num2str(app.Output2mod.TransferAngle);
        app.SquatAngle_mod_2.Text = num2str(app.Output2mod.SquatAngle);
        app.SquatRatio_mod_2.Text = num2str(app.Output2mod.SquatRatio);

        app.EffSteerAngle_mod_2.Text = num2str(app.Output2mod.EffectiveSteeringAngle);
        app.ChainElong_mod_2.Text = num2str(app.Output2mod.ChainElong);
        app.SwingarmAngle_mod_2.Text = num2str(app.Output2mod.SwingarmAngle);
        app.COG_mod_2.Text = num2str(app.Output2mod.COG');
        app.WDistr_mod_2.Text = num2str(app.Output2mod.distr);
        app.Eff_Rear_mod_2.Text = num2str(app.Output2mod.RearEffectiveRadius);
        app.Eff_Front_mod_2.Text = num2str(app.Output2mod.FrontEffectiveRadius);

        if str2num(app.SquatRatio_mod_2.Text) >= 1
            app.SquatRatio_mod_2.FontColor = 'r';
        else
            app.SquatRatio_mod_2.FontColor = 'g';
        end
end







end

