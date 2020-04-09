function [OD, OS] = calcFRC(PlotAndSave, filename)
%% Loads data and calculates the Frequency Response Curve

if ~exist('filename', 'var')
    [SinOD, SinOS, filename] = loadRETevalSin;
else
    [SinOD, SinOS, filename] = loadRETevalSin(filename);
end
    
% Isolate time/volt of a single response and trim NaN values
% then store them into separate arrays for each frequencies

freqs = [50,45,40,35,30,25,20,15,10,7,5,3,2,1,0.7,0.5,0.3];
freqsS = {'50','45','40','35','30','25','20','15','10','7','5','3','2','1','07','05','03'};
freqs2 = freqs*2; 
freqs2S = {'100','90','80','70','60','50','40','30','20','14','10','6','4','2','1.4','1','0.6'};
Sin = struct;

if ~isempty(SinOD) 
    for idx = 1:2:size(SinOD,2)
        Response = SinOD(:,idx:idx+1);
        mask = isnan(Response);
        tmpTime = Response(:,1);
        tmpVolt = Response(:,2);
        tmpVolt = tmpVolt(~mask(:,2));
        tmpTime = tmpTime(~mask(:,1));
        Response = [tmpTime, tmpVolt];
        Sin.(['SinOD' freqsS{(idx+1)/2} 'hz'])= Response;
    end
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
        Sin.(['SinOS' freqsS{(idx+1)/2} 'hz']) = Response;
    end
end
clear tmp* mask Response idx

%% Calculate Frequency Response Profile for each eye

AmpsOD = zeros(size(freqs));
AmpsODsecHarm = zeros(size(freqs));

for f = 1:numel(freqs)
    Response = Sin.(['SinOD' freqsS{f} 'hz']);
    tmpTime = Response(:,1)/1000; % times are stored in ms, convert to s
    tmpVolt = Response(:,2);
    
    if isempty(tmpVolt)
        continue
    end
    
    % Calculate principal harmonic amplitude from FFT
    amp = fftRETevalAmp(tmpTime', tmpVolt', freqs(f));
    if ~isempty(amp)
        AmpsOD(f) = amp;
    end
    
    % Calculate second harmonic amplitude from FFT
    amp2 = fftRETevalAmp(tmpTime', tmpVolt', freqs(f)*2);    
    if ~isempty(amp2)
        AmpsODsecHarm(f) = amp2;
    end
    
end

AmpsOS = zeros(size(freqs));
AmpsOSsecHarm = zeros(size(freqs));

for f = 1:numel(freqs)
    Response = Sin.(['SinOS' freqsS{f} 'hz']);
    tmpTime = Response(:,1)/1000; % times are stored in ms, convert to s
    tmpVolt = Response(:,2);
    
    if isempty(tmpVolt)
        continue
    end
    
    % Calculate principal harmonic amplitude from FFT    
    amp = fftRETevalAmp(tmpTime', tmpVolt', freqs(f));        
    if ~isempty(amp)
        AmpsOS(f) = amp;
    end
    
    % Calculate second harmonic amplitude from FFT
    amp2 = fftRETevalAmp(tmpTime', tmpVolt', freqs(f)*2);    
    if ~isempty(amp2)
        AmpsOSsecHarm(f) = amp2;
    end
    
end

% Save data
if ~isempty(SinOD)
    OD          = struct;
    OD.Amps     = AmpsOD;
    OD.Amps2    = AmpsODsecHarm;
    OD.freqs    = freqs;
    OD.freqs2   = freqs2;
else
    SinOD = [];
    OD.Amps     = 0;
    OD.Amps2    = 0;
    OD.freqs    = freqs;
    OD.freqs2   = freqs2;    
end

if ~isempty(SinOS)
    OS          = struct;
    OS.Amps     = AmpsOS;
    OS.Amps2    = AmpsOSsecHarm;
    OS.freqs    = freqs;
    OS.freqs2   = freqs2;    
else 
    SinOS = [];
    OS.Amps     = 0;
    OS.Amps2    = 0;
    OS.freqs    = freqs;
    OS.freqs2   = freqs2;    
end

% Plot Frequency Response Profile
if exist('PlotAndSave', 'var') && PlotAndSave
    [fPath,fName,fExt] = fileparts(filename);
    
    figure('Name', 'Frequency Response Profile','Units', 'normalized', 'Position', [0.2 0.1 0.6 0.8], 'PaperOrientation', 'landscape'); 
    hold on;
    
    t = tiledlayout(2,2);    
    title(t, [fName fExt], 'Interpreter', 'none');
    
    nexttile;
    if ~isempty(SinOD)
        plot(freqs, AmpsOD, '-ok');
        ylim([0 10]);
        title('OD - Principal harmonic');
    end
    
    nexttile;
    if ~isempty(SinOS)
        plot(freqs, AmpsOS, '-ok');
        ylim([0 10]);
        title('OS - Principal harmonic');
    end
    
    nexttile;
    if ~isempty(SinOD)
        plot(freqs2, AmpsODsecHarm, '-ok');
        ylim([0 10]);
        title('OD - Second harmonic');
    end
    
    nexttile;
    if ~isempty(SinOS)
        plot(freqs2, AmpsOSsecHarm, '-ok');
        ylim([0 10]);
        title('OS - Second harmonic');
    end
        
    xlabel(t, 'Frequency (Hz)');
    ylabel(t, 'ERG Amplitude(μV)');
    
    print([fPath filesep fName '-FRCplot.pdf'],'-dpdf','-fillpage');
    save([fPath filesep fName '-FRCdata.mat'], 'OD','OS');
end

clear tmp*
end