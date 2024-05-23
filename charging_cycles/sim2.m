function[tot_Loss_R,tot_Loss_F,tot_Loss_N,dt,total_time,intres]=sim2()
%
%
[~, ~,~,~,Rmot,fmot,nmot]=Iloss;
[~, Itake, Icruise, Lrear, Lfwings, Lnwings, AreaR , Areafwing ,Areanwing, ~ , ~ , ~,densityCU]=Variables;


% Constants
%internal resistance of high performance lithium battery
%https://x-engineer.org/calculate-internal-resistance-battery-cell/#:~:text=For%20example%2C%20a%20high%2Dperformance,resistance%20of%20around%20200%20m%CE%A9.
%https://iopscience.iop.org/article/10.1088/1742-6596/2301/1/012014/pdf#:~:text=The%20result%20shows%20that%20the,of%20battery%20are%20nearly%20identical.
% reference above internal resistance of batteries decrease as temp
% increases thus modelling for worst case senario of const intres
intres = 50*10^-3;

Mrear = Lrear*AreaR*densityCU; % Mass rear cables (kg)
Mfwing = Lfwings*Areafwing*densityCU;
MnWing =Lnwings*Areanwing*densityCU;
C = 385;        % Specific heat capacity of copper
alfa = 0.00393;% coefficient of resistance for copper
TR_initial = 20; % Initial rear cablestemperature (degC)
TF_initial = 20;
TN_initial = 20;
RR_initial = Rmot;%initial resistance of rear tyres
RF_initial = fmot;
RN_initial = nmot;

dt = 1;         % Change in time (s)
TT =120;
CT = 10*60;
total_time = 2*TT + CT; % Total simulation time (s)

% Initialize variables
t = 0:dt:total_time;  % Time array
TR = zeros(size(t));   % Temperature array
TF = zeros(size(t));
TN = zeros(size(t));
RR = zeros(size(t)); % Resistance rear motor wires array
RF = zeros(size(t));
RN = zeros(size(t));
dRR = zeros(size(t)); %change in temp from initial
dRF = zeros(size(t));
dRN = zeros(size(t));

Energy_R = zeros(size(t)); %energy loss of rear wiring
Energy_F = zeros(size(t));
Energy_N = zeros(size(t));
% Initial condition
TR(1) = TR_initial;
TF(1) = TF_initial;
TN(1) = TN_initial;
RR(1) = RR_initial;
RF(1) = RF_initial;
RN(1) = RN_initial;
Energy_R(1)=0;
Energy_F(1)=0;
Energy_N(1)=0;
dRR(1) = 0;
dRF(1) = 0;
dRN(1) = 0;
% Calculate temperature over time
for i = 2:length(t)
    if i<TT || i>TT+CT
        current = Itake;
    else
        current = Icruise;
    end
    RR(i) =RR_initial*(1+alfa*dRR(i-1));
    RF(i) =RF_initial*(1+alfa*dRF(i-1));
    RN(i) =RN_initial*(1+alfa*dRN(i-1));
    TR(i) = (((current^2)*RR(i) * dt) / (Mrear * C)) + TR(i-1);
    TF(i) = (((current^2)*RF(i) * dt) / (Mfwing * C)) + TF(i-1);
    TN(i) = (((current^2)*RN(i) * dt) / (MnWing * C)) + TN(i-1);
    Energy_R(i) = ((current^2)*RR(i) * dt);
    Energy_F(i) = ((current^2)*RF(i) * dt);
    Energy_N(i) = ((current^2)*RN(i) * dt);
    dRR(i) = TR(i)-TR(1);
    dRF(i) = TF(i)-TF(1);
    dRN(i) = TN(i)-TN(1);
end
tot_Loss_R = sum(Energy_R);
tot_Loss_F = sum(Energy_F);
tot_Loss_N = sum(Energy_N);
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

% Add labels and legend
xlabel('Time (s)');
ylabel('Temperature');
title('Multiple Variables on the Same Plot');
legend('TR', 'TF', 'TN');

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