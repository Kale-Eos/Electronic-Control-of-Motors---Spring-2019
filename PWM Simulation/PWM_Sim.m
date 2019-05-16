%% EE450 - Pulse Width Modulation (PWM) Simulation
% MATLAB Code developed by Paco Ellaga
% SID: 009602331

clc, clear all, close all;

% Variables (temp values, change if needed)
fs = 1000;          % sampling frequency
dt = 1/fs;          % differentional of time
t = 0:dt:1-dt;      % time interval and spacing

Vdc = 120;          % Source Voltage
RLoad = 10;         % Resistor Load
LLoad = 20e-3;      % Inductor Load

fTri = 120;         % Triangular frequency (amplitude)
fSin = 120;         % Sinusoidal frequency (amplitude)
aTri = 10;          % amplitude of Triangular
aSin = 10;          % amplitude of Sinusoidal -- less than value of aTri
thetaTri = -pi/2;   % Triangular phase delay
thetaSin = -pi/2;   % Triangular phase delay

% Signal ratios 
mF = fTri/fSin;     % frequency modulation ratio
mA = aSin/aTri;     % amplitude modulation ratio

% Actual Signals
Tri = aTri.*sawtooth(2*pi*fTri*t+thetaTri);     % Triangular signal
Sin = aSin.*sin(2*pi*fSin*t+thetaSin);          % Sinusoidal signal
L = length(Tri);

% need to eval following:
% V1 - amplitude of fundamental frequency
% THD - total harmonic distortion
% Power - reflective of load

% Simulation loop
for i = 1:L
    if (Sin(i) > Tri(i))
        PWM(i) = -1;     % if M value is greater than C return pulse
    else
        PWM(i) = 1;     % else return positive PWM signal
    end
end

figure('Name','PWM Signal Generation and Output Representation'),figure(1)

% Representation of the Sinusoidal Signal
subplot(3,1,1)
hold on, plot(t,Sin,'black','LineWidth',2)
plot(t,Tri), hold off
xlabel('Time (Snapshot)')
xlim([0 0.1])   % may be adjusted based on various input scenarios
ylabel('Amplitude'), % ylim([min(Sin) max(Sin)])
title('Message Signal'), legend('Message Signal','Triangular Signal')
grid minor, box on

% Representation of Triangular Signal
subplot(3,1,2)
hold on, plot(t,Tri)
plot(t,PWM,'red','LineWidth',2), hold off
xlabel('Sample (Snapshot)')
xlim([0 0.1])   % may be adjusted based on various input scenarios
ylabel('Amplitude'), ylim([min(Tri) max(Tri)])
title('PWM Signal Output'), legend('Triangular Signal','PWM Signal')
grid minor, box on

% Power Spectral Density
Welch = pwelch(PWM);    % allocation of Welch's PSD estimate
subplot(3,1,3)
plot(Welch)             % Spectrum of PWelch returned values
xlabel('Sample'), ylabel('Amplitude')
title('PWM Power Spectral Density'), legend('Power Spectral Density')
grid minor, box on

PSD_Min = min(Welch);   % Power Spectral Density Absolute Min 
PSD_Max = max(Welch);   % Power Spectral Density Absolute Max

% Spectrogram representations
figure('Name','Spectragram Evaluations'),figure(2)
subplot(3,1,1)
spectrogram(t,Sin)                      % time versus Sinusoid
title('Sinusoid Signal Spectrogram')
subplot(3,1,2)
spectrogram(t,Tri)                      % time versus Triangular
title('Triangular Signal Spectrogram')
subplot(3,1,3)
spectrogram(t,PWM)                      % time versus PWM
title('PWM SPectrogram')