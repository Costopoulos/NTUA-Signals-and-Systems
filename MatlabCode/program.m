%Konstantinos Kostopoulos
%03117043
%Signals and Systems
%MATLAB Handout Exercise

%PART A

%A.1
a = audiorecorder;
recordblocking(a, 2);
y = getaudiodata(a);
audiowrite('sound.wav', y, 8000);

%A.2
y = audioread('sound.wav');
t = linspace(0,2,16000);
plot(t,y);
xlabel('Time(s)');
ylabel('Amplitude');
title('My Name');

%A.3
y = audioread('sound.wav');
%100ms time difference is 800 samples
window = 800; 
%Due to 50% overlap the window moves window/2 positions
step = window / 2; 
size = length(y)/step - 1;
x = y.^2;
energy = zeros(1, size);
first = 1;
last = window;
for i = 1 : size
    energy(i) = sum(x(first:last));
    first = first + step;
    last = last + step;
end
stem(energy);
xlabel('Window');
ylabel('Amplitude');
title('Energy per 100ms window (50% overlap)');

%A.4
y = audioread('sound.wav');
z = y(7200:8000);
sound(z);
audiowrite('rec.wav', z, 8000);
%z corresponds to 'a'
t = linspace(0, 100, 801);
plot(t,z);
title('Periodic 100ms window of "My Name"');
xlabel('Time(ms)');
ylabel('Amplitude');

%A.5
z = audioread('rec.wav');
a = fft(z, 1024);
N = length(a);
F = 8000;
DF = F / N;
%Frequency axis
f = [0:DF:F - DF];
%Abs
x = abs(a);
plot(f, x); 
title('Absolute value of Fourier Transform');
ylabel('|fft(a)|')
xlabel('Frequency(Hz)');
%Log
y = 20*log10(abs(a));
plot(f, y);
title('Absolute value of Fourier Transform in logarithmic scale');
ylabel('20*log10(|fft(a)|');
xlabel('Frequency(Hz)');

%B.1
%a = 0.5, n0 = 10
nom = [1 zeros(1, 9) 0.5]; %z^10 + 0.5
denom = [1 zeros(1,10)]; %z^10
%s[n]
[s,n] = stepz(nom, denom, 21);
stem(n,s);
title('Step response s[n]');
%Impulse response h[n]
[h,n] = impz(nom, denom, 21);
stem(n, h);
title('Impulse response h[n]');

%B.2
%n0 = 10

%a = 0.1
subplot(2,2,1);
nom = [1 zeros(1, 9) 0.1];
denom = [1 zeros(1,10)];
zplane(nom,denom);
title('a = 0.1');
disp(roots(nom));
disp(roots(denom));
%Note: roots has less accuracy than zplane
%a = 0.01
subplot(2,2,2);
nom = [1 zeros(1, 9) 0.01];
denom = [1 zeros(1,10)];
zplane(nom,denom);
title('a = 0.01');
%a = 0.001
subplot(2,2,3);
nom = [1 zeros(1, 9) 0.001];
denom = [1 zeros(1,10)];
zplane(nom,denom);
title('a = 0.001');

%B.3 - B.4
%a = 0.5, n0 = 2000
nom = [1 zeros(1, 1999) 0.5];
denom = [1 zeros(1,1999)];
y = audioread('rec.wav');
y = [y; zeros(2000, 1)];
z = filter(nom, denom, y);
plot(z);
title('rec.wav filtered by y');
xlabel('Samples');
ylabel('Amplitude');
sound(z);
%Fourier
a = fft(z, 4096);
N = length(a);
F = 8000;
DF = F / N;
%Frequency axis
f = [0:DF:F - DF];
%Abs(fft)
x = abs(a);
plot(f, x); 
title('Absolute value of Fourier Transform');
ylabel('|fft(a)|')
xlabel('Frequency(Hz)');
%Log(fft)
y = 20*log10(abs(a));
plot(f, y);
title('Absolute value of Fourier Transform in logarithmic scale');
ylabel('20*log10(|fft(a)|');
xlabel('Frequency(Hz)');


%PART C

%C.1
function y = resonator(x, resonator_frequency, r, sampling_frequency)
    nom = [1];
    denom = [1 -2*r*cos(2*pi*resonator_frequency/sampling_frequency) r^2];
    y = filter(nom, denom, x);
end

%C.2
Fs = 800;
Fr = 200;
%For r = 0.95 or 0.5 or 1.2 change value below
r = 0.95;
%Impulse response 
subplot(2,1,1);
t = linspace(0,1,Fs);
h = (t==0);
z = resonator(h, Fr, r, Fs);
plot(t, z);
title(['Impulse response r = ', num2str(r)]);
xlabel('Time(s)');
ylabel('Amplitude');
%Frequency response;
subplot(2,1,2);
a = abs(fft(z, 1024));
DF = Fs / length(a);
f = [0:DF:Fs-DF];
plot(f,a);
title(['Frequency response r = ', num2str(r)]);
ylabel('|fft(a)|');
xlabel('Frequency(Hz)');


%C.3
Fs = 8000;
r = 0.95;
t = linspace(0,1,Fs);
h = (t==0);
z1 = resonator(h, 500, r, Fs); %Fr1= 500
z2 = resonator(z1, 1500, r, Fs); %Fr2 = 1500
z3 = resonator(z2, 2500, r, Fs); %Fr3 = 2500
a = abs(fft(z3));
DF = Fs / length(a);
f = [0:DF:Fs-DF];
plot(f,a);
title('Frequency response');
ylabel('|fft(a)|');
xlabel('Frequency(Hz)');

%C.4
Fs = 8000;
r = 0.95;
t = linspace(0,0.2, 201);
h = (mod(1000*t,10)== 0);
stem(t, h);
title('Impulse train');
xlabel('Time(s)');
ylabel('Amplitude');
z1 = resonator(h, 500, r, Fs); %Fr1= 500
z2 = resonator(z1, 1500, r, Fs); %Fr2 = 1500
z3 = resonator(z2, 2500, r, Fs); %Fr3 = 2500
a = abs(fft(z3));
DF = Fs / length(a);
f = [0:DF:Fs-DF];
plot(f,a);
title('Frequency response');
ylabel('|fft(a)|');
xlabel('Frequency(Hz)');
sound(a);
nom = [1 -1];
denom = [1 0];
y = filter(nom, denom, a);
sound(y); %sound=E
