%% Batch processing of all the recorded signals in one directory
% Will create Excel files with the analyzed data

% Load data folder path
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

% Process each of the csv files with the respective analysis
tblDataFlash = [];
tblDataOnOff = [];
tblDataSin =[];

for i = 1:numel(lstData)
    filename = lstData{i};
    [fPath, fName, ~] = fileparts(filename);
    
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
                tblDataFlash = table({fName}, {'OD'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.PHNRtime, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'PhNRtime', 'RatioPhNR'});
            else
                tblDataFlash = [tblDataFlash; table({fName}, {'OD'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.PHNRtime, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT','PhNRtime', 'RatioPhNR'})]; %#ok
            end
        end
        if ~isempty(FlashOS)
            Flash   = FlashOS;
            Flicker = FlickerOS;
            PhNR    = PhNROS;
            if isempty(tblDataFlash)
                tblDataFlash = table({fName}, {'OS'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.PHNRtime, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'PhNRtime', 'RatioPhNR'});
            else
                tblDataFlash = [tblDataFlash; table({fName}, {'OS'}, {'Flash'}, Flash.Awave, Flash.Atime, Flash.Bwave, Flash.Btime, {'Flicker'}, Flicker.AmpAvg, Flicker.AmpFFT, {'PhNR'}, PhNR.BT, PhNR.PT, PhNR.PHNRtime, PhNR.RatioPHNR, 'VariableNames', {'FileName', 'Eye', 'Stim1', 'Awave', 'Atime', 'Bwave', 'Btime', 'Stim2', 'AmpAvg', 'AmpFFT', 'Stim3', 'BT', 'PT', 'PhNRtime', 'RatioPhNR'})]; %#ok
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
                tblDataOnOff = [tblDataOnOff; table({fName}, {'OD'}, OnOff.Awave, OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'})]; %#ok
            end
        end
        
        if ~isempty(OnOffOS)
            OnOff = OnOffOS;
            if isempty(tblDataOnOff)
                tblDataOnOff = table({fName}, {'OS'}, OnOff.Awave,  OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'});
            else
                tblDataOnOff = [tblDataOnOff; table({fName}, {'OS'}, OnOff.Awave, OnOff.Atime, OnOff.Bwave, OnOff.Btime, OnOff.Dwave, OnOff.Dtime, 'VariableNames', {'FileName', 'Eye', 'Awave', 'Atime', 'Bwave', 'Btime', 'Dwave', 'Dtime'})]; %#ok
            end
        end
    elseif contains(filename, 'Sin')
        [SinOD, SinOS] = calcFRC(false, filename);

        if ~isempty(SinOD)
            Sin = SinOD;
            if isempty(tblDataSin)
                tblDataSin = table({fName}, {'OD'}, Sin.Amps(1), Sin.Amps(2), Sin.Amps(3), Sin.Amps(4), Sin.Amps(5), Sin.Amps(6), Sin.Amps(7), Sin.Amps(8), Sin.Amps(9), Sin.Amps(10), Sin.Amps(11), Sin.Amps(12), Sin.Amps(13), Sin.Amps(14), Sin.Amps(15), Sin.Amps(16), Sin.Amps(17),...
                                    'VariableNames', {'FileName', 'Eye', 'f50hz', 'f45hz', 'f40hz', 'f35hz', 'f30hz', 'f25hz', 'f20hz', 'f15hz', 'f10hz', 'f7hz', 'f5hz', 'f3hz', 'f2hz', 'f1hz', 'f07hz', 'f05hz', 'f03hz'});
            else
                tblDataSin = [tblDataSin; table({fName}, {'OD'}, Sin.Amps(1), Sin.Amps(2), Sin.Amps(3), Sin.Amps(4), Sin.Amps(5), Sin.Amps(6), Sin.Amps(7), Sin.Amps(8), Sin.Amps(9), Sin.Amps(10), Sin.Amps(11), Sin.Amps(12), Sin.Amps(13), Sin.Amps(14), Sin.Amps(15), Sin.Amps(16), Sin.Amps(17),...
                                    'VariableNames', {'FileName', 'Eye', 'f50hz', 'f45hz', 'f40hz', 'f35hz', 'f30hz', 'f25hz', 'f20hz', 'f15hz', 'f10hz', 'f7hz', 'f5hz', 'f3hz', 'f2hz', 'f1hz', 'f07hz', 'f05hz', 'f03hz'})]; %#ok
            end
        end
        
        if ~isempty(SinOS)
            Sin = SinOS;
            if isempty(tblDataSin)
                tblDataSin = table({fName}, {'OS'}, Sin.Amps(1), Sin.Amps(2), Sin.Amps(3), Sin.Amps(4), Sin.Amps(5), Sin.Amps(6), Sin.Amps(7), Sin.Amps(8), Sin.Amps(9), Sin.Amps(10), Sin.Amps(11), Sin.Amps(12), Sin.Amps(13), Sin.Amps(14), Sin.Amps(15), Sin.Amps(16), Sin.Amps(17),...
                                    'VariableNames', {'FileName', 'Eye', 'f50hz', 'f45hz', 'f40hz', 'f35hz', 'f30hz', 'f25hz', 'f20hz', 'f15hz', 'f10hz', 'f7hz', 'f5hz', 'f3hz', 'f2hz', 'f1hz', 'f07hz', 'f05hz', 'f03hz'});
            else
                tblDataSin = [tblDataSin; table({fName}, {'OS'}, Sin.Amps(1), Sin.Amps(2), Sin.Amps(3), Sin.Amps(4), Sin.Amps(5), Sin.Amps(6), Sin.Amps(7), Sin.Amps(8), Sin.Amps(9), Sin.Amps(10), Sin.Amps(11), Sin.Amps(12), Sin.Amps(13), Sin.Amps(14), Sin.Amps(15), Sin.Amps(16), Sin.Amps(17),...
                                    'VariableNames', {'FileName', 'Eye', 'f50hz', 'f45hz', 'f40hz', 'f35hz', 'f30hz', 'f25hz', 'f20hz', 'f15hz', 'f10hz', 'f7hz', 'f5hz', 'f3hz', 'f2hz', 'f1hz', 'f07hz', 'f05hz', 'f03hz'})]; %#ok
            end
        end
    end
end

tblFileName = [fPath filesep 'AnalysisFlash.xls'];
writetable(tblDataFlash, tblFileName);    % Write an Excel table
tblFileName = [fPath filesep 'AnalysisOnOff.xls'];
writetable(tblDataOnOff, tblFileName);    % Write an Excel table
tblFileName = [fPath filesep 'AnalysisSin.xls'];
writetable(tblDataSin, tblFileName);    % Write an Excel table

clear filename Flash* Flicker* f* i lstData OnOff* selpath PhNR* ext Sin* tblFileName