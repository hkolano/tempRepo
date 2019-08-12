%{ 
 killcomms.m 
 PURPOSE: To disconnect the PC from the E-712.2AN Controller, to be used at
 the very end of scripts.
 Modeled after KillComms.m by Alex Hattori
 Last modified by Hannah Kolano, 5/9/2019
 %}

%% Close the Connection
E712.CloseConnection;

disp('Connection to Controller closed.');

Controller.Destroy;
clear Controller;
clear E712;
