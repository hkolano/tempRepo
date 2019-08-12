%{ 
 sendaxistoposition.m
 PURPOSE: 
    Sends the axis to an absolute position. 
 TAKES:
    (1) Index of axis to reference, as a string
    (2) The desired absolute position

 Note: leaves axis in closed loop mode.
 Last modified by Hannah Kolano, 8/7/2019
 %}

function sendaxistoposition(AX, pos)

    global E712;
    
    % Save set parameters
    origSSA = E712.qSSA(1);
    origSL = E712.qSPA('1', hex2dec('7011700'));
    
    % Change parameters to defaults for the move
    fprintf('Setting Step Size and SSA to default for the move. Moving to position... \n')
    E712.SSA(1, 250);
    E712.SPA('1', hex2dec('7011700'), 25);
    
    % Make the move
    E712.SVO(AX, 1);    % Set to closed-loop mode
    pause(.1);
    E712.MOV(AX, pos);    % Move to given position
    while E712.IsMoving(AX)
    end
    pause(.1)
    
    % Display current position
    fprintf('Done. Position is: %f \n', E712.qPOS(AX)) 
    pause(.1);
    
    % Return SSA and Step Size to previous values 
    E712.SSA(1, origSSA);
    E712.SPA('1', hex2dec('7011700'), origSL);
    fprintf('Step Size and SSA have been reset. \n')
end