function [Tout,dx,T_final] = radiator()

InletTemp = 80; % input temperature in degC
SinkLength = 0.15; % ; lenth of copper pipes for single motor
SinkThickness = 0.01;
SinkHeight = 0.03;
SinkArea = 2*SinkHeight*SinkLength;
 
airtemp = 20;
 

% This block is to calculate the mass flow rate of coolant for a single
% radiator assuming density of coolant is 1000KG/m3
%https://www.engineersedge.com/physics/viscosity_of_air_dynamic_and_kinematic_14483.htm

coolant_density = 1.092;
airspeed = 67; % air speed in meters per second
Viscosity = 1.963*10^-5;

% This bock calculates the reynolds number
% with air temp 20degC and InletTemp 80degC
% Tf = 50degC
Re = (coolant_density*airspeed*SinkLength)/Viscosity;

%This block calculates the the prandth number
Cp = 1007; %coefficient of heat of air
cond_air = 0.02735; %conductivity of air

Pr = (Viscosity*Cp)/cond_air;

% This block defines the constants to find the heat transfer coefficients 
% from the Nusselt number
% https://dspace.mit.edu/bitstream/handle/1721.1/35739/3-185Fall-2002/NR/rdonlyres/Materials-Science-and-Engineering/3-185Transport-Phenomena-in-Materials-EngineeringFall2002/424CAB6E-0B2A-47BA-8FF4-EBD0F84E2AEE/0/NUSSELT3185.pdf
cone = 0.026;
ctwo = 0.8;
cthree = 1/3;

%This block containts the equation to calculate the heat transer coefficient

h = cone*Re^ctwo*Pr^cthree*cond_air/SinkLength;

% This block is to calculate the thermal resistance of the conduction from
% the copper pipe and the convection from flowing air

Therm_condCU = 401; %W/mK

Rf = ((SinkHeight/(2*Therm_condCU)) + 1/h)^-1;

%This block describes coolant properties
Sinks = 140; %the number of heat sink fins
Sinks2 = 80; %the number of heat sink fins
Sinks3 = 50; %the number of heat sink fins
Sinks4 = 30; %the number of heat sink fins

MassFlow =0.45;
specC_coolant = 4200;
% Tot_Area = Sinks*SinkArea;
% Const = (Rf*Tot_Area)/(MassFlow*specC_coolant);
SinkPermimeter = (2*SinkThickness) + 2*SinkLength; % this is the perimeter of the heat sink in contact with the the copper pipe
Tot_SinkPerimeter2 = SinkPermimeter*Sinks2;
Tot_SinkPerimeter3 = SinkPermimeter*Sinks3;
Tot_SinkPerimeter4 = SinkPermimeter*Sinks4;
Tot_SinkPerimeter = SinkPermimeter*Sinks;

Const = (Rf*Tot_SinkPerimeter)/(MassFlow*specC_coolant);
Const2 = (Rf*Tot_SinkPerimeter2)/(MassFlow*specC_coolant);
Const3 = (Rf*Tot_SinkPerimeter3)/(MassFlow*specC_coolant);
Const4 = (Rf*Tot_SinkPerimeter4)/(MassFlow*specC_coolant);

%[ResLoss,usedPower,wireMass,current,WLWing,WLRear,WLfront,Areaw,densityCU,RearRes,wingRes,frontRes,L,K,A,A2,A3,A4,voltage]= variables2();
distance = SinkLength*100;
Ts = InletTemp * ones(1, distance);  % Temperature array
Tm = airtemp * ones(1, distance);    % Temperature array
Tout = zeros(1, distance);           % Temperature array
Tout2 = zeros(1, distance);           % Temperature array
Tout3 = zeros(1, distance);           % Temperature array
Tout4 = zeros(1, distance);           % Temperature array

Mdx = 1:distance;                      % variable for legth of pipe in cm
dx = Mdx/100;                       %Convert distance to metres
Tout(1) = InletTemp;
Tout2(1) = InletTemp;
Tout3(1) = InletTemp;
Tout4(1) = InletTemp;

for i = 2:distance

    Tout(i) = Tout(i-1) - dx(i)*Const*(Tout(i-1)-Tm(i));
    Tout2(i) = Tout2(i-1) - dx(i)*Const2*(Tout2(i-1)-Tm(i));
    Tout3(i) = Tout3(i-1) - dx(i)*Const3*(Tout3(i-1)-Tm(i));
    Tout4(i) = Tout4(i-1) - dx(i)*Const4*(Tout4(i-1)-Tm(i));
    
end

T_final = Tout(distance);
% Plot all Tout variables on the same plot with a legend
plot(dx, Tout, 'b', dx, Tout2, 'r', dx, Tout3, 'g', dx, Tout4, 'm');
xlabel('Distance (m)');
ylabel('Temperature (°C)');
title('Temperature Evolution along the Pipe');
legend('140 Sinks', '80 Sinks', '50 Sinks', '30 Sinks');