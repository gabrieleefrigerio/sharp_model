function GUI_Update_mod(app,input)
%input 1 se cambia mod 1, 2 se cambia mod 2

switch input 
    case 1
        if ~isempty(app.data1mod)
            % Ricalcola chiususre moto
            [app.data1mod, app.P1mod, app.T1mod, app.Output1mod] = GUI_Output_Computation(app.data1mod);
            
            GUI_Output_Update(app,2);
        end
    case 2
        if ~isempty(app.data2mod)
            % Ricalcola chiususre moto
            [app.data2mod, app.P2mod, app.T2mod, app.Output2mod] = GUI_Output_Computation(app.data2mod);
            
            GUI_Output_Update(app,4);
        end

end
    
    %aggiorna label di delta 
    GUI_delta_Update(app); %si potrebbe non aggiornare tutto il delta per il setup ma solo output
    
    
    %% aggiornare i plot dove serve con i controlli degli state e se
    %sono già plottati
    switch input 
        case 1
            if isequal(app.DropDown_22.Value,'Bike 1 Mod') || isequal(app.DropDown_22.Value,'All Bike 1') || isequal(app.DropDown_22.Value,'All Bike Mod')
                app.main_plott()
            end
    
        case 2
            if isequal(app.DropDown_22.Value,'Bike 2 Mod') || isequal(app.DropDown_22.Value,'All Bike 2') || isequal(app.DropDown_22.Value,'All Bike Mod')
                app.main_plott()
            end
    

    end

end

