%% Load OnOff Data

[OnOffOD, OnOffOS, filename] = loadRETevalOnOff;


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

% Calculate A and B waves
[pksPosOD,locsPosOD] = findpeaks(VoltOD);
[pksNegOD,locsNegOD] = findpeaks(-VoltOD);

% First calculate B wave as maximum positive peak
pksBOD = times(pksPosOD, (TimeOD(locsPosOD) < 100));
[ValueBwaveOD, locBwaveOD] = max(pksBOD);
locBwaveOD = locsPosOD(locBwaveOD);

% Calculate A wave as the first negative peak prior to B wave
locAwaveOD = TimeOD(locsNegOD) < TimeOD(locBwaveOD) & TimeOD(locsNegOD) > 0;
locAwaveOD = times(locAwaveOD, pksNegOD);
[~, locAwaveOD] = max(locAwaveOD);
locAwaveOD = locsNegOD(locAwaveOD);

% Calculate the B wave for the second flash. 
%First find the largest Neg wave, and then create set from there
PostBwaveOD = TimeOD(locsNegOD) > TimeOD(locBwaveOD);
PostBwaveOD = times(PostBwaveOD, pksNegOD);
[~, PostBwaveOD] = max(PostBwaveOD);
locDwaveOD = TimeOD(locsPosOD) > TimeOD(locsNegOD(PostBwaveOD)) & TimeOD(locsPosOD) < 300;
locDwaveOD = times(locDwaveOD, pksPosOD);
[~, locDwaveOD] = max(locDwaveOD);
locDwaveOD = locsPosOD(locDwaveOD);

% Repeat for OS
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[pksNegOS,locsNegOS] = findpeaks(-VoltOS);
pksBOS = times(pksPosOS, (TimeOS(locsPosOS) < 100));
[~, locBwaveOS] = max(pksBOS);
locBwaveOS = locsPosOS(locBwaveOS);

locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS) & TimeOS(locsNegOS) > 0;
locAwaveOS = times(locAwaveOS, pksNegOS);
[~, locAwaveOS] = max(locAwaveOS);
locAwaveOS = locsNegOS(locAwaveOS);

PostBwaveOS = TimeOS(locsNegOS) > TimeOS(locBwaveOS);
PostBwaveOS = times(PostBwaveOS, pksNegOS);
[~, PostBwaveOS] = max(PostBwaveOS);
locDwaveOS = TimeOS(locsPosOS) > TimeOS(locsNegOS(PostBwaveOS)) & TimeOS(locsPosOS) < 300;
locDwaveOS = times(locDwaveOS, pksPosOS);
[~, locDwaveOS] = max(locDwaveOS);
locDwaveOS = locsPosOS(locDwaveOS);

% Calculate
stimulusoffOD = TimeOD > 209.4 & TimeOD < 209.5;
stimulusoffOD = times(stimulusoffOD, VoltOD);
stimulusoffOS = TimeOS > 209.4 & TimeOS < 209.5;
stimulusoffOS = times(stimulusoffOS, VoltOS);

AwaveOD = -VoltOD(locAwaveOD);
BwaveOD = plus(VoltOD(locBwaveOD), AwaveOD);
DwaveOD = plus(VoltOD(locDwaveOD), abs(max(stimulusoffOD)));

AwaveOS = -VoltOS(locAwaveOS);
BwaveOS = plus(VoltOS(locBwaveOS), AwaveOS);
DwaveOS = plus(VoltOS(locDwaveOS), abs(max(stimulusoffOS)));

AtimeOD = TimeOD(locAwaveOD);
BtimeOD = TimeOD(locBwaveOD);
DtimeOD = TimeOD(locDwaveOD);

AtimeOS = TimeOS(locAwaveOS);
BtimeOS = TimeOS(locBwaveOS);
DtimeOS = TimeOS(locDwaveOS);


% Plot graph 
figure('Name', 'Frequency Response Profile', 'visible', 'off'); hold on;
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

%
[filepath,name,ext] = fileparts(filename);
print([filepath filesep name '-plot.pdf'],'-dpdf','-fillpage');
save([filepath filesep name '-data.mat'], 'AwaveOD', 'BwaveOD', 'DwaveOD', 'AtimeOD', 'BtimeOD', 'DtimeOD',  'AwaveOS', 'BwaveOS', 'DwaveOS', 'AtimeOS', 'BtimeOS', 'DtimeOS');