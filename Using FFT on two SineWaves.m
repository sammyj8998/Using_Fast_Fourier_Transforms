clc;            %Clear the command window
close all;      %Close all figures
clear ;         %Clear all variables

fontSize = 11;

% Sample every 0.1 seconds 
d = 2;          %Distance
Fs = 4000;      %Sample rate chosen has to be at the minimum double the frequency of the highest signal
x = 0:1/Fs:d;   %Samples per Second 

% Defining the parameters 
f1   = 700;     %Signal 1 Frequency
amp1 = 2;       %Signal 1 Amplitude
f2   = 1500;    %Signal 2 Frequency
amp2 = 4;       %Signal 2 Amplitude

% Generate Signals 
signal1 = amp1 *sin(2*pi*x*f1);  %Multiplying the amplitude by the sine wave
signal2 = amp2 *sin(2*pi*x*f2);  
sineWave1  = signal1 + signal2;  %Adding the two signals together

% Plotting the Signals 

plot(x, sineWave1, 'b.-', 'LineWidth', 1, 'MarkerSize', 11);  %Amplitude should be 6 as the the two waves are added together
hold on;
grid on;
title('Sine Waves', 'FontSize', fontSize);
xlabel('Time', 'FontSize', fontSize);
ylabel('Amplitude', 'FontSize', fontSize);

% Adding a Ramp
initial_amp = 0.7;                                            %Starting at 70% of the orignal amplitude
final_amp   = 0.2;                                            %Finishing at 20% of the original amplitude
envelope    = linspace(initial_amp,final_amp,(Fs*d)+1);       %Linspace is used to create a tunnel for which the signal follows
sineWave2   = sineWave1 .* envelope;
plot(x, sineWave2, 'g.-', 'LineWidth', 1, 'MarkerSize', 1);

% Generate the Lowpass filter 
f_cutoff        = 800;                                        %Frequency of 800 should cut out the frequency 2 amplitude
norm_f_cutoff   = f_cutoff/(Fs/2);
taps            = -500:500;                                   %Number of taps is dependent on processing speed

% Generate the coefficients of the filter
B       = sinc(norm_f_cutoff*(taps));                         %Hamming Windowed Sinc filter, this is the most basic sinc filter
A       = 1;

% Apply the Lowpass filter
sineWave3 = filter(B,A,sineWave2);                            %Adding the filter to the enveloped filtered signal 
plot(x, sineWave3, 'y.-', 'LineWidth', 0.5, 'MarkerSize', 0.5);

% Adding a legend to the graph
line(xlim, [0,0], 'Color', 'k', 'LineWidth', 2);
legend( 'Sine Wave 1', 'Sine Wave 2 (Ramp)', 'Sine Wave 3 (Filtered)');

%% FFT the signals 

N = length(sineWave1);                      %This allows the time of the signal to be found
f = 0:Fs/N:Fs/2;                            %This will declare the time domain variable

figure;
SineWave1FFT = abs(fft(sineWave1)/Fs);      %Looking for the absolute value of the fast fourier transform of sinewave 1
SineWave1FFT = SineWave1FFT(1:d*Fs/2+1);    %This will give the location of the frequency of the fft, the purpose of the +1 is to center it
plot(f,SineWave1FFT);
grid on
title('Frequency Spectrum of Sine Wave 1')
xlabel('Frequency')
ylabel('Amplitude')

figure;
SineWave2FFT = abs(fft(sineWave2)/Fs);
SineWave2FFT = SineWave2FFT(1:d*Fs/2+1);
plot(f,SineWave2FFT);
grid on
title('Frequency Spectrum of Sine Wave 2')
xlabel('Frequency')
ylabel('Amplitude')

figure;
SineWave3FFT = abs(fft(sineWave3)/Fs);
SineWave3FFT = SineWave3FFT(1:d*Fs/2+1);
plot(f,SineWave3FFT);
grid on
title('Frequency Spectrum of Sine Wave 3')
xlabel('Frequency')
ylabel('Amplitude')