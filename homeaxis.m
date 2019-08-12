%{ 
 homeaxis.m
 PURPOSE: 
    Home an axis to zero. 
 TAKES:
    Index of axis to reference, as a string
 Note: leaves axis in closed loop mode.
 Last modified by Hannah Kolano, 5/20/2019
 %}

function homeaxis(AX)

    global E712;
    
    E712.SVO(AX, 1);    % Set to closed-loop mode
    pause(.1);
    E712.MOV(AX, 0);    % Move to position 0
    while E712.IsMoving(AX)
    end
    pause(.1)
    fprintf('Homed. Position is: %f \n', E712.qPOS(AX)) % Display current position
    pause(.1);
end