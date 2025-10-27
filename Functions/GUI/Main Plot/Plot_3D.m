function Plot_3D(app,Vista, T_1, P_1, data_1, T_2, P_2, data_2)
    % Plot_3D - Visualizza la geometria del sistema multibody della moto in 3D
    %
    % AUTORE:
    %   Antonio Filianoti
    %
    % DESCRIZIONE:
    %   Questa funzione permette di visualizzare in 3D la geometria di una moto
    %   multibody. È possibile rappresentare una singola moto oppure confrontarne
    %   due contemporaneamente con colori diversi (blu e rosso).
    %
    % INPUT:
    %   Vista     - Vettore [azimuth, elevation] che specifica la vista 3D iniziale.
    %   T_1, P_1, data_1 - Strutture che contengono le trasformazioni, posizioni
    %                      e dati geometrici della moto 1.
    %   T_2, P_2, data_2 - Strutture della moto 2 (necessarie solo se plot_both = true).
    %
    % OUTPUT:
    %   Nessun output restituito. La funzione apre una finestra grafica con la
    %   visualizzazione 3D della moto (o delle due moto).
    %

    %% === Creazione della finestra grafica ===
    %axes(app.UIAxes_2)  % dimensioni della figura
    view(app.UIAxes_2,Vista);                                % imposta vista 3D (azimuth, elevazione)
    cla(app.UIAxes_2);                         % proporzioni e griglia
    camlight(app.UIAxes_2); hold (app.UIAxes_2,"on");                          % luce e mantenimento grafica
    app.UIAxes_2.YLim = [-1000 1000];
    app.UIAxes_2.XLim = [-1000 2000];
    app.UIAxes_2.ZLim = [-100 1000];

    %% === Moto singola o doppia ===
    if nargin == 8
        % Moto 1 → plottata in blu
        plot_single_moto_3D(app,T_1, P_1, data_1, 'b');
        % Moto 2 → plottata in rosso
        plot_single_moto_3D(app,T_2, P_2, data_2, 'r');
    else
        % Solo Moto 1 → plottata in nero
        plot_single_moto_3D(app,T_1, P_1, data_1, 'k');
    end

    %% === Etichette assi ===
    app.UIAxes_2.XLabel.String = 'X [mm]';                             % asse X
    app.UIAxes_2.YLabel.String = 'Y [mm]';                             % asse Y
    app.UIAxes_2.ZLabel.String = 'Z [mm]';                             % asse Z

    %% === Legenda ===
    if nargin == 8
        % Creiamo dummy plot invisibili per legenda coerente coi colori
        h1 = plot(app.UIAxes_2,nan, nan, 'ob', 'MarkerFaceColor','b');
        h2 = plot(app.UIAxes_2,nan, nan, 'or', 'MarkerFaceColor','r');
        legend([h1 h2], {data_1.nome, data_2.nome}, 'Location', 'Best');
    else
        % Legenda per la singola moto (nera)
        h1 = plot(app.UIAxes_2,nan, nan, 'ok', 'MarkerFaceColor','k');
        legend(h1, data_1.nome, 'Location', 'Best');
    end

     hold (app.UIAxes_2,"off");
end

%% ============================================================
function plot_single_moto_3D(app,T, P, data, color)
    % plot_single_moto_3D - Disegna una singola moto in 3D
    %
    % INPUT:
    %   T     - Struttura con matrici di trasformazione
    %   P     - Struttura con punti chiave (pivot, ruote, COG, ecc.)
    %   data  - Struttura con parametri geometrici (ruote, torus, ecc.)
    %   color - Colore usato per gli elementi principali della moto
    %

    %% === Parametri grafici locali ===
    giallo_ohlins   = [1.0, 0.72, 0.0];   % colore foderi forcella
    grigio_cromato  = [0.72, 0.72, 0.72]; % colore steli forcella
    diameter_fodero = 40;                 % diametro foderi
    diameter_stelo  = 30;                 % diametro steli

    %% === Disegno del piano strada ===
    drawRoad(app.UIAxes_2,T.T_SDR_abs, 1000);

    %% === Ruote ===
    % Ruota posteriore
    drawTorus(app.UIAxes_2,T.T_centro_post, data.Wheels.CoarseRearMesh, true);
    % Ruota anteriore
    drawTorus(app.UIAxes_2,T.T_centro_ant,  data.Wheels.CoarseFrontMesh , true);

    %% === Forcelle ===
    % Foderi (parte superiore, gialli tipo Ohlins)
    drawCylinder(app.UIAxes_2,T.T_sup_forc_sx, T.T_mid_forc_sx, diameter_fodero, giallo_ohlins);
    drawCylinder(app.UIAxes_2,T.T_sup_forc_dx, T.T_mid_forc_dx, diameter_fodero, giallo_ohlins);
    % Steli (parte inferiore, cromati)
    drawCylinder(app.UIAxes_2,T.T_mid_forc_sx, T.T_end_forc_sx, diameter_stelo,  grigio_cromato);
    drawCylinder(app.UIAxes_2,T.T_mid_forc_dx, T.T_end_forc_dx, diameter_stelo,  grigio_cromato);

    %% === Connessioni rigide (linee telaio e forcellone) ===
    % Forcellone (centro ruota posteriore → pivot)
    plot3(app.UIAxes_2,[P.p_centro_post(1), P.p_pivot(1)], ...
          [P.p_centro_post(2), P.p_pivot(2)], ...
          [P.p_centro_post(3), P.p_pivot(3)], ...
          '-', 'Color', color, 'LineWidth', 3);

    % Telaio principale (pivot → asse sterzo)
    plot3(app.UIAxes_2,[P.p_pivot(1), P.p_steering_axis(1)], ...
          [P.p_pivot(2), P.p_steering_axis(2)], ...
          [P.p_pivot(3), P.p_steering_axis(3)], ...
          '-', 'Color', color, 'LineWidth', 3);

    %% === Piastra di sterzo superiore ===
    % Poligono che unisce piastra sup dx, sx e asse sterzo
    V = [P.p_piastra_sup_dx'; ...
         P.p_piastra_sup_sx'; ...
         P.p_steering_axis'];
    patch(app.UIAxes_2,'Vertices', V, 'Faces', 1:3, ...
          'FaceColor', [0.9, 0.9, 0.9], ... % grigio chiaro
          'EdgeColor', color, ...
          'LineWidth', 1.5);

    %% === Baricentro (COG) ===
    % Rappresentato come sfera a scacchi colorata
    drawCOG(app.UIAxes_2,P.p_COG_tot, 20, color);
end
