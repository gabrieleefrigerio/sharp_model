function Plot_2D(app, P_1 , data_1, Output_1,  P_2, data_2,Output_2)
    % Plot_2D - Visualizza il profilo 2D di una o due moto nel piano X-Z
    %
    % AUTORE:
    %   Antonio Filianoti
    %
    % DESCRIZIONE:
    %   Questa funzione plottail profilo laterale (proiezione X-Z) della
    %   geometria multibody di una moto. È possibile visualizzare una singola
    %   moto oppure confrontarne due contemporaneamente.
    %
    % INPUT:
    %   P_1       - Struttura con le posizioni di punti rilevanti della moto 1
    %   data_1    - Struttura con parametri geometrici della moto 1
    %   P_2       - Struttura della moto 2 (necessaria solo se plot_both = true)
    %   data_2    - Struttura con parametri geometrici della moto 2
    %
    % OUTPUT:
    %   Nessun output restituito. La funzione genera una finestra grafica
    %   contenente il profilo 2D della moto (o delle due moto).
    %

    % === Creazione della figura ===
    %axes(app.UIAxes_2)  % imposta dimensione finestra
    view(app.UIAxes_2,[0,90])
    cla(app.UIAxes_2); hold(app.UIAxes_2,"on"); % mantiene proporzioni corrette e griglia
    


    %% ---- Moto 2 (rosso, opzionale) ----
    if nargin == 7
        h1 = plotBikeSymmetryPlane2(app,P_1, data_1,Output_1, 'b');
        % Se richiesto, disegna anche la moto 2 in rosso
        h2 = plotBikeSymmetryPlane2(app,P_2, data_2,Output_2, 'r');
    elseif nargin == 4
        h1 = plotBikeSymmetryPlane2(app,P_1, data_1,Output_1);
    end

    %% ---- Titoli assi e legenda ----
    app.UIAxes_2.XLabel.String = 'X [m]';  % etichetta asse X
    app.UIAxes_2.YLabel.String = 'Z [m]';  % etichetta asse Z

    % Costruzione legenda in base al numero di moto plottate
    if nargin == 7
        legend([h1, h2], {data_1.nome, data_2.nome}, 'Location', 'Best');
    else
        legend(h1, data_1.nome, 'Location', 'Best');
    end

    %grid(app.UIAxes_2,"on"); 
    hold (app.UIAxes_2,"off");  % rilascia hold
end

%% =====================================================================
function h_profile = plotBikeSymmetryPlane2(app,P, data, Output,color)
% plotBikeSymmetryPlane - Disegna la moto in 2D nel piano di simmetria
%
% Questa funzione visualizza la geometria della moto (in forma semplificata)
% nel piano di simmetria, includendo telaio, ruote, trasmissione, baricentro
% e le linee cinematiche (Squat Line e Transfer Line).
%
% INPUT:
%   P      : struct con i punti della moto già proiettati nel piano di simmetria
%            --> punti accessibili come P.bikePlane.p_nome
%   data   : struct con parametri geometrici (ruote, trasmissione ecc.)
%   Output : struct contenente i punti geometrici derivati (es. squat, transfer)
%
% OUTPUT:
%   Un plot 2D (X-Z) della moto nel suo piano di simmetria.


    %% === Profilo telaio ===
    % (non includo i punti di contatto nella linea nera)
    X = [P.bikePlane.p_centro_post(1), P.bikePlane.p_pivot(1), ...
         P.bikePlane.p_piastra_sup_dx(1), ...
         P.bikePlane.p_centro_ant(1)];
    Z = [P.bikePlane.p_centro_post(3), P.bikePlane.p_pivot(3), ...
         P.bikePlane.p_piastra_sup_dx(3), ...
         P.bikePlane.p_centro_ant(3)];

    xlim(app.UIAxes_2, [-500 1700]);
    ylim(app.UIAxes_2, [-200 1000]);

    if nargin == 5
        h_profile = plot(app.UIAxes_2, X, Z, color,'LineWidth',2,'MarkerFaceColor','k');
    else
        h_profile = plot(app.UIAxes_2, X, Z, '-b','LineWidth',2,'MarkerFaceColor','k');
    end
    
    
    % Punti di contatto evidenziati in rosso
    if nargin == 5
        scatter(app.UIAxes_2,P.bikePlane.p_contatto_post(1), P.bikePlane.p_contatto_post(3), ...
            80, strcat(color,'o') , 'filled','DisplayName','Contatto Post');
        scatter(app.UIAxes_2,P.bikePlane.p_contatto_ant(1), P.bikePlane.p_contatto_ant(3), ...
            80, strcat(color,'o') , 'filled','DisplayName','Contatto Ant');
    else
        scatter(app.UIAxes_2,P.bikePlane.p_contatto_post(1), P.bikePlane.p_contatto_post(3), ...
            80, 'ro', 'filled','DisplayName','Contatto Post');
        scatter(app.UIAxes_2,P.bikePlane.p_contatto_ant(1), P.bikePlane.p_contatto_ant(3), ...
            80, 'ro', 'filled','DisplayName','Contatto Ant');
    end
    

    %% === Strada ===
    plot(app.UIAxes_2,[-500, 1700], [0 0], 'k', 'LineWidth', 1.5, 'DisplayName','Strada');


    %% === Ruote ===
    theta = linspace(0,2*pi,200);

    % Ruota posteriore
    x_rear = P.bikePlane.p_centro_post(1) + P.bikePlane.p_centro_post(3) * cos(theta);
    z_rear = P.bikePlane.p_centro_post(3) + P.bikePlane.p_centro_post(3) * sin(theta);
    if nargin == 5
        plot(app.UIAxes_2,x_rear, z_rear, color,'LineWidth',1.2);
    else
        plot(app.UIAxes_2,x_rear, z_rear, 'k','LineWidth',1.2);
    end
    

    % Ruota anteriore
    x_front = P.bikePlane.p_centro_ant(1) + P.bikePlane.p_centro_ant(3) * cos(theta);
    z_front = P.bikePlane.p_centro_ant(3) + P.bikePlane.p_centro_ant(3) * sin(theta);
    if nargin == 5
        plot(app.UIAxes_2,x_front, z_front, color,'LineWidth',1.2);
    else
        plot(app.UIAxes_2,x_front, z_front, 'k','LineWidth',1.2);
    end

    %% === Trasmissione ===
    theta = linspace(0,2*pi,200);

    % Corona (sprocket) -> assunta centrata sul centro ruota posteriore
    r_sprocket = (data.Transmission.FinalSprocket * data.Transmission.FinalChainModule) / (2*pi);
    x_sprocket = P.bikePlane.p_centro_post(1) + r_sprocket*cos(theta);
    z_sprocket = P.bikePlane.p_centro_post(3) + r_sprocket*sin(theta);
    if nargin == 5
        plot(app.UIAxes_2,x_sprocket, z_sprocket, color,'LineWidth',1.2);
    else
        plot(app.UIAxes_2,x_sprocket, z_sprocket, 'k','LineWidth',1.2);
    end

    % Pignone
    r_pinion = (data.Transmission.FinalPinion * data.Transmission.FinalChainModule) / (2*pi);
    x_pinion = P.bikePlane.p_pinion(1) + r_pinion*cos(theta);
    z_pinion = P.bikePlane.p_pinion(3) + r_pinion*sin(theta);
    if nargin == 5
        plot(app.UIAxes_2,x_pinion, z_pinion, color,'LineWidth',1.2);
    else
        plot(app.UIAxes_2,x_pinion, z_pinion, 'k','LineWidth',1.2);
    end

    % Catena superiore (linea tra i punti di tangenza)
    if nargin == 5
        plot(app.UIAxes_2,[P.bikePlane.p_sup_sprocket(1), P.bikePlane.p_sup_pinion(1)], ...
         [P.bikePlane.p_sup_sprocket(3), P.bikePlane.p_sup_pinion(3)], ...
         color,'LineWidth',1.2);
    else
        plot(app.UIAxes_2,[P.bikePlane.p_sup_sprocket(1), P.bikePlane.p_sup_pinion(1)], ...
         [P.bikePlane.p_sup_sprocket(3), P.bikePlane.p_sup_pinion(3)], ...
         'k','LineWidth',1.2);
    end

    %% === Baricentro (cerchio diviso in 4 quadranti curvi) ===
    r = 20;  % raggio del cerchio del COG
    centerX = P.bikePlane.p_COG_tot(1);  % coordinata X del COG
    centerZ = P.bikePlane.p_COG_tot(3);  % coordinata Z del COG
    
    theta_edges = linspace(0, 2*pi, 5);  % divisione in 4 quadranti
    
    for i = 1:4
        t = linspace(theta_edges(i), theta_edges(i+1), 50);
        x_patch = [centerX, centerX + r*cos(t), centerX];
        z_patch = [centerZ, centerZ + r*sin(t), centerZ];


        if nargin == 5
            % Colora alternando pieno e bianco
            if mod(i,2)==0
                patch(app.UIAxes_2,x_patch, z_patch, color, 'EdgeColor', 'none'); % quadrante colorato
            else
                patch(app.UIAxes_2,x_patch, z_patch, 'w', 'EdgeColor', 'none');   % quadrante bianco
            end
        else
            % Colora alternando pieno e bianco
            if mod(i,2)==0
                patch(app.UIAxes_2,x_patch, z_patch, 'b', 'EdgeColor', 'none'); % quadrante colorato
            else
                patch(app.UIAxes_2,x_patch, z_patch, 'w', 'EdgeColor', 'none');   % quadrante bianco
            end
        end
    end
    
    % Bordo esterno del cerchio baricentro
    theta = linspace(0, 2*pi, 200);
    x_circle = centerX + r*cos(theta);
    z_circle = centerZ + r*sin(theta);
    if nargin == 5
        plot(app.UIAxes_2,x_circle, z_circle, color, 'LineWidth', 1.5);
    else
        plot(app.UIAxes_2,x_circle, z_circle, 'k', 'LineWidth', 1.5);
    end
    


    %% === Punto di Intersezione (stella) ===
    if nargin == 5
        scatter(app.UIAxes_2,P.bikePlane.p_intersect(1), P.bikePlane.p_intersect(3), ...
        40, 'o','MarkerEdgeColor',color,'MarkerFaceColor',color, ...
        'DisplayName','Intersect');
    else
        scatter(app.UIAxes_2,P.bikePlane.p_intersect(1), P.bikePlane.p_intersect(3), ...
        40, 'o','MarkerEdgeColor','r','MarkerFaceColor','r', ...
        'DisplayName','Intersect');
    end
    
    

    %% === Linee cinematiche ===

    L = 1500;  % lunghezza fittizia delle linee da plottare
    
    % Punto di partenza (contatto posteriore)
    x0 = P.bikePlane.p_contatto_post(1);
    z0 = P.bikePlane.p_contatto_post(3);
    
    % Squat Line
    x_squat = [x0, x0 + L * cosd(Output.SquatAngle)];
    z_squat = [z0, z0 + L * sind(Output.SquatAngle)];
    if nargin == 5
        plot(app.UIAxes_2,x_squat, z_squat, strcat('-.',color), 'LineWidth', 2, 'DisplayName', 'Squat Line');
    else
        plot(app.UIAxes_2,x_squat, z_squat, '-.m', 'LineWidth', 2, 'DisplayName', 'Squat Line');
    end
    
    
    % Transfer Line
    x_transfer = [x0, x0 + L * cosd(Output.TransferAngle)];
    z_transfer = [z0, z0 + L * sind(Output.TransferAngle)];
    if nargin == 5
        plot(app.UIAxes_2,x_transfer, z_transfer, strcat('-.',color), 'LineWidth', 2, 'DisplayName', 'Transfer Line');
    else
        plot(app.UIAxes_2,x_transfer, z_transfer, '-.c', 'LineWidth', 2, 'DisplayName', 'Transfer Line');
    end

    %% === Archi degli angoli ===
    % Centro degli archi = punto di contatto posteriore
    x0 = P.bikePlane.p_contatto_post(1);
    z0 = P.bikePlane.p_contatto_post(3);
    r_arc = 200; % raggio fittizio per gli archi
    r_arc_2 = 400; % raggio fittizio per gli archi
    
    % Squat Angle (arco da 0 a SquatAngle)
    theta_squat = linspace(0, deg2rad(Output.SquatAngle), 100);
    xs = x0 + r_arc * cos(theta_squat);
    zs = z0 + r_arc * sin(theta_squat);
    if nargin == 5
        plot(app.UIAxes_2,xs, zs, strcat('-',color),'LineWidth',2);
        text(app.UIAxes_2,xs(end)+20, zs(end), 'Squat', 'Color',color,'FontWeight','bold');
    else
        plot(app.UIAxes_2,xs, zs, '-m','LineWidth',2);
        text(app.UIAxes_2,xs(end)+20, zs(end), 'Squat', 'Color','m','FontWeight','bold');
    end
    

    % Transfer Angle (arco da 0 a TransferAngle)
    theta_transfer = linspace(0, deg2rad(Output.TransferAngle), 100);
    xt = x0 + r_arc_2 * cos(theta_transfer);
    zt = z0 + r_arc_2 * sin(theta_transfer);
    if nargin == 5
        plot(app.UIAxes_2,xt, zt, strcat('-',color),'LineWidth',2);
        text(app.UIAxes_2,xt(end)+20, zt(end), 'Transfer', 'Color',color,'FontWeight','bold');
    else
        plot(app.UIAxes_2,xt, zt, '-c','LineWidth',2);
        text(app.UIAxes_2,xt(end)+20, zt(end), 'Transfer', 'Color','c','FontWeight','bold');
    end



    % legend('Location','Best');
end






%% =====================================================================
% function h_profile = plot_single_moto(app,P, data, color)
%     % plot_single_moto - Disegna il profilo 2D di una singola moto
%     %
%     % INPUT:
%     %   P     - Struttura contenente i punti chiave della moto (pivot, ruote, COG, ecc.)
%     %   data  - Struttura con parametri geometrici (dimensioni ruote, ecc.)
%     %   color - Colore usato per la moto ('b', 'r', 'k', ecc.)
%     %
%     % OUTPUT:
%     %   h_profile - Handle della linea principale del profilo, utile per la legenda
%     %
% 
%     %% --- Profilo telaio (linea passante per punti principali) ---
%     % Estrae coordinate X e Z di alcuni punti rilevanti del telaio
%     X3D = [P.p_centro_post(1), P.p_pivot(1), ...
%            P.p_steering_axis(1), P.p_piastra_sup_dx(1), P.p_centro_ant(1)];
% 
%     Z3D = [P.p_centro_post(3), P.p_pivot(3), ...
%            P.p_steering_axis(3), P.p_piastra_sup_dx(3), P.p_centro_ant(3)];
% 
%     % Disegna linea telaio → handle usato per legenda
%     h_profile = plot(app.UIAxes_2,X3D, Z3D, color, 'LineWidth', 2);
%     app.UIAxes_2.YLim = [-100 1000];
%     app.UIAxes_2.XLim = [-500 2000];
% 
%     %% --- Cerchi delle ruote ---
%     theta = linspace(0, 2*pi, 200);  % angolo parametrico per cerchio
% 
%     % Ruota posteriore
%     x_rear = P.p_centro_post(1) + data.Wheels.RearSize * cos(theta);
%     z_rear = P.p_centro_post(3) + data.Wheels.RearSize * sin(theta);
%     plot(app.UIAxes_2,x_rear, z_rear, color, 'LineWidth', 1.5);
% 
%     % Ruota anteriore
%     x_front = P.p_centro_ant(1) + data.Wheels.FrontSize * cos(theta);
%     z_front = P.p_centro_ant(3) + data.Wheels.FrontSize * sin(theta);
%     plot(app.UIAxes_2,x_front, z_front, color, 'LineWidth', 1.5);
% 
%     %% --- Baricentro (cerchio diviso in 4 quadranti curvi) ---
%     r = 20;                          % raggio cerchio baricentro
%     centerX = P.p_COG_tot(1);        % coordinata X del COG
%     centerZ = P.p_COG_tot(3);        % coordinata Z del COG
% 
%     theta_edges = linspace(0, 2*pi, 5);  % divisione in 4 quadranti
% 
%     for i = 1:4
%         % Calcola arco del quadrante
%         t = linspace(theta_edges(i), theta_edges(i+1), 50);
%         x_patch = [centerX, centerX + r*cos(t), centerX];
%         z_patch = [centerZ, centerZ + r*sin(t), centerZ];
% 
%         % Colora alternando pieno e bianco
%         if mod(i,2)==0
%             patch(app.UIAxes_2,x_patch, z_patch, color, 'EdgeColor', 'none'); % quadrante colorato
%         else
%             patch(app.UIAxes_2,x_patch, z_patch, 'w', 'EdgeColor', 'none');   % quadrante bianco
%         end
%     end
% 
%     % Bordo esterno del cerchio baricentro
%     x_circle = centerX + r*cos(theta);
%     z_circle = centerZ + r*sin(theta);
%     plot(app.UIAxes_2,x_circle, z_circle, color, 'LineWidth', 1.5);
% 
% 
% 
%     % if nargin == 5  
%     % 
%     %     % --- Linea Squat Angle ---
%     %     L = 1000;  % lunghezza arbitraria per visualizzare la linea
%     %     x0 = P.p_contatto_post(1);
%     %     z0 = P.p_contatto_post(3);
%     % 
%     %     linea inclinata
%     %     x_squat = [x0, x0 + L*cosd(Output.SquatAngle)];
%     %     z_squat = [z0, z0 + L*sind(Output.SquatAngle)];
%     %     plot(app.UIAxes_2, x_squat, z_squat, 'g', 'LineWidth', 1);
%     % 
%     %     arco angolo squat
%     %     t = linspace(0, Output.SquatAngle, 50);
%     %     r_ang = 100; % raggio dell'arco per evidenziare l'angolo
%     %     x_arc = x0 + r_ang*cosd(t);
%     %     z_arc = z0 + r_ang*sind(t);
%     %     plot(app.UIAxes_2, x_arc, z_arc, 'g', 'LineWidth', 1);
%     % 
%     %     testo
%     %     text(app.UIAxes_2, x0 + r_ang*1.1, z0 + r_ang*0.2, 'Squat Angle', ...
%     %         'Color','g','FontSize',8);
%     % 
%     % 
%     %     % --- Linea Transfer Angle ---
%     %     x_trans = [x0, x0 + L*cosd(Output.TransferAngle)];
%     %     z_trans = [z0, z0 + L*sind(Output.TransferAngle)];
%     %     plot(app.UIAxes_2, x_trans, z_trans, 'g', 'LineWidth', 1);
%     % 
%     %     arco angolo transfer
%     %     t2 = linspace(0, Output.TransferAngle, 50);
%     %     x_arc2 = x0 + r_ang*cosd(t2);
%     %     z_arc2 = z0 + r_ang*sind(t2);
%     %     plot(app.UIAxes_2, x_arc2, z_arc2, 'g', 'LineWidth', 1);
%     % 
%     %     testo
%     %     text(app.UIAxes_2, x0 + r_ang*1.1, z0 + r_ang*0.5, 'Transfer Angle', ...
%     %         'Color','g','FontSize',8);
%     % 
%     % 
%     %     % --- Cerchi rossi nei punti di contatto ---
%     %     r_contact = 10;
%     %     theta_c = linspace(0,2*pi,100);
%     % 
%     %     posteriore
%     %     x_cpost = P.p_contatto_post(1) + r_contact*cos(theta_c);
%     %     z_cpost = P.p_contatto_post(3) + r_contact*sin(theta_c);
%     %     plot(app.UIAxes_2, x_cpost, z_cpost, 'r', 'LineWidth', 1.5);
%     % 
%     %     anteriore
%     %     x_cant = P.p_contatto_ant(1) + r_contact*cos(theta_c);
%     %     z_cant = P.p_contatto_ant(3) + r_contact*sin(theta_c);
%     %     plot(app.UIAxes_2, x_cant, z_cant, 'r', 'LineWidth', 1.5);
%     % 
%     % 
%     %     % --- Avancorsa (Trail) ---
%     %     x_trail = [P.p_contatto_ant(1), P.p_contatto_ant(1) + Output.Trail];
%     %     z_trail = [P.p_contatto_ant(3), P.p_contatto_ant(3)];
%     %     plot(app.UIAxes_2, x_trail, z_trail, 'g', 'LineWidth', 1);
%     % 
%     % 
%     %     % --- Corona e pignone (cerchi neri) ---
%     %     Calcolo raggio da numero denti e modulo catena
%     %     Diametro primitivo = N * m
%     %     Raggio = (N * m) / 2
%     % 
%     %     r_sprocket = (data.Transmission.FinalSprocket * data.Transmission.ChainModule)/2;
%     %     r_pinion   = (data.Transmission.FinalPinion   * data.Transmission.ChainModule)/2;
%     % 
%     %     corona (al centro ruota posteriore)
%     %     x_sprocket = P.p_centro_post(1) + r_sprocket*cos(theta_c);
%     %     z_sprocket = P.p_centro_post(3) + r_sprocket*sin(theta_c);
%     %     plot(app.UIAxes_2, x_sprocket, z_sprocket, 'k', 'LineWidth', 1);
%     % 
%     %     pignone
%     %     x_pinion = P.p_pinion(1) + r_pinion*cos(theta_c);
%     %     z_pinion = P.p_pinion(3) + r_pinion*sin(theta_c);
%     %     plot(app.UIAxes_2, x_pinion, z_pinion, 'k', 'LineWidth', 1);
%     % 
%     % end
% end
