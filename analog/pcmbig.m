
clc;
clear;
close all;

A = 5;
N = 20;
n = 3;

t = linspace(0,2*pi,N);
x = A*sin(t);

q = uencode(x,n,A);
y = udecode(q,n,A);

b = dec2bin(q,n)-'0';
b = reshape(b',1,[]);

subplot(4,1,1);
plot(t,x);
title('Original Signal');

subplot(4,1,2);
stem(t,q);
title('Quantized Levels');

subplot(4,1,4);
stairs(t,y);
title('Reconstructed Signal');


subplot(4,1,3);
stairs(b);
title('PCM Bitstream');

