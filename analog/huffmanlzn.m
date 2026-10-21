
clc; clear; close all;

txt = input('Enter text: ','s');
if isempty(txt), txt='ABRAKADABRA'; end

s = unique(double(txt));
p = arrayfun(@(x) sum(txt==x),s)/length(txt);
H = -sum(p.*log2(p));

d = huffmandict(s,p);
h = huffmanenco(double(txt),d);

D = containers.Map;
for i=1:256, D(char(i))=i; end
p1=''; l=[]; n=257;

for c=txt
    pc=[p1 c];
    if isKey(D,pc)
        p1=pc;
    else
        l(end+1)=D(p1);
        D(pc)=n; n=n+1; p1=c;
    end
end
l(end+1)=D(p1);

O=8*length(txt);
CR1=O/length(h);
CR2=O/(length(l)*ceil(log2(n)));

fprintf('Entropy = %.2f\nHuffman CR = %.2f\nLZW CR = %.2f\n',H,CR1,CR2);

subplot(1,2,1); bar([O length(h) length(l)*ceil(log2(n))]);
set(gca,'XTickLabel',{'Original','Huffman','LZW'});
title('Encoded Size');

subplot(1,2,2); bar([CR1 CR2]);
set(gca,'XTickLabel',{'Huffman','LZW'});
title('Compression Ratio');

