%% Load OnOff Data

[OnOffOD, OnOffOS, filename] = loadRETevalOnOff;

%%
if ~isempty(OnOffOD) 
    TimeOD = OnOffOD(:,1);
    VoltOD = OnOffOD(:,2);
end

if ~isempty(OnOffOS) 
    TimeOS = OnOffOS(:,1);
    VoltOS = OnOffOS(:,2);
end


%% 
figure('Name', 'Frequency Response Profile'); hold on;
subplot(2,1,1)
if ~isempty(OnOffOD)
    plot(TimeOD, VoltOD, 'k');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end

subplot(2,1,2)
if ~isempty(OnOffOS)
    plot(TimeOS, VoltOD, 'k');
    xlabel('Time (ms)');
    ylabel('Amplitude (microV)');
end