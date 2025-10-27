% ----------------- Impostazioni iniziali -----------------
clear; clc; close all;

% ----------------- Parametri di input -----------------
vx = linspace(4,6,100);           % velocità in km/h
Zf = linspace(0.01,-1,100);       % carico anteriore

% ----------------- load .pmf file -----------------

data = load_PMF_V2()

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

% ----------------- Primo calcolo per identificare n_modi -----------------
vx_i = vx_values(1);
Zf_i = Zf_values(1);