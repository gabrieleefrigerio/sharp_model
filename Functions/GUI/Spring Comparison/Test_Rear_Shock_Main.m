clc
clear
clear all

% MAIN TEST

% % Shock_1
% Shock.spring.stiff   = 8;    % N/mm
% Shock.spring.preload = 17;     % mm
% Shock.spring.dwgstrk = 40;    % mm
% 
% Shock.topOut.stiff   = 18;    % N/mm
% Shock.topOut.strk    = 9;    % mm
% 
% Shock.intElem.strk     = 40;     % corsa interna totale [mm]
% Shock.intElem.pistRod  = 14;     % diametro stelo [mm]
% Shock.intElem.gasRoom  = [40, 37]; % [diametro gas room mm, altezza mm]
% Shock.intElem.gasPress = 5;     % pressione gas [bar]
% 
% Shock.rubber.data = []; % disattivato (usa LUT interna)
% 
% % Shock_2
% 
% Shock.spring.stiff   = 8;    % N/mm
% Shock.spring.preload = 17;     % mm
% Shock.spring.dwgstrk = 40;    % mm
% 
% Shock.topOut.stiff   = 18;    % N/mm
% Shock.topOut.strk    = 9;    % mm
% 
% Shock.intElem.strk     = 40;     % corsa interna totale [mm]
% Shock.intElem.pistRod  = 14;     % diametro stelo [mm]
% Shock.intElem.gasRoom  = [40, 37]; % [diametro gas room mm, altezza mm]
% Shock.intElem.gasPress = 5;     % pressione gas [bar]
% 
% Shock.rubber.data = []; % disattivato (usa LUT interna)

% Shock

Shock.spring.stiff   = 8;    % N/mm
Shock.spring.preload = 17;     % mm
Shock.spring.dwgstrk = 40;    % mm

Shock.use_top_out = true;
Shock.topOut.stiff   = 18;    % N/mm
Shock.topOut.strk    = 9;    % mm

Shock.use_gas = true;
Shock.intElem.strk     = 40;     % corsa interna totale [mm]
Shock.intElem.pistRod  = 14;     % diametro stelo [mm]
Shock.intElem.gasRoom  = [40, 37]; % [diametro gas room mm, altezza mm]
Shock.intElem.gasPress = 5;     % pressione gas [bar]

Shock.use_rubber = false;
Shock.rubber.data = []; % disattivato (usa LUT interna)

% Tre ammortizzatori uguali per test
rear_shock_forces_compare(Shock, Shock, Shock);
