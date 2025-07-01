clc;clear;close all

%define value
P3_P2=1.7;
P1=100000;
T1=300;
k=1.4;
T_max=2500;
U=[];
i=1;
c_v=718;
c_p=1005;
for CR=12:1:18
    T2=T1*(CR)^(1.4-1);
    P2=P1*(CR)^k;
    T3=T2*P3_P2;
    P3=P2*P3_P2;
    r_c=(CR-1)*0.05+1;
    T4=r_c*T3;
    P4=P3;
    T5=T4*((CR/r_c)^(-0.4));
    P5=P4*((CR/r_c)^(1.4));
    % calculate heat
    q1=c_v*(T3-T2);
    q2=c_p*(T4-T3);
    q_in=q1+q2;
    q_out=c_v*(T5-T1);
    etta=1-(q_out/q_in);
    %pass if for T4
    if T4<2500
       %put valu in matris U
       U(1,i)=CR;
       U(2,i)=T4;
       U(3,i)=q_in;
       U(4,i)=q_out;
       U(5,i)=etta;
       i=i+1;
    end
end
% ایجاد جدول مرتب برای نمایش U
U_table = table(U(1,:)', U(2,:)', U(3,:)', U(4,:)', U(5,:)', ...
    'VariableNames', {'CR', 'T4', 'q_in', 'q_out', 'Efficiency'});

% نمایش جدول
disp(U_table);

