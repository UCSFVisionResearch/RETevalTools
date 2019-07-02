%% Batch processing of all the recorded signals in one directory
% Will create Excel files with the analyzed data

%% Load data folder path
selpath = uigetdir(pwd, 'Select data folder');
if ~exist(selpath,"dir")
    return;
end

% Identify image files to score and store path to them in a list
files = dir([selpath filesep '*.csv']);  % List the content of ImageFolder
files = files(~[files.isdir]);  % Keep only files (ignore subdirs)

lstData = {};
for i = 1:numel(files)
    currFile = [files(i).folder filesep files(i).name];
    if isempty(lstData)
        lstData = {currFile};
    else
        lstData{end+1} = currFile; %#ok
    end
end
clear currFile files i

%% Process each of the csv files with the respective analysis
tblDataFlash = [];
tblDataOnOff = [];
tblSin =[];

for i = 1:numel(lstData)
    filename = lstData{i};
    [fPath, fName, ext] = fileparts(filename);
    
    if contains(filename, 'Flash')
        % Analyze Flash, Flicker and PhNR response, write into tblFlash
        [FlashOD, FlashOS] = calcFlash(false, filename);
        [FlickerOD, FlickerOS] = calcFlicker(false, filename);
        [PhNROD, PhNROS] = calcPHNR(false, filename);

        if ~isempty(FlashOD)
            Flash   = FlashOD;
            Flicker = FlickerOD;
            PhNR    = PhNROD;
            if isempty(tblDataFlash)
                tblDataFlash = table({fName}, {'OD'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'RatioPhNR'});
            else
                tblDataFlash = [tblDataFlash; table({fName}, {'OD'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'RatioPhNR'})];
            end
        end
        if ~isempty(FlashOS)
            Flash   = FlashOS;
            Flicker = FlickerOS;
            PhNR    = PhNROS;
            if isempty(tblDataFlash)
                tblDataFlash = table({fName}, {'OS'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'RatioPhNR'});
            else
                tblDataFlash = [tblDataFlash; table({fName}, {'OS'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'RatioPhNR'})];
            end
        end
    elseif contains(filename, 'ON-OFF')
        % Analyze On-Off response and write into tblOnOff
        [OnOffOD, OnOffOS] = calcOnOff(false, filename);
        if ~isempty(OnOffOD)
            OnOff = OnOffOD;
            if isempty(tblDataOnOff)
                tblDataOnOff = table({fName}, {'OD'}, OnOff.Awave,  OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'});
            else
                tblDataOnOff = [tblDataOnOff; table({fName}, {'OD'}, OnOff.Awave, OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'})];
            end
        end
        
        if ~isempty(OnOffOS)
            OnOff = OnOffOS;
            if isempty(tblDataOnOff)
                tblDataOnOff = table({fName}, {'OS'}, OnOff.Awave,  OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'});
            else
                tblDataOnOff = [tblDataOnOff; table({fName}, {'OS'}, OnOff.Awave, OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'})];
            end
        end
    elseif contains(filename, 'Sin')
        %Sin = calcFRC(false, filename);
    end
end

tblFileName = [fPath filesep 'AnalysisFlash.xls'];
writetable(tblDataFlash, tblFileName);    % Write an Excel table
tblFileName = [fPath filesep 'AnalysisOnOff.xls'];
writetable(tblDataOnOff, tblFileName);    % Write an Excel table

clear filename Flash* Flicker* f* i lstData OnOff* selpath PhNR* ext