%% Import RETeval sinusoidal responses from .csv file
% Imports csv data exprted with RFFextractor
% ERG data recorded with protocol: Sine flicker 300 cd/m²: 50-0.3 Hz

function [SinOD,SinOS, filename] = loadRETevalSin(filename)
%% Initialize variables.
if ~exist('filename', 'var') || ~filename
    [file,path] = uigetfile('*.csv');
    filename = fullfile(path,file);
    if isequal(file,0)
        disp('User selected Cancel');
        return
    end
end

if contains(file, 'reported')
    % Name filename
    %filename = fullfile(path,file);
    % REPORTED WAVEFORM exported from rffExtractor
    
    % Setup the Import Options
    opts = delimitedTextImportOptions("NumVariables", 38);
    
    % Specify range and delimiter
    opts.DataLines = [3, Inf];
    opts.Delimiter = ",";
    
    % Specify column names and types
    opts.VariableNames = ["Var1", "Var2", "ms", "uV", "ms_1", "uV_1", "ms_2", "uV_2", "ms_3", "uV_3", "ms_4", "uV_4", "ms_5", "uV_5", "ms_6", "uV_6", "ms_7", "uV_7", "ms_8", "uV_8", "ms_9", "uV_9", "ms_10", "uV_10", "ms_11", "uV_11", "ms_12", "uV_12", "ms_13", "uV_13", "ms_14", "uV_14", "ms_15", "uV_15", "ms_16", "uV_16", "Var37", "Var38"];
    opts.SelectedVariableNames = ["ms", "uV", "ms_1", "uV_1", "ms_2", "uV_2", "ms_3", "uV_3", "ms_4", "uV_4", "ms_5", "uV_5", "ms_6", "uV_6", "ms_7", "uV_7", "ms_8", "uV_8", "ms_9", "uV_9", "ms_10", "uV_10", "ms_11", "uV_11", "ms_12", "uV_12", "ms_13", "uV_13", "ms_14", "uV_14", "ms_15", "uV_15", "ms_16", "uV_16"];
    opts.VariableTypes = ["string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string"];
    opts = setvaropts(opts, [1, 2, 37, 38], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, [1, 2, 37, 38], "EmptyFieldRule", "auto");
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    
    % Import the data
    dataTable = readtable(fullfile(path, file), opts);
    
    % Convert to output type
    Sin = table2array(dataTable);
else
    % RAW WAVEFORM exported as csv using rffExtractor
    
    delimiter = ",";
    formatSpec = '%*q%*q%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%*s%*s%[^\n\r]';
    fileID = fopen(fullfile(path, file),'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines', 2, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    
    % Create output variable
    Sin = [dataArray{1:end-1}];
    if size(Sin, 2) > 34
        SinOD = Sin(:,1:34);
        SinOS = Sin(:,35:68);
    else 
        SinOD = Sin;
        SinOS = [];
    end
end
    
%% Clear temporary variables
clearvars delimiter startRow formatSpec fileID dataArray ans file path opts dataTable;
end