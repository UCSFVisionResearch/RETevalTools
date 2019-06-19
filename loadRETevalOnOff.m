%% Import RETeval sinusoidal responses from .csv file
% Imports csv data exprted with RFFextractor
% ERG data recorded with Phnr protacol 

function [OnOffOD, OnOffOS, filename] = loadRETevalOnOff()
%% Initialize variables.
[file,path] = uigetfile('*.csv');
if isequal(file,0)
   disp('User selected Cancel');
else
   filename = fullfile(path,file);
   delimiter = ',';
end

% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%f%f%f%f%*s%*s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', 2, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);



% Create output variable
OnOff = [dataArray{1:end-1}];
    if size(OnOff, 2) > 2
        OnOffOD = OnOff(:,1:2);
        OnOffOS = OnOff(:,3:4);
    else 
        OnOffOD = OnOff;
        OnOffOS= [];
    end

%% Clear temporary variables
clearvars delimiter startRow formatSpec fileID dataArray ans file path;
