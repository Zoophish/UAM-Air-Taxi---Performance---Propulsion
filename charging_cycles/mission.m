function [eff] = mission(rpm_T)
% goal of this function is to get a good estimation of effeciency based on
% the current rpm and torque requirements
% this data is significant as it shows how the motor claims 96% efficiency
% but that is at 1 specific torque and rpm value that at best it achieves a
% more consistant 95% and at takeoff where rpm and torque demands may be
% higher may require a much lower efficiency
load("rpm_T.mat");
%calling function to get efficiency cyrves
[nineseven,ninesix,ninetwo,eighteight,eightthree] = efficiency();
% Extract x and y coordinates
xnineseven= nineseven(:, 1);
ynineseven = nineseven(:, 2);
xninesix = ninesix(:, 1);
yninesix = ninesix(:, 2);
xninetwo = ninetwo(:, 1);
yninetwo = ninetwo(:, 2);
xeighteight = eighteight(:, 1);
yeighteight = eighteight(:, 2);
xeightthree = eightthree(:, 1);
yeightthree = eightthree(:, 2);

% This section contains the current Torque and rpm in the mission and will
% be used to extract the efficiency at that time

% rpm_T = [
%     2500 410
%     4000 500
%     5000 400
%     4000 400
%     ];
% assuming rpm must not exceeed 5500 and torque 500

speed = rpm_T(:, 2);
Torque = rpm_T(:, 1);

% Combine values considered as coordinates
all_coordinates = {nineseven,ninesix,ninetwo,eighteight,eightthree};

% Initialize values
% min_distance = Inf;
% closest = -1;

eff = size(speed);
for t = 1:length(speed)
    % initialise eff
    min_distance = Inf;
closest = -1;
% Iterate over each set of coordinates
for i = 1:length(all_coordinates)
    % Extract x and y coordinates from the current set
    x_coords = all_coordinates{i}(:, 1);
    y_coords = all_coordinates{i}(:, 2);

    % Calculate Euclidean distance
    distances = sqrt((x_coords - Torque(t)).^2 + (y_coords - speed(t)).^2);

    % Find the minimum distance and update the index if needed
    [min_dist_i, ~] = min(distances);

    if min_dist_i < min_distance
        min_distance = min_dist_i;
        closest = i;
    end
    %using this fo get a efficiency percentage
    if closest == 1
        eff(t) = 0.97;
    elseif closest ==2
        eff(t) = 0.96;
    elseif closest == 3
        eff(t) = 0.92;
    elseif closest == 4
        eff(t) = 0.88;
    elseif closest == 5
        eff(t) = 0.83;
        if speed(t)> 4400
            eff(t) = 0.86;
        end

    end
end
%fprintf('The closest set of coordinates is set #%d\n', eff);
end

% Display the result
%fprintf('The closest set of coordinates is set #%d\n', eff);


%
%
%
%
%
%
%
%
%
%
%
%
% here we deal with plots of all values
% Extract x and y coordinates

% Plot both shapes
figure;
plot(xnineseven, ynineseven, 'o-', 'DisplayName', '97%');
hold on;
plot(xninesix, yninesix, 's-', 'DisplayName', '96%');
plot(xninetwo, yninetwo, 's-', 'DisplayName', '92%');
plot(xeighteight, yeighteight, 's-', 'DisplayName', '88%');
plot(xeightthree, yeightthree, 's-', 'DisplayName', '83%');

plot(Torque, speed, 'x-', 'DisplayName', 'Current Values','LineWidth',2);


hold off;

xlabel('RPM');
ylabel('Torque');
title('Efficiency Curves');
legend('Location', 'Best');
grid on;
end