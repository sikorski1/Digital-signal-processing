clear all;
close all;


[data,fs] = audioread('challenge2020.wav');

values=['1' '2' '3'; '4' '5' '6'; '7' '8' '9'; '*' '0' '#'];

N=length(data);
df = fs/N;
f = 0 : df : fs/2-df;
dt = 1/fs; t = dt*(0:N-1); T=1/fs;
figure
plot(t, data);
figure
spectrogram( data, 4096, 4096-512, [0:5:2000], fs )
title("Wykres częstotliwościowy sygnału")

%39335

f1 = [692, 702];
f2 = [765, 775];
f3 = [847, 857];
f4 = [936, 946];
f5 = [1204, 1214];
f6 = [1331, 1341];
f7 = [1472, 1482];
fr = [697,770,852,941,1209,1336,1477];
H = [];
b = [];
a = [];
N=2;
Rp=1;
Rs=50;
freq = [f1;f2;f3;f4;f5;f6;f7];
figure
hold on
for i = 1:length(freq)
    [b(:,i), a(:,i)]= ellip(N,Rp, Rs,[freq(i,1), freq(i,2)]/(fs/2),'bandpass');
    z = exp(j*2*pi*f/fs);
    H(:,i) = polyval( b(end:-1:1, i), z ) ./ polyval( a(end:-1:1, i), z);
    plot(f,20*log10(abs(H(:,i)))); xlabel('f [Hz]'); grid; title('|H(f)| [dB]');
    plot([fr(i) fr(i)], [-70, 20], "k")
    xlim([0 1600]);
end
figure
hold on
y = [];
for i = 1:length(freq)
   y(:,i) = filter(b(:,i), a(:,i), data);
   y(:,i)   = y(:,i)./max(y(:,i));
   plot(abs(y(:,i)));
   plot([23300 23300], [0 0.01], "k")
   xlim([300000 1000000]);
   pause()
end

l=1;
i=1;
code = "";
prevs = 1;
s = [];
for j = 1:4
        s(j) = step(y(prevs:length(data),j)) 
end
for j = 1:3
        k(j) = step(y(prevs:length(data),j)) 
end
smin = min(s);
kmin = min(k);
vmax = max(smin,kmin)
while(i+vmax<length(data))
    a1=mean(abs(y(i:i+vmax,1)));
    a2=mean(abs(y(i:i+vmax,2)));
    a3=mean(abs(y(i:i+vmax,3)));
    a4=mean(abs(y(i:i+vmax,4)));
    b1=mean(abs(y(i:i+vmax,5)));
    b2=mean(abs(y(i:i+vmax,6)));
    b3=mean(abs(y(i:i+vmax,7)));
    [m, a] = max([a1, a2, a3, a4]);
    [m, b] = max([b1, b2, b3]);
    code(l) = values(a, b);
    i=i+vmax;
    l=l+1;
    prevs = vmax;
    s = [];
    k = [];
    for j = 1:4
        s(j) = step(y(prevs:length(data),j)); 
    end
    for j = 1:3
        k(j) = step(y(prevs:length(data),j));
    end
    smin = min(s);
    kmin = min(k);
    vmax = max(smin,kmin);
end
disp(code);
%123456789*0#5382207431215#6345934527*3026#9*4341392*45070047412*58*3150#28**000000

