% Define the RPM values for x-axis
rpm = [0, 1000, 2000, 3000, 4000, 5000, 5800];

% Define the power and torque values for y-axis
continuous_power = [0, 25, 50, 100, 130, 125, 90];
peak_power = [0, 50.0, 100.0, 160, 210, 200, 150];
continuous_torque = [290, 290, 290, 300, 310, 210, 170];
peak_torque = [480, 480, 500, 510, 510, 400, 260];

% Create a new figure
figure;

% Plot the power curves
subplot(2, 1, 1);
plot(rpm, continuous_power, 'b-');
hold on;
plot(rpm, peak_power, 'r-');
xlabel('RPM /min^{-1}');
ylabel('Power /kW');
title('Continuous and Peak Power');
legend('Continuous Power', 'Peak Power', 'Location', 'NorthWest');
grid on;

% Plot the torque curves
subplot(2, 1, 2);
plot(rpm, continuous_torque, 'b-');
hold on;
plot(rpm, peak_torque, 'r-');
xlabel('RPM /min^{-1}');
ylabel('Torque /Nm');
title('Continuous and Peak Torque');
grid on;