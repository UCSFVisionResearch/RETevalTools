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

% Calculate Amplitudes
[pksPosOD,locsPosOD] = findpeaks(VoltOD);
[pksNegOD,locsNegOD] = findpeaks(-VoltOD);

%% Split into three sections
FirstTimeOD = times((TimeOD < 40), VoltOD);
SecondTimeOD = times((TimeOD > 40 & TimeOD < 80), VoltOD);
ThirdTimeOD = times((TimeOD > 80 & TimeOD < 120), VoltOD);
FirstVoltOD = times((TimeOD < 40), VoltOD);
SecondVoltOD = times((TimeOD > 40 & TimeOD < 80), VoltOD);
ThirdVoltOD = times((TimeOD > 80 & TimeOD < 120), VoltOD);

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
FirstTimeOS = times((TimeOS < 40), VoltOS);
SecondTimeOS = times((TimeOS > 40 & TimeOS < 80), VoltOS);
ThirdTimeOS = times((TimeOS > 80 & TimeOS < 120), VoltOS);
FirstVoltOS = times((TimeOS < 40), VoltOS);
SecondVoltOS = times((TimeOS > 40 & TimeOS < 80), VoltOS);
ThirdVoltOS = times((TimeOS > 80 & TimeOS < 120), VoltOS);

[firstpksPosOS,firstlocsPosOS] = findpeaks(FirstVoltOS);
[secondpksPosOS,secondlocsPosOS] = findpeaks(SecondVoltOS);
[thirdpksPosOS,thirdlocsPosOS] = findpeaks(ThirdVoltOS);
[firstpksNegOS,firstlocsNegOS] = findpeaks(-FirstVoltOS);
[secondpksNegOS,secondlocsNegOS] = findpeaks(-SecondVoltOS);
[thirdpksNegOS,thirdlocsNegOS] = findpeaks(-ThirdVoltOS);


[firstlocBwaveOS, firstlocAwaveOS] = ABwave(firstpksPosOS, firstpksNegOS, firstlocsPosOS, firstlocsNegOS, TimeOS, VoltOS);
[secondlocBwaveOS, secondlocAwaveOS] = ABwave(secondpksPosOS, secondpksNegOS, secondlocsPosOS, secondlocsNegOS, TimeOS, VoltOS);
[thirdlocBwaveOS, thirdlocAwaveOS] = ABwave(thirdpksPosOS, thirdpksNegOS, thirdlocsPosOS, thirdlocsNegOS, TimeOS, VoltOS);


%% Graph
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

%% Flash 
if ~isempty(FlashOD) 
    TimeOD = FlashOD(:,1);
    VoltOD = FlashOD(:,2);
end

if ~isempty(FlashOS) 
    TimeOS = FlashOS(:,1);
    VoltOS = FlashOS(:,2);
end

% Calculate A and B wave peaks
[pksPosOD,locsPosOD] = findpeaks(VoltOD);
[pksNegOD,locsNegOD] = findpeaks(-VoltOD);

% First calculate B wave as maximum positive peak
[~, locBwaveOD] = max(pksPosOD);
locBwaveOD = locsPosOD(locBwaveOD);

% Calculate A wave as the first negative peak prior to B wave
locAwaveOD = TimeOD(locsNegOD) < TimeOD(locBwaveOD) & TimeOD(locsNegOD) > 0;
locAwaveOD = times(locAwaveOD, pksNegOD);
[~, locAwaveOD] = max(locAwaveOD);
locAwaveOD = locsNegOD(locAwaveOD);
%locAwaveOD = find(locAwaveOD, 1, 'last');
%locAwaveOD = locsNegOD(locAwaveOD);

% Repeat for OS
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[pksNegOS,locsNegOS] = findpeaks(-VoltOS);
[~, locBwaveOS] = max(pksPosOS);
locBwaveOS = locsPosOS(locBwaveOS);

locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS) & TimeOS(locsNegOS) > 0;
locAwaveOS = times(locAwaveOS, pksNegOS);
[~, locAwaveOS] = max(locAwaveOS);
locAwaveOS = locsNegOS(locAwaveOS);

% graph Flash
figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(FlashOD)
    plot(TimeOD, VoltOD, 'k');
    hold on
    %scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
    %scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
    scatter(TimeOD(locAwaveOD), VoltOD(locAwaveOD),'or');
    scatter(TimeOD(locBwaveOD), VoltOD(locBwaveOD),'ob');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

subplot(2,1,2)
if ~isempty(FlashOS)
    plot(TimeOS, VoltOS, 'k');
    hold on
    %scatter(TimeOS(locsPosOS), VoltOS(locsPosOS),'or');
    %scatter(TimeOS(locsNegOS), VoltOS(locsNegOS),'ob');
    scatter(TimeOS(locAwaveOS), VoltOS(locAwaveOS),'or');
    scatter(TimeOS(locBwaveOS), VoltOS(locBwaveOS),'ob');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

% Print Flash 

[filepath,name,ext] = fileparts(filename);
print([filepath filesep name '-Flashplot.pdf'],'-dpdf','-fillpage');
save([filepath filesep name '-Flashdata.mat']);

% PHNR 
if ~isempty(PHNROD) 
    TimeOD = PHNROD(:,1);
    VoltOD = PHNROD(:,2);
end

if ~isempty(PHNROS) 
    TimeOS = PHNROS(:,1);
    VoltOS = PHNROS(:,2);
end

% Calculate A and B wave peaks
[pksPosOD,locsPosOD] = findpeaks(VoltOD);
[pksNegOD,locsNegOD] = findpeaks(-VoltOD);

% First calculate B wave as maximum positive peak
[ValueBwaveOD, locBwaveOD] = max(pksPosOD);
locBwaveOD = locsPosOD(locBwaveOD);

% Calculate A wave as the first negative peak prior to B wave
locAwaveOD = TimeOD(locsNegOD) < TimeOD(locBwaveOD);
locAwaveOD = find(locAwaveOD, 1, 'last' );
locAwaveOD = locsNegOD(locAwaveOD);

% Calculate PHNR. Most minimum peak after first trough from B wave
MinwaveOD = TimeOD(locsNegOD) > TimeOD(locBwaveOD) & TimeOD(locsNegOD) < 100;
MinwaveOD(find(MinwaveOD,1)) = 0;
MinwaveOD = times(MinwaveOD, pksNegOD);
[ValueMinwaveOD, locMinwaveOD] = max(MinwaveOD);
locMinwaveOD = locsNegOD(locMinwaveOD);

% Repeat for OS
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[pksNegOS,locsNegOS] = findpeaks(-VoltOS);
[ValueBwaveOS, locBwaveOS] = max(pksPosOS);
locBwaveOS = locsPosOS(locBwaveOS);

locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS);
locAwaveOS = find(locAwaveOS, 1, 'last' );
locAwaveOS = locsNegOS(locAwaveOS);

MinwaveOS = TimeOS(locsNegOS) > TimeOS(locBwaveOS) & TimeOS(locsNegOS) < 100;
MinwaveOS(find(MinwaveOS,1)) = 0;
MinwaveOS = times(MinwaveOS, pksNegOS);
[ValueMinwaveOS, locMinwaveOS] = max(MinwaveOS);
locMinwaveOS = locsNegOS(locMinwaveOS);

% Graph PHNR

figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(PHNROD)
    plot(TimeOD, VoltOD, 'k');
    hold on
    %scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
    %scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
    scatter(TimeOD(locAwaveOD), VoltOD(locAwaveOD),'or');
    scatter(TimeOD(locBwaveOD), VoltOD(locBwaveOD),'ob');
    scatter(TimeOD(locMinwaveOD), VoltOD(locMinwaveOD), 'og');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

subplot(2,1,2)
if ~isempty(PHNROS)
    plot(TimeOS, VoltOS, 'k');
    hold on
    %scatter(TimeOS(locsPosOS), VoltOS(locsPosOS),'or');
    %scatter(TimeOS(locsNegOS), VoltOS(locsNegOS),'ob');
    scatter(TimeOS(locAwaveOS), VoltOS(locAwaveOS),'or');
    scatter(TimeOS(locBwaveOS), VoltOS(locBwaveOS),'ob');
    scatter(TimeOS(locMinwaveOS), VoltOS(locMinwaveOS), 'og');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

% Print PHNR
[filepath,name,ext] = fileparts(filename);
print([filepath filesep name '-PHNRplot.pdf'],'-dpdf','-fillpage');
save([filepath filesep name '-PHNRdata.mat']);


