function main_Plot(app,use_3D, Vista, T_1, P_1, data_1,Output_1, T_2, P_2, data_2,Output_2)
    % main_Plot - Funzione principale per la visualizzazione della moto
    %
    % AUTORE:
    %   Antonio Filianoti
    %
    % DESCRIZIONE:
    %   Questa funzione gestisce la scelta del tipo di grafico (2D o 3D)
    %   e se plottare una o due moto. Funziona come "dispatcher" che richiama
    %   le funzioni Plot_2D o Plot_3D a seconda delle impostazioni fornite
    %   dall’utente.
    %
    % INPUT:
    %   use_3D    - Boolean (true/false). Se true viene utilizzato il plot 3D,
    %               altrimenti quello 2D.
    %   Vista     - Vettore [azimuth, elevation] che definisce l’angolo di vista
    %               per il grafico 3D. Ignorato se use_3D = false.
    %   T_1       - Struttura delle trasformazioni rigide della moto 1
    %   P_1       - Struttura con i punti caratteristici della moto 1
    %   data_1    - Struttura con i parametri geometrici e il nome della moto 1
    %   T_2       - (Opzionale) Struttura delle trasformazioni rigide della moto 2
    %   P_2       - (Opzionale) Struttura con i punti caratteristici della moto 2
    %   data_2    - (Opzionale) Struttura con i parametri geometrici e il nome della moto 2
    %
    % OUTPUT:
    %   Nessun output diretto. La funzione genera una finestra grafica
    %   contenente la visualizzazione scelta (2D o 3D).
    %
    


    % view(0,0) side
    % view(90,0) front
    % view(-90,0) back
    % view(0,90) top
    % view(45,30) 3D


    % === Caso in cui si vogliono plottare entrambe le moto e posso ===
    if nargin == 11 & ~isempty(T_1) & ~isempty(T_2)
        if use_3D
            % Richiamo funzione di visualizzazione 3D per due moto
            Plot_3D(app, Vista, T_1, P_1, data_1, T_2, P_2, data_2)
        else
            % Richiamo funzione di visualizzazione 2D per due moto
            Plot_2D(app, P_1 , data_1,Output_1,  P_2, data_2,Output_2)
        end

    % === Caso in cui si vogliono plottare entrambe le moto e non posso ===
    elseif nargin == 11 & isempty(T_1) 
        if use_3D
            % Richiamo funzione di visualizzazione 3D per una moto
            % Nota: per coerenza con la firma della funzione Plot_3D,
            %       si passano array vuoti per la seconda moto
            Plot_3D(app, Vista, T_2, P_2, data_2);
        else
            % Richiamo funzione di visualizzazione 2D per una moto
            Plot_2D(app, P_2, data_2,Output_2)
        end

    elseif nargin == 11 & isempty(T_2) 
        if use_3D
            % Richiamo funzione di visualizzazione 3D per una moto
            % Nota: per coerenza con la firma della funzione Plot_3D,
            %       si passano array vuoti per la seconda moto
            Plot_3D(app, Vista, T_1, P_1, data_1);
        else
            % Richiamo funzione di visualizzazione 2D per una moto
            Plot_2D(app, P_1, data_1,Output_1)
        end

    % === Caso in cui si vuole plottare una sola moto e si può
    elseif nargin ~= 11 & ~isempty(T_1)
        if use_3D
            % Richiamo funzione di visualizzazione 3D per una moto
            % Nota: per coerenza con la firma della funzione Plot_3D,
            %       si passano array vuoti per la seconda moto
            Plot_3D(app, Vista, T_1, P_1, data_1);
        else
            % Richiamo funzione di visualizzazione 2D per una moto
            Plot_2D(app, P_1, data_1,Output_1)
        end
    elseif nargin ~= 11 & isempty(T_1)

    end
end
