%{ 
 startcomms.m 
 PURPOSE: To connect the PC to the E-712.2AN Controller.
    Modeled after StartComms.m by Alex Hattori.
    Creates global variable E712, a Controller object. 
 Last modified by Hannah Kolano, 5/15/2019

Note: If connection fails, restart Matlab and try again. The controller 
    needs time to warm up. 
 %}

%% Setup
instrreset
global E712;

%% Load PI MATLAB Driver GCS2
% Path to the PI MATLAB Driver 
addpath ( 'C:\Users\Public\PI\PI_MATLAB_Driver_GCS2' );

% Create controller if it does not already exist
if ( ~exist ( 'Controller', 'var' ) || ~isa ( Controller, 'PI_GCS_Controller' ) )
    Controller = PI_GCS_Controller ();
end

%% Start Connection via USB

boolPIdeviceConnected = false; if ( exist ( 'PIdevice', 'var' ) ), if ( PIdevice.IsConnected ), boolPIdeviceConnected = true; end; end;
if ( ~(boolPIdeviceConnected ) )
    % USB protocol (see manuals for TCP/IP or Serial)
    controllerSerialNumber = '119009040';
    E712 = Controller.ConnectUSB ( controllerSerialNumber );
end


% Initialize controller
E712 = E712.InitializeController();
disp('Controller connected via USB.');
