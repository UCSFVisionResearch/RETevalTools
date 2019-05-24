% Loads data and calculates the Frequency Response Curve
% TODO: debug fftRETevalAmp does not calculate amplitudes for frequencies >0

[Sin, filename] = loadRETevalSin;

% Isolate time/volt of a single response and trim NaN values
% then store them into separate arrays for each frequencies

freqs = [50,45,40,35,30,25,20,15,10,7,5,3,2,1,0.7,0.5,0.3];
freqsS = {'50','45','40','35','30','25','20','15','10','7','5','3','2','1','07','05','03'};

for idx = 1:2:size(Sin,2)
    Response = Sin(:,idx:idx+1);
    mask = isnan(Response);
    tmpTime = Response(:,1);
    tmpVolt = Response(:,2);
    tmpVolt = tmpVolt(~mask(:,2));
    tmpTime = tmpTime(~mask(:,1));
    Response = [tmpTime, tmpVolt];
    assignin('base', ['Sin' freqsS{(idx+1)/2} 'hz'], Response);
end
clear tmp* mask Response idx

% Calculate Frequency Response Profile for each eye

Amps = zeros(size(freqs));

for f = 1:numel(freqs)
    Response = eval(['Sin' freqsS{f} 'hz']);
    tmpTime = Response(:,1)/1000; % times are stored in ms, convert to s
    tmpVolt = Response(:,2);

    amp = fftRETevalAmp(tmpTime', tmpVolt', freqs(f));
    
    if ~isempty(amp)
        Amps(f) = amp;
    end
end

% Plot Frequency Response Profile

figure('Name', 'Frequency Response Profile'); hold on;
plot(freqs, Amps, '-ok');
xlabel('Frequency (hz)');
ylabel('Amplitude (microV)');

[filepath,name,ext] = fileparts(filename);
print([filepath filesep name '-FRCplot.pdf'],'-dpdf','-fillpage');
save([filepath filesep name '-FRCdata.mat'], 'Amps', 'freqs'); 

close