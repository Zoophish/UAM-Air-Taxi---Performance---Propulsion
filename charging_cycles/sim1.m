%
%
%
%
%
%
dt = 1;%1 second time step
TT = 120;% takeoff time
CT = 10*60; % 10 minute cruise time
totT = TT + 2*CT;% TOTAL TIME
specCU = 385;% J/Kg degC
alfa = 0.00393;% temp coefficient of copper R u Rref( 1 + alfat(deltaTemp))
[TNLloss, CruiseLoss,Takeloss,Landloss,Rmot,fmot,nmot]=Iloss;
[rho, Itake, Icruise, Lrear, Lfwings, Lnwings, AreaR , Areafwing ,Areanwing, TnL , cruise , kWhcon,densityCU]=Variables;
% initialise temp
WireRearT = 20;% degC cables to rear prop
WirefWingT = 20;% degC cables to wide wing props
WirenWing = 20;% degC vable to near wing props
Mrear = Lrear*AreaR*densityCU;
Mwingf= Lfwings*Areafwing*densityCU;
Mwingn= Lnwings*Areanwing*densityCU;
DeltaTR = 1; % initial chnage in temp
DeltaTf = 1; % initial chnage in temp
DeltaTn = 1; % initial chnage in temp
% Reference CU resistances at 20 degC for each set of wires
Rref=Rmot;
Fref=fmot;
nref=nmot;
ResR = Rref;
Resf = Fref;
ResN = nref;
%initial lise prev temperatures
RTprev=Rmot;
FTprev=fmot;
NTprev=nmot;
% for loop goal model heating of copper wires during takeoff and landing

for t = 1:dt:totT

    if t <= TT
        current = Itake;
    elseif t>TT && t <=(TT+CT)
        current = Icruise;
    else
        current = Itake;

        % rear motor wires
        % Note 2 seperate and 1 big wiwre no diff as both I and radius are
        % squared
        ResR = Rref*(1+alfa*DeltaTR);
        WireRearT  = (((current^2)*ResR*dt)/(Mrear*specCU))+RTprev;
        DeltaTR = WireRearT- RTprev;
        RTprev = WireRearT;

        % further motor wires on wing

        Resf = Fref*(1+DeltaTf);
        WirefWingT   = (((current^2)*Resf*dt)/(Mwingf*specCU))+FTprev;
        DeltaTf = WirefWingT- FTprev;
        FTprev = WirefWingT;

        % Near wires on wing WirenWing  =
        ResN = nref*(1+DeltaTn);
        WirenWing  = (((current^2)*ResN*dt)/(Mwingn*specCU))+NTprev;
        DeltaTn = WirenWing- NTprev;
        NTprev = WirenWing;

        % itterate t


    end


end