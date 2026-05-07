function temp_prediction(a)
a = arduino

% LED pin setting
greenPin = 'D13';
yellowPin = 'D12';
redPin = 'D11';

windowSize = 20;
    timeWindow = [];
    tempWindow = [];
    startTime = tic;

fprintf('Time(s)\tTemp(°C)\tRate(°C/s)\tPredicted5min(°C)\n');

while true
    voltage = readVoltage(a, 'A0');
    currentTemp = (voltage - 0.5) / 0.01;
    currentTime = toc(startTime);

    timeWindow = [timeWindow, currentTime];
    tempWindow = [tempWindow, currentTemp];
    if length(timeWindow) > windowSize
        timeWindow = timeWindow(end-windowSize+1:end);
        tempWindow = tempWindow(end-windowSize+1:end);
    end

    % Calculate rate
    if length(timeWindow) >= 2
        p = polyfit(timeWindow, tempWindow, 1);
        rate = p(1);
    else
        rate = 0;
    end
    % Expected temperature in 5 minutes
    predictedTemp = currentTemp + rate * 300;

    fprintf('%.1f\t%.2f\t%.3f\t%.2f\n', currentTime, temp, rate, predictedTemp);

    % LED indication
    if abs(rate * 60) > 4
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 1);
    elseif rate * 60 > -4
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, greenPin, 1);
    else  % rate * 60 < -4
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, greenPin, 0);
    end

    pause(1);
end
end