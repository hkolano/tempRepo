%{ 
 SetUpTables.m 
 PURPOSE: Modify # of tables for # of parameters being recorded
 TAKES:
    RecOptions, a vector [] of "Recording Options", of length n
 DOES:
    Configures the number of data tables to n
 RETURNS:
    recordTables, a vector of length n, designating the tables
 Last modified by Hannah Kolano, 5/15/2019
 %}

function recordTables = setuprecordingtables(RecOptions)

global E712;

numtables = length(RecOptions);    % check how many variables we're recording

if (numtables > 12)
    fprintf('Can only handle 12 variables. Check RecordOptions.')
    return
end

recordTables = [1:1:numtables];     % enumerate the tables we'll have

E712.CCL(1, 'advanced');            % change control level to 1 to access parameters
E712.SPA('1', hex2dec('16000300'), numtables);  % set the number of data tables to the number of variables
fprintf(' %f tables set up \n', numtables);

for n = 1:numtables                 
    E712.DRC(recordTables(n), '1', RecOptions(n));    % assign RecOptions 
end

end