clear all;
close all;
%% Dane
fs   = 256*10^3;
f0   = fs/2;
f3dB = f0/2;
w0   = 2*pi*f0;
w3dB = 2*pi*f3dB;

f = 0:1:300*10^3;
w = 2*pi*f;

%% Filtr Butterworth

N=7;
[bm,an] = butter(N, w3dB, 's');
H1      = polyval(bm,j*w)./ polyval(an,j*w);
H1      = H1/max(H1);
H1log   = 20*log10(abs(H1));
plot(f, H1log, "b-")
hold on
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -160],'k');
plot([128 128]*10^3, [20 -160],'k');
title("ButterWorth N = " + N)
xlabel("Hz")
ylabel("dB")
xticks([0, 64e3, 128e3, 192e3, 256e3])
yticks([-120, -100, -80, -60, -40, -20, -3, 0])
figure 
plot(an,'r o');
title('Rozkład biegunów filtru Butterworth');

%% Filtr Czebyszewa pierwszy

N=5;
[bm,an] = cheby1(N, 3, w3dB, 's');
H2      = polyval(bm,j*w)./ polyval(an,j*w);
H2      = H2/max(H2);
H2log   = 20*log10(abs(H2));
figure
plot(f, H2log, "b-")
hold on
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -160],'k');
plot([128 128]*10^3, [20 -160],'k');
title("Czebyszew I N = " + N)
xlabel("Hz")
ylabel("dB")
xticks([0, 64e3, 128e3, 192e3, 256e3])
yticks([-120, -100, -80, -60, -40, -20, -3, 0])
figure
plot(an,'r o');
title('Rozkład biegunów filtru Czebyszewa I');

%% Filtr Czebyszewa drugi

N=4;
[bm,an] = cheby2(N, 40, w0, 's');
H3      = polyval(bm,j*w)./ polyval(an,j*w);
H3      = H3/max(H3);
H3log   = 20*log10(abs(H3));
figure
plot(f, H3log, "b-")
hold on
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -160],'k');
plot([128 128]*10^3, [20 -160],'k');
title("Czebyszew II N = " + N)
xlabel("Hz")
ylabel("dB")
xticks([0, 64e3, 128e3, 192e3, 256e3])
yticks([-120, -100, -80, -60, -40, -20, -3, 0])
figure
plot(an,'r o');
title('Rozkład biegunów filtru Czebyszewa II');

%% Filtr eliptyczny

N=10;
[bm,an] = ellip(N, 3, 40, w3dB, 's');
H4      = polyval(bm,j*w)./ polyval(an,j*w);
H4      = H4/max(H4);
H4log   = 20*log10(abs(H4));
figure
plot(f, H4log, "b-")
hold on
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -160],'k');
plot([128 128]*10^3, [20 -160],'k');
title("Eliptyczny N = " + N)
xlabel("Hz")
ylabel("dB")
xticks([0, 64e3, 128e3, 192e3, 256e3])
yticks([-120, -100, -80, -60, -40, -20, -3, 0])
figure
plot(an,'r o');
title('Rozkład biegunów filtru eliptycznego');

display("Butterworth 64kHz: " +H1log(f3dB) + "db")
display("Czebyszew I 64kHz: " +H2log(f3dB)  + "db")
display("Czebyszew II 64kHz: " +H3log(f3dB)  + "db")
display("Eliptyczny 64kHz: " +H4log(f3dB) + "db")

display("Butterworth 128kHz: " +H1log(f0) + "db")
display("Czebyszew I 128kHz: " +H2log(f0) + "db")
display("Czebyszew II 128kHz: " +H3log(f0) + "db")
display("Eliptyczny 128kHz: " +H4log(f0) + "db")