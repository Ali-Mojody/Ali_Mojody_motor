clc;clear;close all
P_t=105e3; %pa
T_t=300; %k
C_D=0.7;
A_t=4e-4; %m^2     فرض از جزوه
R = 287;         % J/kg.K for air
k=1.3 ;   %فرض از جزوه
T_u=1000; %k    فرض از جزوه

i=1;
%ماتریس برای ریختن جواب حا در آن
U=[];
for P_u=100e3:1000:400e3
    A1=P_u/P_t;
    A2=((k+1)/2)^(k/(k-1));
    if A1<A2    %subsonic flow
        m_dot=C_D*A_t*P_u*sqrt(2/(R*T_u)*((P_t/P_u)^(2/k))*k/(k-1)*(1-(P_t/P_u)^((k-1)/k)));
        U(i)=m_dot;
        i=i+1;
    end
    if A1>=A2    %sonic flow
        m_dot=C_D*A_t*P_u*sqrt(k/(R*T_u)*(2/(k+1))^((k+1)/(k-1)));
        U(i)=m_dot;
        i=i+1;
    end
end

%رسم نمودار 
L=100e3:1000:400e3;
plot(L,U,'b', 'LineWidth', 2)
P_u_c=((k+1)/2)^(k/(k-1))*P_t;
xline(P_u_c,'--g', 'LineWidth', 1.5, 'Label', 'Critical Pressure')
ylabel('Mass Flow Rate \dot{m} (kg/s)')
xlabel('Upstream Pressure P_0 (Pa)')
title('Mass Flow Rate vs Upstream Pressure')
legend('Mass Flow Rate \dot{m}', 'Critical Pressure for Sonic Flow')
