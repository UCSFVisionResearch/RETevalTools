%% Load data

[FlashOD, FlickerOD, PHNROD, FlashOS, FlickerOS, PHNROS, filename] = loadRETevalPHNR;

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
[ValueBwaveOD, locBwaveOD] = max(pksPosOD);
locBwaveOD = locsPosOD(locBwaveOD);

% Calculate A wave as the first negative peak prior to B wave
locAwaveOD = TimeOD(locsNegOD) < TimeOD(locBwaveOD);
locAwaveOD = find(locAwaveOD, 1, 'last' );
locAwaveOD = locsNegOD(locAwaveOD);

% Repeat for OS
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[~,locsNegOS] = findpeaks(-VoltOS);
[ValueBwaveOS, locBwaveOS] = max(pksPosOS);
locBwaveOS = locsPosOS(locBwaveOS);

locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS);
locAwaveOS = find(locAwaveOS, 1, 'last' );
locAwaveOS = locsNegOS(locAwaveOS);

%% graph Flash
figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(FlashOD)
    plot(TimeOD, VoltOD, 'k');
    hold on
%    scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
%    scatter(TimeOD(locsNegOD), VoltOD(locsNegOD),'ob');
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

%% Flicker 
if ~isempty(FlickerOD) 
    TimeOD = FlickerOD(:,1);
    VoltOD = FlickerOD(:,2);
end

if ~isempty(FlickerOS) 
    TimeOS = FlickerOS(:,1);
    VoltOS = FlickerOS(:,2);
end

figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(FlickerOD)
    plot(TimeOD, VoltOD, 'k');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

subplot(2,1,2)
if ~isempty(FlickerOS)
    plot(TimeOS, VoltOD, 'k');
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

figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(FlashOD)
    plot(TimeOD, VoltOD, 'k');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

subplot(2,1,2)
if ~isempty(FlashOS)
    plot(TimeOS, VoltOS, 'k');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

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

% Calculate most minimum peak
[ValueMinwaveOD, locMinwaveOD] = max(pksNegOD);
locMinwaveOD = locsNegOD(locMinwaveOD);

% Repeat for OS
[pksPosOS,locsPosOS] = findpeaks(VoltOS);
[pksNegOS,locsNegOS] = findpeaks(-VoltOS);
[ValueBwaveOS, locBwaveOS] = max(pksPosOS);
locBwaveOS = locsPosOS(locBwaveOS);

locAwaveOS = TimeOS(locsNegOS) < TimeOS(locBwaveOS);
locAwaveOS = find(locAwaveOS, 1, 'last' );
locAwaveOS = locsNegOS(locAwaveOS);

[ValueMinwaveOS, locMinwaveOS] = max(pksNegOS);
locMinwaveOS = locsNegOS(locMinwaveOS);
%% Graph PHNR

figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(PHNROD)
    plot(TimeOD, VoltOD, 'k');
    hold on
%    scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
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
%    scatter(TimeOD(locsPosOD), VoltOD(locsPosOD),'or');
    %scatter(TimeOD(locsNegOS), VoltOD(locsNegOS),'ob');
    scatter(TimeOS(locAwaveOS), VoltOS(locAwaveOS),'or');
    scatter(TimeOS(locBwaveOS), VoltOS(locBwaveOS),'ob');
    scatter(TimeOS(locMinwaveOS), VoltOS(locMinwaveOS), 'og');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end