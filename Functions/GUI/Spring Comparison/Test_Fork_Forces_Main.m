clc; clear; close all;

% MAIN script per testare fork_forces_compare
% -------------------------------------------------------------------------
% Crea 3 configurazioni di forcella con parametri diversi
% e richiama la funzione fork_forces_compare.
% -------------------------------------------------------------------------

% ---- Forcella 1: solo molla meccanica ----
Spring.k_main     = 0;    % [kg/mm] rigidità molla
Spring.preload    = 20;      % [mm] precarico

Spring.use_top_out = true;
Spring.k_top      = 0.40;    % [kg/mm] rigidità top-out
Spring.top_travel = 40;      % [mm] corsa max top-out

Spring.fork_angle = 23;      % [deg] inclinazione forcella
Spring.stroke     = 124;     % [mm] corsa massima

Spring.useAir     = true;
Spring.air_gap    = 100;       % non usato
Spring.dia_air    = 46;

Spring.useGas     = true;
Spring.p_gas0     = 1;
Spring.dia_cart   = 5;
Spring.dia_gas    = 30;
Spring.h_gas      = 42;



% Richiamo funzione di confronto
%fork_forces_compare(app,Spring, Spring, Spring);


