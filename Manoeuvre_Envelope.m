Precision = 64 ;
VcEAS = 67.056;
MTOW = 2400;
Rho = 1.225;
Sw = 13.33;
etabar = deg2rad(30);
Vbar = 0.6757;
a2 = 3.5;
H0 = 3.4/1.11;
Hfwd = 3.302;
a1 = 2.8638;
a = 5.2696;
Lt = 3.10878;
dEpsilon_dAlpha = 0; %% Downwash Effect on Tailplane Lift
Mu1 = (MTOW)/(Rho*Sw*Lt) ;%non-dimensionalised Longitudinal Relative Density
CruiseSpeed = VcEAS*1.5; %poorly named, Gives the Dive speed based off cruise speed
sf = 1.5; %Safety Factor (doesn't do anything in this code but could be used to show structural limits)
clMax = 1.5; 
gLim=2.2;
for I=1:Precision
    gLimPos=gLim; %G Limits defined by requirements
    gLimNeg= gLimPos/2; %Negative tends to be half the positive
    VEAS = (I*((CruiseSpeed)/Precision)); %Speed for current loop iteration
    cl = (MTOW*9.81)/(0.5*Rho*VEAS*VEAS*Sw); %Coefficient of Lift for this given speed (doesn't actually have a limit)
    n = etabar/( (cl/(Vbar*a2)) *(  (H0-Hfwd) + Vbar*( ( (a1/a)*(1-dEpsilon_dAlpha) ) + a1/(2*Mu1)  ) )); %The number of G you can pull with a given elevator deflection
   % n = (.5*clMax*VEAS*VEAS*1.225*Sw)/(MTOW*9.81);


    if n>gLimPos %prevents the N going outside the limit loads
        npos=gLimPos;
    else
        npos=n;
    end

    if n>gLimNeg
        nneg = -gLimNeg;
    else
        nneg = -n;
    end
    Velocity(1,I) = VEAS;
    ManLimPos(1,I) = npos;
    ManLimNeg(1,I) = nneg; %Stores the values in arrays
end

gLim=3.8;
for I=1:Precision
    gLimPos=gLim; %G Limits defined by requirements
    gLimNeg= gLimPos/2; %Negative tends to be half the positive
    VEAS = (I*((CruiseSpeed)/Precision)); %Speed for current loop iteration
    n = (.5*clMax*VEAS*VEAS*1.225*Sw)/(MTOW*9.81);


    if n>gLimPos %prevents the N going outside the limit loads
        npos=gLimPos;
    else
        npos=n;
    end

    if n>gLimNeg
        nneg = -gLimNeg;
    else
        nneg = -n;
    end
    Velocity1(1,I) = VEAS;
    ManLimPos2(1,I) = npos;
    ManLimNeg3(1,I) = nneg; %Stores the values in arrays
end


Vs = ManLimPos;
Vs(1,:) = 40; %Stall speed in m/s

Va = ManLimPos;
Va(1,:) = sqrt((gLim*MTOW*9.81)/(.5*clMax*Rho*Sw)); %Cruise Speed in m/s

Vc = ManLimPos;
Vc(1,:) = 67.056; %Cruise Speed in m/s

Vd = ManLimPos;
Vd(1,:) = 1.5 * Vc(1,1); %Dive Speed in m/s

%GustFactor = (0.88*Mu1)/(5.3+Mu1); %Gust Factor from Equations
GustFactor = 1.2;

GustNPos(1,1) = 0;
GustNPos(2,1) = 1;
GustNPos(1,2) = Vc(1,1);
GustNPos(2,2) = 1 - ((GustFactor*Rho*a*Vc(1,1)*15.24)/(2*MTOW)); %Cruise speed gust
GustNPos(1,3) = Vd(1,1);
GustNPos(2,3) = 1 - ((GustFactor*Rho*a*Vd(1,1)*7.62)/(2*MTOW)); %Dive speed gust
GustNPos(1,4) = 1;
GustNPos(2,4) = 1;

GustNNeg(1,1) = 0;
GustNNeg(2,1) = 1;
GustNNeg(1,2) = Vc(1,1);
GustNNeg(2,2) = 1 + ((GustFactor*Rho*a*Vc(1,1)*15.24)/(2*MTOW)); %Negative Cruise Speed Gust
GustNNeg(1,3) = Vd(1,1);
GustNNeg(2,3) = 1 + ((GustFactor*Rho*a*Vd(1,1)*7.62)/(2*MTOW)); %Negative Dive Speed Gust
GustNNeg(1,4) = 1;
GustNNeg(2,4) = 1;

%%Plots Everything
hold on
plot(Velocity,ManLimPos,"color",[0, 84/255, 255/255], 'LineWidth', .6)
plot(Velocity,ManLimNeg,"color",[0, 84/255, 255/255], 'LineWidth', .6)

%plot(Velocity1,ManLimPos2,"color",[84/255, 84/255, 255/255])
%plot(Velocity1,ManLimNeg3,"color",[84/255, 0, 255/255])

plot(GustNNeg(1,:),GustNNeg(2,:),"color",[0, 43/255, 130/255],"LineStyle","--", 'LineWidth', .6)
plot(GustNPos(1,:),GustNPos(2,:),"color",[0, 43/255, 130/255],"LineStyle","--", 'LineWidth', .6)

%plot(Vs,ManLimPos,"k")
%plot(Vs,ManLimNeg,"k")
xline(Vs(1),"Label","Vs", 'linestyle', '-');

%plot(Va,ManLimPos,"k")
%plot(Va,ManLimNeg,"k")
xline(Va(1),"Label","Va", 'linestyle', '-');

%plot(Vc,ManLimPos,"k")
%plot(Vc,ManLimNeg,"k")
xline(Vc(1),"Label","Vc", 'linestyle', '-');

%plot(Vd,ManLimPos,"k")
%plot(Vd,ManLimNeg,"k")
xline(Vd(1),"Label","Vd", 'linestyle', '-');

ax=gca;
ax.XAxisLocation = "origin";
ax.YAxisLocation = "origin";
xlabel('Velocity /{ms^{-1}}', 'Position', [72, -2.35]);
ylabel('Load Factor');
ylim([-2,3])
box on
ax = gca
ax.LineWidth = 0.8
hold off
