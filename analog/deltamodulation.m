clc;
clear;
close all;

t = 0:0.01:1;
x = sin(2*pi*2*t);

d = 0.1;
y = zeros(size(x));

for i = 2:length(x)
    if x(i) >= y(i-1)
        y(i) = y(i-1) + d;
    else
        y(i) = y(i-1) - d;
    end
end

subplot(2,1,1);
plot(t,x);
title('Original Signal');

subplot(2,1,2);
stairs(t,y);
title('Delta Modulation Output');

figure;
stem(t,y);