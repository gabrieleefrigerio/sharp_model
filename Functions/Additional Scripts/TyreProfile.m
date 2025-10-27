%% stima_raggio_gomma_scaled.m
% Carica un’immagine del profilo trasversale e stima il raggio in funzione
% dell’angolo di rollio, calibrando la scala in base al diametro esterno fornito.

clear; close all; clc;

%% 1. Parametri
 imgFile       = 'Rear_Profile.png';  % nome file immagine
% imgFile       = 'Front_Profile.png';  % nome file immagine
D_real_mm     = 576;                 % diametro esterno reale [mm] (input)
Nangles       = 100;                 % numero di angoli gamma da 0 a gamma_max
gamma_max     = 50;                  % angolo massimo [°]
windowSize_px = 90;                 % dimensione finestra in pixel per fitting
minEdgeTh     = 0.0001;              % soglia per edge detection

%% 2. Carica e pre-processa l’immagine
Iorig = imread(imgFile);
if size(Iorig,3)>1
    I = rgb2gray(Iorig);
else
    I = Iorig;
end
I = im2double(I);
I = imadjust(I);

%% 3. Rileva il bordo esterno
BW = edge(I, 'Canny', minEdgeTh);
[B, ~] = bwboundaries(BW, 'noholes');

% Prendi il contorno più lungo
boundary = B{1};
for k = 2:length(B)
    if length(B{k}) > length(boundary)
        boundary = B{k};
    end
end
xB_px = boundary(:,2);
yB_px = boundary(:,1);

%% 4. Calcola fattore di scala in mm/pixel
coords = [xB_px, yB_px];
D_px = max(pdist(coords));      % diametro massimo in pixel
s = D_real_mm / D_px;           % mm/pixel

% Converti in mm e centra sul baricentro
xc_px = mean(xB_px); yc_px = mean(yB_px);
xB = (xB_px - xc_px) * s;
yB = (yB_px - yc_px) * s;

%% 5. Campionamento angoli e fitting locale
gammas = linspace(0, gamma_max, Nangles);
R_est = nan(size(gammas));
centers = nan(length(gammas), 2);  % per memorizzare i centri stimati

% Raggio nominale stimato (metà diametro reale)
R0 = D_real_mm / 2;

for i = 1:length(gammas)
    gamma = gammas(i) * pi/180;
    x0 =  R0 * sin(gamma);
    y0 = -R0 * cos(gamma);

    % Fitting locale su tutto il bordo
    D = hypot(xB - x0, yB - y0);
    idx = find(D < windowSize_px * s);
    if numel(idx) < 5, continue; end

    xb = xB(idx); yb = yB(idx);
    A = [2*xb, 2*yb, ones(size(xb))];
    b = xb.^2 + yb.^2;
    p = A\b;
    xc = p(1); yc = p(2);
    R_est(i) = sqrt(p(3) + xc^2 + yc^2);
    centers(i,:) = [xc, yc];
end

%% 6. Plot dei risultati
% figure;
% plot(gammas, R_est, 'o-','LineWidth',1.5);
% xlabel('Angolo di rollio \gamma [°]');
% ylabel('Raggio stimato R(\gamma) [mm]');
% grid on;
% title('Raggio del profilo gomma in funzione dell’angolo di rollio');

%% 7. Plot finale: profilo reale + cerchi stimati + cerchio ideale

% Cerchio ideale (nominale)
theta_circ = linspace(0, 2*pi, 200);


% Cerchi stimati
xc = centers(i,1);
yc = centers(i,2);
R  = R_est(i);
x_circle = R * cos(theta_circ) + xc;
y_circle = R * sin(theta_circ) + yc;


%% 7. Plot finale: profilo reale + cerchi stimati + cerchio ideale
figure;
hold on; axis equal; grid on;
title('Profilo reale e cerchi stimati');

% --- Profilo completo della gomma come punti ---
plot(xB, yB, 'k.', 'DisplayName', 'Profilo reale');


% --- Cerchi stimati ---
xc = centers(i,1);
yc = centers(i,2);
R  = R_est(i);
x_circle = R * cos(theta_circ) + xc;
y_circle = R * sin(theta_circ) + yc;
plot(x_circle, y_circle, 'r-', 'LineWidth', 0.5, 'Color', [1 0 0 0.3], 'DisplayName', 'Profilo ideale');

% --- Fitting polinomiale del profilo reale ---
% Usiamo una regressione polinomiale per approssimare il profilo reale (curva liscia).
% Consideriamo di fare un fitting su una curva di grado 3 (cubic spline o polinomio)
p = polyfit(xB, yB, 15);  % Fitting polinomiale di grado 3

% Generiamo i punti della curva approssimata (smooth curve)
x_smooth = linspace(min(xB), max(xB), 1000);  % Intervallo per la curva liscia
y_smooth = polyval(p, x_smooth);  % Calcoliamo i valori della curva

% --- Aggiungi la curva approssimata al plot ---
plot(x_smooth, y_smooth, 'g-', 'LineWidth', 2, 'DisplayName', 'Curva approssimata (polinomiale)');

% --- Legenda e etichette ---
legend();
xlabel('X [mm]');
ylabel('Y [mm]');
