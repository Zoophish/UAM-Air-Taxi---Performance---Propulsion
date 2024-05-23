function [BatteryMass,wireMass,totMass,totEnergy,mechPower,ResPowerloss]= Masses()

% this fuction is used to calculate the masses of all circuitry elements

[ResLoss,usedPower,wireMass,current,WLWing,WLRear,WLfront,Areaw,densityCU]= variables2();

mechPower = sum(usedPower);
ResPowerloss = sum(ResLoss);
totEnergy = sum(ResLoss) + sum(usedPower);
% Battery Energy Densisty
  WHdens = 500; % Wh/kg
% convert to joules per Kg
Whconv = 3600;
Edens = WHdens*Whconv;

%multiply by 1.25 for 80% battery healt safety factor
BatteryMass = (totEnergy(1)*1.25)/Edens;
totMass = BatteryMass+wireMass;
% Or use fprintf
%fprintf('Battey mass: %d\n',BatteryMass );
