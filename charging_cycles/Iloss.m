function [TNLloss, CruiseLoss,Takeloss,Landloss,Rmot,fmot,nmot]=Iloss
[rho, Itake, Icruise, Lrear, Lfwings, Lnwings, AreaR , Areafwing  ,Areanwing]=Variables;
% % resistivity of copper 
% rho = 1.777*10^-8; %ohms per centimeter 
% 
% %Takeoff current per motor
% Itake = 100; % Ampere
% Icruise = 34; % Ampere
% 
% % Lenth to rear rotars
% Lrear = 3.25;
% Lfwings = 2*6; % two for far two far rotars inn meteres 
% Lnwings = 2*3 ; % two for two near body rotars
% 
% % Wire areas 
% AreaR = pi*0.03^2; % rear wires assuming diameter of 6 cm
% Areafwing =pi*0.03^2; % far wing rotarrs
% Areanwing =pi*0.03^2; % near wing rotars

% Resistances to motors wires
Rmot = (rho*Lrear)/AreaR;
fmot = (rho*Lfwings)/Areafwing;
nmot = (rho*Lnwings)/Areanwing;

% TOTAL MOTOR POWER LOSSES AT TAKEOFF & landing 100A single takeoff 
Takeloss = (Itake^2)*(Rmot+fmot+nmot);
Landloss = Takeloss;

%Total motor power loss for cruise
CruiseLoss = (Icruise^2)*(Rmot+fmot+nmot);

% total motor loss mission requires resrve for 2 takeoff and 2 landing
% the value is a power loss 
TNLloss = (2*Takeloss)+(2*Landloss);