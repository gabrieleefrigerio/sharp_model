% ----------------- Impostazioni iniziali -----------------
clear; clc; close all;

% ----------------- Parametri di input -----------------
vx = linspace(10,150*0.3048,100);           % velocità in km/h
Zf = linspace(0.01,-1,100);       % carico anteriore

% ----------------- Conversioni -----------------
vx_values = vx(:)' / 3.6;    % km/h → m/s, garantito vettore riga
Zf_values = Zf(:)';          % garantito vettore riga
n_points = max(length(vx_values), length(Zf_values));

% Uniforma la lunghezza dei vettori se necessario
if isscalar(vx_values)
    vx_values = repmat(vx_values, 1, n_points);
end
if isscalar(Zf_values)
    Zf_values = repmat(Zf_values, 1, n_points);
end

% ----------------- Import data -----------------
Bike = load_PMF_V2();
[Bike, Output, P, T] = getBike(Bike);
data = computeData(P,Bike, Output);

% ----------------- Primo calcolo per identificare n_modi -----------------
vx_i = vx_values(1);
Zf_i = Zf_values(1);

A = Sharp_Model(vx_i, Zf_i, data);
[~, D] = eig(A);
n_modi = size(D, 1);

% ----------------- Preallocazioni -----------------
poli = zeros(n_modi, n_points);
frequenze_naturali = zeros(n_modi, n_points);
smorzamenti = zeros(n_modi, n_points);
stabilita = strings(n_modi, n_points);
autovettori_modo = cell(n_points, 1);

% ----------------- Calcoli dinamici -----------------
for i = 1:n_points
    vx_i = vx_values(i);
    Zf_i = Zf_values(i);
    A = Sharp_Model(vx_i, Zf_i, data);
    [V, D] = eig(A);

    % Ordina i poli e i vettori propri in base alla parte reale
    [sorted_poli, idx_sort] = sort(diag(D), 'ComparisonMethod', 'real');
    V = V(:, idx_sort);

    poli(:, i) = sorted_poli;

    if i == 1
        autovettori_modo{i} = V;
    end

    for j = 1:n_modi
        lambda = sorted_poli(j);
        sigma = real(lambda);
        omega = abs(imag(lambda));
        omega_n = abs(lambda);
        zeta = (omega_n == 0) * 1 + (omega_n ~= 0) * (-sigma / omega_n);
        freq_n = omega / (2 * pi);

        frequenze_naturali(j, i) = freq_n;
        smorzamenti(j, i) = zeta;
        if sigma < 0
            stabilita(j, i) = "Si";
        else
            stabilita(j, i) = "No";
        end

    end
end

% ----------------- Tabella per vx iniziale -----------------
i = 1;
V = autovettori_modo{i};
Modes_Table = table();
Modes_Table.Modo = (1:n_modi)';
Modes_Table.Velocita = repmat(vx_values(i), n_modi, 1);
Modes_Table.Reale = real(poli(:, i));
Modes_Table.Immaginario = imag(poli(:, i));
Modes_Table.Frequenza_Hz = frequenze_naturali(:, i);
Modes_Table.Smorzamento = smorzamenti(:, i);
Modes_Table.Stabile = stabilita(:, i);

for row = 1:size(V,1)
    Modes_Table.(sprintf('Comp_%d', row)) = V(row, :).';
end

fprintf ('--- Tabella Modi vx: %d Km/h --- \n', vx(1));
disp(Modes_Table);
assignin('base', 'Modes_Table', Modes_Table);

% ----------------- Tabelle per ogni modo -----------------
for j = 1:n_modi
    modo_table = table();
    modo_table.Velocita = vx_values';
    modo_table.Reale = real(poli(j, :))';
    modo_table.Immaginario = imag(poli(j, :))';
    modo_table.Frequenza_Hz = frequenze_naturali(j, :)';
    modo_table.Smorzamento = smorzamenti(j, :)';
    modo_table.Stabile = stabilita(j, :)';

    for comp = 1:n_modi
        comp_j = zeros(n_points, 1);
        for i = 1:n_points
            A = Sharp_Model(vx_i, Zf_i, data);
            [V, D] = eig(A);
            [sorted_poli, idx_sort] = sort(diag(D), 'ComparisonMethod', 'real');
            V = V(:, idx_sort);
            comp_j(i) = V(comp, j);
        end
        modo_table.(sprintf('Comp_%d', comp)) = comp_j;
    end

    assignin('base', sprintf('Modo_%d_Table', j), modo_table);
end

% ---------------- Palette Colori ----------------
colors = lines(n_modi);

% ---------------- Plot Frequenze Naturali ----------------
figure('Name','Frequenze Naturali','NumberTitle','off');
hold on;
for j = 1:n_modi
    plot(vx_values * 3.6, frequenze_naturali(j, :), 'LineWidth', 1.8, 'Color', colors(j, :));
end
xlabel('Velocità [km/h]');
ylabel('Frequenza [Hz]');
legend(arrayfun(@(j) sprintf('Modo %d', j), 1:n_modi, 'UniformOutput', false), 'Location', 'best');
grid on;
grid minor;

% ---------------- Plot Root Locus ----------------
figure('Name','Plot Root Locus','NumberTitle','off');
hold on;

% Traccia i root locus per ogni modo
for j = 1:n_modi
    h(j) = plot(real(poli(j,:)), imag(poli(j,:)), 'LineWidth', 1.5, 'Color', colors(j, :));
end

% Traccia una "x" solo una volta per indicare il punto iniziale (senza ripetere in legenda)
for j = 1:n_modi
    plot(real(poli(j,1)), imag(poli(j,1)), 'x', 'MarkerSize', 10, 'LineWidth', 2, 'Color', colors(j,:));
end

% Aggiungi etichette
xlabel('Parte Reale');
ylabel('Parte Immaginaria');

% Crea legenda: modi + punto iniziale
legend([h, plot(nan, nan, 'xk', 'MarkerSize', 10, 'LineWidth', 2)], ...
       [arrayfun(@(j) sprintf('Modo %d', j), 1:n_modi, 'UniformOutput', false), {'pto. di partenza polo'}], ...
       'Location', 'best');

grid on;
grid minor;


% ----------------- Analisi Stabilità -----------------
fprintf('\n--- Analisi stabilità dei modi ---\n');
for j = 1:n_modi
    parte_reale = real(poli(j, :));
    idx_instabile = find(parte_reale > 0, 1);

    if isempty(idx_instabile)
        fprintf('Modo %d: sempre STABILE.\n', j);
    elseif idx_instabile == 1
        fprintf('Modo %d: sempre INSTABILE.\n', j);
    else
        fprintf('Modo %d: diventa INSTABILE a vx = %.2f Km/h\n', j, vx_values(idx_instabile)*3.6);
    end
end

% ---------------- Plot Parte Reale dei Poli vs Velocità ----------------
figure('Name','Parte Reale dei Poli vs Velocità','NumberTitle','off');
hold on;

for j = 1:n_modi
    plot(vx_values * 3.6, real(poli(j,:)), 'LineWidth', 1.8, 'Color', colors(j, :));
end

xlabel('Velocità [km/h]');
ylabel('Parte Reale (\sigma)');
title('Parte Reale dei Poli vs Velocità');
grid on;
grid minor;

% Linea orizzontale a 0 (confine stabilità)
yline(0, '--k', 'LineWidth', 1.2);

legend(arrayfun(@(j) sprintf('Modo %d', j), 1:n_modi, 'UniformOutput', false), ...
       'Location', 'best');
% % ----------------- FRF -----------------
% vx_med = mean(vx_values);
% Zf_med = mean(Zf_values);
% 
% K = vx_med * [2 -1; -1 2];
% C = Zf_med * [2 -1; -1 2];
% w = (0:0.001:0.5) * (2*pi);
% 
% G11 = zeros(size(w)); G12 = G11;
% G21 = G11; G22 = G11;
% 
% for ii = 1:length(w)
%     G = inv(-w(ii)^2*M + 1i*w(ii)*C + K);
%     G11(ii) = G(1,1); G12(ii) = G(1,2);
%     G21(ii) = G(2,1); G22(ii) = G(2,2);
% end
% 
% % ----------------- Plot FRF -----------------
% figure('Name','Funzioni di Trasferimento (FRF)','NumberTitle','off');
% subplot(2,4,1); plot(w/(2*pi), abs(G11)); title('G_{11}'); grid on;  grid minor;
% subplot(2,4,5); plot(w/(2*pi), unwrap(angle(G11))); ylabel('Fase [rad]'); grid on; grid minor;
% 
% subplot(2,4,2); plot(w/(2*pi), abs(G12)); title('G_{12}'); grid on; grid minor;
% subplot(2,4,6); plot(w/(2*pi), unwrap(angle(G12))); ylabel('Fase [rad]'); grid on;grid minor;
% 
% subplot(2,4,3); plot(w/(2*pi), abs(G21)); title('G_{21}'); grid on;grid minor;
% subplot(2,4,7); plot(w/(2*pi), unwrap(angle(G21))); ylabel('Fase [rad]'); grid on;grid minor;
% 
% subplot(2,4,4); plot(w/(2*pi), abs(G22)); title('G_{22}'); grid on;grid minor;
% subplot(2,4,8); plot(w/(2*pi), unwrap(angle(G22))); ylabel('Fase [rad]'); grid on;grid minor;
% 
% % ----------------- Pulizia finale -----------------
% varNames = ["Modes_Table", arrayfun(@(j) sprintf("Modo_%d_Table", j), 1:n_modi, "UniformOutput", false)];
% clearvars('-except', varNames{:});

