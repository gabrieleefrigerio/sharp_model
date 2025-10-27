function rear_shock_forces_compare(app,Shock1, Shock2, Shock3)
% rear_shock_forces_compare
% -------------------------------------------------------------------------
% This function compares the force contributions of three rear shocks.
%
% INPUT:
%   Shock1, Shock2, Shock3 : structs containing the parameters of each rear
%   shock absorber. Each struct must include:
%       - spring.stiff    : spring stiffness [N/mm]
%       - spring.preload  : spring preload [mm]
%       - spring.dwgstrk  : drawing stroke, i.e., effective working stroke [mm]
%       - intElem.strk    : maximum available travel [mm]
%       - intElem.gasRoom : [diameter, length] of gas chamber [mm]
%       - intElem.pistRod : piston rod diameter [mm]
%       - intElem.gasPress: initial gas pressure [bar]
%       - use_top_out     : boolean, whether top-out spring is active
%       - topOut.stiff    : stiffness of the top-out spring [N/mm]
%       - topOut.strk     : stroke length for top-out effect [mm]
%       - use_gas         : boolean, whether gas spring effect is active
%       - use_rubber      : boolean, whether bump rubber is active
%
% OUTPUT:
%   - A plot comparing the total force vs. stroke for the three shocks
%   - A table comparing total forces across shocks at common stroke values
%   - A detailed table for each shock, listing contributions:
%         * Spring force
%         * Top-out force
%         * Gas force
%         * Rubber force
%         * Total force
%
% VARIABLES USED:
%   Stroke1, Stroke2, Stroke3 : stroke vectors [mm] for each shock
%   Stroke_common             : common stroke vector used for comparison
%   F_springX                 : spring force [N] (X = 1,2,3 for each shock)
%   F_topX                    : top-out force [N]
%   F_gasX                    : gas spring force [N]
%   F_rubberX                 : bump rubber force [N]
%   F_totalX                  : total force [N], sum of all contributions
%   F_totalXc                 : interpolated total forces over Stroke_common
%   ForceTable                : table comparing total forces between shocks
%   ShockXTable               : table listing separate force contributions
%                               for each shock
%
% Author: Antonio Filianoti
% -------------------------------------------------------------------------

%mettere if che annulla uno shock se i dati non sono validi
s1 = 1;
s2 = 1;
s3 = 1;

% IMPORTANTE PER MODIFICHE FUTURE. IL 15 NELLE CONDIZIONI è IL MAX DEL LUT PRIMA COL
if Shock1.spring.dwgstrk < 0 || Shock1.intElem.strk < 1 || (((pi * (Shock1.intElem.gasRoom(1)/2)^2 * Shock1.intElem.gasRoom(2) - pi * (Shock1.intElem.pistRod/2)^2 * Shock1.intElem.strk) <= 0) && (isfield(Shock1, 'use_gas') && Shock1.use_gas)) || ((isfield(Shock1, 'use_rubber') && Shock1.use_rubber) && (Shock1.intElem.strk > (Shock1.intElem.strk - 15) + 15))
        s1 = 0;
end
if Shock2.spring.dwgstrk < 0 || Shock2.intElem.strk < 1 || (((pi * (Shock2.intElem.gasRoom(1)/2)^2 * Shock2.intElem.gasRoom(2) - pi * (Shock2.intElem.pistRod/2)^2 * Shock2.intElem.strk) <= 0) && (isfield(Shock2, 'use_gas') && Shock2.use_gas)) || ((isfield(Shock2, 'use_rubber') && Shock2.use_rubber) && (Shock2.intElem.strk > (Shock2.intElem.strk - 15) + 15))
        s2 = 0;
end
if Shock3.spring.dwgstrk < 0 || Shock3.intElem.strk < 1 || (((pi * (Shock3.intElem.gasRoom(1)/2)^2 * Shock3.intElem.gasRoom(2) - pi * (Shock3.intElem.pistRod/2)^2 * Shock3.intElem.strk) <= 0) && (isfield(Shock3, 'use_gas') && Shock3.use_gas)) || ((isfield(Shock3, 'use_rubber') && Shock3.use_rubber) && (Shock3.intElem.strk > (Shock3.intElem.strk - 15) + 15))
        s3 = 0;
end





%% --- Compute forces for each shock ---
if s1
    [Stroke1, F_total1, F_spring1, F_top1, F_gas1, F_rubber1] = compute_shock_forces(Shock1);
end
if s2
    [Stroke2, F_total2, F_spring2, F_top2, F_gas2, F_rubber2] = compute_shock_forces(Shock2);
end
if s3
    [Stroke3, F_total3, F_spring3, F_top3, F_gas3, F_rubber3] = compute_shock_forces(Shock3);
end


%% --- Plot contributions for each shock (optional, commented) ---
% plot_contributions(Stroke1, F_spring1, F_top1, F_gas1, F_rubber1, F_total1, 'Shock 1', Shock1.spring.dwgstrk);
% plot_contributions(Stroke2, F_spring2, F_top2, F_gas2, F_rubber2, F_total2, 'Shock 2', Shock2.spring.dwgstrk);
% plot_contributions(Stroke3, F_spring3, F_top3, F_gas3, F_rubber3, F_total3, 'Shock 3', Shock3.spring.dwgstrk);

%% --- Define a common stroke vector for comparison ---
if s1 && s2 && s3
    Stroke_common = 0:max([Shock1.spring.dwgstrk, Shock2.spring.dwgstrk, Shock3.spring.dwgstrk]);
elseif s1 && s2 && ~s3
    Stroke_common = 0:max([Shock1.spring.dwgstrk, Shock2.spring.dwgstrk]);
elseif s1 && ~s2 && s3
    Stroke_common = 0:max([Shock1.spring.dwgstrk, Shock3.spring.dwgstrk]);
elseif ~s1 && s2 && s3
    Stroke_common = 0:max([Shock2.spring.dwgstrk, Shock3.spring.dwgstrk]);
elseif s1 && ~s2 && ~s3
    Stroke_common = 0:max([Shock1.spring.dwgstrk]);
elseif ~s1 && ~s2 && s3
    Stroke_common = 0:max([Shock3.spring.dwgstrk]);
elseif ~s1 && s2 && ~s3
    Stroke_common = 0:max([Shock2.spring.dwgstrk]);
end


% Interpolate each total force curve onto the common stroke
if s1
F_total1c = interp1(Stroke1, F_total1, Stroke_common, 'linear', NaN);
end
if s2
F_total2c = interp1(Stroke2, F_total2, Stroke_common, 'linear', NaN);
end
if s3
F_total3c = interp1(Stroke3, F_total3, Stroke_common, 'linear', NaN);
end

%% --- Plot comparison of total shock forces ---
cla(app.UIAxes2_15);
hold(app.UIAxes2_15,"on");
if s1
plot(app.UIAxes2_15,Stroke_common, F_total1c, 'r-', 'LineWidth', 2);
end
if s2
plot(app.UIAxes2_15,Stroke_common, F_total2c, 'b-', 'LineWidth', 2);
end
if s3
plot(app.UIAxes2_15,Stroke_common, F_total3c, 'k-', 'LineWidth', 2);
end

if s1 && s2 && s3
    legend(app.UIAxes2_15,{'Shock 1','Shock 2','Shock 3'}, 'Location','NorthWest');
elseif s1 && s2 && ~s3
    legend(app.UIAxes2_15,{'Shock 1','Shock 2'}, 'Location','NorthWest');
elseif s1 && ~s2 && s3
    legend(app.UIAxes2_15,{'Shock 1','Shock 3'}, 'Location','NorthWest');
elseif ~s1 && s2 && s3
    legend(app.UIAxes2_15,{'Shock 2','Shock 3'}, 'Location','NorthWest');
elseif s1 && ~s2 && ~s3
    legend(app.UIAxes2_15,{'Shock 1'}, 'Location','NorthWest');
elseif ~s1 && ~s2 && s3
    legend(app.UIAxes2_15,{'Shock 3'}, 'Location','NorthWest');
elseif ~s1 && s2 && ~s3
    legend(app.UIAxes2_15,{'Shock 2'}, 'Location','NorthWest');
end

hold(app.UIAxes2_15,"off");

%% --- Create comparison table for total forces ---
if s1 && s2 && s3
    ForceTable = table(Stroke_common(:), ...
    F_total1c(:), F_total2c(:), F_total3c(:), ...
    F_total1c(:)-F_total2c(:), ...
    F_total1c(:)-F_total3c(:), ...
    F_total2c(:)-F_total3c(:), ...
    'VariableNames', {'Stroke [mm]','Total Shock 1 [N]','Total Shock 2 [N]','Total Shock 3 [N]', ...
    'Delta 1-2 [N]','Delta 1-3 [N]','Delta 2-3 [N]'});

    app.UITable7.Data = ForceTable;
    app.UITable7.ColumnName = {'Stroke [mm[','Total Shock 1 [N]','Total Shock 2 [N]','Total Shock 3 [N]','Delta 1-2 [N]','Delta 1-3 [N]','Delta 2-3 [N]'};

elseif s1 && s2 && ~s3
    ForceTable = table(Stroke_common(:), ...
    F_total1c(:), F_total2c(:),  ...
    F_total1c(:)-F_total2c(:), ...
    'VariableNames', {'Stroke [mm]','Total Shock 1 [N]','Total Shock 2 [N]', ...
    'Delta 1-2 [N]'});

    app.UITable7.Data = ForceTable;
    app.UITable7.ColumnName = {'Stroke [mm]','Total Shock 1 [N]','Total Shock 2 [N]', ...
    'Delta 1-2 [N]'};
elseif s1 && ~s2 && s3
    ForceTable = table(Stroke_common(:), ...
    F_total1c(:), F_total3c(:), ...
    F_total1c(:)-F_total3c(:), ...
    'VariableNames', {'Stroke [mm]','Total Shock 1 [N]','Total Shock 3 [N]', ...
    'Delta 1-3 [N]'});

    app.UITable7.Data = ForceTable;
    app.UITable7.ColumnName = {'Stroke [mm]','Total Shock 1 [N]','Total Shock 3 [N]', ...
    'Delta 1-3 [N]'};
elseif ~s1 && s2 && s3
    ForceTable = table(Stroke_common(:), ...
    F_total2c(:), F_total3c(:), ...
    F_total2c(:)-F_total3c(:), ...
    'VariableNames', {'Stroke [mm]','Total Shock 2 [N]','Total Shock 3 [N]', ...
    'Delta 2-3 [N]'});

    app.UITable7.Data = ForceTable;
    app.UITable7.ColumnName = {'Stroke [mm]','Total Shock 2 [N]','Total Shock 3 [N]', ...
    'Delta 2-3 [N]'};
elseif s1 && ~s2 && ~s3
    app.UITable7.Data = [];
    app.UITable7.ColumnName = {};
elseif ~s1 && ~s2 && s3
    app.UITable7.Data = [];
    app.UITable7.ColumnName = {};
elseif ~s1 && s2 && ~s3
    app.UITable7.Data = [];
    app.UITable7.ColumnName = {};
end



%% --- Create tables of force contributions for each shock ---
if s1
    Shock1Table = table(Stroke1(:), F_spring1(:), F_top1(:), F_gas1(:), F_rubber1(:), F_total1(:), ...
        'VariableNames', {'Stroke [mm]','Spring [N]','TopOut [N]','Gas [N]','Rubber [N]','Total [N]'});
    app.UITable7_2.Data = Shock1Table;
    app.UITable7_2.ColumnName = {'Stroke [mm]','Spring [N]','TopOut [N]','Gas [N]','Rubber [N]','Total [N]'};
else
    app.UITable7_2.Data = [];
    app.UITable7_2.ColumnName = {};
end

if s2
Shock2Table = table(Stroke2(:), F_spring2(:), F_top2(:), F_gas2(:), F_rubber2(:), F_total2(:), ...
    'VariableNames', {'Stroke [mm]','Spring [N]','TopOut [N]','Gas [N]','Rubber [N]','Total [N]'});
app.UITable7_3.Data = Shock2Table;
app.UITable7_3.ColumnName = {'Stroke [mm]','Spring [N]','TopOut [N]','Gas [N]','Rubber [N]','Total [N]'};
else
    app.UITable7_3.Data = [];
    app.UITable7_3.ColumnName = {};

end

if s3
Shock3Table = table(Stroke3(:), F_spring3(:), F_top3(:), F_gas3(:), F_rubber3(:), F_total3(:), ...
    'VariableNames', {'Stroke [mm]','Spring','TopOut','Gas','Rubber','Total'});
app.UITable7_4.Data = Shock3Table;
app.UITable7_4.ColumnName = {'Stroke [mm]','Spring [N]','TopOut [N]','Gas [N]','Rubber [N]','Total [N]'};
else
    app.UITable7_4.Data = [];
    app.UITable7_4.ColumnName = {};
end

end


%% compute forces
function [Stroke, F_total, F_spring, F_top, F_gas, F_rubber] = compute_shock_forces(S)
    travel = S.intElem.strk;
    Stroke_full = (0:travel)';   % compressione
    
    % --- Forze elastiche ---
    % Molla principale
    F_spring = S.spring.stiff .* (S.spring.preload + Stroke_full);
    
    % Top-out
    if S.use_top_out
        F_top = S.topOut.stiff .* (Stroke_full - S.topOut.strk);
        F_top(F_top > 0) = 0;   % solo trazione
    else
        F_top = zeros(1,length(Stroke_full));
    end
    
    % --- Gas (formula corretta con legge di Boyle) ---
    if S.use_gas 
        A_gas = pi * (S.intElem.gasRoom(1)/2)^2;
        A_rod = pi * (S.intElem.pistRod/2)^2;
        V0    = A_gas * S.intElem.gasRoom(2);
        P0    = S.intElem.gasPress;
        
        V = V0 - A_rod .* Stroke_full;
        F_gas = P0 .* (V0 ./ V) .* A_rod ./ 10;   % diviso 10 per bar->N/mm²
    else 
        F_gas = zeros(1,length(Stroke_full));
    end
        
    % --- Gommino (nuova LUT solo nella parte finale della corsa) ---
    rubberLUT = [...
        0	0
        1	10.8
        2	134.3
        3	307.9
        4	556.9
        5	796.1
        6	945.2
        7	1204
        8	1411.9
        9	1639.4
        10	1835.5
        11	2249.3
        12	2698.5
        13	3204.6
        14	4205
        15	6325.3];
    if S.use_rubber
        F_rubber = zeros(size(Stroke_full));
        max_def = max(rubberLUT(:,1));
        idx = Stroke_full >= (travel - max_def);
        comp = Stroke_full(idx) - (travel - max_def);
        F_rubber(idx) = interp1(rubberLUT(:,1), rubberLUT(:,2), comp, 'linear', 'extrap');
    else
        F_rubber = zeros(1,length(Stroke_full));
    end
    
    % --- Totale ---
    F_total = F_spring + F_top + F_gas + F_rubber;
    
    % --- Output tagliato al diagram stroke ---
    if isfield(S.spring, 'dwgstrk')
        dwg = min(S.spring.dwgstrk, travel);
    else
        dwg = travel;
    end
    
    Stroke   = Stroke_full(1:dwg+1);
    F_spring = F_spring(1:dwg+1);
    F_top    = F_top(1:dwg+1);
    F_gas    = F_gas(1:dwg+1);
    F_rubber = F_rubber(1:dwg+1);
    F_total  = F_total(1:dwg+1);
end

%% plot
function plot_contributions(Stroke, F_spring, F_top, F_gas, F_rubber, F_total, labelStr, dwgstrk)
    idx_max  = min(dwgstrk+1, length(Stroke));
    Stroke   = Stroke(1:idx_max);
    F_spring = F_spring(1:idx_max);
    F_top    = F_top(1:idx_max);
    F_gas    = F_gas(1:idx_max);
    F_rubber = F_rubber(1:idx_max);
    F_total  = F_total(1:idx_max);

    figure; hold on;
    plot(Stroke, F_spring, 'b-', 'LineWidth', 1.5);
    plot(Stroke, F_top,    'm-', 'LineWidth', 1.5);
    plot(Stroke, F_gas,    'g-', 'LineWidth', 1.5);
    plot(Stroke, F_rubber, 'c-', 'LineWidth', 1.5);
    plot(Stroke, F_total,  'k--','LineWidth', 2);

    title(['Contributi di forza - ' labelStr], 'FontWeight','bold');
    xlabel('Compressione [mm]');
    ylabel('Forza [N]');
    legend({'Molla','Top-out','Gas','Gommino','Totale'}, 'Location','NorthWest');
    grid on; grid minor;
    axis tight;
    hold off;
end
