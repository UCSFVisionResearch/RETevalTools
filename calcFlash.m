%% Load data

[FlashOD, ~, ~, FlashOS, ~, ~, filename] = loadRETevalPHNR;

%% Flash 
if ~isempty(FlashOD) 
    mask = isnan(FlashOD);
    TimeOD = FlashOD(:,1);
    TimeOD = TimeOD(~mask(:,2));
    VoltOD = FlashOD(:,2);
    VoltOD = VoltOD(~mask(:,1));
end

if ~isempty(FlashOS) 
    mask = isnan(FlashOS)
    TimeOS = FlashOS(:,1);
    TimeOS = TimeOS(~mask(:,2));
    VoltOS = FlashOS(:,2);
    VoltOS = VoltOS(~mask(:,1));
end
clear mask

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

% Repeat for OS
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[pksNegOS,locsNegOS] = findpeaks(-VoltOS);
[~, locBwaveOS] = max(pksPosOS);
locBwaveOS = locsPosOS(locBwaveOS);

locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS) & TimeOS(locsNegOS) > 0;
locAwaveOS = times(locAwaveOS, pksNegOS);
[~, locAwaveOS] = max(locAwaveOS);
locAwaveOS = locsNegOS(locAwaveOS);

% Calculate
AwaveOD = -VoltOD(locAwaveOD);
BwaveOD = plus(VoltOD(locBwaveOD), AwaveOD);
AwaveOS = -VoltOS(locAwaveOS);
BwaveOS = plus(VoltOS(locBwaveOS), AwaveOS);

AtimeOD = timeOD(locAwaveOD);
BtimeOD = timeOD(locBwaveOD):
AtimeOS = timeOS(locAwaveOS);
BtimeOS = timeOS(locBwaveOS):

if ~isempty(FlashOD)
    OD          = struct;
    OD.Time     = TimeOD;
    OD.Volt     = VoltOD;
    OD.Awave    = AwaveOD;
    OD.Atime    = AtimeOD;
    OD.Bwave    = BwaveOD;
    OD.Btime    = BtimeOD;
else
    FlashOD = [];
end

if ~isempty(FlashOS)
    OS          = struct;
    OS.Time     = TimeOS;
    OS.Volt     = VoltOS;
    OS.Awave    = AwaveOS;
    OS.Atime    = AtimeOS;
    OS.Bwave    = BwaveOS;
    OS.Btime    = BtimeOS;
else 
    FlashOS = [];
end

% graph Flash 
figure('Name', 'Frequency Response Profile','visible','off'); hold on;
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
save([filepath filesep name '-Flashdata.mat'], 'AwaveOD', 'BwaveOD', 'AwaveOS', 'BwaveOS', 'AtimeOD', 'BtimeOD', 'AtimeOS', 'BtimeOS');



