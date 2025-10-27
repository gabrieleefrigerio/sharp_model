%% ---------------- MODELLO MIO --------------------
%% PARAMETRI
% Mass
Mf = 2.1; % mass front part
Mr = 14.9;
Ifx = 1;
Ifz = 1;
Irx = 23;
Irz = 15.54;
Ify = 0.53;
Iry = 0.775;
Crxz = 1.28;

% Geometrical Parameters
k = 0.05;
e = 0.08;
j = 0.05;
h = 2.02;
epsilon = 0.4715;
l = 0.05;
b = 1.574;
Rr = 1;
Rf = 1;
t = 0.38;

% Tires
sigmaf = 0.8;
sigmar = 0.8;
Cf1 = 2512;
Cf2 = 211;
Cr1 = 3559;
Cr2 = 298;
% graviti acceleration
g = 1;
% steering damper
K = 5;
% Input
vx = 1; % forward speed
Zf = -226; % front tire load

%% MATRICE M

% riga 1
m11 = Mf + Mr;
m12 = Mf * k;
m13 = 0;
m14 = 0;
m15 = Mf * e;
m16 = Mf * j + Mr * h;

% riga 2
m21 = Mf * k;
m22 = Mf * k^2 + Irz + Ifx * sin(epsilon)^2 + Ifz * cos(epsilon)^2;
m23 = 0;
m24 = 0;
m25 = Mf * e * k + Ifz * cos(epsilon);
m26 = Mf * j * k - Crxz + (Ifz - Ifx) * sin(epsilon) * cos(epsilon);

% riga 3
m31 = Mf * j + Mr * h;
m32 = Mf * j * k - Crxz + (Ifz - Ifx) * sin(epsilon) * cos(epsilon);
m33 = 0;
m34 = 0;
m35 = Mf * e * j + Ifz * sin(epsilon);
m36 = Mf * j^2 + Mr * h^2 + Irx + Ifx * cos(epsilon)^2 + Ifz * sin(epsilon)^2;

% riga 4
m41 = Mf * e;
m42 = Mf * e * k + Ifz * cos(epsilon);
m43 = 0;
m44 = 0;
m45 = Ifz + Mf * e^2;
m46 = Mf * e * j + Ifz * sin(epsilon);

% riga 5
m51 = 0;
m52 = 0;
m53 = sigmaf / vx;
m54 = 0;
m55 = 0;
m56 = 0;

% riga 6
m61 = 0;
m62 = 0;
m63 = 0;
m64 = sigmar / vx;
m65 = 0;
m66 = 0;

% Costruzione matrice M
M = [
    m11, m12, m13, m14, m15, m16;
    m21, m22, m23, m24, m25, m26;
    m31, m32, m33, m34, m35, m36;
    m41, m42, m43, m44, m45, m46;
    m51, m52, m53, m54, m55, m56;
    m61, m62, m63, m64, m65, m66
];

%% MATRICE H

% riga 1
h11 = 0;
h12 = (Mf + Mr) * vx;
h13 = -1;
h14 = -1;
h15 = 0;
h16 = 0;

% riga 2
h21 = 0;
h22 = Mf * k * vx;
h23 = -l;
h24 = b;
h25 = -Ify / Rr * sin(epsilon) * vx;
h26 = -(Ify / Rf - Iry / Rr) * vx;

% riga 3
h31 = 0;
h32 = (Mf * j + Mr * h + Ify / Rf + Iry / Rr) * vx;
h33 = 0;
h34 = 0;
h35 = Ify / Rf * cos(epsilon) * vx;
h36 = 0;

% riga 4
h41 = 0;
h42 = (Mf * e + Ify / Rf * sin(epsilon)) * vx;
h43 = t;
h44 = 0;
h45 = K;
h46 = -Ify / Rf * cos(epsilon) * vx;

% riga 5
h51 = -Cf1 / vx;
h52 = -Cf1 * l / vx;
h53 = -1;
h54 = 0;
h55 = Cf1 * t / vx;  % <-- Controllato
h56 = 0;

% riga 6
h61 = Cr1 / vx;
h62 = -Cr1 * b / vx;
h63 = 0;
h64 = 1;
h65 = 0;
h66 = 0;

% Costruzione matrice H
H = [
    h11, h12, h13, h14, h15, h16;
    h21, h22, h23, h24, h25, h26;
    h31, h32, h33, h34, h35, h36;
    h41, h42, h43, h44, h45, h46;
    h51, h52, h53, h54, h55, h56;
    h61, h62, h63, h64, h65, h66
];

%% MATRICE P

% riga 1
p11 = 0;
p12 = 0;

% riga 2
p21 = 0;
p22 = 0;

% riga 3
p31 = t * Zf - Mf * e * g;
p32 = -(Mf * j + Mr * h);

% riga 4 
p41 = t * Zf - Mf * e * g;
p42 = t * Zf - Mf * e * g;

% riga 5
p51 = Cf1 * cos(epsilon) + Cf2 * sin(epsilon);
p52 = Cf2;

% riga 6
p61 = 0;
p62 = -Cr2;

% Costruzione matrice P
P = [
    p11, p12;
    p21, p22;
    p31, p32;
    p41, p42;
    p51, p52;
    p61, p62
];

%% VETTORE G
G = [0; 0; 0; -1; 0; 0];

%% MATRICE S
S = [0, 0, 0, 0, 1, 0;
     0, 0, 0, 0, 0, 1 ];

%% RISCRITTURUA STATE SPACE METODO 1
O = zeros(6,6);
I = eye(6);

A21 = -M^(-1) * P * S;
A22 = -M^(-1) * H ;

A = [O,     I;
     A21, A22];



[V, D] = eig(A)

omega = abs(imag(diag(D)))

f = omega/(2*pi)