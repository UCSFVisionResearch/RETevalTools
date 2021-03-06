function [OD, OS] = calcOnOff(PlotAndSave, filename)
%% Load OnOff Data

if ~exist('filename', 'var')
    [OnOffOD, OnOffOS, filename] = loadRETevalOnOff;
else
    [OnOffOD, OnOffOS, filename] = loadRETevalOnOff(filename);
end

if ~isempty(OnOffOD) 
    mask = isnan(OnOffOD);
    TimeOD = OnOffOD(:,1);
    TimeOD = TimeOD(~mask(:,2));
    VoltOD = OnOffOD(:,2);
    VoltOD = VoltOD(~mask(:,1));
end

if ~isempty(OnOffOS) 
    mask = isnan(OnOffOS);
    TimeOS = OnOffOS(:,1);
    TimeOS = TimeOS(~mask(:,2));
    VoltOS = OnOffOS(:,2);
    VoltOS = VoltOS(~mask(:,1));
end
clear mask

if ~isempty(TimeOD)
    % Calculate A and B waves
    [pksPosOD,locsPosOD] = findpeaks(VoltOD);
    [pksNegOD,locsNegOD] = findpeaks(-VoltOD);
    
    % First calculate B wave as maximum positive peak
    locBwaveOD = TimeOD(locsPosOD) < 100 & TimeOD(locsPosOD) > 0;
    pksBOD = pksPosOD(locBwaveOD);
    [~, locBwaveOD] = max(pksBOD);
    baselineOD = find(TimeOD(locsPosOD) < 0);
    baselineOD = baselineOD(end);
    locBwaveOD = locsPosOD(plus(locBwaveOD, baselineOD));
    
    % Calculate A wave as the first negative peak prior to B wave
    locAwaveOD = TimeOD(locsNegOD) < TimeOD(locBwaveOD) & TimeOD(locsNegOD) > 0;
    locAwaveOD = pksNegOD(locAwaveOD);
    [~, locAwaveOD] = max(locAwaveOD);
    baselineOD = find(TimeOD(locsNegOD) < 0);
    baselineOD = baselineOD(end);
    locAwaveOD = locsNegOD(plus(locAwaveOD, baselineOD));
    
    % Calculate the D wave. look after signal is off from 200 ms
    %locDwaveOD = TimeOD(locsPosOD) > TimeOD(locsNegOD(PostBwaveOD)) & TimeOD(locsPosOD) < 300;
    locDwaveOD = TimeOD(locsPosOD) > 200 & TimeOD(locsPosOD) < 300;
    locDwaveOD = pksPosOD(locDwaveOD);  
    [~, locDwaveOD] = max(locDwaveOD);
    baselineOD = find(TimeOD(locsPosOD) < 200);
    baselineOD = baselineOD(end);
    locDwaveOD = locsPosOD(plus(locDwaveOD, baselineOD));

    % Calculate
    stimulusoffOD = TimeOD > 209.408;
    stimulusoffOD = VoltOD(stimulusoffOD);
    stimulusoffOD = stimulusoffOD(1);
    
    AwaveOD = -VoltOD(locAwaveOD);
    BwaveOD = plus(VoltOD(locBwaveOD), AwaveOD);
    DwaveOD = plus(VoltOD(locDwaveOD), abs(max(stimulusoffOD)));
    
    AtimeOD = TimeOD(locAwaveOD);
    BtimeOD = TimeOD(locBwaveOD);
    DtimeOD = TimeOD(locDwaveOD);

end

% Repeat for OS
if ~isempty(TimeOS)
    [pksPosOS,locsPosOS] = findpeaks(VoltOS);
    [pksNegOS,locsNegOS] = findpeaks(-VoltOS);
    locBwaveOS = TimeOS(locsPosOS) < 100 & TimeOS(locsPosOS) > 0;
    pksBOS = pksPosOS(locBwaveOS);
    [~, locBwaveOS] = max(pksBOS);
    baselineOS = find(TimeOS(locsPosOS) < 0);
    baselineOS = baselineOS(end);
    locBwaveOS = locsPosOS(plus(locBwaveOS, baselineOS));
    
    locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS) & TimeOS(locsNegOS) > 0;
    locAwaveOS = pksNegOS(locAwaveOS);
    [~, locAwaveOS] = max(locAwaveOS);
    baselineOS = find(TimeOS(locsNegOS) < 0);
    baselineOS = baselineOS(end);
    locAwaveOS = locsNegOS(plus(locAwaveOS, baselineOS));
    
    locDwaveOS = TimeOS(locsPosOS) > 200 & TimeOS(locsPosOS) < 300;
    locDwaveOS = pksPosOS(locDwaveOS);
    [~, locDwaveOS] = max(locDwaveOS);
    baselineOS = find(TimeOS(locsPosOS) < 200);
    baselineOS = baselineOS(end);
    locDwaveOS = locsPosOS(plus(locDwaveOS, baselineOS));

    % Calculate
    stimulusoffOS = TimeOS > 209.408;
    stimulusoffOS = VoltOS(stimulusoffOS);
    stimulusoffOS = stimulusoffOS(1);
    
    AwaveOS = -VoltOS(locAwaveOS);
    BwaveOS = plus(VoltOS(locBwaveOS), AwaveOS);
    DwaveOS = plus(VoltOS(locDwaveOS), abs(max(stimulusoffOS)));
    
    AtimeOS = TimeOS(locAwaveOS);
    BtimeOS = TimeOS(locBwaveOS);
    DtimeOS = TimeOS(locDwaveOS);
end

if ~isempty(TimeOD)
    OD          = struct;
    OD.Time     = TimeOD;
    OD.Volt     = VoltOD;
    OD.Awave    = AwaveOD;
    OD.Atime    = AtimeOD;
    OD.Bwave    = BwaveOD;
    OD.Btime    = BtimeOD;
    OD.Dwave    = DwaveOD;
    OD.Dtime    = DtimeOD;
else
    OnOffOD = [];
    OD          = struct;
    OD.Time     = 0;
    OD.Volt     = 0;
    OD.Awave    = 0;
    OD.Atime    = 0;
    OD.Bwave    = 0;
    OD.Btime    = 0;
    OD.Dwave    = 0;
    OD.Dtime    = 0;
end

if ~isempty(TimeOS)
    OS          = struct;
    OS.Time     = TimeOS;
    OS.Volt     = VoltOS;
    OS.Awave    = AwaveOS;
    OS.Atime    = AtimeOS;
    OS.Bwave    = BwaveOS;
    OS.Btime    = BtimeOS;
    OS.Dwave    = DwaveOS;
    OS.Dtime    = DtimeOS;
else 
    OnOffOS = [];
    OS          = struct;
    OS.Time     = 0;
    OS.Volt     = 0;
    OS.Awave    = 0;
    OS.Atime    = 0;
    OS.Bwave    = 0;
    OS.Btime    = 0;
    OS.Dwave    = 0;
    OS.Dtime    = 0;
end

% Plot graph 
if exist('PlotAndSave', 'var') && PlotAndSave
    figure('Name', 'Frequency Response Profile', 'visible', 'on'); hold on;
    subplot(2,1,1)
    if ~isempty(OnOffOD)
        plot(TimeOD, VoltOD, 'k');
        hold on
        %scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
        %scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
        scatter(TimeOD(locAwaveOD), VoltOD(locAwaveOD),'or');
        scatter(TimeOD(locBwaveOD), VoltOD(locBwaveOD),'ob');
        %scatter(TimeOD(450), VoltOD(450), 'o')
        scatter(TimeOD(locDwaveOD), VoltOD(locDwaveOD), 'og');
        xlabel('Time (ms)');
        ylabel('Amplitude (microV)');
    end
    
    subplot(2,1,2)
    if ~isempty(OnOffOS)
        plot(TimeOS, VoltOS, 'k');
        hold on
        %scatter(TimeOS(locsPosOS), VoltOS(locsPosOS),'or');
        %scatter(TimeOS(locsNegOS), VoltOS(locsNegOS),'ob');
        scatter(TimeOS(locAwaveOS), VoltOS(locAwaveOS),'or');
        scatter(TimeOS(locBwaveOS), VoltOS(locBwaveOS),'ob');
        scatter(TimeOS(locDwaveOS), VoltOS(locDwaveOS), 'og');
        xlabel('Time (ms)');
        ylabel('Amplitude (microV)');
    end
    
 %%   %
    [filepath,name,ext] = fileparts(filename);
    print([filepath filesep name '-plot.pdf'],'-dpdf','-fillpage');
    save([filepath filesep name '-data.mat'], 'OD',  'OS');
end
end