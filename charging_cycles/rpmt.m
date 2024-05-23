function []=rpmt()

% Given a total take of power of 575Kw meaning 96Kw per motor 
% (96000 w)  at 800RPM with a required torque of 1146. 
% Cruise tottal power is 105Kw( 10500) which is 17.5Kw(17500 W) per motor
% at 800 rpm thus T = 206Nm

% worst case mission two takeoff 2 landing and 80 mile range thus
% manipulate cruise time from 600s for 25 miles to 1920s thus total time is
% diversion mission is 60 miles not 25
% 20+20+20+20+1920= 2000s
% will divide cruise into 2 40 mile trips 
%creating matrix for rpm and torque value
%

rpm_T = zeros(2100, 2);

% filling spaces with RPM & T values during mission. Each spavce represents
% one second thus dt = 1
% assuming rpm must not exceeed 5500 and torque 500
%Gear ratio reduction
N = 3;

for i = 1:2100 % total journey time
    
    if i <= 35  % Takeoff 1
rpm_T (i,1)= 800*N;
rpm_T (i,2)= 1540/N;

    elseif i > 35 && i <= 45 % accelerate 1
rpm_T (i,1)= 800*N;
rpm_T (i,2)= 585/N;

    elseif i >45 && i<= 645 % cruise 1 40 mile
rpm_T (i,1)= 800*N;
rpm_T (i,2)= 203/N;

 elseif i >645 && i<= 655 % decelerate 1
rpm_T (i,1)= 800*N;
rpm_T (i,2)= 585/N;

  elseif i > 655 && i <= 700 % land 1
rpm_T (i,1)= 800*N;
rpm_T (i,2)= 1540/N;

    end
    
end
