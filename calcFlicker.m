function [OD, OS] = calcFlicker(PlotAndSave, filename)
%% Load data
if ~exist('filename', 'var')
    [~, FlickerOD, ~, ~, FlickerOS, ~, filename] = loadRETevalPHNR;
else
    [~, FlickerOD, ~, ~, FlickerOS, ~, filename] = loadRETevalPHNR(filename);
end
%% Extract response to Flicker 28Hz stimulation and trim NaN values 
if ~isempty(FlickerOD)
    mask = isnan(FlickerOD);
    TimeOD = FlickerOD(:,1);    
    TimeOD = TimeOD(~mask(:,2));
    VoltOD = FlickerOD(:,2);
    VoltOD = VoltOD(~mask(:,1));
end

if ~isempty(FlickerOS) 
    mask = isnan(FlickerOS);
    TimeOS = FlickerOS(:,1);
    TimeOS = TimeOS(~mask(:,2));
    VoltOS = FlickerOS(:,2);
    VoltOS = VoltOS(~mask(:,1));
end
clear mask

%% Split into three sections
if ~isempty(TimeOD)
    [pksPosOD,locsPosOD] = findpeaks(VoltOD);
    [pksNegOD,locsNegOD] = findpeaks(-VoltOD);
    
    [~, locTopPeaks] = maxk(pksPosOD, 3);
    FirstTimeOD     = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(1)))), TimeOD);
    SecondTimeOD    = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(2))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(1)))), TimeOD);
    ThirdTimeOD     = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(3))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(2)))), TimeOD);
    FirstVoltOD     = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(1)))), VoltOD);
    SecondVoltOD    = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(2))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(1)))), VoltOD);
    ThirdVoltOD     = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(3))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(2)))), VoltOD);
    
    [firstpksPosOD,  firstlocsPosOD]    = findpeaks(FirstVoltOD);
    [secondpksPosOD, secondlocsPosOD]   = findpeaks(SecondVoltOD);
    [thirdpksPosOD,  thirdlocsPosOD]    = findpeaks(ThirdVoltOD);
    [firstpksNegOD,  firstlocsNegOD]    = findpeaks(-FirstVoltOD);
    [secondpksNegOD, secondlocsNegOD]   = findpeaks(-SecondVoltOD);
    [thirdpksNegOD,  thirdlocsNegOD]    = findpeaks(-ThirdVoltOD);
    
    [firstlocBwaveOD, firstlocAwaveOD]  = ABwave(firstpksPosOD, firstpksNegOD, firstlocsPosOD, firstlocsNegOD, TimeOD, VoltOD);
    [secondlocBwaveOD,secondlocAwaveOD] = ABwave(secondpksPosOD, secondpksNegOD, secondlocsPosOD, secondlocsNegOD, TimeOD, VoltOD);
    [thirdlocBwaveOD, thirdlocAwaveOD]  = ABwave(thirdpksPosOD, thirdpksNegOD, thirdlocsPosOD, thirdlocsNegOD, TimeOD, VoltOD);

    x = minus(VoltOD(firstlocBwaveOD),  VoltOD(firstlocAwaveOD));
    y = minus(VoltOD(secondlocBwaveOD), VoltOD(secondlocAwaveOD));
    z = minus(VoltOD(thirdlocBwaveOD),  VoltOD(thirdlocAwaveOD));
    AmpOD = [x, y, z]; % individual peak-to-peak amplitudes in time domain
    AmpODavg = mean(AmpOD); % average peak-to-peak amplitude in time domain
    AmpODfft = fftRETevalAmp(TimeOD/1000, VoltOD, 28); %1st harmonic amplitude
else 
    AmpOD = [0, 0, 0];
    AmpODavg = [0];
    AmpODfft = [0];
end

% Repeat for left eye
if ~isempty(TimeOS)
    [pksPosOS,locsPosOS] = findpeaks(VoltOS);
    [pksNegOS,locsNegOS] = findpeaks(-VoltOS);
    
    [~, locTopPeaks] = maxk(pksPosOS, 3);
    FirstTimeOS     = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(1)))), TimeOS);
    SecondTimeOS    = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(2))) & TimeOS > TimeOS(locsPosOS(locTopPeaks(1)))), TimeOS);
    ThirdTimeOS     = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(3))) & TimeOS > TimeOS(locsPosOS(locTopPeaks(2)))), TimeOS);
    FirstVoltOS     = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(1)))), VoltOS);
    SecondVoltOS    = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(2))) & TimeOS > TimeOS(locsPosOS(locTopPeaks(1)))), VoltOS);
    ThirdVoltOS     = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(3))) & TimeOS > TimeOS(locsPosOS(locTopPeaks(2)))), VoltOS);
    
    [firstpksPosOS,  firstlocsPosOS]    = findpeaks(FirstVoltOS);
    [secondpksPosOS, secondlocsPosOS]   = findpeaks(SecondVoltOS);
    [thirdpksPosOS,  thirdlocsPosOS]    = findpeaks(ThirdVoltOS);
    [firstpksNegOS,  firstlocsNegOS]    = findpeaks(-FirstVoltOS);
    [secondpksNegOS, secondlocsNegOS]   = findpeaks(-SecondVoltOS);
    [thirdpksNegOS,  thirdlocsNegOS]    = findpeaks(-ThirdVoltOS);
    
    [firstlocBwaveOS, firstlocAwaveOS]  = ABwave(firstpksPosOS, firstpksNegOS, firstlocsPosOS, firstlocsNegOS, TimeOS, VoltOS);
    [secondlocBwaveOS, secondlocAwaveOS]= ABwave(secondpksPosOS, secondpksNegOS, secondlocsPosOS, secondlocsNegOS, TimeOS, VoltOS);
    [thirdlocBwaveOS, thirdlocAwaveOS]  = ABwave(thirdpksPosOS, thirdpksNegOS, thirdlocsPosOS, thirdlocsNegOS, TimeOS, VoltOS);
    
    % Calculations
    x = minus(VoltOS(firstlocBwaveOS),  VoltOS(firstlocAwaveOS));
    y = minus(VoltOS(secondlocBwaveOS), VoltOS(secondlocAwaveOS));
    z = minus(VoltOS(thirdlocBwaveOS),  VoltOS(thirdlocAwaveOS));
    AmpOS = [x, y, z]; % individual peak-to-peak amplitude in time domain
    AmpOSavg = mean(AmpOS); % average peak-to-peak amplitude in time domain
    AmpOSfft = fftRETevalAmp(TimeOS/1000, VoltOS, 28); %1st harmonic amplitude
else
    AmpOS = [0, 0, 0];
    AmpOSavg = [0];
    AmpOSfft = [0];
end

%% Generate a structure containing all analyzed data
if ~isempty(FlickerOD)
    OD          = struct;
    OD.Time     = TimeOD;
    OD.Volt     = VoltOD;
    OD.Amps     = AmpOD;
    OD.AmpAvg   = AmpODavg;
    OD.AmpFFT   = AmpODfft;
else
    FlickerOD = [];
end

if ~isempty(FlickerOS)
    OS          = struct;
    OS.Time     = TimeOS;
    OS.Volt     = VoltOS;
    OS.Amps     = AmpOS;
    OS.AmpAvg   = AmpOSavg;
    OS.AmpFFT   = AmpOSfft;
else
    FlickerOS = [];
end

%% Plot responses in time and circle peaks locations 'visible','off'
if exist('PlotAndSave', 'var') && PlotAndSave
    figure('Name', 'Frequency Response Profile'); hold on;
    subplot(2,1,1)
    if ~isempty(FlickerOD)
        plot(TimeOD, VoltOD, 'k');
        hold on
        %scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
        %scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
        scatter(TimeOD(firstlocBwaveOD),    VoltOD(firstlocBwaveOD),'or');
        scatter(TimeOD(firstlocAwaveOD),    VoltOD(firstlocAwaveOD),'ob');
        scatter(TimeOD(secondlocBwaveOD),   VoltOD(secondlocBwaveOD),'or');
        scatter(TimeOD(secondlocAwaveOD),   VoltOD(secondlocAwaveOD),'ob');
        scatter(TimeOD(thirdlocBwaveOD),    VoltOD(thirdlocBwaveOD),'or');
        scatter(TimeOD(thirdlocAwaveOD),    VoltOD(thirdlocAwaveOD),'ob');
        xlabel('Time (ms)');
        ylabel('Amplitude (microV)');
    end
    
    subplot(2,1,2)
    if ~isempty(FlickerOS)
        plot(TimeOS, VoltOS, 'k');
        hold on
        scatter(TimeOS(firstlocBwaveOS),    VoltOS(firstlocBwaveOS),'or');
        scatter(TimeOS(firstlocAwaveOS),    VoltOS(firstlocAwaveOS),'ob');
        scatter(TimeOS(secondlocBwaveOS),   VoltOS(secondlocBwaveOS),'or');
        scatter(TimeOS(secondlocAwaveOS),   VoltOS(secondlocAwaveOS),'ob');
        scatter(TimeOS(thirdlocBwaveOS),    VoltOS(thirdlocBwaveOS),'or');
        scatter(TimeOS(thirdlocAwaveOS),    VoltOS(thirdlocAwaveOS),'ob');
        xlabel('Time (ms)');
        ylabel('Amplitude (microV)');
    end
    
    % Save data and plots to disk
    [filepath,name,~] = fileparts(filename);
    print([filepath filesep name '-Flicker28hzPlot.pdf'],'-dpdf','-fillpage');
    save([filepath filesep name '-Flicker28hzData.mat'], 'OD', 'OS');
end
end