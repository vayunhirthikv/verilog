
clc; clear; close all;

d = input('Enter decimal: ');
b = dec2bin(d)-'0';

b = [zeros(1,mod(-length(b),4)) b];
m = reshape(b,4,[])';

% Hamming Code
h = encode(m,7,4,'hamming/binary');
h = reshape(h',1,[]);

% Cyclic Code
p = cyclpoly(7,4);
c = encode(m,7,4,'cyclic/binary',p);
c = reshape(c',1,[]);

% Convolutional Code
t = poly2trellis(3,[7 5]);
v = convenc(b,t);

subplot(4,1,1); stairs(b); title('Message Bits');
subplot(4,1,2); stairs(h); title('Hamming Code');
subplot(4,1,3); stairs(c); title('Cyclic Code');
subplot(4,1,4); stairs(v); title('Convolutional Code');

disp(['Message: ',char(b+'0')]);
disp(['Hamming: ',char(h+'0')]);
disp(['Cyclic: ',char(c+'0')]);
disp(['Convolutional: ',char(v+'0')]);

