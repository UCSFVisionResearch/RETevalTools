function [OD, OS] = calcPHNR(PlotAndSave, filename)
%% Load data

if ~exist('filename', 'var')
    [~, ~, PHNROD, ~, ~, PHNROS, filename] = loadRETevalPHNR;
else
    [~, ~, PHNROD, ~, ~, PHNROS, filename] = loadRETevalPHNR(filename);
end

%% PHNR 
if ~isempty(PHNROD) 
    mask = isnan(PHNROD);
    TimeOD = PHNROD(:,1);
    TimeOD = TimeOD(~mask(:,2));
    VoltOD = PHNROD(:,2);
    VoltOD = VoltOD(~mask(:,1));
end

if ~isempty(PHNROS) 
    mask = isnan(PHNROS);
    TimeOS = PHNROS(:,1);
    TimeOS = TimeOS(~mask(:,2));
    VoltOS = PHNROS(:,2);
    VoltOS = VoltOS(~mask(:,1));
end
clear mask

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

AtimeOD     = TimeOD(locAwaveOD);
BtimeOD     = TimeOD(locBwaveOD);
PHNRtimeOD  = TimeOD(locMinwaveOD);
AtimeOS     = TimeOS(locAwaveOS);
BtimeOS     = TimeOS(locBwaveOS);
PHNRtimeOS  = TimeOS(locMinwaveOS);

if ~isempty(PHNROD)
    OD          = struct;
    OD.Time     = TimeOD;
    OD.Volt     = VoltOD;
    OD.Awave    = AwaveOD;
    OD.Atime    = AtimeOD;
    OD.Bwave    = BwaveOD;
    OD.Btime    = BtimeOD;
    OD.BT       = BTOD;
    OD.PT       = PTOD;
    OD.RatioPHNR= RatioPHNROD;
    OD.PHNRtime = PHNRtimeOD;
else
    PHNROD = [];
end

if ~isempty(PHNROS)
    OS          = struct;
    OS.Time     = TimeOS;
    OS.Volt     = VoltOS;
    OS.Awave    = AwaveOS;
    OS.Atime    = AtimeOS;
    OS.Bwave    = BwaveOS;
    OS.Btime    = BtimeOS;
    OS.BT       = BTOS;
    OS.PT       = PTOS;
    OS.RatioPHNR= RatioPHNROS;
    OS.PHNRtime = PHNRtimeOS;
else 
    PHNROS = [];
end

% Graph PHNR
if exist('PlotAndSave', 'var') && PlotAndSave
    figure('Name', 'Frequency Response Profile', 'visible', 'on'); hold on;
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
    [filepath,name,~] = fileparts(filename);
    print([filepath filesep name '-PHNRplot.pdf'],'-dpdf','-fillpage');
    save([filepath filesep name '-PHNRdata.mat'], 'OD','OS');
end
end