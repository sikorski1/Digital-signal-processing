clear all;
close all;
load('butter.mat');
N = 16e3;
fs = 16e3;

f1 = 1209;
f2 = 1272;

dt = 1/fs;
df = N/fs;
T = N/fs;

t = 0:dt:T-dt;
f = 0:df:fs/2-df;
x = sin(2*pi*f1*t) + sin(2*pi*f2*t);

X = fft(x)/max(fft(x));
Xlog = 20*log10(abs(X));

figure
plot(t, x)
title("Sygnał wejściowy")
xlabel("t[s]")
ylabel("Ampituda[V]")
figure
plot(f, Xlog(1:length(f)), "b");
title("Charakterystyka w skali decybelowej")
xlabel("f[Hz]")
ylabel("Ampituda[dB]")
xlim([1100 1300]);

bm = poly(z);          
an = poly(p);          

Ha    = polyval(bm, j*2*pi*f)./polyval(an, j*2*pi*f);
Ha    = Ha./max(Ha);
Halog = 20*log10(abs(Ha));

[zd,pd,kd] = bilinear(z,p,k,fs);
z  = exp(j*2*pi*f/fs);
bm = poly(zd);          
an = poly(pd);
Hd    = kd * polyval(bm, z)./polyval(an, z);
Hd    = Hd./max(Hd);
Hdlog = 20*log10(abs(Hd));
figure
hold on
plot(f, Halog(1:length(f)), "r")
plot(f, Hdlog(1:length(f)), "b")
plot([1189 1189], [-70 20], 'k');
plot([1229 1229], [-70 20], 'k');
title('Filtr analogowy i cyfrowy (Ha, Hd)');
legend('Analogowy','Cyfrowy');
xlabel('Częstotliwość [Hz]');
ylabel('H [j\omega]');
xlim([1100 1300]);

y1 = filter(bm,an,x);

N = length(an);
ak = an(2:N); 
N = N-1;

M = length(bm);
xnm = zeros(1, M);
ynk = zeros(1, N);

for n = 1:16e3
    xnm    = [x(n)  xnm(1:M-1)];
    y2(n) = sum(xnm.*bm) - sum(ynk.*ak);
    ynk    = [y2(n) ynk(1:N-1)];
end

Y1    = fft(y1)/max(fft(y1));
Y1log = 20*log10(abs(Y1));

Y2    = fft(y2)/max(fft(y2));
Y2log = 20*log10(abs(Y2));

figure
hold on
plot(f, Y1log(1:length(f)), "b")
plot(f, Y2log(1:length(f)), "r")
title("Charakterystyka Y w skali decybelowej")
legend('matlab','własny');
xlim([1100 1300]);



f1 = 1189;  % częstotliwości filtru pasmowo-przepustowego BP
f2 = 1229;

w1 = 2/dt * tan(pi*f1/fs);
w2 = 2/dt * tan(pi*f2/fs);

[bm, an] = butter(4, [w1, w2], 's');
[z,p,k]  = tf2zp(bm,an);    
[zd,pd,kd] = bilinear(z,p,k,fs);

Ha2    = polyval(bm, j*2*pi*f)./polyval(an, j*2*pi*f);
Ha2    = Ha2./max(Ha2);
Ha2log = 20*log10(abs(Ha2));

bm = poly(zd);          
an = poly(pd);
Hd2    = kd * polyval(bm, exp(j*2*pi*f/fs))./polyval(an, exp(j*2*pi*f/fs));
Hd2    = Hd2./max(Hd2);
Hd2log = 20*log10(abs(Hd2));

figure
hold on
plot(f, Halog(1:length(f)), "bo")
plot(f, Ha2log(1:length(f)), "rx")
plot([1189 1189], [-70 20], 'k');
plot([1229 1229], [-70 20], 'k');
title("Przed prewarpingiem")
xlim([1100 1300]);

figure
hold on
plot(f, Hdlog(1:length(f)), "bo")
plot(f, Hd2log(1:length(f)), "rx")
plot([1189 1189], [-70 20], 'k');
plot([1229 1229], [-70 20], 'k');
title("Po prewarpingu")
xlim([1100 1300]);