function GUI_delta_Update(app)


    if isequal(app.DropDown_Delta.Value, 'Delta Stock & Mod')

        %devono essere caricate 2 moto per questo
        if ~isempty(app.data1) && ~isempty(app.data2)

            %settings delta
            %magari mettere abs
            app.Roll_stock_delta.Text = num2str(str2num(app.Roll_stock_1.Text)-str2num(app.Roll_stock_2.Text));
            app.SteerAngle_stock_delta.Text = num2str(str2num(app.SteerAngle_stock_1.Text)-str2num(app.SteerAngle_stock_2.Text));
            app.FrontSuspCompr_stock_delta.Text = num2str(str2num(app.FrontSuspCompr_stock_1.Text)-str2num(app.FrontSuspCompr_stock_2.Text));
            app.RearSuspCompr_stock_delta.Text = num2str(str2num(app.RearSuspCompr_stock_1.Text)-str2num(app.RearSuspCompr_stock_2.Text));
            app.ForkVertOff_stock_delta.Text = num2str(str2num(app.ForkVertOff_stock_1.Text)-str2num(app.ForkVertOff_stock_2.Text));
            app.SwingOff_stock_delta.Text = num2str(str2num(app.SwingOff_stock_1.Text)-str2num(app.SwingOff_stock_2.Text));
            app.RodOff_stock_delta.Text = num2str(str2num(app.RodOff_stock_1.Text)-str2num(app.RodOff_stock_2.Text)); %sistemare se si vuole offset e non lunghezza
            app.PlatesOff_stock_delta.Text = num2str(str2num(app.PlatesOff_stock_1.Text)-str2num(app.PlatesOff_stock_2.Text));
            app.SteerTopOff_stock_delta.Text = num2str(str2num(app.SteerTopOff_stock_1.Text)-str2num(app.SteerTopOff_stock_2.Text));
            app.SteerBotOff_stock_delta.Text = num2str(str2num(app.SteerBotOff_stock_1.Text)-str2num(app.SteerBotOff_stock_2.Text))  ;
            app.PivOffX_stock_delta.Text = num2str(str2num(app.PivOffX_stock_1.Text)-str2num(app.PivOffX_stock_2.Text));
            app.PivOffZ_stock_delta.Text = num2str(str2num(app.PivOffZ_stock_1.Text)-str2num(app.PivOffZ_stock_2.Text));
            



            app.Roll_mod_delta.Text = num2str(app.Roll_mod_1.Value-app.Roll_mod_2.Value);
            app.SteerAngle_mod_delta.Text = num2str(app.SteerAngle_mod_1.Value-app.SteerAngle_mod_2.Value);
            app.FrontSuspCompr_mod_delta.Text = num2str(app.FrontSuspCompr_mod_1.Value-app.FrontSuspCompr_mod_2.Value);
            app.RearSuspCompr_mod_delta.Text = num2str(app.RearSuspCompr_mod_1.Value-app.RearSuspCompr_mod_2.Value);
            app.ForkVertOff_mod_delta.Text = num2str(app.ForkVertOff_mod_1.Value-app.ForkVertOff_mod_2.Value);
            app.SwingOff_mod_delta.Text = num2str(app.SwingOff_mod_1.Value-app.SwingOff_mod_2.Value);
            app.RodOff_mod_delta.Text = num2str(app.RodOff_mod_1.Value-app.RodOff_mod_2.Value); %sistemare se si vuole offset e non lunghezza
            app.PlatesOff_mod_delta.Text = num2str(app.PlatesOff_mod_1.Value-app.PlatesOff_mod_2.Value);
            app.SteerTopOff_mod_delta.Text = num2str(app.SteerTopOff_mod_1.Value-app.SteerTopOff_mod_2.Value);
            app.SteerBotOff_mod_delta.Text = num2str(app.SteerBotOff_mod_1.Value-app.SteerBotOff_mod_2.Value);
            app.PivOffX_mod_delta.Text = num2str(app.PivOffX_mod_1.Value-app.PivOffX_mod_2.Value);
            app.PivOffZ_mod_delta.Text = num2str(app.PivOffZ_mod_1.Value-app.PivOffZ_mod_2.Value);

        
        %output delta
            app.WheelBase_stock_delta.Text = num2str(str2num(app.WheelBase_stock_1.Text)-str2num(app.WheelBase_stock_2.Text));
            app.RakeAngle_stock_delta.Text = num2str(str2num(app.RakeAngle_stock_1.Text)-str2num(app.RakeAngle_stock_2.Text));
            app.Trail_stock_delta.Text = num2str(str2num(app.Trail_stock_1.Text)-str2num(app.Trail_stock_2.Text));
            app.NormTrail_stock_delta.Text = num2str(str2num(app.NormTrail_stock_1.Text)-str2num(app.NormTrail_stock_2.Text));

            app.TransfAngle_stock_delta.Text = num2str(str2num(app.TransfAngle_stock_1.Text)-str2num(app.TransfAngle_stock_2.Text));
            app.SquatAngle_stock_delta.Text = num2str(str2num(app.SquatAngle_stock_1.Text)-str2num(app.SquatAngle_stock_2.Text));
            app.SquatRatio_stock_delta.Text = num2str(str2num(app.SquatRatio_stock_1.Text)-str2num(app.SquatRatio_stock_2.Text));

            app.EffSteerAngle_stock_delta.Text = num2str(str2num(app.EffSteerAngle_stock_1.Text)-str2num(app.EffSteerAngle_stock_2.Text));
            app.ChainElong_stock_delta.Text = num2str(str2num(app.ChainElong_stock_1.Text)-str2num(app.ChainElong_stock_2.Text));
            app.SwingarmAngle_stock_delta.Text = num2str(str2num(app.SwingarmAngle_stock_1.Text)-str2num(app.SwingarmAngle_stock_2.Text));
            app.COG_stock_delta.Text = num2str(str2num(app.COG_stock_1.Text)-str2num(app.COG_stock_2.Text));
            app.WDistr_stock_delta.Text = num2str(str2num(app.WDistr_stock_1.Text)-str2num(app.WDistr_stock_2.Text));
            app.Eff_Rear_stock_delta.Text = num2str(str2num(app.Eff_Rear_stock_1.Text)-str2num(app.Eff_Rear_stock_2.Text));
            app.Eff_Front_stock_delta.Text = num2str(str2num(app.Eff_Front_stock_1.Text)-str2num(app.Eff_Front_stock_2.Text));
            %riempire i mancanti inserendo funzioni di calcolo in output
            %multibody
        
            app.WheelBase_mod_delta.Text = num2str(str2num(app.WheelBase_mod_1.Text)-str2num(app.WheelBase_mod_2.Text));
            app.RakeAngle_mod_delta.Text = num2str(str2num(app.RakeAngle_mod_1.Text)-str2num(app.RakeAngle_mod_2.Text));
            app.Trail_mod_delta.Text = num2str(str2num(app.Trail_mod_1.Text)-str2num(app.Trail_mod_2.Text));
            app.NormTrail_mod_delta.Text = num2str(str2num(app.NormTrail_mod_1.Text)-str2num(app.NormTrail_mod_2.Text));

            app.TransfAngle_mod_delta.Text = num2str(str2num(app.TransfAngle_mod_1.Text)-str2num(app.TransfAngle_mod_2.Text));
            app.SquatAngle_mod_delta.Text = num2str(str2num(app.SquatAngle_mod_1.Text)-str2num(app.SquatAngle_mod_2.Text));
            app.SquatRatio_mod_delta.Text = num2str(str2num(app.SquatRatio_mod_1.Text)-str2num(app.SquatRatio_mod_2.Text));

            app.EffSteerAngle_mod_delta.Text = num2str(str2num(app.EffSteerAngle_mod_1.Text)-str2num(app.EffSteerAngle_mod_2.Text));
            app.ChainElong_mod_delta.Text = num2str(str2num(app.ChainElong_mod_1.Text)-str2num(app.ChainElong_mod_2.Text));
            app.SwingarmAngle_mod_delta.Text = num2str(str2num(app.SwingarmAngle_mod_1.Text)-str2num(app.SwingarmAngle_mod_2.Text));
            app.COG_mod_delta.Text = num2str(str2num(app.COG_mod_1.Text)-str2num(app.COG_mod_2.Text));
            app.WDistr_mod_delta.Text = num2str(str2num(app.WDistr_mod_1.Text)-str2num(app.WDistr_mod_2.Text));
            app.Eff_Rear_mod_delta.Text = num2str(str2num(app.Eff_Rear_mod_1.Text)-str2num(app.Eff_Rear_mod_2.Text));
            app.Eff_Front_mod_delta.Text = num2str(str2num(app.Eff_Front_mod_1.Text)-str2num(app.Eff_Front_mod_2.Text));
            %riempire i mancanti inserendo funzioni di calcolo in output
            %multibody
        end

    elseif isequal(app.DropDown_Delta.Value, 'Delta Bike 1 & 2')

        if ~isempty(app.data1)
            %settings delta
            %magari mettere abs
            app.Roll_stock_delta.Text = num2str(str2num(app.Roll_stock_1.Text)-app.Roll_mod_1.Value);
            app.SteerAngle_stock_delta.Text = num2str(str2num(app.SteerAngle_stock_1.Text)-app.SteerAngle_mod_1.Value);
            app.FrontSuspCompr_stock_delta.Text = num2str(str2num(app.FrontSuspCompr_stock_1.Text)-app.FrontSuspCompr_mod_1.Value);
            app.RearSuspCompr_stock_delta.Text = num2str(str2num(app.RearSuspCompr_stock_1.Text)-app.RearSuspCompr_mod_1.Value);
            app.ForkVertOff_stock_delta.Text = num2str(str2num(app.ForkVertOff_stock_1.Text)-app.ForkVertOff_mod_1.Value);
            app.SwingOff_stock_delta.Text = num2str(str2num(app.SwingOff_stock_1.Text)-app.SwingOff_mod_1.Value);
            app.RodOff_stock_delta.Text = num2str(str2num(app.RodOff_stock_1.Text)-app.RodOff_mod_1.Value); %sistemare se si vuole offset e non lunghezza
            app.PlatesOff_stock_delta.Text = num2str(str2num(app.PlatesOff_stock_1.Text)-app.PlatesOff_mod_1.Value);
            app.SteerTopOff_stock_delta.Text = num2str(str2num(app.SteerTopOff_stock_1.Text)-app.SteerTopOff_mod_1.Value);
            app.SteerBotOff_stock_delta.Text = num2str(str2num(app.SteerBotOff_stock_1.Text)-app.SteerBotOff_mod_1.Value)  ;
            app.PivOffX_stock_delta.Text = num2str(str2num(app.PivOffX_stock_1.Text)-app.PivOffX_mod_1.Value);
            app.PivOffZ_stock_delta.Text = num2str(str2num(app.PivOffZ_stock_1.Text)-app.PivOffZ_mod_1.Value);
            
            %output delta
            
            app.WheelBase_stock_delta.Text = num2str(str2num(app.WheelBase_stock_1.Text)-str2num(app.WheelBase_mod_1.Text));
            app.RakeAngle_stock_delta.Text = num2str(str2num(app.RakeAngle_stock_1.Text)-str2num(app.RakeAngle_mod_1.Text));
            app.Trail_stock_delta.Text = num2str(str2num(app.Trail_stock_1.Text)-str2num(app.Trail_mod_1.Text));
            app.NormTrail_stock_delta.Text = num2str(str2num(app.NormTrail_stock_1.Text)-str2num(app.NormTrail_mod_1.Text));

            app.TransfAngle_stock_delta.Text = num2str(str2num(app.TransfAngle_stock_1.Text)-str2num(app.TransfAngle_mod_1.Text));
            app.SquatAngle_stock_delta.Text = num2str(str2num(app.SquatAngle_stock_1.Text)-str2num(app.SquatAngle_mod_1.Text));
            app.SquatRatio_stock_delta.Text = num2str(str2num(app.SquatRatio_stock_1.Text)-str2num(app.SquatRatio_mod_1.Text));

            app.EffSteerAngle_stock_delta.Text = num2str(str2num(app.EffSteerAngle_stock_1.Text)-str2num(app.EffSteerAngle_mod_1.Text));
            app.ChainElong_stock_delta.Text = num2str(str2num(app.ChainElong_stock_1.Text)-str2num(app.ChainElong_mod_1.Text));
            app.SwingarmAngle_stock_delta.Text = num2str(str2num(app.SwingarmAngle_stock_1.Text)-str2num(app.SwingarmAngle_mod_1.Text));
            app.COG_stock_delta.Text = num2str(str2num(app.COG_stock_1.Text)-str2num(app.COG_mod_1.Text));
            app.WDistr_stock_delta.Text = num2str(str2num(app.WDistr_stock_1.Text)-str2num(app.WDistr_mod_1.Text));
            app.Eff_Rear_stock_delta.Text = num2str(str2num(app.Eff_Rear_stock_1.Text)-str2num(app.Eff_Rear_mod_1.Text));
            app.Eff_Front_stock_delta.Text = num2str(str2num(app.Eff_Front_stock_1.Text)-str2num(app.Eff_Front_mod_1.Text));
            %riempire i mancanti inserendo funzioni di calcolo in output
            %multibody
            

        end

        if ~isempty(app.data2)
            %settings delta
            %magari mettere abs
            app.Roll_mod_delta.Text = num2str(str2num(app.Roll_stock_2.Text)-app.Roll_mod_2.Value);
            app.SteerAngle_mod_delta.Text = num2str(str2num(app.SteerAngle_stock_2.Text)-app.SteerAngle_mod_2.Value);
            app.FrontSuspCompr_mod_delta.Text = num2str(str2num(app.FrontSuspCompr_stock_2.Text)-app.FrontSuspCompr_mod_2.Value);
            app.RearSuspCompr_mod_delta.Text = num2str(str2num(app.RearSuspCompr_stock_2.Text)-app.RearSuspCompr_mod_2.Value);
            app.ForkVertOff_mod_delta.Text = num2str(str2num(app.ForkVertOff_stock_2.Text)-app.ForkVertOff_mod_2.Value);
            app.SwingOff_mod_delta.Text = num2str(str2num(app.SwingOff_stock_2.Text)-app.SwingOff_mod_2.Value);
            app.RodOff_mod_delta.Text = num2str(str2num(app.RodOff_stock_2.Text)-app.RodOff_mod_2.Value); %sistemare se si vuole offset e non lunghezza
            app.PlatesOff_mod_delta.Text = num2str(str2num(app.PlatesOff_stock_2.Text)-app.PlatesOff_mod_2.Value);
            app.SteerTopOff_mod_delta.Text = num2str(str2num(app.SteerTopOff_stock_2.Text)-app.SteerTopOff_mod_2.Value);
            app.SteerBotOff_mod_delta.Text = num2str(str2num(app.SteerBotOff_stock_2.Text)-app.SteerBotOff_mod_2.Value)  ;
            app.PivOffX_mod_delta.Text = num2str(str2num(app.PivOffX_stock_2.Text)-app.PivOffX_mod_2.Value);
            app.PivOffZ_mod_delta.Text = num2str(str2num(app.PivOffZ_stock_2.Text)-app.PivOffZ_mod_2.Value);
            
            %output delta
            app.WheelBase_mod_delta.Text = num2str(str2num(app.WheelBase_stock_2.Text)-str2num(app.WheelBase_mod_2.Text));
            app.RakeAngle_mod_delta.Text = num2str(str2num(app.RakeAngle_stock_2.Text)-str2num(app.RakeAngle_mod_2.Text));
            app.Trail_mod_delta.Text = num2str(str2num(app.Trail_stock_2.Text)-str2num(app.Trail_mod_2.Text));
            app.NormTrail_mod_delta.Text = num2str(str2num(app.NormTrail_stock_2.Text)-str2num(app.NormTrail_mod_2.Text));

            app.TransfAngle_mod_delta.Text = num2str(str2num(app.TransfAngle_stock_2.Text)-str2num(app.TransfAngle_mod_2.Text));
            app.SquatAngle_mod_delta.Text = num2str(str2num(app.SquatAngle_stock_2.Text)-str2num(app.SquatAngle_mod_2.Text));
            app.SquatRatio_mod_delta.Text = num2str(str2num(app.SquatRatio_stock_2.Text)-str2num(app.SquatRatio_mod_2.Text));

            app.EffSteerAngle_mod_delta.Text = num2str(str2num(app.EffSteerAngle_stock_2.Text)-str2num(app.EffSteerAngle_mod_2.Text));
            app.ChainElong_mod_delta.Text = num2str(str2num(app.ChainElong_stock_2.Text)-str2num(app.ChainElong_mod_2.Text));
            app.SwingarmAngle_mod_delta.Text = num2str(str2num(app.SwingarmAngle_stock_2.Text)-str2num(app.SwingarmAngle_mod_2.Text));
            app.COG_mod_delta.Text = num2str(str2num(app.COG_stock_2.Text)-str2num(app.COG_mod_2.Text));
            app.WDistr_mod_delta.Text = num2str(str2num(app.WDistr_stock_2.Text)-str2num(app.WDistr_mod_2.Text));
            app.Eff_Rear_mod_delta.Text = num2str(str2num(app.Eff_Rear_stock_2.Text)-str2num(app.Eff_Rear_mod_2.Text));
            app.Eff_Front_mod_delta.Text = num2str(str2num(app.Eff_Front_stock_2.Text)-str2num(app.Eff_Front_mod_2.Text));

            %riempire i mancanti inserendo funzioni di calcolo in output
            %multibody
            

        end
                
    end



end

