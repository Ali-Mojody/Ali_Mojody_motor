clc; clear; close all

% -------------------- داده‌ها --------------------
P1 = 100000; % Pa
T1 = 300;    % K
k = 1.4;
c_v = 718;
c_p = 1005;
q_in1 = 1390723; % J/kg
CR = 14;
ER = 17;

V1 = 1;
V2 = V1 / CR;
n_points = 50;

%% ---------- چرخه آتکینسون ----------
T2 = T1 * CR^(k-1);
P2 = P1 * CR^k;
T3 = T2 + q_in1/c_v;
P3 = P2 * (T3/T2);
T4 = T3 * (1/CR)^(k-1);
P4 = P3 * (1/CR)^k;
T5 = T3 * (1/ER)^(k-1);
P5 = P3 * (1/ER)^k;
T6 = T1 * (ER/CR);
P6 = P1 * (ER/CR)^(-k);

V5 = V1 * ER / CR;

V_12 = linspace(V1, V2, n_points) / V1;
P_12 = P1 * (V1 ./ (V_12 * V1)).^k / 1e5;

V_23 = (V2 / V1) * ones(1, n_points);
P_23 = linspace(P2, P3, n_points) / 1e5;

V_35 = linspace(V2, V5, n_points) / V1;
P_35 = P3 * (V2 ./ (V_35 * V1)).^k / 1e5;

V_56 = (V5 / V1) * ones(1, n_points);
P_56 = linspace(P5, P6, n_points) / 1e5;

V_61 = linspace(V5, V1, n_points) / V1;
P_61 = P6 * ones(1, n_points) / 1e5;

%% ---------- چرخه دوآل ----------
P2 = P1 * CR^k;
T2 = T1 * CR^(k-1);
P3 = 2 * P2;
T3 = T2 * 2;
V3 = V2;
stroke = V1 - V2;
V4 = V3 + 0.05 * stroke;
T4 = T3 * (V4/V3);
P4 = P3;
V5 = V1;
P5 = P4 * (V4/V5)^k;

V_12_dual = linspace(V1, V2, n_points) / V1;
P_12_dual = P1 * (V1 ./ (V_12_dual * V1)).^k / 1e5;

V_23_dual = (V2 / V1) * ones(1, n_points);
P_23_dual = linspace(P2, P3, n_points) / 1e5;

V_34_dual = linspace(V3, V4, n_points) / V1;
P_34_dual = P3 * ones(1, n_points) / 1e5;

V_45_dual = linspace(V4, V5, n_points) / V1;
P_45_dual = P4 * (V4 ./ (V_45_dual * V1)).^k / 1e5;

V_51_dual = ones(1, n_points);
P_51_dual = linspace(P5, P1, n_points) / 1e5;

V_dual = [V_12_dual V_23_dual V_34_dual V_45_dual V_51_dual];
P_dual = [P_12_dual P_23_dual P_34_dual P_45_dual P_51_dual];

%% ---------- چرخه اتو ----------
T2_ot = T1 * CR^(k - 1);
P2_ot = P1 * CR^k;
T3_ot = T2_ot + q_in1 / c_v;
P3_ot = P2_ot * (T3_ot / T2_ot);
P4_ot = P3_ot * (1/CR)^k;

V_12_ot = linspace(V1, V2, n_points) / V1;
P_12_ot = P1 * (V1 ./ (V_12_ot * V1)).^k / 1e5;

V_23_ot = (V2 / V1) * ones(1, n_points);
P_23_ot = linspace(P2_ot, P3_ot, n_points) / 1e5;

V_34_ot = linspace(V2, V1, n_points) / V1;
P_34_ot = P3_ot * (V2 ./ (V_34_ot * V1)).^k / 1e5;

V_41_ot = ones(1, n_points);
P_41_ot = linspace(P4_ot, P1, n_points) / 1e5;

V_otto = [V_12_ot V_23_ot V_34_ot V_41_ot];
P_otto = [P_12_ot P_23_ot P_34_ot P_41_ot];

%% ---------- چرخه دیزل ----------
T2_dies = T2_ot;
P2_dies = P2_ot;
T3_dies = T2_dies + q_in1 / c_p;
r_c_dies = T3_dies / T2_dies;
V3_dies = V2 * r_c_dies;
P3_dies = P2_dies;
V4_dies = V1;
P4_dies = P3_dies * (CR / r_c_dies)^(-k);

V_12_dies = linspace(V1, V2, n_points) / V1;
P_12_dies = P1 * (V1 ./ (V_12_dies * V1)).^k / 1e5;

V_23_dies = linspace(V2, V3_dies, n_points) / V1;
P_23_dies = P2_dies * ones(1, n_points) / 1e5;

V_34_dies = linspace(V3_dies, V4_dies, n_points) / V1;
P_34_dies = P3_dies * (V3_dies ./ (V_34_dies * V1)).^k / 1e5;

V_41_dies = ones(1, n_points);
P_41_dies = linspace(P4_dies, P1, n_points) / 1e5;

V_diesel = [V_12_dies V_23_dies V_34_dies V_41_dies];
P_diesel = [P_12_dies P_23_dies P_34_dies P_41_dies];

%% ---------- رسم نهایی ----------
figure; hold on; grid on; box on

plot([V_12 V_23 V_35 V_56 V_61], [P_12 P_23 P_35 P_56 P_61], 'c-', 'LineWidth', 2, 'DisplayName', 'Atkinson')
plot(V_dual, P_dual, 'b-', 'LineWidth', 2, 'DisplayName', 'Dual')
plot(V_otto, P_otto, 'r-', 'LineWidth', 2, 'DisplayName', 'Otto')
plot(V_diesel, P_diesel, 'g-', 'LineWidth', 2, 'DisplayName', 'Diesel')

xlabel('Normalized Volume (V / V_1)')
ylabel('Pressure (bar)')
title('P-V Diagram for Atkinson, Otto, Diesel, and Dual Cycles')
legend('Location', 'best')
