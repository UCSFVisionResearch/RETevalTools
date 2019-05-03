Sin = loadRETevalSin;

%% Isolate time/volt of a single response and trim NaN values

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