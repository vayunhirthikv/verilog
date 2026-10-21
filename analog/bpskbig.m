clc; clear; close all;

b = randi([0 1],1,100);
s = pskmod(b,2);
r = awgn(s,-5);
d = pskdemod(r,2);

BER = mean(b~=d);
disp(BER);

subplot(3,1,1);
stem(b);
title('Input Bits');

subplot(3,1,2);
stem(real(s));
title('BPSK Signal');

subplot(3,1,3);
stem(d);
title('Detected Bits');