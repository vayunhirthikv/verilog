
clc; clear; close all;

Am = input('Message amplitude: ');
Ac = input('Carrier amplitude: ');
fm = input('Message frequency: ');
fc = input('Carrier frequency: ');

mu = Am/Ac;
fs = 20*fc;
t = 0:1/fs:2/fm;

m = Am*cos(2*pi*fm*t);
c = Ac*cos(2*pi*fc*t);
s = (Ac+m).*cos(2*pi*fc*t);

y = abs(hilbert(s))-Ac;

subplot(4,1,1); plot(t,m); title('Message Signal');
subplot(4,1,2); plot(t,c); title('Carrier Signal');
subplot(4,1,3); plot(t,s); hold on; plot(t,Ac+m,'r--'); title('AM Signal');
subplot(4,1,4); plot(t,y); hold on; plot(t,m,'b--'); title('Demodulated Signal');

disp(['Modulation Index = ',num2str(mu)]);

