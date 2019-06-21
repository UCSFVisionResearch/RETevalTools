%% Calculating peaks
function [locBwave, locAwave] = ABwave(pksPos, pksNeg, locsPos, locsNeg, Time, Volt)
[~, locBwave] = max(pksPos);
locBwave = locsPos(locBwave);

locAwave = Time(locsNeg) < Time(locBwave);
locAwave = times(locAwave, pksNeg);
[~, locAwave] = max(locAwave);
locAwave = locsNeg(locAwave);
