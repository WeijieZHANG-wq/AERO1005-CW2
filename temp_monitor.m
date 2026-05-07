% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
function temp_monitor(a)
a = arduino

% LED pin setting
greenPin = 'D13';
yellowPin = 'D12';
redPin = 'D11';

% Create initialize figure
figure;
hLine = plot(nan, nan, '-b');
xlabel('Time (s)'); ylabel('Temperature (°C)');
title('Real-time Temperature Monitor');
xlim([0 60]); ylim([15 35]);
grid on;
% Store data
timeData = [];
tempData = [];
startTime = tic;

while true
    % Read temperature
    voltage = readVoltage(a, 'A0');
    temp = (voltage - 0.5) / 0.01;
    % Record data
    
    timeData = [timeData, currentTime];
    tempData = [tempData, temp];
    % Update graph
    set(hLine, 'XData', timeData, 'YData', tempData);
    drawnow

    % LED control
    if temp >= 18 && temp <= 24
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
        
    elseif temp < 18
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 1); pause(0.5);
        writeDigitalPin(a, yellowPin, 0); pause(0.5);
        writeDigitalPin(a, redPin, 0);
    else  % temp > 24
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1); pause(0.25);
        writeDigitalPin(a, redPin, 0); pause(0.25);
    end
    elapsed = toc;
    if elapsed < 1
        pause(1 - elapsed);
    end
end
end