function [tot_Loss_R,tot_Loss_N,tot_Loss_F,maxtempRear,maxtempfront,maxtempwing,maxtempbat,tot_loss_bat,Tbat,Tm,consttwo,TmOut, constthree,const]= Heatingthree()

[BatteryMass,wireMass,totMass,totEnergy,mechPower,ResPowerloss]= Masses();
[ResLoss,usedPower,wireMass,current,WLWing,WLRear,WLfront,Areaw,densityCU,RearRes,wingRes,frontRes,L,K,A,A2,A3,A4,voltage]= variables2();

% Constants
%internal resistance of high performance lithium battery
%https://x-engineer.org/calculate-internal-resistance-battery-cell/#:~:text=For%20example%2C%20a%20high%2Dperformance,resistance%20of%20around%20200%20m%CE%A9.
%https://iopscience.iop.org/article/10.1088/1742-6596/2301/1/012014/pdf#:~:text=The%20result%20shows%20that%20the,of%20battery%20are%20nearly%20identical.
% reference above internal resistance of batteries decrease as temp
% increases thus modelling for worst case senario of const intres
intres = 12*10^-3;
packRes = 0.432; %ohms
packcurrent = (current*6)/34;

% assuming the surface area of each battery is 1m^2
%batArea = 1;
Bat_Surf_Area = 0.09188; % This is the surface area of pipe in contact with the battery in a single pack
Mrear = WLRear*Areaw*densityCU; % Mass rear cables (kg)
Mfwing = WLfront*Areaw*densityCU;
MnWing =WLWing*Areaw*densityCU;

% This block is to chnage curret to account for buck convertor
%buckcurrent = (voltage.*current)/1110;
buckcurrent = current;
totcurrent = buckcurrent*6;
C = 385;        % Specific heat capacity of copper
Cbat = 1040;
alfa = 0.00393;% coefficient of resistance for copper

Tambient = 25;
% L is the thickness of the pipe walls
%LL = 14; % TOTAL lenth of copper pipes

%Mdot =0.45; %mass flow rate
Mdot =0.0515; %mass flow rate for single pack

% Aint = (pi*(0.01)^2)*(26*8*0.5); % croess sectional area of pipe 26*8 is because the simulation is for all batteries 0.5 as half is in contact
% radratio = log(10/9); % natural log  ratio of internal and outer pipr radius
% const = ((L/(K*Aint^2))+radratio/(2*pi*LL*K))^-1; % CONSTANT IN CALCULATIONS
% consttwo = const/(BatteryMass*Cbat);
% constthree = ((2*pi*0.01*LL)/(Mdot*4200));
fins1= 330;
fins2 = 100;
fins3 = 600;
fins4 = 1000;
Pipe_wall_thickness = 1*10^-3;
pipe_contact =(3/2)*(1*10^-3)*(pi*(10*10^-3))*fins1; % pipe contact area
pipe_contacttwo = (3/2)*(1*10^-3)*(pi*(10*10^-3))*fins2; % pipe contact area
pipe_contactthree = (3/2)*(1*10^-3)*(pi*(10*10^-3))*fins3; % pipe contact area
pipe_contactfour = (3/2)*(1*10^-3)*(pi*(10*10^-3))*fins4; % pipe contact area

%This block is to calculate the Reynolds number
coolant_viscocity = 1.65*10^-3;
coolantDensity = 1030; %KG/m63
pipe_diameter = 9*10^-3;
Pipe_cross_area = pi*(0.5*pipe_diameter)^2; % pepie cross sectional area
fluid_vellocity = Mdot/(coolantDensity*Pipe_cross_area);
Re = coolantDensity*fluid_vellocity*pipe_diameter/coolant_viscocity;

% This block is to calculate the prandth constand
fluid_coeff_heat = 3900;
fluid_coeff_cond = 0.512;
Pr = coolant_viscocity*fluid_coeff_heat/fluid_coeff_cond;

% This block describes how to calculate the coefficient of heat transfer
cone = 0.332;
ctwo = 0.5;
cthree = 0.343;

h = cone*(Re^ctwo)*(Pr^cthree)*(fluid_coeff_cond)/pipe_diameter;

% This block calculates the thermal resistivity
Al_coeff_cond = 210;

U = ((Pipe_wall_thickness/Al_coeff_cond) + (1/h))^-1;

packMass = 7.994; %Kg

TR_initial = Tambient; % Initial rear cablestemperature (degC)
TF_initial = Tambient;
TN_initial = Tambient;
RR_initial = RearRes;%initial resistance of rear tyres
RF_initial = frontRes;
RN_initial = wingRes;

dt = 1;
% Initialize variables
t = 1 : dt : length(current);
TR = zeros(size(t));   % Temperature array
TF = zeros(size(t));
TN = zeros(size(t));
Tbat = zeros(size(t));
TmOut = zeros(size(t)); % outlest coolant temp
Tm = zeros(size(t)); %mean coolant temp
RR = zeros(size(t)); % Resistance rear motor wires array
RF = zeros(size(t));
RN = zeros(size(t));
dRR = zeros(size(t)); %change in temp from initial
dRF = zeros(size(t));
dRN = zeros(size(t));

Energy_R = zeros(size(t)); %energy loss of rear wiring
Energy_F = zeros(size(t));
Energy_N = zeros(size(t));
Energy_bat = zeros(size(t));

% Initial condition
TR(1) = TR_initial;
TF(1) = TF_initial;
TN(1) = TN_initial;
Tm(1)= TN_initial;
TmOut(1) = TN_initial;
Tbat(1) = Tambient;
Tbat2(1) = Tambient;
Tbat3(1) = Tambient;
Tbat4(1) = Tambient;
RR(1) = RR_initial;
RF(1) = RF_initial;
RN(1) = RN_initial;
outlet_temp(1) = TR_initial;
Energy_R(1)=0;
Energy_F(1)=0;
Energy_N(1)=0;
Energy_bat(1)=0;
dRR(1) = 0;
dRF(1) = 0;
dRN(1) = 0;

for i =2:2100
    RR(i) =RR_initial*(1+alfa*dRR(i-1));
    RF(i) =RF_initial*(1+alfa*dRF(i-1));
    RN(i) =RN_initial*(1+alfa*dRN(i-1));
    TR(i) = (((buckcurrent(i)^2)*RR(i) * dt) / (Mrear * C)) + TR(i-1);
    TF(i) = (((buckcurrent(i)^2)*RF(i) * dt) / (Mfwing * C)) + TF(i-1);
    TN(i) = (((buckcurrent(i)^2)*RN(i) * dt) / (MnWing * C)) + TN(i-1);
   
    Tbat(i) = Tbat(i-1) + (1/(packMass*Cbat))*(packRes*(packcurrent(i)^2) - U*pipe_contact*(Tbat(i-1)-Tambient));

%     %Tbat(i) = Tbat(i-1) + (1/(BatteryMass*Cbat))*((totcurrent(i)^2)*intres * dt) + const*(30-Tbat(i-1))*(1/BatteryMass*Cbat);
%     Tbat(i) = Tbat(i-1) + (1/(BatteryMass*Cbat))*((totcurrent(i)^2)*intres * dt) + (Tm(i-1)-Tbat(i-1))*consttwo;
%     %Tbat(i) = Tbat(i-1) + (1/(BatteryMass*Cbat))*((totcurrent(i)^2)*intres * dt);
%     TmOut(i) = TN_initial + (const*(Tbat(i-1)- Tm(i-1))*constthree);
%     Tm(i) = (TmOut(i-1) + TN_initial)/2; % Avergae coolant temp
   

    Tbat2(i) = Tbat2(i-1) + (1/(packMass*Cbat))*(packRes*(packcurrent(i)^2) - U*pipe_contacttwo*(Tbat2(i-1)-Tambient));
    Tbat3(i) = Tbat3(i-1) + (1/(packMass*Cbat))*(packRes*(packcurrent(i)^2) - U*pipe_contactthree*(Tbat3(i-1)-Tambient));
    Tbat4(i) = Tbat4(i-1) + (1/(packMass*Cbat))*(packRes*(packcurrent(i)^2) - U*pipe_contactfour*(Tbat4(i-1)-Tambient));

    % assuming 20 L of flow per minute approximate density of water 1L/KG
    % and inlet temp is TR_initial this is to calculate outlet temp
    % considering perfect conduction of heat by liquid
    %6=20lmper min = 0.34L per sec
    outlet_temp(i) =TmOut(i);

    Energy_R(i) = ((buckcurrent(i)^2)*RR(i) * dt);
    Energy_F(i) = ((buckcurrent(i)^2)*RF(i) * dt);
    Energy_N(i) = ((buckcurrent(i)^2)*RN(i) * dt);
    Energy_bat(i) = ((totcurrent(i)^2)*RN(i) * dt);
    dRR(i) = TR(i)-TR(1);
    dRF(i) = TF(i)-TF(1);
    dRN(i) = TN(i)-TN(1);
end
tot_Loss_R = sum(Energy_R);
tot_Loss_F = sum(Energy_F);
tot_Loss_N = sum(Energy_N);
tot_loss_bat = sum(Energy_bat);

maxtempRear = max(TR);
maxtempfront = max(TF);
maxtempwing = max(TN);
maxtempbat = max(Tbat);
% disp(['Energy lost to rear wires ' num2str(tot_Loss_R)]);
% disp(['Energy lost to wing wide wires ' num2str(tot_Loss_F)]);
% disp(['Energy lost to wing near wires ' num2str(tot_Loss_N)]);
% Plot the results
% Plot TR
figure;
plot(t, TR, '-b', 'LineWidth', 2);  % Blue solid line

hold on;  % Hold the current graph

% Plot TF
plot(t, TF, '--r', 'LineWidth', 2);  % Red dashed line

% Plot TN
plot(t, TN, ':g', 'LineWidth', 2);  % Green dotted line

plot(t, Tbat, ':k', 'LineWidth', 2);  % Green dotted line

% Add labels and legend
xlabel('Time (s)');
ylabel('Temperature');
title('Multiple Variables on the Same Plot');
legend('TR', 'TF', 'TN','Tbat');
%legend('TR', 'TF', 'TN');

hold off;
figure;
plot(t,RR,'-b','LineWidth',2);
hold on
plot(t,RF,'-g','LineWidth',2);
plot(t,RN,'-r','LineWidth',2);

xlabel('Time (s)');
ylabel('Resistance');
title('Multiple Variables on the Same Plot');
legend('RR', 'RF', 'RN');
hold off;

figure;
hold on
plot(t,outlet_temp,'-k','LineWidth',2);
xlabel('Time (s)');
ylabel('outlet coolant temp');
title('Multiple Variables on the Same Plot');
%legend('RR', 'RF', 'RN');
hold off;
figure;
plot(t, Tbat4, '-b', 'LineWidth', 2);  % Blue solid line

hold on;  % Hold the current graph

% Plot TF
plot(t, Tbat3, '--r', 'LineWidth', 2);  % Red dashed line

% Plot TN
plot(t, Tbat2, ':g', 'LineWidth', 2);  % Green dotted line

plot(t, Tbat, ':k', 'LineWidth', 2);  % Green dotted line

% Add labels and legend
xlabel('Time (s)');
ylabel('Temperature');
title('Surface area VS temp');
legend('0.0471 m2 1000 Sinks', '0.0283 m2 600 Sinks', '0.0047 m2 100 Sinks' ,'0.0156 m2 330 Sinks');
%legend('TR', 'TF', 'TN');

hold off;