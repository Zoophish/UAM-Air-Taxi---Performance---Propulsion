function [dissipation,invertor_eff_loss] = invertor()




load("sinhundV.mat");
load("hundV.mat");
load("eighthundV.mat");
load("fourhundV.mat");
load("eightthree.mat");

[voltage,PowerIn,eff,PowerOut,current,energy] = VI_to_motor();

x = length(voltage);

dissipation = zeros(1,x);
invertor_eff_loss1 = zeros(1,x);
invertor_eff_loss = zeros(x,1);
c = current/sqrt(2);

for i = 1:x

if voltage(i) <300

    j = hundV(:,1);

    [~, idx] = min(abs(j - c(i)));
    
    % Extract the value from the second column of hundV corresponding to
    % the found current
    dissipation(i) = hundV(idx, 2);
    


elseif voltage(i)>= 300 && voltage(i)<500

     y = fourhundV(:,1);

    [~, idx] = min(abs(j - c(i)));
    
    % Extract the value from the second column of hundV corresponding to
    % the found current
    dissipation(i) = fourhundV(idx, 2);

    elseif voltage(i)>= 500 && voltage(i)<700

         z = sinhundV(:,1);

    [~, idx] = min(abs(z - c(i)));
    
    % Extract the value from the second column of hundV corresponding to
    % the found current
    dissipation(i) = sinhundV(idx,2);

        elseif voltage(i)>= 700

             w = eighthundV(:,1);

    [~, idx] = min(abs(j - c(i)));
    
    % Extract the value from the second column of hundV corresponding to
    % the found current
    dissipation(i) = eighthundV(idx,2);
            

end
invertor_eff_loss1(i) = 1 - dissipation(i)/PowerOut(i);
invertor_eff_loss(i) = transpose(invertor_eff_loss1(i));
end
