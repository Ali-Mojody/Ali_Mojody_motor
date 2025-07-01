clc; clear; close all

% پارامترهای فیزیکی
P_t = 105e3;    % فشار پایین‌دست (Pa)
T_u = 1000;     % دمای بالا‌دست (K)
R = 287;        % ثابت گاز هوا (J/kg.K)
k = 1.3;        % نسبت گرمایی هوا

% محاسبه نسبت فشار بحرانی
critical_ratio = (2 / (k + 1))^(k / (k - 1));
P_u_critical = P_t / critical_ratio;   % Pu بحرانی

% بردار فشار بالادست
P_u = 100e3:1000:400e3;
V_t = zeros(size(P_u));  % بردار سرعت خروجی

% محاسبه سرعت خروجی
for i = 1:length(P_u)
    pr = P_t / P_u(i);
    
    if pr > critical_ratio   % جریان ساب‌سونیک
        V_t(i) = sqrt(2 * R * T_u * (k / (k - 1)) * (1 - (P_t / P_u(i))^((k - 1)/k)));
    else                     % جریان سونیک
        V_t(i) = sqrt((2 * k / (k + 1)) * R * T_u);
    end
end

% رسم نمودار
plot(P_u, V_t, 'b', 'LineWidth', 2)
hold on
xline(P_u_critical, '--r', 'LineWidth', 1.5, 'Label', 'فشار بحرانی')

xlabel('فشار بالا‌دست P_u (Pa)')
ylabel('سرعت خروجی V_t (m/s)')
title('سرعت خروجی بر حسب فشار بالا‌دست')
legend('V_t', 'فشار بحرانی')
grid on
