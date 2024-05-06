clear all;
close all;
fs = 8000;
N = fs;
dt = 1/fs;
t = 0:dt:1-dt;
f = 0:fs/8000:fs/2;
A1 = -0.5;
A2 = 1;
f1 = 34.2;
f2 = 115.5;

dref = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t);


figure();
plot(t, dref, "g")
title("Czysty sygnał")
awgntab = [10,20,40];
for k = 1:3
d = awgn(dref, awgntab(k), "measured");
x = [d(1) d(1:end-1)];

figure
hold on
plot(t, x, "b")
plot(t, dref, "g")


M = 100; % długość filtru
mi = 0.0025; % współczynnik szybkości adaptacji
y = zeros(1,N); e = zeros(1,N); % sygnały wyjściowe z filtra
bx = zeros(M,1); % bufor na próbki wejściowe x
h = zeros(M,1); % początkowe (puste) wagi filtru
for n = 1 : length(x)
    bx = [ x(n); bx(1:M-1) ]; % pobierz nową próbkę x[n] do bufora
    y(n) = h' * bx; % oblicz y[n] = sum( x .* bx) – filtr FIR
    e(n) = d(n) - y(n); % oblicz e[n]
    h = h + mi * e(n) * bx; % LMS
    % h = h + mi * e(n) * bx /(bx'*bx); % NLMS
    if(0) % Obserwacja wag filtra oraz jego odpowiedzi czestotliwosciowej
            subplot(211); stem(h); xlabel('n'); title('h(n)'); grid;
            subplot(212); plot(f,abs(freqz(h,1,f,fs))); xlabel('f (Hz)');
            plot([34.2 34.2], [0 1], "k" )
                plot([115.5 115.5], [0 1], "k" )
            title('|H(f)|'); grid; pause(0.1)
        end  
end


figure;
subplot(211); plot(t,e,'r'); grid; title('WY : sygnal e(n) = d(n)-y(n) ' , awgntab(k));
subplot(212); plot(t,y,'b'); grid; title('WY : sygnal y(n) = destim ', awgntab(k));
xlabel('czas [s]');

figure; subplot(111); plot(t,dref,'g',t,e,'r',t,y,'b');
grid; xlabel('czas [s]'); title('Sygnały WE i WY ', awgntab(k));
legend('s(n) - oryginal','e(n) = d(n)-y(n)','y(n) = filtr[x(n)]'); 
SNR = 10*log10(sum(dref.^2) / sum((dref - y).^2))
end


