%{
Patrick O'Hagan
MECH 103
12/6/2019

Final Project:
Reaction time game
%}

clear
clc

%Description
%{
This program will be paired with a circuit that contains four buttons and
four corrisponding LEDs. 

When the program starts it will randomly light up any of the four LEDs and
start a timer. The timer will stop when the correct button is pressed and
the program will log the reaction time in a table called reactionTimes. 

For each iteration of the program only 10 different LEDs will light up thus
for each individual there will only be 10 trials.

Once the game is finished a tone will play.
%}

reactionArduino = arduino();
configurePin(reactionArduino,'D2','DigitalInput');
configurePin(reactionArduino,'D3','DigitalInput');
configurePin(reactionArduino,'D4','DigitalInput');
configurePin(reactionArduino,'D5','DigitalInput');
configurePin(reactionArduino,'D12','DigitalOutput');
configurePin(reactionArduino,'D11','DigitalOutput');
configurePin(reactionArduino,'D10','DigitalOutput');
configurePin(reactionArduino,'D9','DigitalOutput');

% LED Pins
red = 'D12';
blue = 'D11';
yellow = 'D10';
green = 'D9';

% Button Input Pins
redButton = 'D5';
blueButton = 'D4';
yellowButton = 'D3';
greenButton = 'D2';

% Sets the number of trials and also matches up the data slots
trials = 1:10; % This is the trial array for the game
control_data = 1:10; % Must be same size as trials
experiment_data = 1:10;

for i = trials
    LED_num = randi([1,4],1,1); % Select random number between 1 and 4
    if LED_num == 1 % Checks the randomly selected number
        LED = red; % Sets the LED variable to the pin designation based on the random number
        button = redButton; % Sets the button varibale based on the random number
        writeDigitalPin(reactionArduino,LED,1); % turns on the LED 
    elseif LED_num == 2
        LED = blue;
        button = blueButton;
        writeDigitalPin(reactionArduino,LED,1);
    elseif LED_num == 3
        LED = yellow;
        button = yellowButton;
        writeDigitalPin(reactionArduino,LED,1);
    elseif LED_num == 4
        LED = green;
        button = greenButton;
        writeDigitalPin(reactionArduino,LED,1);
    end
    
    tic() % starts the timer
    
    button_state = 0; % Sets initial button_state to 0
    while(button_state == 0) % Loops while true
        button_state = readDigitalPin(reactionArduino,button);
        if button_state == 1 
            % display(button_state)
            writeDigitalPin(reactionArduino,LED,0); % Turns off the LED
            toc() % Ends the timer
            control_data(1,i) = toc(); % Inputs the time data into the data slot
        end
    end
    
    pause(1)
    
end

pause; % Pauses the program between the control and the experimental data

for i = trials
    LED_num = randi([1,4],1,1); % Select random number between 1 and 4
    if LED_num == 1 % Checks the randomly selected number
        LED = red; % Sets the LED variable to the pin designation based on the random number
        button = redButton; % Sets the button varibale based on the random number
        writeDigitalPin(reactionArduino,LED,1); % turns on the LED 
    elseif LED_num == 2
        LED = blue;
        button = blueButton;
        writeDigitalPin(reactionArduino,LED,1);
    elseif LED_num == 3
        LED = yellow;
        button = yellowButton;
        writeDigitalPin(reactionArduino,LED,1);
    elseif LED_num == 4
        LED = green;
        button = greenButton;
        writeDigitalPin(reactionArduino,LED,1);
    end
    
    tic() % starts the timer
    
    button_state = 0; % sets the initial state to 0 as contingency
    while(button_state == 0) % while button isn't pressed
        button_state = readDigitalPin(reactionArduino,button); % reads the button state
        if button_state == 1 % if button is pushed...
            % display(button_state) 
            writeDigitalPin(reactionArduino,LED,0); % turn off led
            toc() % end timer
            experiment_data(1,i) = toc(); % record time
        end
    end
    
    pause(1)
    
end

controlAverage = mean(control_data); % Averages the control data
experimentalAverage = mean(experiment_data); % Average the experimental data

plot(trials, control_data, "k*") % plots control data
hold on
plot(trials, experiment_data, "r*") % plots experimental data
hold on
plot(trials, controlAverage*ones(size(trials)), "-k") % plots control mean
hold on
plot(trials, experimentalAverage*ones(size(trials)), "-r") % plots experimental mean
hold off
title("Reaction Time")
legend("Control", "Experimental", "Control Average", "Experimental Average")
xticks(trials)
xlabel("Trial Number")
ylabel("Time (s)")