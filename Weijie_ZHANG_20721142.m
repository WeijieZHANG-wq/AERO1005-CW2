% Weijie ZHANG
% ssywz9@nottingham.edu.cn
clear; clc

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Connect MATLAB and Arduino
a = arduino('COM7', 'Uno');

% Blink an LED
for i = 1:10
    writeDigitalPin(a, 'D13', 1);
    pause(0.5);
    writeDigitalPin(a, 'D13', 0);
    pause(0.5);
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Record voltage and calculate temperature
duration = 601; % s
voltages = zeros(1,duration);
times = 0:duration-1;
V_0C = 0.5 % 500mV
T_C = 0.01 % 10 mV/C

for t = 1:duration
    voltages(t) = readVoltage(a, 'A0');
    pause(1);
end
temp = (voltages - V_0C) / T_C;

T_min = min(temp);
T_max = max(temp);
T_avg = mean(temp);

% Plot a temperature/time graph
plot(times/60, temp);
xlabel('Time (min)'); ylabel('Temperature (°C)');
title('Task 1: Temperature Recording');
saveas(gcf, 'temp_plot_task1.png');

% Formatted output recorded data
fprintf('Data logging initiated - %s\n', datestr(now, 'dd/mm/yyyy'));
fprintf('Location - Nottingham\n');
for min = 0:10
    idx = min*60 + 1;
    fprintf('Minute %d\tTemperature %.2f C\n', min, temp(idx));
end
fprintf('Max temp %.2f C\n', T_max);
fprintf('Min temp %.2f C\n', T_min);
fprintf('Average temp %.2f C\n', T_avg);
fprintf('Data logging terminated\n');

% Write the data into txt file
fid = fopen('capsule_temperature.txt', 'w');
fprintf(fid, 'Data logging initiated - %s\n', datestr(now, 'dd/mm/yyyy'));
fprintf(fid, 'Location - Nottingham\n');
for min = 0:10
    idx = min*60 + 1;
    fprintf(fid, 'Minute %d\tTemperature %.2f C\n', min, temp(idx));
end
fprintf(fid, 'Max temp %.2f C\n', T_max);
fprintf(fid, 'Min temp %.2f C\n', T_min);
fprintf(fid, 'Average temp %.2f C\n', T_avg);
fprintf(fid, 'Data logging terminated\n');
fclose(fid);

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% function temp_monitor(a);


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% function temp_prediction(a);
