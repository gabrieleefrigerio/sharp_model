function [data] = computeData(P,Bike, Output)
    %% PARAMETRI
    data = struct();
    % Mass
    % data.Mf = 2.1; % mass front part
    % data.Mr = 14.9;
    % data.Ifx = 1;
    % data.Ifz = 1;
    % data.Irx = 23;
    % data.Irz = 15.54;
    % data.Ify = 0.53;
    % data.Iry = 0.775;
    % data.Crxz = 1.28;
    
    % Geometrical Parameters
    data.k = P.COG_front_assembl(1)-P.COG_rear_assembl(1);
    data.e = Bike.offset_e;
    data.j = P.COG_front_assembl(3);
    data.h = P.COG_rear_assembl(3);
    data.epsilon = Output.caster_angle;
    data.l =  Output.Wheelbase - P.COG_rear_assembl(1);
    data.b = P.COG_rear_assembl(1);
    data.Rr = Bike.Wheels.RearSize;
    data.Rf = Bike.Wheels.FrontSize;
    data.t = Output.NormalTrail;
    % 
    % % Tires
    % data.sigmaf = 0.8;
    % data.sigmar = 0.8;
    % data.Cf1 = 2512;
    % data.Cf2 = 211;
    % data.Cr1 = 3559;
    % data.Cr2 = 298;
    % % gravity acceleration
    % data.g = 9.81;
    % % steering damper
    % data.K = 5;
end