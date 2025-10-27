function [datamod, Pmod, Tmod, Outputmod] = GUI_Output_Computation(datamod)
% =========================================================================
% GUI_Output_Computation - Compute updated multibody model outputs.
%
% INPUT:
%   datamod   : struct containing all bike configuration parameters
%               (geometry, suspension, angles, etc.)
%
% OUTPUT:
%   datamod   : updated input struct, possibly modified during computations
%   Pmod      : struct containing 3D coordinates of all key points
%   Tmod      : struct containing all 4x4 homogeneous transformation matrices
%   Outputmod : struct containing final output results (wheelbase, trail,
%               caster angle, etc.)
% =========================================================================

%% Recalculate kinematic closures
% === [ COMPUTE KINEMATIC CLOSURES WITH REGULATIONS ] ===
% This function ensures geometric constraints are satisfied, such as link lengths
[datamod, Pmod] = cinematicClosures(datamod);

%% Compute transformation matrices and key point coordinates
% === [ COMPUTE TRANSFORMATION MATRICES AND COORDINATES ] ===
% This function computes the 4x4 transformation matrices (Tmod) and updates
% the 3D coordinates (Pmod) based on the multibody kinematics
[Tmod, Pmod, datamod] = MultibodyMatrices(datamod, Pmod);

%% Compute output results from the multibody model
% === [ OUTPUT COMPUTATION ] ===
% This function calculates final outputs like wheelbase, trail, caster angle, etc.
[Outputmod,Pmod] = OutputMultibody(Tmod, Pmod, datamod);

end

