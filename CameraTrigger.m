%{ 
 CameraTrigger.m 
 PURPOSE: 
    Provide a 500Hz trigger for the camera.
 Last modified by Hannah Kolano, 8/8/2019
 %}

%% One-time Setup

% Controller
if (~exist ('E712'))       % Connect the controller if it isn't already
    startcomms;
end

% Variables
AX = '1';              % Axis index
clear varTypes;        % fix for bad code 
WALK_CHAN = 1;         % PiezoWalk channels. For ours, 1 
NSTEPS = 1000;         % number steps to walk
START_POSITION = -20000; % position along the runner to start. -21000 to 21000
TARGET_FREQ = 500;      % Target frequency, in Hz
COMM_STEP_SIZE = 1000/TARGET_FREQ;  % Decides on a normalization factor to achieve the intended frequency


%% Test Parameters
E712.SPA('1', hex2dec('07000204'), 1000);   % set open-loop velocity to 1 mm/s 
E712.SPA('1', hex2dec('7011900'), 1/TARGET_FREQ);    % Set max frequency to 500Hz (Min Cycle Time to .002ms)
E712.SPA('1', hex2dec('7011700'), COMM_STEP_SIZE)


%% Data recording
recordedVars = [2, 16, 27];    % what we want to record (see results of E712.qHDR or see getcolumntitles)
    % 2 = Current Position of Axis (runner, in um)
    % 16 = Voltage of Output Channel (waveform sent to one of the Piezo
    % devices)
    % 27 = Digital Out
recordTables = setuprecordingtables(recordedVars);      % Configures data recording on the controller


%% Initialize Stage
referenceandhome(AX);   % reference the axis, moves it to center
pause(.1);       
sendaxistoposition(AX, START_POSITION);  % send axis to its starting position


%% Configure Trigger
%{ 
Read in sets of three: { OUT#, parameter, value }
Parameters:
    1 = Trigger Step    2 = Axis 
    3 = Trigger Mode    5 = Min.Threshold 
    6 = Max.Threshold   7 = Polarity  
    8 = Start Threshold 9 = Stop Threshold 
1, 2, 1 is: set DigOut channel (1)'s axis (2) to be axis number 1 (1)
1, 3, 0 is: set DigOut channel (1)'s Trigger Mode (3) to be Position Distance(0)
see the E712 manual page 148 section 8.2 for trigger modes
%}

% DigOut 1 outputs a pulse every time axis 1 travels 5um
E712.CTO(1, 2, 1);  % set axis to 1
E712.CTO(1, 3, 0);  % set trigger output to "position distance"
E712.CTO(1, 1, 25);  % set it to trigger every 25um


%% Run Test

fprintf('Running Test... \n')
xZero = E712.qPOS(AX);          % Record starting position of axis
E712.SVO('1', 0);               % Set to open loop mode
pause(1.5)

E712.DRT(0, 1, '0');            % start recording at next command
E712.OSM(WALK_CHAN, NSTEPS);    % walk!
while (0 ~= E712.qOSN(WALK_CHAN))  %wait until there's no steps left to perform
    pause ( 0.01 );
end
xNew = E712.qPOS(AX);           % Record final position of axis
fprintf('Done. New position is: %f \n', xNew)


%% Read data from controller
START_POINT = 1;               % read the data from the beginning.
numPoints = E712.qDRL(1);      % Get number of data points recorded in table 1 (should be uniform)

disp('Retrieving data from controller...');
rawData = E712.qDRR(recordTables, START_POINT, numPoints);     % import data from recordTables on controller
disp('Retrieving data finished.');


%% Store data in a Matlab table
[varTitles, varIDs] = getcolumntitles(recordedVars);    % get the titles of what we recorded
varTypes(1:length(varTitles)) = {'double'};
DataTable = table('Size', [numPoints, length(varTitles)], 'VariableType', varTypes, 'VariableNames', varIDs);

for k = 1:length(varIDs)
    DataTable.(k) = rawData(:,k);
end
    
%% Parse table for trigger values
[~, triggerOnIndices] = findpeaks(DataTable.digitalOut);    % Find the trigger indices
triggerTimes = DataTable.time(triggerOnIndices);            % Find the trigger times
triggerPositions = DataTable.currentPos(triggerOnIndices);  % Find the trigger positions

% Get the intervals for sample length and time 
stepLengths = zeros(1, length(triggerTimes));               
sampleTimes = zeros(1, length(triggerTimes));
for m = 1:length(triggerTimes)-1
    stepLengths(m) = triggerPositions(m+1) - triggerPositions(m);
    sampleTimes(m) = triggerTimes(m+1) - triggerTimes(m);
end        
% Should be 25um and .002s

% Find the actual frequency
avgSampleTime = mean(sampleTimes);
avgFrequency = 1/avgSampleTime;
fprintf('The actual frequency is %.2f Hz. \n', avgFrequency)


%% plot data
%     plotdata(DataTable, varTitles, 'OSM');


%% Cleanup
relax;

