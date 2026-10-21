
clc; clear; close all;

N = input('Enter number of bits (multiple of 4): ');
snr = input('Enter SNR: ');

b = randi([0 1],1,N);
t = 1:N;

% DPSK
d = dpskmod(b',2);
dr = dpskdemod(awgn(d,snr,'measured'),2);

% QPSK
q = pskmod(bit2int(b',2),4,pi/4);
qr = pskdemod(awgn(q,snr,'measured'),4,pi/4);
qb = int2bit(qr,2)';

% 16-QAM
m = qammod(bit2int(b',4),16);
mr = qamdemod(awgn(m,snr,'measured'),16);
mb = int2bit(mr,4)';

subplot(3,2,1); plot(real(d)); title('DPSK Modulated');
subplot(3,2,2); stairs(dr); title('DPSK Demodulated');

subplot(3,2,3); plot(real(q)); title('QPSK Modulated');
subplot(3,2,4); stairs(qb(:)); title('QPSK Demodulated');

subplot(3,2,5); plot(real(m)); title('16-QAM Modulated');
subplot(3,2,6); stairs(mb(:)); title('16-QAM Demodulated');

fprintf('DPSK BER = %f\n',biterr(b,dr')/N);
fprintf('QPSK BER = %f\n',biterr(b,qb)/N);
fprintf('QAM BER = %f\n',biterr(b,mb)/N);

