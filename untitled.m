clc;clear;close all


%l_teta=l_max*sin(pi(teta_teta_vo)/teta_dur)
theta = 0:1:720;  % زاویه میل‌لنگ (درجه)


%فرضیاتی که برای حل این مسئله در نظ میگیریم 

L_max = 10;       % حداکثر باز شدن سوپاپ (mm)

% اطلاعات سوپاپ ورودی
theta_vo_in = 350;    % شروع باز شدن (درجه)
theta_dur_in = 230;   % مدت باز بودن (درجه)
theta_vc_in = theta_vo_in + theta_dur_in;

% اطلاعات سوپاپ خروجی
theta_vo_ex = 120;    % شروع باز شدن (درجه)
theta_dur_ex = 260;   % مدت باز بودن (درجه)
theta_vc_ex = theta_vo_ex + theta_dur_ex;

L_in = zeros(size(theta));
L_ex = zeros(size(theta));

for i = 1:length(theta)
    t = theta(i);
    
    % سوپاپ ورودی
    if t >= theta_vo_in && t <= theta_vc_in
        L_in(i) = L_max * sin( pi * (t - theta_vo_in) / theta_dur_in );
    end
    
    % سوپاپ خروجی
    if t >= theta_vo_ex && t <= theta_vc_ex
        L_ex(i) = L_max * sin( pi * (t - theta_vo_ex) / theta_dur_ex );
    end
end


% رسم نمودار
figure;
plot(theta, L_in, 'b', 'LineWidth', 2); hold on;
plot(theta, L_ex, 'r', 'LineWidth', 2);
xlabel('زاویه میل‌لنگ (درجه)');
ylabel('میزان باز شدن سوپاپ (میلی‌متر)');
title('نمودار باز شدن سوپاپ ها بر حسب زاویه میل لنگ');
legend('سوپاپ ورودی', 'سوپاپ خروجی');
grid on;



