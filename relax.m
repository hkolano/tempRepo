%{ 
 relax.m
 PURPOSE: a quick call to relax the PiezoWalk steppers, for longetivity.
 USAGE: call in the command line when the stage is not in use.
 Last modified by Hannah Kolano, 7/30/2019
 %}

%% Check relevant parameters
if (~exist ('E712'))       % check that the controller is connected
    disp('No current communication with controller; cannot relax.');
    return;
end

% Change Axis 1 to open-loop mode
E712.SVO('1', 0);

pause(1);
E712.RNP(1, 0);     % Relax steppers