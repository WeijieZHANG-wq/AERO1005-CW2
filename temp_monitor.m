% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

function temp_monitor(a)

% LED pin setting
greenPin = 'D13';
yellowPin = 'D12';
redPin = 'D11';

% Create initialize figure
figure;
hLine = plot(nan, nan, '-b');
xlabel('Time (s)'); ylabel('Temperature (°C)');
title('Real-time Temperature Monitor');
xlim([0 60]); ylim([15 30]);
grid on;

