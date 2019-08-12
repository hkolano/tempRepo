%{ 
 plotdata.m 
 PURPOSE: Take a table and plot each of the recorded variables against time.
 Last modified by Hannah Kolano, 5/22/2019
 %}

function plotdata(DataTable, varTitles, testType)
   
    nVars = length(DataTable.Properties.VariableNames);

    for n = 1:(nVars-1)
        varTitle = varTitles{n+1};
        
        % don't plot TargetPos or CurrentPos if they're already being
        % plotted together
%         if ~(strcmp(varTitle, 'Target Position (um)') || strcmp(varTitle, 'Current Position (um)')) && alreadyPlottedPosition 
            figure('Name', varTitle)
            plot(DataTable.time, DataTable.(n+1));
            grid on

            title([varTitle ' over time for ' testType ' system']);
            xlabel('Time (s)');
            ylabel(varTitle);
%         end
        
%         if strcmp(varTitle, 'PiezoWalk Table Phase')
%             figure('Name', 'PiezoWalk Distance')
%             plot(DataTable.currentPos, DataTable.walkPhase)
%             title('PiezoWalk Phase over Distance')
%             xlabel('Distance (um)')
%             ylabel(varTitle)
%         end
    end

end

