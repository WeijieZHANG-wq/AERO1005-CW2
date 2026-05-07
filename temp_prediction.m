function temp_prediction(a)

% LED pin setting
greenPin = 'D13';
yellowPin = 'D12';
redPin = 'D11';

historyTime = [];
historyTemp = [];
windowLength = 60;
startTime = tic;

fprintf('Time(s)\tTemp(°C)\tRate(°C/s)\tPredicted5min(°C)\n');

while true
    loopStart = tic;

    voltage = readVoltage(a, 'A0');
    currentTemp = (voltage - 0.5) / 0.01;
    currentTime = toc(startTime);

    timeWindow = [timeWindow, currentTime];
    tempWindow = [tempWindow, temp];
    if length(timeWindow) > windowSize
        timeWindow = timeWindow(end-windowSize+1:end);
        tempWindow = tempWindow(end-windowSize+1:end);
    end

    % 计算变化率（线性拟合）
    if length(timeWindow) >= 2
        p = polyfit(timeWindow, tempWindow, 1);
        rate = p(1);  % °C/s
    else
        rate = 0;
    end

    predictedTemp = temp + rate * 300;  % 5分钟预测

    fprintf('%.1f\t%.2f\t%.3f\t%.2f\n', currentTime, temp, rate, predictedTemp);

    % LED 阈值 (每分钟4°C)
    if abs(rate * 60) < 4
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    elseif rate * 60 > 4
        writeDigitalPin(a, redPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, greenPin, 0);
    else  % rate * 60 < -4
        writeDigitalPin(a, yellowPin, 1);
        writeDigitalPin(a, redPin, 0);
        writeDigitalPin(a, greenPin, 0);
    end

    pause(1);
end
end