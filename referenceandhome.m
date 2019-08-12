%{ 
 referenceandhome.m
 PURPOSE: 
    Reference and home an axis to zero. 
 TAKES:
    Index of axis to reference, as a string
 Note: leaves axis in closed loop mode.
 Last modified by Hannah Kolano, 5/15/2019
 %}

function referenceandhome(ax)

global E712;

E712.FRF(ax);       % Reference the axis
fprintf('Stage is referencing.');
while (E712.qFRF(ax) == 0)
end
fprintf('\n Stage referenced. \n');
pause(.1)

E712.SVO(ax, 1);    % Set to closed-loop mode
pause(.1);
E712.MOV(ax, 0);    % Move to position 0
pause(2)
fprintf('Homed. Position is: %f \n', E712.qPOS(ax)) % Display current position
pause(.1);


end