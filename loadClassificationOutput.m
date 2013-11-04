% from https://soundsoftware.ac.uk/projects/aasp-d-case-metrics
function [fileID,classID] = loadClassificationOutput(filename)

% Open raw file
fid = fopen(filename,'r+');

% Read 1st line
tline = fgetl(fid);
fileID{1} = char(sscanf(tline, '%s\t%*s'));
classID{1} = char(sscanf(tline, '%*s\t%s'));

% Read rest of the lines
i=1;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    if (ischar(tline))
        
        fileID{i} = char(sscanf(tline, '%s\t%*s'));
        classID{i} = char(sscanf(tline, '%*s\t%s'));

    end;
end

% Close file
fclose(fid);

