
clc; clear; close all;

N = input('Enter even number of bits: ');
snr = input('Enter SNR: ');

if mod(N,2), N=N+1; end
b = randi([0 1],1,N);

Rb = 100;
fs = 100*Rb;
fc = 2*Rb;
spb = fs/Rb;
sps = 2*spb;

t = (0:sps-1)/fs;
tt = (0:N*sps/2-1)/fs;

I = repelem(2*b(1:2:end)-1,sps);
Q = repelem(2*b(2:2:end)-1,sps);

I_mod = I.*cos(2*pi*fc*tt);
Q_mod = -Q.*sin(2*pi*fc*tt);
s = I_mod+Q_mod;

r = awgn(s,snr,'measured');

for k=1:N/2
    idx=(k-1)*sps+1:k*sps;
    a(k)=sum(r(idx).*cos(2*pi*fc*t));
    c(k)=sum(r(idx).*(-sin(2*pi*fc*t)));
end

rx=zeros(1,N);
rx(1:2:end)=a>0;
rx(2:2:end)=c>0;

y=repelem(rx,spb);

subplot(5,1,1); plot(tt,repelem(b,spb)); title('Input Bits');
subplot(5,1,2); plot(tt,I_mod); title('In-Phase Signal');
subplot(5,1,3); plot(tt,Q_mod); title('Quadrature Signal');
subplot(5,1,4); plot(tt,s); title('QPSK Modulated Signal');
subplot(5,1,5); plot(tt,y); title('Decoded Signal');

disp(['Received Bits: ',char(rx+'0')]);
disp(['Bit Errors: ',num2str(sum(b~=rx))]);

