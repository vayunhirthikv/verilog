
clc; clear; close all;

N = input('Enter number of symbols: ');
snr = input('Enter SNR: ');

b = randi([0 1],N,1);
q = randi([0 3],N,1);
m = randi([0 15],N,1);

x = pskmod(b,2);
y = pskmod(q,4,pi/4);
z = qammod(m,16);

x = awgn(x,snr,'measured');
y = awgn(y,snr,'measured');
z = awgn(z,snr,'measured');

subplot(1,3,1);
plot(real(x),imag(x),'r.');
hold on;
plot([-1 1],[0 0],'ko');
xline(0);
title('BPSK'); grid on; axis square;

subplot(1,3,2);
plot(real(y),imag(y),'b.');
hold on;
xline(0); yline(0);
title('QPSK'); grid on; axis square;

subplot(1,3,3);
plot(real(z),imag(z),'m.');
hold on;
xline([-2 0 2]); yline([-2 0 2]);
title('16-QAM'); grid on; axis square;

