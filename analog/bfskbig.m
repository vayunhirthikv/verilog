
clc; clear; close all;

d = input('Decimal: ');
Rb = input('Bit rate: ');
snr = input('SNR: ');

b = dec2bin(d)-'0';
N = length(b);

t = 0:1/(100*Rb):1/Rb-1/(100*Rb);
c1 = sin(2*pi*4*Rb*t);
c0 = sin(2*pi*2*Rb*t);

data = repelem(b,length(t));
s = [];

for i = 1:N
    if b(i)==1
        s = [s c1];
    else
        s = [s c0];
    end
end

r = awgn(s,snr,'measured');

for i = 1:N
    k = (i-1)*length(t)+1;
    z = r(k:k+length(t)-1);
    b2(i) = sum(z.*c1)>sum(z.*c0);
end

y = repelem(b2,length(t));

subplot(4,1,1); plot(data); title('Digital Signal');
subplot(4,1,2); plot(s); title('BFSK Signal');
subplot(4,1,3); plot(r); title('Received Signal');
subplot(4,1,4); plot(y); title('Decoded Signal');

disp(bin2dec(char(b2+'0')));
