function [OD, OS] = calcFlash(PlotAndSave, filename)
%% Load data

if ~exist('filename', 'var')
[FlashOD, ~, ~, FlashOS, ~, ~, filename] = loadRETevalPHNR;
else
[FlashOD, ~, ~, FlashOS, ~, ~, filename] = loadRETevalPHNR(filename);    
end
%% Flash 
if ~isempty(FlashOD) 
    mask = isnan(FlashOD);
    TimeOD = FlashOD(:,1);
    TimeOD = TimeOD(~mask(:,2));
    VoltOD = FlashOD(:,2);
    VoltOD = VoltOD(~mask(:,1));
end

if ~isempty(FlashOS) 
    mask = isnan(FlashOS);
    TimeOS = FlashOS(:,1);
    TimeOS = TimeOS(~mask(:,2));
    VoltOS = FlashOS(:,2);
    VoltOS = VoltOS(~mask(:,1));
end
clear mask

% Calculate A and B wave peaks
if ~isempty(TimeOD)
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
    % Calculate
    AwaveOD = -VoltOD(locAwaveOD);
    BwaveOD = plus(VoltOD(locBwaveOD), AwaveOD);
    AtimeOD = TimeOD(locAwaveOD);
    BtimeOD = TimeOD(locBwaveOD);
end

% Repeat for OS
if ~isempty(TimeOS)
    [pksPosOS,locsPosOS] = findpeaks(VoltOS);
    [pksNegOS,locsNegOS] = findpeaks(-VoltOS);
    [~, locBwaveOS] = max(pksPosOS);
    locBwaveOS = locsPosOS(locBwaveOS);
    
    locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS) & TimeOS(locsNegOS) > 0;
    locAwaveOS = times(locAwaveOS, pksNegOS);
    [~, locAwaveOS] = max(locAwaveOS);
    locAwaveOS = locsNegOS(locAwaveOS);
    % Calculate
    AwaveOS = -VoltOS(locAwaveOS);
    BwaveOS = plus(VoltOS(locBwaveOS), AwaveOS);
    AtimeOS = TimeOS(locAwaveOS);
    BtimeOS = TimeOS(locBwaveOS);
end 

if ~isempty(TimeOD)
    OD          = struct;
    OD.Time     = TimeOD;
    OD.Volt     = VoltOD;
    OD.Awave    = AwaveOD;
    OD.Atime    = AtimeOD;
    OD.Bwave    = BwaveOD;
    OD.Btime    = BtimeOD;
else
    FlashOD = [];
    OD          = struct;
    OD.Time     = 0;
    OD.Volt     = 0;
    OD.Awave    = 0;
    OD.Atime    = 0;
    OD.Bwave    = 0;
    OD.Btime    = 0;
end

if ~isempty(TimeOS)
    OS          = struct;
    OS.Time     = TimeOS;
    OS.Volt     = VoltOS;
    OS.Awave    = AwaveOS;
    OS.Atime    = AtimeOS;
    OS.Bwave    = BwaveOS;
    OS.Btime    = BtimeOS;
else 
    FlashOS = [];
    OS          = struct;
    OS.Time     = 0;
    OS.Volt     = 0;
    OS.Awave    = 0;
    OS.Atime    = 0;
    OS.Bwave    = 0;
    OS.Btime    = 0;
end

% graph Flash 
if exist('PlotAndSave', 'var') && PlotAndSave
    figure('Name', 'Frequency Response Profile','visible','on'); hold on;
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
    [filepath,name,~] = fileparts(filename);
    print([filepath filesep name '-Flashplot.pdf'],'-dpdf','-fillpage');
    save([filepath filesep name '-Flashdata.mat'], 'OD', 'OS')
end
end

