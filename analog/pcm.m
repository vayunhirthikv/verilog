clc;
clear;
close all;

t = 0:0.01:1;
x = sin(2*pi*2*t);

L = 8;
q = round((x+1)*(L-1)/2);
q = 2*q/(L-1)-1;

subplot(3,1,1);
plot(t,x);
title('Original Signal');

subplot(3,1,2);
stairs(t,q);
title('Quantized Signal');

subplot(3,1,3);
stem(t,q);
title('PCM Quantized Levels');