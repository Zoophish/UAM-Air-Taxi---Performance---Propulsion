function [tot_Loss_R,tot_Loss_N,tot_Loss_F,maxtempRear,maxtempfront,maxtempwing,maxtempbat,tot_loss_bat,Tbat,Tm,consttwo,TmOut, constthree,const]= Heatingtwo()

[BatteryMass,wireMass,totMass,totEnergy,mechPower,ResPowerloss]= Masses();
[ResLoss,usedPower,wireMass,current,WLWing,WLRear,WLfront,Areaw,densityCU,RearRes,wingRes,frontRes,L,K,A,A2,A3,A4,voltage]= variables2();

% Constants
%internal resistance of high performance lithium battery
%https://x-engineer.org/calculate-internal-resistance-battery-cell/#:~:text=For%20example%2C%20a%20high%2Dperformance,resistance%20of%20around%20200%20m%CE%A9.
%https://iopscience.iop.org/article/10.1088/1742-6596/2301/1/012014/pdf#:~:text=The%20result%20shows%20that%20the,of%20battery%20are%20nearly%20identical.
% reference above internal resistance of batteries decrease as temp
% increases thus modelling for worst case senario of const intres
intres = 12*10^-3;

% assuming the surface area of each battery is 1m^2
batArea = 1;
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
Tambient = 20;
% L is the thickness of the pipe walls
LL = 14; % TOTAL lenth of copper pipes

%Mdot =0.45; %mass flow rate
Mdot =0.45; %mass flow rate for all batteries as simulation is carried out for all packs

Aint = (pi*(0.01)^2)*(26*8*0.5); % croess sectional area of pipe 26*8 is because the simulation is for all batteries 0.5 as half is in contact
radratio = log(10/9); % natural log  ratio of internal and outer pipr radius
const = ((L/(K*Aint^2))+radratio/(2*pi*LL*K))^-1; % CONSTANT IN CALCULATIONS
consttwo = const/(BatteryMass*Cbat);
constthree = ((2*pi*0.01*LL)/(Mdot*4200));
TR_initial = 20; % Initial rear cablestemperature (degC)
TF_initial = 20;
TN_initial = 20;
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
    %Tbat(i) = Tbat(i-1) + (1/(BatteryMass*Cbat))*((totcurrent(i)^2)*intres * dt) + const*(30-Tbat(i-1))*(1/BatteryMass*Cbat);
    Tbat(i) = Tbat(i-1) + (1/(BatteryMass*Cbat))*((totcurrent(i)^2)*intres * dt) + (Tm(i-1)-Tbat(i-1))*consttwo;
    %Tbat(i) = Tbat(i-1) + (1/(BatteryMass*Cbat))*((totcurrent(i)^2)*intres * dt);
    TmOut(i) = TN_initial + (const*(Tbat(i-1)- Tm(i-1))*constthree);
    Tm(i) = (TmOut(i-1) + TN_initial)/2; % Avergae coolant temp
   

    Tbat2(i) = Tbat2(i-1) + (1/(BatteryMass*Cbat))*(((totcurrent(i)^2)*intres * dt) + K*A2*(TR_initial-Tbat2(i-1))*(1/L) );
    Tbat3(i) = Tbat3(i-1) + (1/(BatteryMass*Cbat))*(((totcurrent(i)^2)*intres * dt) + K*A3*(TR_initial-Tbat3(i-1))*(1/L) );
    Tbat4(i) = Tbat4(i-1) + (1/(BatteryMass*Cbat))*(((totcurrent(i)^2)*intres * dt) + K*A4*(TR_initial-Tbat4(i-1))*(1/L) );

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
legend('0.3 m2 ', '0.05 m2 ', '0.08 m2','0.1 m2');
%legend('TR', 'TF', 'TN');

hold off;