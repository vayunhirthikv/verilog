
clc; clear; close all;

P = [1 1 0;1 0 1;0 1 1;1 1 1];
G = [P eye(4)];
H = [eye(3) P'];

d = [1 0 1 1];
c = mod(d*G,2);
disp('Encoded:'); disp(c);

r = c;
r(3) = ~r(3);
disp('Received:'); disp(r);

S = mod(r*H',2);
disp('Syndrome:'); disp(S);

for i = 1:7
    e = zeros(1,7); e(i) = 1;
    if isequal(mod(e*H',2),S)
        r(i) = ~r(i);
        break;
    end
end

disp('Corrected:'); disp(r);
disp('Decoded:'); disp(r(4:7));

