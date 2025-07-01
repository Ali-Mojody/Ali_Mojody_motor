clc; clear; close all

% -------------------- داده‌ها --------------------
P1 = 100000; % Pa
T1 = 300;    % K
k = 1.4;
c_v = 718;
q_in1 = 1390723; % J/kg
CR = 14;         % Compression ratio
ER = 17;         % Expansion ratio

% حجم‌ها
V1 = 1;          % حجم مرجع (اختیاری)
V2 = V1 / CR;

% نقاط اصلی دما و فشار
T2 = T1 * CR^(k-1);
P2 = P1 * CR^k;
T3 = T2 + q_in1/c_v;
P3 = P2 * (T3/T2);
T4 = T3 * (1/CR)^(k-1); % انبساط ایزنتروپیک به V1؟
P4 = P3 * (1/CR)^k;
T5 = T3 * (1/ER)^(k-1); % انبساط ایزنتروپیک به V3؟
P5 = P3 * (1/ER)^k;
T6 = T1 * (ER/CR);
P6 = P1 * (ER/CR)^(-k);

% گرمای خروجی و بازده
q_out1 = c_v * (T5 - T6);
etta = (1 - (q_out1/q_in1)) * 100;
fprintf('بازده چرخه آتکینسون = %.2f%%\n', etta);

% -------------------- رسم نمودار P-V --------------------
n_points = 50;

% فرآیند 1-2: ایزنتروپیک فشرده‌سازی
V_12 = linspace(V1, V2, n_points);
P_12 = P1 * (V1 ./ V_12).^k;

% فرآیند 2-3: حجم ثابت (افزایش فشار در حجم ثابت)
V_23 = V2 * ones(1, n_points);
P_23 = linspace(P2, P3, n_points);

% فرآیند 3-5: ایزنتروپیک انبساط
V5 = V1 * ER / CR;
V_35 = linspace(V2, V5, n_points);
P_35 = P3 * (V2 ./ V_35).^k;

% فرآیند 5-6: کاهش فشار در حجم ثابت
V_56 = V5 * ones(1, n_points);
P_56 = linspace(P5, P6, n_points);

% فرآیند 6-1: حجم ثابت به حالت اولیه (اختیاری - چرخه بسته)
V_61 = linspace(V5, V1, n_points);
P_61 = P6 * ones(1, n_points);

% رسم نمودار
figure;
hold on; grid on; box on;
plot(V_12, P_12, 'b-', 'LineWidth', 2);
plot(V_23, P_23, 'r-', 'LineWidth', 2);
plot(V_35, P_35, 'g-', 'LineWidth', 2);
plot(V_56, P_56, 'm-', 'LineWidth', 2);
plot(V_61, P_61, 'k-', 'LineWidth', 2);

xlabel('V (نسبی)');
ylabel('P (Pa)');
title('چرخه آتکینسون - نمودار P-V');
legend('1→2 (فشرده‌سازی)', '2→3 (گرمایش)', '3→5 (انبساط)', '5→6 (تخلیه)', '6→1 (بسته‌شدن چرخه)');

