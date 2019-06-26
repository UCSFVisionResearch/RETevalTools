%% Load data

[~, ~, PHNROD, ~, ~, PHNROS, filename] = loadRETevalPHNR;

%% PHNR 
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

% Calculate
AwaveOD = -VoltOD(locAwaveOD);
BwaveOD = plus(VoltOD(locBwaveOD), AwaveOD);
BTOD = -VoltOD(locMinwaveOD);
PTOD = plus(BwaveOD, BTOD);
RatioPHNROD = PTOD/BwaveOD;
AwaveOS = -VoltOS(locAwaveOS);
BwaveOS = plus(VoltOS(locBwaveOS), AwaveOS);
BTOS = -VoltOS(locMinwaveOS);
PTOS = plus(BwaveOS, BTOS);
RatioPHNROS = PTOS/BwaveOS;

AtimeOD = timeOD(locAwaveOD);
BtimeOD = timeOD(locBwaveOD);
PHNRtimeOD = timeOD(locMinwaveOD);
AtimeOS = timeOS(locAwaveOS);
BtimeOS = timeOS(locBwaveOS);
PHNRtimeOS = timeOS(locMinwaveOS);


% Graph PHNR

figure('Name', 'Frequency Response Profile', 'visible', 'off'); hold on;
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
save([filepath filesep name '-PHNRdata.mat'], 'AwaveOD', 'BwaveOD', 'BTOD', 'PTOD','ratioPHNROD', 'AwaveOS', 'BwaveOS', 'BTOS', 'PTOS', 'ratioPHNROS','AtimeOD','BtimeOD','PHNRtimeOD','AtimeOS','BtimeOS','PHNRtimeOS');