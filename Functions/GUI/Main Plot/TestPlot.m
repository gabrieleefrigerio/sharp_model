clc
clear all
close all

% AUTHOR:
%   Antonio Filianoti

%% ========================== VARIABLES DESCRIPTION ==========================
% data     : struct containing all bike configuration parameters (geometry, suspension, angles, etc.)
% T        : struct containing all 4x4 homogeneous transformation matrices from the multibody model
% P        : struct containing 3D coordinates of all key points (wheel centers, pivots, etc.)
% Output   : struct containing computed results from the model (wheelbase, trail, caster angle, etc.)
% ============================================================================ 

%% === [ LOAD DATA STRUCT ] ===
% Carica la struct 'data' con i parametri da un file
data_1 = load_PMF_V2();  % Modifica il nome del file di input

data_2 = data_1;

%% === DEBUG/TEST VALUES (DA USARE PER TEST STAND-ALONE) ===
% === Inizializzazione struttura 'data' ===

% --- Parametri della strada ---
data_1.Road.RoadSlope = deg2rad(0);
data_1.Road.Banking   = deg2rad(0);
data_1.Multibody.Roll = deg2rad(0); 
data_1.Multibody.SteeringAngle = deg2rad(0); 


% --- Sospensione anteriore ---
data_1.FrontSuspension.ForksVerticalOffset = 0;
data_1.FrontSuspension.Compression         = 0;
data_1.FrontSuspension.OffsetTop = 0;
data_1.FrontSuspension.OffsetBottom = 0;
data_1.FrontSuspension.FootOffset = 0;
data_1.RearSuspension.Compression = 0;
data_1.Frame.SteeringAxisTopOffset = 0;
data_1.Frame.SteeringAxisBottomOffset = 0;
data_1.Frame.PivotOffsetX = 0;
data_1.Frame.PivotOffsetZ = 0;

%

% --- Parametri della strada ---
data_2.Road.RoadSlope = deg2rad(0);
data_2.Road.Banking   = deg2rad(0);
data_2.Multibody.Roll = deg2rad(0); 
data_2.Multibody.SteeringAngle = deg2rad(0); 
data_1.FrontSuspension.Compression         = 50;

clc

% === [ C0MPUTE KINEMATIC CLOSURES WITH REGULATIONS ] ===
[data_1,P_1] = cinematicClosures(data_1);

% === [ COMPUTE TRANSFORMATION MATRICES AND COORDINATES ] ===
[T_1, P_1, data_1] = MultibodyMatrices(data_1,P_1);


% === [ OUTPUT COMPUTATION ] ====
[Output_1, P_1] = OutputMultibody(T_1, P_1, data_1);

% === [ C0MPUTE KINEMATIC CLOSURES WITH REGULATIONS ] ===
[data_2,P_2] = cinematicClosures(data_2);

% === [ COMPUTE TRANSFORMATION MATRICES AND COORDINATES ] ===
[T_2, P_2, data_2] = MultibodyMatrices(data_2,P_2);


% === [ OUTPUT COMPUTATION ] ====
[Output_2, P_2] = OutputMultibody(T_2, P_2, data_2);


%% === [ PLOT MULTIBODY BIKE MODEL ] ===

use_3D = true;
plot_both = true;
Vista = [45,30];

main_Plot(use_3D, plot_both, Vista, T_1, P_1, data_1, T_2, P_2, data_2);

%% === [ PLOT MULTIBODY BIKE MODEL ] ===

use_3D = true;
plot_both = false;
Vista = [45,30];

main_Plot(use_3D, plot_both, Vista, T_1, P_1, data_1, [], [], []);

%% === [ PLOT MULTIBODY BIKE MODEL ] ===

use_3D = false;
plot_both = false;
Vista = [45,30];

main_Plot(use_3D, plot_both, Vista, T_1, P_1, data_1, [], [], []);

%% === [ PLOT MULTIBODY BIKE MODEL ] ===

use_3D = false;
plot_both = true;
Vista = [45,30];

main_Plot(use_3D, plot_both, Vista, T_1, P_1, data_1, T_2, P_2, data_2);


% view(0,0) side
% view(90,0) front
% view(-90,0) back
% view(0,90) top
% view(45,30) 3D