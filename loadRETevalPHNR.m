%% Import RETeval sinusoidal responses from .csv file
% Imports csv data exprted with RFFextractor
% ERG data recorded with Phnr protacol 

function [FlashOD, FlickerOD, PHNROD, FlashOS, FlickerOS, PHNROS, filename] = loadRETevalPHNR(filename)
%% Initialize variables.
if ~exist('filename', 'var')
    [file,path] = uigetfile('*.csv');
    if isequal(file,0)
        disp('User selected Cancel');
    else
        filename = fullfile(path,file);
        delimiter = ',';
    end
else
    delimiter = ',';
end

% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%f%f%f%f%f%f%f%f%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', 2, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

% Create output variable
Total = [dataArray{1:end-1}];
    if size(Total, 2) > 6
        TotalOD = Total(:,1:6);
        TotalOS = Total(:,7:12);
    else 
        TotalOD = Total;
        TotalOS= [];
    end

% Create individual variables
if ~isempty(TotalOD)
    FlashOD = TotalOD(:,1:2);
    FlickerOD = TotalOD(:,3:4);
    PHNROD = TotalOD(:,5:6);
end

if ~isempty(TotalOS)
    FlashOS = TotalOS(:,1:2);
    FlickerOS = TotalOS(:,3:4);
    PHNROS = TotalOS(:,5:6);
end

%% Clear temporary variables
clearvars delimiter startRow formatSpec fileID dataArray ans file path;
