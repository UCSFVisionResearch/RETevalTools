function [OD, OS] = calcFRC(PlotAndSave)
%% Loads data and calculates the Frequency Response Curve
% TODO: debug fftRETevalAmp does not calculate amplitudes for frequencies >0

[SinOD, SinOS, filename] = loadRETevalSin;

% Isolate time/volt of a single response and trim NaN values
% then store them into separate arrays for each frequencies

freqs = [50,45,40,35,30,25,20,15,10,7,5,3,2,1,0.7,0.5,0.3];
freqsS = {'50','45','40','35','30','25','20','15','10','7','5','3','2','1','07','05','03'};

if ~isempty(SinOD) 
    for idx = 1:2:size(SinOD,2)
        Response = SinOD(:,idx:idx+1);
        mask = isnan(Response);
        tmpTime = Response(:,1);
        tmpVolt = Response(:,2);
        tmpVolt = tmpVolt(~mask(:,2));
        tmpTime = tmpTime(~mask(:,1));
        Response = [tmpTime, tmpVolt];
        assignin('base', ['SinOD' freqsS{(idx+1)/2} 'hz'], Response);
    end

if ~isempty(SinOS) 
    for idx = 1:2:size(SinOS,2)
        Response = SinOS(:,idx:idx+1);
        mask = isnan(Response);
        tmpTime = Response(:,1);
        tmpVolt = Response(:,2);
        tmpVolt = tmpVolt(~mask(:,2));
        tmpTime = tmpTime(~mask(:,1));
        Response = [tmpTime, tmpVolt];
        assignin('base', ['SinOS' freqsS{(idx+1)/2} 'hz'], Response);
    end
end


clear tmp* mask Response idx

% Calculate Frequency Response Profile for each eye

AmpsOD = zeros(size(freqs));

for f = 1:numel(freqs)
    Response = eval(['SinOD' freqsS{f} 'hz']);
    tmpTime = Response(:,1)/1000; % times are stored in ms, convert to s
    tmpVolt = Response(:,2);
    
    if isempty(tmpVolt)
        continue
    end
    
    amp = fftRETevalAmp(tmpTime', tmpVolt', freqs(f));
        
    if ~isempty(amp)
        AmpsOD(f) = amp;
    end
end

AmpsOS = zeros(size(freqs));

for f = 1:numel(freqs)
    Response = eval(['SinOS' freqsS{f} 'hz']);
    tmpTime = Response(:,1)/1000; % times are stored in ms, convert to s
    tmpVolt = Response(:,2);
    
    if isempty(tmpVolt)
        continue
    end
    
    amp = fftRETevalAmp(tmpTime', tmpVolt', freqs(f));
        
    if ~isempty(amp)
        AmpsOS(f) = amp;
    end
end

% Save data
if ~isempty(SinOD)
    OD          = struct;
    OD.Amps     = AmpsOD;
    OD.freqs    = freqs;
else
    SinOD = [];
end

if ~isempty(SinOS)
    OS          = struct;
    OS.Amps     = AmpsOS;
    OS.freqs    = freqs;
else 
    SinOS = [];
end

% Plot Frequency Response Profile
if exist('PlotAndSave', 'var') && PlotAndSave
    figure('Name', 'Frequency Response Profile'); hold on;
    subplot(1,2,1)
    if ~isempty(SinOD)
        plot(freqs, AmpsOD, '-ok');
        xlabel('Frequency (hz)');
        ylabel('Amplitude (microV)');
        ylim([0 10]);
    end
    
    subplot(1,2,2)
    if ~isempty(SinOS)
        plot(freqs, AmpsOS, '-ok');
        xlabel('Frequency (hz)');
        ylabel('Amplitude (microV)');
        ylim([0 10]);
    end
    
    [filepath,name,~] = fileparts(filename);
    print([filepath filesep name '-FRCplot.pdf'],'-dpdf','-fillpage');
    save([filepath filesep name '-FRCdata.mat'], 'OD','OS');
end
end