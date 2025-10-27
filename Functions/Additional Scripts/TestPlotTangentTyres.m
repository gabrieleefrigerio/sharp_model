clear; close all; clc;

%% === Operatori di trasformazione ===
[Rx, Ry, Rz, T_rot, T_tr] = getOperators();

%% === Parametri geometrici ===
RearSize  = 300;   % Raggio grande del toroide [mm]
RearTorus = 50;    % Raggio piccolo del toroide [mm]

%% === Angoli di test (in radianti) ===
banking = deg2rad(0);   % Inclinazione laterale strada
slope   = deg2rad(0);   % Pendenza longitudinale strada
roll    = deg2rad(30);    % Rollio ruota

%% === Trasformazioni ===
% Piano stradale inclinato
T_plane = T_rot(Rx(banking)) * T_rot(Ry(slope));
T_plane(1:3,4) = [0; 0; 0];

% Orientamento iniziale toroide (centrato e con rollio)
T_torus_init = T_rot(Rx(roll)) * T_tr(RearTorus * [0; 0; 1]);

%% === Generazione punti toroide (locali) ===
[P_local, ~, ~, ~] = drawTorus(eye(4), RearSize, RearTorus, false, false);

%% === Allineamento toroide tangente al piano ===
[T_torus_final, p_contact] = alignTorusTangentialToPlane(T_torus_init, T_plane, P_local);

%% === Visualizzazione ===
figure('Position', [100, 100, 1600, 900]);
hold on; grid on; axis equal; view(3);
xlabel('X [mm]'); ylabel('Y [mm]'); zlabel('Z [mm]');
title('Toroide tangente al piano inclinato');
camlight; lighting gouraud;

% Disegna piano stradale
range = RearSize * 1.5;
drawRoad(T_plane, range);

% Disegna toroide
drawTorus(T_torus_final, RearSize, RearTorus);

% Punto di contatto
plot3(p_contact(1), p_contact(2), p_contact(3), 'ro', 'MarkerSize', 10, 'LineWidth', 2);

legend('Piano', 'Toroide', 'Punto di contatto');

%% FUNCTIONS

function [T_final, p_contact] = alignTorusTangentialToPlane(T_init, T_plane, P_local)
    % Author: Antonio FIlianoti

    % Allinea il toroide a essere tangente a un piano inclinato.
    % INPUT:
    %   T_init   : trasformazione iniziale del toroide (4×4)
    %   T_plane  : trasformazione del piano inclinato (4×4)
    %   P_local  : punti omogenei (4×N) del toroide in coordinate locali
    % OUTPUT:
    %   T_final   : trasformazione finale (4×4)
    %   p_contact : punto di contatto 3×1 nel sistema globale

    % Inversa del piano e normale globale
    T_inv_plane  = inv(T_plane);
    plane_normal = T_plane(1:3,3);

    % Operatore di traslazione omogenea
    T_tr = @(v) [eye(3), v; zeros(1,3), 1];

    % Funzione che, per uno spostamento lungo la normale (dz), restituisce
    % la minima altezza (Z) dei punti del toroide nello spazio del piano.
    % Se minimaZ < 0, significa penetrazione.
    function minZ = penetrationDepth(dz)
        T_tmp   = T_init * T_tr(dz * plane_normal);
        P_glob  = T_tmp * P_local;
        P_plane = T_inv_plane * P_glob;
        minZ    = min(P_plane(3,:));
    end

    % Obiettivo: ridurre al minimo la penetrazione (voglio che minZ >= 0)
    costFunc = @(dz) max(0, -penetrationDepth(dz));

    % Vincolo non lineare: almeno un punto sul piano => minZ == 0
    function [c, ceq] = tangencyConstraint(dz)
        c   = [];                 % nessuna disuguaglianza aggiuntiva
        ceq = penetrationDepth(dz); % vogliamo ceq == 0
    end

    % Ottimizzazione con fmincon
    opts = optimoptions('fmincon','Display','none');
    dz0  = 0;  % punto di partenza (nessuna traslazione)
    lb   = -1e3; ub = 1e3;
    dz_opt = fmincon(costFunc, dz0, [],[],[],[], lb, ub, @tangencyConstraint, opts);

    % Costruisco la trasformazione finale
    T_final = T_init * T_tr(dz_opt * plane_normal);

    % Calcolo il punto di contatto (minZ == 0)
    P_glob_final  = T_final * P_local;
    P_plane_final = T_inv_plane * P_glob_final;
    [~, idx] = min(P_plane_final(3,:));
    p_contact = P_glob_final(1:3, idx);
end
