
clc; clear; close all;

snr = -10:30;
s = 10.^(snr/10);
B = [1000 2000 5000];

subplot(2,1,1);
for b = B
    plot(snr,b*log2(1+s)/1000); hold on;
end
grid on;
title('Capacity vs SNR');
xlabel('SNR (dB)'); ylabel('Capacity (kbps)');
legend('1 kHz','2 kHz','5 kHz');

B = 100:100:50000;
C = B.*log2(1+1./(1e-4*B));

subplot(2,1,2);
plot(B/1000,C/1000); hold on;
yline(1.44*1/1e-4/1000,'r--');
grid on;
title('Capacity vs Bandwidth');
xlabel('Bandwidth (kHz)'); ylabel('Capacity (kbps)');
legend('Capacity','Shannon Limit');

