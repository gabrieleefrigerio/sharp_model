function fork_forces_compare(app,Spring1, Spring2, Spring3)
% fork_forces_compare
% -------------------------------------------------------------------------
% Computes and plots the spring force contributions for three different
% motorcycle fork setups. Also generates a table comparing their total
% forces across displacements.
%
% INPUTS:
%   Spring1, Spring2, Spring3 : structs with parameters
%       .k_main     - main spring stiffness [kg/mm]
%       .preload    - preload compression [mm]
%       .k_top      - top-out spring stiffness [kg/mm]
%       .top_travel - maximum travel of top-out spring [mm]
%       .fork_angle - fork inclination [deg]
%       .stroke     - maximum travel displacement [mm]
%
%       % Air spring parameters
%       .useAir     - true/false, include air spring contribution
%       .air_gap    - initial air gap length [mm]
%       .dia_air    - piston diameter of air chamber [mm]
%       .h_air      - initial height of air chamber [mm]
%
%       % Gas spring parameters
%       .useGas     - true/false, include gas spring contribution
%       .p_gas0     - initial gas pressure [bar or kg/cm^2 eq.]
%       .dia_cart   - cartridge piston diameter [mm]
%       .dia_gas    - gas chamber diameter [mm]
%       .h_gas      - initial gas chamber height [mm]
%
% OUTPUT:
%   - 3 figures: detailed force contributions for each spring setup
%   - 1 figure: comparison of total fork forces of the three springs
%   - Table in MATLAB workspace: stroke vs. 3 total forces
%
%
% AUTHOR:
%   Antonio Filianoti

%mettere if che annulla uno Spring se i dati non sono validi
s1 = 1;
s2 = 1;
s3 = 1;
if Spring1.stroke < 0.5 || ((isfield(Spring1,'useAir') && Spring1.useAir) && ((Spring1.air_gap + Spring1.stroke - 1.4 * Spring1.stroke) <= 0)) || ((isfield(Spring1,'useGas') && Spring1.useGas) && ((((pi * (Spring1.dia_gas/2)^2 / 100) * Spring1.h_gas) - (pi * (Spring1.dia_cart/2)^2 / 100) * Spring1.stroke) <= 0))
        s1 = 0;
end
if Spring2.stroke < 0.5 || ((isfield(Spring2,'useAir') && Spring2.useAir) && ((Spring2.air_gap + Spring2.stroke - 1.4 * Spring2.stroke) <= 0)) || ((isfield(Spring2,'useGas') && Spring2.useGas) && ((((pi * (Spring2.dia_gas/2)^2 / 100) * Spring2.h_gas) - (pi * (Spring2.dia_cart/2)^2 / 100) * Spring2.stroke) <= 0))
        s2 = 0;
end
if Spring3.stroke < 0.5 || ((isfield(Spring3,'useAir') && Spring3.useAir) && ((Spring3.air_gap + Spring3.stroke - 1.4 * Spring3.stroke) <= 0)) || ((isfield(Spring3,'useGas') && Spring3.useGas) && ((((pi * (Spring3.dia_gas/2)^2 / 100) * Spring3.h_gas) - (pi * (Spring3.dia_cart/2)^2 / 100) * Spring3.stroke) <= 0))
        s3 = 0;
end


% -------------------------------------------------------------------------
% Compute forces for each spring
if s1
[Stroke1, F_total1, F_main1, F_top1, F_air1, F_gas1] = compute_forces(Spring1);
end
if s2
[Stroke2, F_total2, F_main2, F_top2, F_air2, F_gas2] = compute_forces(Spring2);
end
if s3
[Stroke3, F_total3, F_main3, F_top3, F_air3, F_gas3] = compute_forces(Spring3);
end

% Plot contributions for each spring
% plot_contributions(Stroke1, F_main1, F_top1, F_air1, F_gas1, F_total1, 'Spring 1');
% plot_contributions(Stroke2, F_main2, F_top2, F_air2, F_gas2, F_total2, 'Spring 2');
% plot_contributions(Stroke3, F_main3, F_top3, F_air3, F_gas3, F_total3, 'Spring 3');


% --- Create tables with contributions for each spring ---
if s1
Spring1Table = table(Stroke1(:), F_main1(:), F_top1(:), F_air1(:), F_gas1(:), F_total1(:), ...
    'VariableNames', {'Stroke [mm]','Main Spring [N]','Top-Out [N]','Air [N]','Gas [N]','Total Force [N]'});
app.UITable7_10.Data = Spring1Table;
app.UITable7_10.ColumnName = {'Stroke [mm]','Main Spring [N]','Top-Out [N]','Air [N]','Gas [N]','Total Force [N]'};
end
if s2
Spring2Table = table(Stroke2(:), F_main2(:), F_top2(:), F_air2(:), F_gas2(:), F_total2(:), ...
    'VariableNames', {'Stroke [mm]','Main Spring [N]','Top-Out [N]','Air [N]','Gas [N]','Total Force [N]'});
app.UITable7_11.Data = Spring2Table;
app.UITable7_11.ColumnName = {'Stroke [mm]','Main Spring [N]','Top-Out [N]','Air [N]','Gas [N]','Total Force [N]'};
end
if s3
Spring3Table = table(Stroke3(:), F_main3(:), F_top3(:), F_air3(:), F_gas3(:), F_total3(:), ...
    'VariableNames', {'Stroke [mm]','Main Spring [N]','Top-Out [N]','Air [N]','Gas [N]','Total Force [N]'});
app.UITable7_12.Data = Spring3Table;
app.UITable7_12.ColumnName =  {'Stroke [mm]','Main Spring [N]','Top-Out [N]','Air [N]','Gas [N]','Total Force [N]'};
end

% --- Create a common stroke grid for comparison ---
Stroke_common = 0:max([Spring1.stroke, Spring2.stroke, Spring3.stroke]);

if s1 && s2 && s3
    Stroke_common = 0:max([Spring1.stroke, Spring2.stroke, Spring3.stroke]);
elseif s1 && s2 && ~s3
    Stroke_common = 0:max([Spring1.stroke, Spring2.stroke]);
elseif s1 && ~s2 && s3
    Stroke_common = 0:max([Spring1.stroke, Spring3.stroke]);
elseif ~s1 && s2 && s3
    Stroke_common = 0:max([Spring2.stroke, Spring3.stroke]);
elseif s1 && ~s2 && ~s3
    Stroke_common = 0:max([Spring1.stroke]);
elseif ~s1 && ~s2 && s3
    Stroke_common = 0:max([Spring3.stroke]);
elseif ~s1 && s2 && ~s3
    Stroke_common = 0:max([Spring2.stroke]);
end

if s1
F_total1c = interp1(Stroke1, F_total1, Stroke_common, 'linear', NaN);
end
if s2
F_total2c = interp1(Stroke2, F_total2, Stroke_common, 'linear', NaN);
end
if s3
F_total3c = interp1(Stroke3, F_total3, Stroke_common, 'linear', NaN);
end

% Plot comparison of total forces
cla(app.UIAxes2_16);
hold(app.UIAxes2_16,"on");
if s1
plot(app.UIAxes2_16,Stroke_common, F_total1c, 'b-', 'LineWidth', 2);
end
if s2
plot(app.UIAxes2_16,Stroke_common, F_total2c, 'r-', 'LineWidth', 2);
end
if s3
plot(app.UIAxes2_16,Stroke_common, F_total3c, 'g-', 'LineWidth', 2);
end
if s1 && s2 && s3
    legend(app.UIAxes2_16,{'Spring 1','Spring 2','Spring 3'}, 'Location','NorthWest');
elseif s1 && s2 && ~s3
    legend(app.UIAxes2_16,{'Spring 1','Spring 2'}, 'Location','NorthWest');
elseif s1 && ~s2 && s3
    legend(app.UIAxes2_16,{'Spring 1','Spring 3'}, 'Location','NorthWest');
elseif ~s1 && s2 && s3
    legend(app.UIAxes2_16,{'Spring 2','Spring 3'}, 'Location','NorthWest');
elseif s1 && ~s2 && ~s3
    legend(app.UIAxes2_16,{'Spring 1'}, 'Location','NorthWest');
elseif ~s1 && ~s2 && s3
    legend(app.UIAxes2_16,{'Spring 3'}, 'Location','NorthWest');
elseif ~s1 && s2 && ~s3
    legend(app.UIAxes2_16,{'Spring 2'}, 'Location','NorthWest');
end
hold(app.UIAxes2_16,"off");

% --- Create comparison table (total forces + deltas) ---
if s1 && s2 && s3
    ForceTable = table(Stroke_common(:), ...
    F_total1c(:), F_total2c(:), F_total3c(:), ...
    F_total1c(:) - F_total2c(:), ...
    F_total1c(:) - F_total3c(:), ...
    F_total2c(:) - F_total3c(:), ...
    'VariableNames', {'Stroke [mm]', ...
    'Total Spring 1 [N]','Total Spring 2 [N]','Total Spring 3 [N]', ...
    'Delta 1-2 [N]','Delta 1-3 [N]','Delta 2-3 [N]'});

    app.UITable7_9.Data = ForceTable;
    app.UITable7_9.ColumnName = {'Stroke [mm]', ...
    'Total Spring 1 [N]','Total Spring 2 [N]','Total Spring 3 [N]', ...
    'Delta 1-2 [N]','Delta 1-3 [N]','Delta 2-3 [N]'};
elseif s1 && s2 && ~s3
    ForceTable = table(Stroke_common(:), ...
    F_total1c(:), F_total2c(:), ...
    F_total1c(:) - F_total2c(:), ...
    'VariableNames', {'Stroke [mm]', ...
    'Total Spring 1 [N]','Total Spring 2 [N]', ...
    'Delta 1-2 [N]'});

    app.UITable7_9.Data = ForceTable;
    app.UITable7_9.ColumnName = {'Stroke [mm]', ...
    'Total Spring 1 [N]','Total Spring 2 [N]', ...
    'Delta 1-2 [N]'};
elseif s1 && ~s2 && s3
    ForceTable = table(Stroke_common(:), ...
    F_total1c(:),F_total3c(:), ...
    F_total1c(:) - F_total3c(:), ...
    'VariableNames', {'Stroke [mm]', ...
    'Total Spring 1 [N]','Total Spring 3 [N]', ...
    'Delta 1-3 [N]'});

app.UITable7_9.Data = ForceTable;
app.UITable7_9.ColumnName = {'Stroke [mm]', ...
    'Total Spring 1 [N]','Total Spring 3 [N]', ...
    'Delta 1-3 [N]'};
elseif ~s1 && s2 && s3
    ForceTable = table(Stroke_common(:), ...
    F_total2c(:), F_total3c(:), ...
    F_total2c(:) - F_total3c(:), ...
    'VariableNames', {'Stroke [mm]', ...
    'Total Spring 2 [N]','Total Spring 3 [N]', ...
    'Delta 2-3 [N]'});

app.UITable7_9.Data = ForceTable;
app.UITable7_9.ColumnName = {'Stroke [mm]', ...
    'Total Spring 2 [N]','Total Spring 3 [N]', ...
    'Delta 2-3 [N]'};
elseif s1 && ~s2 && ~s3
    app.UITable7_9.Data = [];
    app.UITable7_9.ColumnName = {};
elseif ~s1 && ~s2 && s3
    app.UITable7_9.Data = [];
    app.UITable7_9.ColumnName = {};
elseif ~s1 && s2 && ~s3
    app.UITable7_9.Data = [];
    app.UITable7_9.ColumnName = {};
end





end





%% Helper function: compute forces
function [Stroke, F_total, F_main, F_top, F_air, F_gas] = compute_forces(S)
    Stroke = 0:0.5:S.stroke;

    % Main spring
    F_main = S.k_main .* (Stroke + S.preload);

    % Top-out spring
    if isfield(S,'use_top_out') && S.use_top_out
        engaged = Stroke < S.top_travel;
        F_top = zeros(size(Stroke));
        F_top(engaged) = -S.k_top .* (S.top_travel - Stroke(engaged));
    else 
        F_top = zeros(size(Stroke));
    end

    % ---------------------------
    % Air spring (formula corretta)
    % ---------------------------
    F_air = zeros(size(Stroke));
    if isfield(S,'useAir') && S.useAir
        A_air = pi * (S.dia_air/2)^2 / 100;   % area [cm^2]
        V0_air = S.air_gap + S.stroke;        % volume iniziale equivalente [mm]
        gamma = 1.4;

        % Forza aria (derivata dalla formula Excel corretta)
        F_air = A_air .* ( (1 ./ (1 - gamma * (Stroke ./ V0_air))) - 1 );
    end

    % ---------------------------
    % Gas spring (formula corretta)
    % ---------------------------
    F_gas = zeros(size(Stroke));
    if isfield(S,'useGas') && S.useGas
        A_cart = pi * (S.dia_cart/2)^2 / 100;   % area pistone cartuccia [cm^2]
        A_gas  = pi * (S.dia_gas/2)^2 / 100;    % area camera gas [cm^2]
        V0_gas = A_gas * S.h_gas;               % volume iniziale gas [mm*cm^2]
        gamma  = 1.4;

        % Forza gas (formula politropica corretta)
        F_gas = A_cart .* ( S.p_gas0 .* ( 1 ./ (1 - (A_cart .* Stroke) ./ V0_gas) ).^gamma - 1 );
    end

    % ---------------------------
    % Total projected force (con angolo forcella)
    % ---------------------------
    F_total = (F_main + F_top + F_air + F_gas) .* cosd(S.fork_angle);
end



%% Helper function: plot contributions
function plot_contributions(Stroke, F_main, F_top, F_air, F_gas, F_total, labelStr)
    figure; hold on;
    plot(Stroke, F_main, 'b-', 'LineWidth', 1.5);
    plot(Stroke, F_top, 'm-', 'LineWidth', 1.5);
    if any(F_air), plot(Stroke, F_air, 'r-', 'LineWidth', 1.5); end
    if any(F_gas), plot(Stroke, F_gas, 'g-', 'LineWidth', 1.5); end
    plot(Stroke, F_total, 'k--', 'LineWidth', 2);

    xlabel('Fork stroke [mm]');
    ylabel('Force [Kg]');
    legendEntries = {'Main spring','Top-out spring'};
    if any(F_air), legendEntries{end+1} = 'Air spring'; end
    if any(F_gas), legendEntries{end+1} = 'Gas spring'; end
    legendEntries{end+1} = 'Total projected force';
    legend(legendEntries, 'Location','NorthWest');

    grid on; grid minor;
    title(['Force Contributions - ' labelStr]);
end
