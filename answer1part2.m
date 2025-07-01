clc;clear;close all

%define value
P3_P2=1.7;
P1=100000;
T1=300;
k=1.4;
T_max=2500;
c_v=718;
c_p=1005;

% گزاشتن گرمای بهینه برای سایر سیکل ها
q_in1 = 1390723;
%گداشتن نسبت تراکم بهینه برای سایر  سیکل ها 
CR = 14;

%سیکل اتو
% بدست آوردن پارامتر ها برای نقاط مختلف سیکل و حساب کردن راندمان
T2=T1*(CR)^(1.4-1);
P2 = P1*(CR)^k;
T3_ot = T2 + q_in1/c_v;
P3_ot = P2 *(T3_ot/T2);
P4_ot = P3_ot *((1/CR)^1.4);
T4_ot=T3_ot*((1/CR)^(0.4));
q_out_ot = c_v*(T4_ot-T1);
efficiency_ot = 1-(q_out_ot/q_in1)



%سیکل دیزل
%بدست آوردن پارامتر ها برای نقاط مختلف سیکل دیزل و حساب کردن راندمان

T2=T1*(CR)^(1.4-1);
P2 = P1*(CR)^k;
P3_dies = P2;
T3_dies = T2 + q_in1/c_p;
r_c_dies = T3_dies/T2;
T4_dies=T3_dies*((CR/r_c_dies)^(-0.4));
q_out_dies = c_v*(T4_dies-T1);
efficiency_dies = 1-(q_out_dies/q_in1)
