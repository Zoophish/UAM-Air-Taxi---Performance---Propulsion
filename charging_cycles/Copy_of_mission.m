function [eff] = mission()
% goal of this function is to get a good estimation of effeciency based on
% the current rpm and torque requirements
% this data is significant as it shows how the motor claims 96% efficiency
% but that is at 1 specific torque and rpm value that at best it achieves a
% more consistant 95% and at takeoff where rpm and torque demands may be
% higher may require a much lower efficiency

%calling function to get efficiency cyrves
[eightysix,ninety,ninethree,ninefour,ninefive] = efficiency();
% Extract x and y coordinates
xeightysix = eightysix(:, 1);
yeightysix = eightysix(:, 2);
xninety = ninety(:, 1);
yninety = ninety(:, 2);
xninethree = ninethree(:, 1);
yninethree = ninethree(:, 2);
xninefour = ninefour(:, 1);
yninefour = ninefour(:, 2);
xninefive = ninefive(:, 1);
yninefive = ninefive(:, 2);

% This section contains the current Torque and rpm in the mission and will
% be used to extract the efficiency at that time

rpm_T = [
    2500 410
    4000 500
    5000 400
    4000 400
    ];
speed = rpm_T(:, 2);
Torque = rpm_T(:, 1);
% Combine values considered as coordinates
all_coordinates = {eightysix, ninety, ninethree, ninefour, ninefive};

% Initialize values
min_distance = Inf;
closest = -1;

% Iterate over each set of coordinates
for i = 1:length(all_coordinates)
    % Extract x and y coordinates from the current set
    x_coords = all_coordinates{i}(:, 1);
    y_coords = all_coordinates{i}(:, 2);

    % Calculate Euclidean distance
    distances = sqrt((x_coords - rpm_T(1)).^2 + (y_coords - rpm_T(2)).^2);

    % Find the minimum distance and update the index if needed
    [min_dist_i, ~] = min(distances);

    if min_dist_i < min_distance
        min_distance = min_dist_i;
        closest = i;
    end
    %using this fo get a efficiency percentage
    if closest == 1
        eff = 0.86;
    elseif closest ==2
        eff = 0.9;
    elseif closest == 3
        eff = 0.93;
    elseif closest == 4
        eff = 0.94;
    elseif closest == 5
        eff = 0.95;
        if speed> 4400
            eff = 0.86;
        end

    end
end

% Display the result
fprintf('The closest set of coordinates is set #%d\n', eff);


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
xninefive = ninefive(:, 1);
yninefive = ninefive(:, 2);
% Plot both shapes
figure;
plot(xeightysix, yeightysix, 'o-', 'DisplayName', '86%');
hold on;
plot(xninety, yninety, 's-', 'DisplayName', '90%');
plot(xninethree, yninethree, 's-', 'DisplayName', '93%');
plot(xninefour, yninefour, 's-', 'DisplayName', '94%');
plot(xninefive, yninefive, 's-', 'DisplayName', '95%');
plot(Torque, speed, 'x', 'DisplayName', 'current values');


hold off;

xlabel('RPM');
ylabel('Torque');
title('Efficiency Curves');
legend('Location', 'Best');
grid on;
end