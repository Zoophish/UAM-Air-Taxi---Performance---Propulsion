function [rho, Itake, Icruise, Lrear, Lfwings, Lnwings, AreaR , Areafwing ,Areanwing, TnL , cruise , kWhcon,densityCU]=Variables

densityCU = 8850; % density copper KG/M^3
% parraemter definitions room for other paraameters
TnL = 45; % KWh
cruise = 45; % KWh
kWhcon = 3600000; % Convert kWh to joules
% resistivity of copper 
rho = 1.724*10^-8; %ohms per meter 

%Takeoff current per motor
Itake = 100; % Ampere
Icruise = 34; % Ampere
% Lenth to rear rotars
Lrear = 3.25;
Lfwings = 2*6; % two for far two far rotars inn meteres 
Lnwings = 2*3 ; % two for two near body rotars

% Wire areas 
radius = 0.001;% readius of copper wires in metres
AreaR = pi*radius^2; 
Areafwing =pi*radius^2; % far wing rotarrs
Areanwing =pi*radius^2; % near wing rotars
