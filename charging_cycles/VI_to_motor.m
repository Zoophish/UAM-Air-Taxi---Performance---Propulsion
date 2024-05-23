function [voltage,PowerIn,eff,PowerOut,current,energy] = VI_to_motor()

% This function uses the efficiency of the motor at specific RPM and torque
% to estimate the power input. Based on the motor V I characteristics this
% of the motor this will then give and estimate of required voltage and
% therfore the invertors and buck and/or boost convertors can be developed

% based on the data sheet operating voltage is 100 - 800 Vdc and max RPM is
% 5500 no stall spped is given so we will assume voltage is linearly
% proportional to speed 
% given that Induced voltage [VRMS/RPM] = 0,07823 the motor capable of
% 210Kw has a nominal design voltage of 680 Vdc vrms = v0/sqrt(2)

%Peak current is 500Arms and continuos is 220Arms the assumption is made 
%that torque is proportional to current but may just use the input power
%and then since the voltage equation is given current can be estimated 
load("rpm_T.mat");
% rpm and tourque requirements during the mission
% rpm_T = [
%     2500 410
%     4000 500
%     5000 400
%     4000 400
%     ];


%Extracting the speed and RPM and applying gear ratio
speedone = rpm_T(:, 1);
Torqueone = rpm_T(:, 2);
radpersec = speedone*((2*pi)/60);

%initialising variables
voltage = zeros(size(speedone));
PowerIn = zeros(size(speedone));
PowerOut = zeros(size(speedone));
current = zeros(size(speedone));

% this for loop takes each value of speed and torque then calls the mission
% function to give the effeciency at the rating this is then used to
% calculate the the power input and current 
 [eff] = mission(rpm_T);

for i = 1:length(speedone)
   
    %[VRMS/RPM] = 0,07823 vrms = vo/sqrt(2)
     %current(i) = (Torqueone(i)/1.22) *sqrt(2);
     voltage(i) = (1/6.5)*speedone(i)*sqrt(2);
     PowerOut(i) = (radpersec(i)*Torqueone(i));
     PowerIn(i) = PowerOut(i)/eff(i);
     % This current is just current  NOT RMS
     current(i) = PowerIn(i)/voltage(i);
     %voltage(i) = PowerIn(i)/current(i);
end
% since echch variable represents 1s dt = 1

energy =sum(PowerIn);