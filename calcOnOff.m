%% Load OnOff Data

[OnOffOD, OnOffOS, filename] = loadRETevalOnOff;


if ~isempty(OnOffOD) 
    TimeOD = OnOffOD(:,1);
    VoltOD = OnOffOD(:,2);
end

if ~isempty(OnOffOS) 
    TimeOS = OnOffOS(:,1);
    VoltOS = OnOffOS(:,2);
end

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
locB2waveOD = TimeOD(locsPosOD) > TimeOD(locsNegOD(PostBwaveOD)) & TimeOD(locsPosOD) < 300;
locB2waveOD = times(locB2waveOD, pksPosOD);
[~, locB2waveOD] = max(locB2waveOD);
locB2waveOD = locsPosOD(locB2waveOD);

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
locB2waveOS = TimeOS(locsPosOS) > TimeOS(locsNegOS(PostBwaveOS)) & TimeOS(locsPosOS) < 300;
locB2waveOS = times(locB2waveOS, pksPosOS);
[~, locB2waveOS] = max(locB2waveOS);
locB2waveOS = locsPosOS(locB2waveOS);

% Plot graph 
figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(OnOffOD)
    plot(TimeOD, VoltOD, 'k');
    hold on
    %scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
    %scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
    scatter(TimeOD(locAwaveOD), VoltOD(locAwaveOD),'or');
    scatter(TimeOD(locBwaveOD), VoltOD(locBwaveOD),'ob');
    scatter(TimeOD(locB2waveOD), VoltOD(locB2waveOD), 'og');
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
    scatter(TimeOS(locB2waveOS), VoltOS(locB2waveOS), 'og');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

%%
[filepath,name,ext] = fileparts(filename);
print([filepath filesep name '-plot.pdf'],'-dpdf','-fillpage');
save([filepath filesep name '-data.mat']);