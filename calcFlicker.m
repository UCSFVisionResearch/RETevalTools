%% Load data

[FlashOD, FlickerOD, PHNROD, FlashOS, FlickerOS, PHNROS, filename] = loadRETevalPHNR;

%% Flicker 
if ~isempty(FlickerOD) 
    TimeOD = FlickerOD(:,1);
    VoltOD = FlickerOD(:,2);
end

if ~isempty(FlickerOS) 
    TimeOS = FlickerOS(:,1);
    VoltOS = FlickerOS(:,2);
end

%% Use FFT
% Convert time to seconds
if ~isempty(FlickerOD)
    TimeSecOD = FlickerOD(:,1)/1000;
end
if ~isempty(FlickerOS)
    TimeSecOS = FlickerOS(:,1)/1000;
end

%FFT
AmpOD = fftRETevalAmp(TimeSecOD, VoltOD, 30);
AmpOS = fftRETevalAmp(TimeSecOS, VoltOS, 30);


%% Split into three sections
[pksPosOD,locsPosOD] = findpeaks(VoltOD);
[pksNegOD,locsNegOD] = findpeaks(-VoltOD);

[~, locTopPeaks] = maxk(pksPosOD, 3);
FirstTimeOD = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(1)))), TimeOD);
SecondTimeOD = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(2))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(1)))), TimeOD);
ThirdTimeOD = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(3))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(2)))), TimeOD);
FirstVoltOD = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(1)))), VoltOD);
SecondVoltOD = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(2))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(1)))), VoltOD);
ThirdVoltOD = times((TimeOD <= TimeOD(locsPosOD(locTopPeaks(3))) & TimeOD > TimeOD(locsPosOD(locTopPeaks(2)))), VoltOD);

[firstpksPosOD,firstlocsPosOD] = findpeaks(FirstVoltOD);
[secondpksPosOD,secondlocsPosOD] = findpeaks(SecondVoltOD);
[thirdpksPosOD,thirdlocsPosOD] = findpeaks(ThirdVoltOD);
[firstpksNegOD,firstlocsNegOD] = findpeaks(-FirstVoltOD);
[secondpksNegOD,secondlocsNegOD] = findpeaks(-SecondVoltOD);
[thirdpksNegOD,thirdlocsNegOD] = findpeaks(-ThirdVoltOD);

[firstlocBwaveOD, firstlocAwaveOD] = ABwave(firstpksPosOD, firstpksNegOD, firstlocsPosOD, firstlocsNegOD, TimeOD, VoltOD);
[secondlocBwaveOD, secondlocAwaveOD] = ABwave(secondpksPosOD, secondpksNegOD, secondlocsPosOD, secondlocsNegOD, TimeOD, VoltOD);
[thirdlocBwaveOD, thirdlocAwaveOD] = ABwave(thirdpksPosOD, thirdpksNegOD, thirdlocsPosOD, thirdlocsNegOD, TimeOD, VoltOD);

% Repeat for left eye
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[pksNegOS,locsNegOS] = findpeaks(-VoltOS);

[~, locTopPeaks] = maxk(pksPosOS, 3);
FirstTimeOS = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(1)))), TimeOS);
SecondTimeOS = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(2))) & TimeOS > TimeOS(locsPosOS(locTopPeaks(1)))), TimeOS);
ThirdTimeOS = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(3))) & TimeOS > TimeOS(locsPosOS(locTopPeaks(2)))), TimeOS);
FirstVoltOS = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(1)))), VoltOS);
SecondVoltOS = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(2))) & TimeOS > TimeOD(locsPosOS(locTopPeaks(1)))), VoltOS);
ThirdVoltOS = times((TimeOS <= TimeOS(locsPosOS(locTopPeaks(3))) & TimeOS > TimeOD(locsPosOS(locTopPeaks(2)))), VoltOS);

[firstpksPosOS,firstlocsPosOS] = findpeaks(FirstVoltOS);
[secondpksPosOS,secondlocsPosOS] = findpeaks(SecondVoltOS);
[thirdpksPosOS,thirdlocsPosOS] = findpeaks(ThirdVoltOS);
[firstpksNegOS,firstlocsNegOS] = findpeaks(-FirstVoltOS);
[secondpksNegOS,secondlocsNegOS] = findpeaks(-SecondVoltOS);
[thirdpksNegOS,thirdlocsNegOS] = findpeaks(-ThirdVoltOS);

[firstlocBwaveOS, firstlocAwaveOS] = ABwave(firstpksPosOS, firstpksNegOS, firstlocsPosOS, firstlocsNegOS, TimeOS, VoltOS);
[secondlocBwaveOS, secondlocAwaveOS] = ABwave(secondpksPosOS, secondpksNegOS, secondlocsPosOS, secondlocsNegOS, TimeOS, VoltOS);
[thirdlocBwaveOS, thirdlocAwaveOS] = ABwave(thirdpksPosOS, thirdpksNegOS, thirdlocsPosOS, thirdlocsNegOS, TimeOS, VoltOS);

% Calculations
x = minus(VoltOD(firstlocBwaveOD), VoltOD(firstlocAwaveOD));
y = minus(VoltOD(secondlocBwaveOD), VoltOD(secondlocAwaveOD));
z = minus(VoltOD(thirdlocBwaveOD), VoltOD(thirdlocAwaveOD));
AmpOD = [x, y, z];
AvgAmpOD = mean(AmpOD);
x = minus(VoltOS(firstlocBwaveOS), VoltOD(firstlocAwaveOS));
y = minus(VoltOS(secondlocBwaveOS), VoltOD(secondlocAwaveOS));
z = minus(VoltOS(thirdlocBwaveOS), VoltOD(thirdlocAwaveOS));
AmpOS = [x, y, z];
AvgAmpOS = mean(AmpOD);

%% Graph 'visible','off'
figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(FlickerOD)
    plot(TimeOD, VoltOD, 'k');
    hold on
    %scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
    %scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
    scatter(TimeOD(firstlocBwaveOD), VoltOD(firstlocBwaveOD),'or');
    scatter(TimeOD(firstlocAwaveOD), VoltOD(firstlocAwaveOD),'ob');
    scatter(TimeOD(secondlocBwaveOD), VoltOD(secondlocBwaveOD),'or');
    scatter(TimeOD(secondlocAwaveOD), VoltOD(secondlocAwaveOD),'ob');
    scatter(TimeOD(thirdlocBwaveOD), VoltOD(thirdlocBwaveOD),'or');
    scatter(TimeOD(thirdlocAwaveOD), VoltOD(thirdlocAwaveOD),'ob');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

subplot(2,1,2)
if ~isempty(FlickerOS)
    plot(TimeOS, VoltOS, 'k');
    hold on
    scatter(TimeOS(firstlocBwaveOS), VoltOS(firstlocBwaveOS),'or');
    scatter(TimeOS(firstlocAwaveOS), VoltOS(firstlocAwaveOS),'ob');
    scatter(TimeOS(secondlocBwaveOS), VoltOS(secondlocBwaveOS),'or');
    scatter(TimeOS(secondlocAwaveOS), VoltOS(secondlocAwaveOS),'ob');
    scatter(TimeOS(thirdlocBwaveOS), VoltOS(thirdlocBwaveOS),'or');
    scatter(TimeOS(thirdlocAwaveOS), VoltOS(thirdlocAwaveOS),'ob');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

% Print Flicker 

[filepath,name,ext] = fileparts(filename);
print([filepath filesep name '-Flashplot.pdf'],'-dpdf','-fillpage');
save([filepath filesep name '-Flashdata.mat'], 'AvgAmpOD', 'AvgAmpOS');