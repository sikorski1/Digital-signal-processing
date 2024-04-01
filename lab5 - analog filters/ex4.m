clear all;
close all;

f  = 92*10^6:100:100*10^6;  % Przedział od 92MHz do 100MHz
f0 = 96*10^6;               % Częstotliwość środkowa 96MHz -+ 100kHz
w  = 2*pi*f;
N = 6;
[bm, an] = ellip(N, 3, 40, [2*pi*(f0-10^6) 2*pi*(f0+10^6)], 's');
H1       = polyval(bm, j*w)./polyval(an, j*w);
H1       = H1/max(H1);
H1log    = 20*log10(abs(H1));

plot(f,H1log,'b'); 
hold on
plot([92, 100]*10^6, [-3, -3], "k")
plot([92, 100]*10^6, [-40, -40], "k")
plot([95*10^6, 95*10^6], [0, -160], "k")
plot([97*10^6, 97*10^6], [0, -160], "k")
title("Filtr eliptyczny 96MHz-+1MHz")
xlabel("Hz")
ylabel("dB")
N=4;
[bm, an] = ellip(N, 3, 40, [2*pi*(f0-10^5) 2*pi*(f0+10^5)], 's');
H2       = polyval(bm, j*w)./polyval(an, j*w);
H2       = H2/max(H2);
H2log    = 20*log10(abs(H2));
figure
plot(f,H2log,'r'); 
hold on
plot([92, 100]*10^6, [-3, -3], "k")
plot([92, 100]*10^6, [-40, -40], "k")
plot([959*10^5, 959*10^5], [0, -160], "k")
plot([961*10^5, 961*10^5], [0, -160], "k")
title("Filtr eliptyczny 96MHz-+100kHz")
xlabel("Hz")
ylabel("dB")