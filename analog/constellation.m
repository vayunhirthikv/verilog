clc; clear; close all;

b = randi([0 3],1,100);
s = pskmod(b,4);
r = awgn(s,10);
d = pskdemod(r,4);

SER = mean(b~=d);
disp(SER);

subplot(2,1,1);
scatterplot(s);
title('QPSK Constellation');

subplot(2,1,2);
stem(d);
title('Detected Symbols');