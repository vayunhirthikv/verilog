clc; clear; close all;

b = randi([0 1],1,100);
s = dpskmod(b,2);
r = awgn(s,10);
d = dpskdemod(r,2);

BER = mean(b~=d);
disp(BER);

subplot(3,1,1);
stem(b);
title('Input Bits');

subplot(3,1,2);
stem(real(s));
title('DPSK Signal');

subplot(3,1,3);
stem(d);
title('Detected Bits');