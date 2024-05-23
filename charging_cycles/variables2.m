function [ResLoss,usedPower,wireMass,current,WLWing,WLRear,WLfront,Areaw,densityCU,RearRes,wingRes,frontRes,L,K,A,A2,A3,A4,voltage]= variables2()
% This function works to provide all the variables need to calculate battry
% mass
[dissipation,invertor_eff_loss] = invertor();

%calling function to get some energy requiremts during operation
[voltage,PowerIn,eff,PowerOut,current,energy] = VI_to_motor();
%[dissipation,invertor_eff_loss] = invertor();
% This block is in order to calculate resistance losses in wires

densityCU = 8850; % density copper KG/M^3
rho = 1.724*10^-8; %ohms per meter 

% lenth of wires will be about 6,8,7 metres 
WLRear = 6; %metres with two wires going there
WLWing = 7; % meteres with two wires heading there
WLfront = 8; % metres with 2 wires headin there
radius = 4.5*10^-3; %radius of copper wires
Areaw = pi*radius^2; % cross sectional area of wires

RearRes = (rho*WLRear)/Areaw; %resistance
wingRes = (rho*WLWing)/Areaw; %resistance
frontRes = (rho*WLfront)/Areaw; %resistance
%multiply by 2 for return wures
wireMass = 2*Areaw*densityCU*(WLfront+WLWing+WLRear);
% Calculating the instantaneous power loss in wires during missions
% The 2 represents the two motors at ecah of these distances
%Therefor we get 6 motors
ResLoss = (current.^2) * 2 * (RearRes + wingRes + frontRes);

%
% 
%
%This block is to calcuate the instantaneous power requirements by motors
% during mission number 6 for 6 motors
usedPower = (PowerIn./invertor_eff_loss)*6;

%This block conatinas parameters for cooling of battery
L = 0.003; %THICKNESS OF COPPER PIPE
% https://thermtest.com/thermal-resources/top-10-resources/top-10-thermally-conductive-materials#:~:text=Copper%20%E2%80%93%20398%20W%2Fm%E2%80%A2K
K = 398; % thermal conductivity of copper
A = 0.1; %battery surface area
A2 = 0.08;
A3 = 0.05;
A4 = 0.3;

