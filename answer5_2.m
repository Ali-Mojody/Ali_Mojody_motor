clc; clear; close all

% پارامترها
P3_P2 = 1.7;
P1 = 100000;
T1 = 300;
k = 1.4;
c_v = 718;
c_p = 1005;
ER = 17;

R = 8.31;     % ثابت گازها (J/mol·K)
dt = 0.00002; % زمان ماند (s)

A = 1.8e8;    % پیش‌نمایی واکنش 1
Ea1 = 3.19e5; % انرژی فعال‌سازی 1
Ea2 = 3.9e4;  % انرژی فعال‌سازی 2

CR_vals = 12:1:18;
n = length(CR_vals);

NO_Otto = zeros(1,n);
NO_Diesel = zeros(1,n);
NO_Dual = zeros(1,n);
NO_Atk = zeros(1,n);

idx = 1;

for CR = CR_vals
    % سیکل دوال
    T2 = T1 * CR^(k - 1);
    P2 = P1 * CR^k;
    T3 = T2 * P3_P2;
    P3 = P2 * P3_P2;
    r_c = (CR - 1) * 0.05 + 1;
    T4 = r_c * T3;
    P4 = P3;
    T5 = T4 * (CR / r_c)^(-0.4);
    P5 = P4 * (CR / r_c)^1.4;

    q1 = c_v * (T3 - T2);
    q2 = c_p * (T4 - T3);
    q_in = q1 + q2;
    q_out = c_v * (T5 - T1);

    % سیکل اتو
    T3_ot = T2 + q_in / c_v;
    P3_ot = P2 * (T3_ot / T2);
    T4_ot = T3_ot * (1 / CR)^0.4;
    q_out_ot = c_v * (T4_ot - T1);

    % سیکل دیزل
    T3_dies = T2 + q_in / c_p;
    P3_dies = P2;
    r_c_dies = T3_dies / T2;
    T4_dies = T3_dies * (CR / r_c_dies)^(-0.4);
    q_out_dies = c_v * (T4_dies - T1);

    % سیکل اتکینسون
    T_2 = T1 * CR^(k - 1);
    P_2 = P1 * CR^k;
    T_3 = q_in / c_v + T_2;
    P_3 = P_2 * (T_3 / T_2);
    T_4 = T_3 * (1 / CR)^(k - 1);
    P_4 = P_3 * (1 / CR)^k;
    T_5 = T_3 * (1 / ER)^(k - 1);
    P_5 = P_3 * (1 / ER)^k;
    T_6 = T1 * (ER / CR);

    % داده‌ها برای محاسبه NO
    data = {
        'Diesel', T3_dies, P3_dies;
        'Otto',   T3_ot,   P3_ot;
        'Dual',   T4,      P3;
        'Atk',    T_3,     P_3
    };

    for j = 1:size(data, 1)
        typ = data{j, 1};
        T = data{j, 2};
        P = data{j, 3};

        C = P / (R * T);

        O2 = 0.21 * C;
        N2 = 0.78 * C;
        O = 1e-4 * C;
        N = 1e-6 * C;

        A2 = 1.8e4 * T;
        k1 = A * exp(-Ea1 / (R * T));
        k2 = A2 * exp(-Ea2 / (R * T));

        rNO = k1 * N2 * O + k2 * N * O2;
        NO = rNO * dt;
        ppm = (NO / C) * 1e6;

        switch typ
            case 'Otto'
                NO_Otto(idx) = ppm;
            case 'Diesel'
                NO_Diesel(idx) = ppm;
            case 'Dual'
                NO_Dual(idx) = ppm;
            case 'Atk'
                NO_Atk(idx) = ppm;
        end
    end

    fprintf('CR=%d -> Otto: %.2f ppm, Diesel: %.2f ppm, Dual: %.2f ppm, Atk: %.2f ppm\n', ...
            CR, NO_Otto(idx), NO_Diesel(idx), NO_Dual(idx), NO_Atk(idx));

    idx = idx + 1;
end

% رسم نمودار
figure;
plot(CR_vals, NO_Otto, '-o', 'LineWidth', 2); hold on;
plot(CR_vals, NO_Diesel, '-s', 'LineWidth', 2);
plot(CR_vals, NO_Dual, '-^', 'LineWidth', 2);
plot(CR_vals, NO_Atk, '-d', 'LineWidth', 2);
xlabel('Compression Ratio (CR)');
ylabel('NO Concentration (ppm)');
legend('Otto', 'Diesel', 'Dual', 'Atkinson', 'Location', 'northwest');
title('NO Emission vs Compression Ratio for Different Cycles');
grid on;
