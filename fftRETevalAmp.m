function amp = fftRETevalAmp(t, signal, freq)
    Fs= 1/(t(2)-t(1));     % Sampling freq
    T = 1/Fs;             % Sampling period       
    L = length(signal);   % Length of signal

    Y = fft(signal);

    % Compute the two-sided spectrum P2. Then compute the single-sided 
    % spectrum P1 based on P2 and the even-valued signal length L.
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    % Define the frequency domain f and plot the single-sided amplitude spectrum P1. 
    % The amplitudes are not exactly at 0.7 and 1, as expected, because of the added noise.
    f = Fs*(0:(L/2))/L;

    % plot(f,P1) 
    % title('Single-Sided Amplitude Spectrum of X(t)')
    % xlabel('f (Hz)')
    % ylabel('|P1(f)|')

    if freq < 1
        amp = P1(round(f,2) == freq) / 1000;
    else
        amp = P1(round(f) == freq) / 1000;
    end

    if numel(amp)>1
        amp = amp(1);
    end
end