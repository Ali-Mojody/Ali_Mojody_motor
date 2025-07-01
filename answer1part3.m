clc; clear; close all
%َعلی موجودی
%40126093

% -------------------- داده‌ها --------------------
P1 = 100000; % فشار اولیه (Pa)
T1 = 300;    % دمای اولیه (K)
k = 1.4;
c_v = 718;
c_p = 1005;
q_in1 = 1390723; % گرمای ورودی
CR = 14; % نسبت تراکم

% حجم‌ها (نسبی)
V1 = 1;
V2 = V1 / CR;

n_points = 50;

% -------------------- سیکل دوآل (چرخه ایده‌آل) با صورت‌مسأله --------------------
CR = 14;  % می‌توانی از حلقه یا sweep هم استفاده کنی

% مرحله 1->2 ایزنتروپیک (تراکم)
P2 = P1 * CR^k;
T2 = T1 * CR^(k-1);

% مرحله 2->3 ایزوکوریک (نسبت فشار 2 برابر)
P3 = 2 * P2;
T3 = T2 * 2;

% حجم V3 در پایان تراکم ایزنتروپیک
V3 = V2;

% محاسبه V4 از cut-off 5% استروک
stroke = V1 - V2;
V4 = V3 + 0.05 * stroke;

% مرحله 3->4 ایزوبار (P ثابت ⇒ T ∝ V)
T4 = T3 * (V4/V3);
P4 = P3; % فشار ثابت

% محدودیت T4 ≤ 2500K
if T4 > 2500
    warning('T4=%.0f K > 2500 K: باید انرژی گرمایی ورودی کاهش یابد یا CR کم شود.', T4);
end

% مرحله 4->5 ایزنتروپیک انبساط به V1
V5 = V1;
P5 = P4 * (V4/V5)^k;
T5 = T4 * (V4/V5)^(k-1);

% مسیرها برای رسم:
V_12_dual = linspace(V1, V2, n_points);
P_12_dual = P1 * (V1 ./ V_12_dual).^k;

V_23_dual = V2 * ones(1, n_points);
P_23_dual = linspace(P2, P3, n_points);

V_34_dual = linspace(V3, V4, n_points);
P_34_dual = P3 * ones(1, n_points);

V_45_dual = linspace(V4, V5, n_points);
P_45_dual = P4 * (V4 ./ V_45_dual).^k;

V_51_dual = V1 * ones(1, n_points);
P_51_dual = linspace(P5, P1, n_points);

V_dual = [V_12_dual V_23_dual V_34_dual V_45_dual V_51_dual];
P_dual = [P_12_dual P_23_dual P_34_dual P_45_dual P_51_dual];


% -------------------- سیکل اتو --------------------
T2_ot = T1 * CR^(k - 1);
P2_ot = P1 * CR^k;
T3_ot = T2_ot + q_in1 / c_v;
P3_ot = P2_ot * (T3_ot / T2_ot);
P4_ot = P3_ot * (1/CR)^k;

V3_ot = V2; % ایزوکوریک
V4_ot = V1;

V_12_ot = linspace(V1, V2, n_points);
P_12_ot = P1 * (V1 ./ V_12_ot).^k;

V_23_ot = V2 * ones(1, n_points);
P_23_ot = linspace(P2_ot, P3_ot, n_points);

V_34_ot = linspace(V3_ot, V4_ot, n_points);
P_34_ot = P3_ot * (V3_ot ./ V_34_ot).^k;

V_41_ot = V1 * ones(1, n_points);
P_41_ot = linspace(P4_ot, P1, n_points);

V_otto = [V_12_ot V_23_ot V_34_ot V_41_ot];
P_otto = [P_12_ot P_23_ot P_34_ot P_41_ot];

% -------------------- سیکل دیزل --------------------
T2_dies = T2_ot;
P2_dies = P2_ot;
P3_dies = P2_dies;
T3_dies = T2_dies + q_in1 / c_p;
r_c_dies = T3_dies / T2_dies;
V3_dies = V2 * r_c_dies;
V4_dies = V1;

P4_dies = P3_dies * (CR / r_c_dies)^(-k);

V_12_dies = linspace(V1, V2, n_points);
P_12_dies = P1 * (V1 ./ V_12_dies).^k;

V_23_dies = linspace(V2, V3_dies, n_points);
P_23_dies = P2_dies * ones(1, n_points);

V_34_dies = linspace(V3_dies, V4_dies, n_points);
P_34_dies = P3_dies * (V3_dies ./ V_34_dies).^k;

V_41_dies = V1 * ones(1, n_points);
P_41_dies = linspace(P4_dies, P1, n_points);

V_diesel = [V_12_dies V_23_dies V_34_dies V_41_dies];
P_diesel = [P_12_dies P_23_dies P_34_dies P_41_dies];

% -------------------- رسم نمودار --------------------
figure
hold on
plot(V_dual, P_dual / 1e5, 'b-', 'LineWidth', 2, 'DisplayName', 'Dual Cycle')
plot(V_otto, P_otto / 1e5, 'r-', 'LineWidth', 2, 'DisplayName', 'Otto Cycle')
plot(V_diesel, P_diesel / 1e5, 'g-', 'LineWidth', 2, 'DisplayName', 'Diesel Cycle')

xlabel('Normalized Volume (V / V_1)')
ylabel('Pressure (bar)')
title('P-V Diagram for Dual, Otto and Diesel Cycles')
legend('Location', 'best')
grid on
hold off
