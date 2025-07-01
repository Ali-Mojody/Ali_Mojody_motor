clc; clear;close all

% ثوابت پایه
R = 8.31;     % ثابت گازها (J/mol·K)
dt = 0.00002;   % زمان ماند (s)

%ثابت های واکنش 
A = 1.8e8;    % پیش‌نمایی واکنش 1
Ea1 = 3.19e5; % انرژی فعال‌سازی 1
Ea2 = 3.9e4;  % انرژی فعال‌سازی 2

% [نوع سیکل, دما(K), فشار(Pa)]
data = {
    'Diesel',   2245,  4e6;
    'Otto',     2799,  1.2e7;
    'Dual',     1724,  8e6;
    'Atk',      2799,  1.2e7
};

% تیتر جدول
fprintf('Type\t\tT(K)\tP(bar)\tRate(mol/m³·s)\tNO(ppm)\n');
fprintf('-------------------------------------------------------------\n');

for j = 1:size(data,1)
    typ = data{j,1};
    T = data{j,2};
    P = data{j,3};

    % چگالی مخلوط (mol/m³)
    C = P / (R*T);

    % غلظت نسبی گازها
    O2 = 0.21*C; N2 = 0.78*C;
    O = 1e-4*C;  N = 1e-6*C;

    % واکنش‌ها
    A2 = 1.8e4 * T;
    k1 = A * exp(-Ea1 / (R*T));
    k2 = A2 * exp(-Ea2 / (R*T));

    % نرخ تولید NO
    rNO = k1*N2*O + k2*N*O2;
    NO = rNO * dt;
    ppm = (NO / C) * 1e6;

    % چاپ نتیجه
    fprintf('%-8s\t%.1f\t%.1f\t%.2e\t%.1f\n', typ, T, P/1e5, rNO, ppm);
end
