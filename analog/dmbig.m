
clc;
clear;
close all;

A = 5;
N = 60;
d = 0.6;

t = linspace(0,2*pi,N);
x = A*sin(t);

y = zeros(1,N);
b = zeros(1,N);

for i = 1:N
    if x(i) > y(max(i-1,1))
        y(i) = y(max(i-1,1)) + d;
        b(i) = 1;
    else
        y(i) = y(max(i-1,1)) - d;
        b(i) = 0;
    end
end

subplot(4,1,1);
plot(t,x);
hold on;
stem(t,x);
title('Original Signal');

subplot(4,1,2);
stairs(t,y);
title('Delta Modulated Signal');

subplot(4,1,3);
stairs(t,b);
title('DM Bitstream');

subplot(4,1,4);
stairs(t,y);
title('Reconstructed Signal');

