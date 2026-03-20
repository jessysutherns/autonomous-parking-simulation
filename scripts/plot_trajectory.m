% plot_trajectory.m
% Purpose:
% Visualizes vehicle trajectory, parking slots, and final configuration
% for different autonomous parking maneuvers.

% REQUIREMENTS:
% - Simulink model must be run first
% - Workspace variables required:
%   XPosScope, YPosScope, CarOrientationScope, TrailerOrientationScope

clear; clc;

%% Load Maneuver Selection
try
maneuver_select = evalin('base', 'manselect');
disp(['Selected Maneuver: ', num2str(maneuver_select)]);
catch
error('Define "manselect" (1–6) in workspace before running.');
end

%% Load Position Data
try
x_car = XPosScope.signals.values;
y_car = YPosScope.signals.values;
time = XPosScope.time;
catch
error('Simulation data not found. Run Simulink model first.');
end

%% Load Orientation
try
car_theta = CarOrientationScope.signals.values;
catch
error('Car orientation data missing.');
end

%% Plot Trajectory
figure;
plot(x_car, y_car, 'g--', 'LineWidth', 2);
hold on;

xlabel('X Position (m)');
ylabel('Y Position (m)');
title(['Vehicle Trajectory - Maneuver ', num2str(maneuver_select)]);
grid on;
axis equal;

%% Define Vehicle Dimensions
car_length = 4;
car_width = 1.5;

%% Final Position
final_x = x_car(end);
final_y = y_car(end);
theta = car_theta(end);

%% Compute Car Geometry
car_x = final_x - car_length/2 * cos(theta);
car_y = final_y - car_length/2 * sin(theta);

car_corners = [
car_x + car_length/2*cos(theta) - car_width/2*sin(theta), car_y + car_length/2*sin(theta) + car_width/2*cos(theta);
car_x + car_length/2*cos(theta) + car_width/2*sin(theta), car_y + car_length/2*sin(theta) - car_width/2*cos(theta);
car_x - car_length/2*cos(theta) + car_width/2*sin(theta), car_y - car_length/2*sin(theta) - car_width/2*cos(theta);
car_x - car_length/2*cos(theta) - car_width/2*sin(theta), car_y - car_length/2*sin(theta) + car_width/2*cos(theta);
car_x + car_length/2*cos(theta) - car_width/2*sin(theta), car_y + car_length/2*sin(theta) + car_width/2*cos(theta)
];

plot(car_corners(:,1), car_corners(:,2), 'k-', 'LineWidth', 1.5);

%% Display Result
disp(['Final Position: (', num2str(final_x), ', ', num2str(final_y), ')']);

hold off;
