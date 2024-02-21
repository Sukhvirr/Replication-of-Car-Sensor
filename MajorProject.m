% EECS 1011 - Major Project
clear all; close all; clc;
a = arduino('COM3','Uno','Libraries','Ultrasonic');
ultrasonicObj = ultrasonic(a,'D2','D3');
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [0  180];
title('Distance from Ultrasonic Sensor vs Time (live)');
xlabel('Time [HH:MM:SS]'); ylabel('Distance [m]');
startTime = datetime('now');
stop = 0;

while stop ~= 1
distance = readDistance(ultrasonicObj);
distanceInCM = distance*100;
fprintf('The distance is %.2f cm.\n',distanceInCM);
t = datetime('now') - startTime;
addpoints(h,datenum(t),distanceInCM);
ax.XLim = datenum([t-seconds(15) t]);
datetick('x','keeplimits') ;
drawnow;
    if distanceInCM <=10
        writePWMDutyCycle(a,'D5',0.33);
        writeDigitalPin(a,'D4',1);
        pause(0.25)
        writePWMDutyCycle(a,'D5',0);
        writeDigitalPin(a,'D4',0);
    elseif distanceInCM >10 && distanceInCM<30
        writePWMDutyCycle(a,'D5',0.33);
        writeDigitalPin(a,'D4',1);
        pause(0.5)
        writePWMDutyCycle(a,'D5',0);
        writeDigitalPin(a,'D4',0);
    elseif distanceInCM >=30
        writePWMDutyCycle(a,'D5',0.33);
        writeDigitalPin(a,'D4',1);
        pause(0.75)
        writePWMDutyCycle(a,'D5',0);
        writeDigitalPin(a,'D4',0);
    end
stop = readDigitalPin(a,'D6');
end