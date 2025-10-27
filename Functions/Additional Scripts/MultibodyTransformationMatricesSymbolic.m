
tic
clc; clear;

%% === [ SYMBOLIC INITIALIZATION ] ===
syms dummy

sym_vars = {
    'ForksLength','ForksVerticalOffset','ForksCompression','ForksMaxCompression',...
    'ForksTopThickness','OffsetTop','OffsetTopMax','OffsetTopMin',...
    'PlatesBottomThickness','OffsetBottom','OffsetBottomMax','OffsetBottomMin',...
    'PlatesForkOffset','FootOffset','ForksWheelbase','xcog','ycog','masscog',...
    'LengthRearSuspension','LengthMaxRearSuspension','LengthMinRearSuspension',...
    'CompressionRear','MaxCompressionRearSuspension','Type',...
    'TriangleSuspFrame','TriangleFrameRod','TriangleRodSusp',...
    'TriangleSwingSup','TriangleSwingRod','RodLength','MaxRodLength','MonRodLength',...
    'LengthRear2SteeringHead','HeightSteeringHead','DistSteeringHead',...
    'SteeringAxisTopOffset','SteeringAxisTopOffsetMax','SteeringAxisTopOffsetMin',...
    'SteeringAxisBottomOffset','SteeringAxisBottomOffsetMax','SteeringAxisBottomOffsetMin',...
    'AttFrameSupX','AttFrameSupZ','AngleAttFrameSupOffset','AttFrameSupOffset','AttFrameSupOffsetMax',...
    'AttFrameInfX','AttFrameInfZ','AngleAttFrameInfOffset','AttFrameInfOffset','AttFrameInfOffsetMax',...
    'PivotOffsetX','PivotOffsetZ','AnglePivotOffset','COGX','COGZ','COGMass','PinionX','PinionZ',...
    'FairingX1','FairingZ1','FairingX2','FairingZ2',...
    'LengthSwingArm','AngleOffset','Offset','OffsetMax',...
    'AttSwingInfX','AttSwingInfZ','AngleAttSwingInf','OffsetAttSwingInf','OffsetAttSwingInfMax',...
    'AttSwingSupX','AttSwingSupZ','AngleAttSwingSup','OffsetAttSwingSup','OffsetAttSwingSupMax',...
    'COGX_SW','COGY_SW','COGMass_SW','FrontSize','FrontMass','RearSize','RearMass','FrontTorus','RearTorus','TraslZ',...
    'LengthSwingArmFinal','LengthFrameFinal','AlphaSwingArm','BetaFrame','GammaSteeringAxis',...
    'RoadSlope','Bancking','FinalPinion','FinalSprocket','FinalChainModule','Roll','SteeringAngle','mu'
};


cellfun(@(v) evalin('base', ['syms ' v]), sym_vars);

%% === [ ROTATION MATRICES (ANONYMOUS) ] ===
Rx = @(theta) [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
Ry = @(theta) [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
Rz = @(theta) [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];

T_rot = @(R) [R, zeros(3,1); 0 0 0 1]; % Rotazione 4x4
T_tr = @(v) [eye(3), v(:); 0 0 0 1];   % Traslazione 4x4

%% === [ ROAD PLANE ] ===
R_road = Ry(RoadSlope) * Rx(Bancking);
T_SDR_abs = T_rot(R_road);

%% === [ BIKE ROLL & PITCH ] ===
R_roll = R_road * Rx(Roll);
T_roll = T_rot(R_roll);

%% === [ REAR WHEEL ] ===
p_contatto_post = [0; -Roll * RearTorus; 0];
T_contatto_post = T_roll; T_contatto_post(1:3,4) = p_contatto_post;

% Centro ruota post
T_centro_post = T_roll * T_tr(RearSize * R_roll(:,3));
T_centro_post = T_centro_post * T_tr([-Roll * RearTorus * R_roll(:,2) + TraslZ * R_roll(:,3)]);

p_centro_post = T_centro_post(1:3,4);

%% === [ SWINGARM ] ===
T_swing_pivot = T_centro_post * T_rot(Ry(AlphaSwingArm)) * T_rot(Ry(mu)) * T_tr(LengthSwingArmFinal * T_centro_post(1:3,1));
p_pivot = T_swing_pivot(1:3,4);

%% === [ FRAME - STEERING AXIS ] ===
T_frame_pivot = T_swing_pivot * T_rot(Ry(BetaFrame));
T_steering_axis = T_frame_pivot * T_tr(LengthFrameFinal * T_frame_pivot(1:3,1));
T_steering_axis = T_steering_axis * T_rot(Ry(GammaSteeringAxis)) * T_rot(Rz(SteeringAngle));

p_steering_axis = T_steering_axis(1:3,4);

%% === [ FORK PLATES - DX / SX ] ===

% Matrice trasformazione posizione superiore forche 
dir = T_steering_axis(1:3,1:3);

v_dx = [PlatesForkOffset; -ForksWheelbase; ForksVerticalOffset];
v_sx = [PlatesForkOffset; ForksWheelbase; ForksVerticalOffset];

T_sup_forc_dx = T_steering_axis * T_tr(dir * v_dx);
T_sup_forc_sx = T_steering_axis * T_tr(dir * v_sx);

p_sup_forc_dx = T_sup_forc_dx(1:3,4);
p_sup_forc_sx = T_sup_forc_sx(1:3,4);

% Matrice Trasformazione fine fodero forche
v_trasl  = [0; 0; - (7/10) * ForksLength ];
T_mid_forc_dx  = T_sup_forc_dx * T_tr(dir * v_trasl);
T_mid_forc_sx  = T_sup_forc_sx * T_tr(dir * v_trasl);

p_mid_forc_dx = T_mid_forc_dx(1:3,4);
p_mid_forc_sx = T_mid_forc_sx(1:3,4);


% Matrice Trasformazione fine forche
v_trasl  = [0; 0; - (3/10) * ForksLength - ForksCompression];
T_end_forc_dx  = T_sup_forc_dx * T_tr(dir * v_trasl);
T_end_forc_sx  = T_sup_forc_sx * T_tr(dir * v_trasl);

p_end_forc_dx = T_end_forc_dx(1:3,4);
p_end_forc_sx = T_end_forc_sx(1:3,4);

% Matrice Trasformazione Offset Piedino Forcella
v_trasl = [FootOffset; 0; 0];

T_foot_dx = T_end_forc_dx * T_tr(dir * v_trasl);
T_foot_sx = T_end_forc_sx * T_tr(dir * v_trasl);

p_foot_dx = T_foot_dx(1:3,4);
p_foot_sx = T_foot_sx(1:3,4);

% Centro Ruota anteriore

delta = dot(p_foot_sx - p_foot_dx, T_foot_dx(1:3,2));  % Calcola la distanza lungo l'asse y tra i due punti

p_centro_ant = p_foot_dx + 0.5 * delta * T_foot_dx(1:3,2);  % Trova il punto centrale lungo l'asse y

% Costruisci la matrice T_centro_ant con stesso orientamento e nuova origine
T_centro_ant = T_foot_dx;
T_centro_ant(1:3,4) = p_centro_ant;



%% === [ CLEANUP - KEEP ONLY TRANSFORM MATRICES AND POINTS ] ===

vars = whos;
to_keep = {};

% Cicla su tutte le variabili nel workspace
for k = 1:length(vars)
    var_name = vars(k).name;
    if startsWith(var_name, 'T_') || startsWith(var_name, 'p_')
        to_keep{end+1} = var_name; %#ok<AGROW>
    end
end

% Costruisci il comando "clear" con le variabili da mantenere escluse
all_vars = {vars.name};
to_clear = setdiff(all_vars, to_keep);

% Cancella tutte le altre variabili
clear(to_clear{:})
toc


