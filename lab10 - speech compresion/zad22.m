clear all;
close all;

[x, fpr] = audioread('mowa1.wav'); % Wczytaj sygnał mowy
oryginalny = x;
bezdzw = 80700:81400; % Zakres dla głoski bezdźwięcznej (Przy!ci!sku...)
dzw = 3000:3700; % Zakres dla głoski dźwięcznej (!M!aterial kursu...)

%% Wybierz ustaloną ramkę
ramka = dzw; % Przykładowa ustalona ramka

%% Preemfaza - filtracja wstępna
x = filter([1 -0.9735], 1, x);

%% Progowanie
P = 0.3 * max(x(ramka));
x(ramka) = x(ramka) - mean(x(ramka)); % Usuń wartość średnią
for iii = 1:length(x(ramka))
    if x(ramka(iii)) >= P
        x(ramka(iii)) = x(ramka(iii)) - P;
    elseif x(ramka(iii)) <= -P
        x(ramka(iii)) = x(ramka(iii)) + P;
    else
        x(ramka(iii)) = 0;
    end
end

%% Analiza - wyznacz parametry modelu
r = xcorr(x(ramka), 'biased');
Np = 10; % Rząd filtra predykcji
rr = r(2:Np+1)';
R = toeplitz(r(1:Np));

%% Oblicz współczynniki filtra predykcji
a = -inv(R) * rr; % Współczynniki filtra predykcji
wzm = r(1) + r(2:Np+1) .* a; % Oblicz wzmocnienie

%% Oblicz sygnał resztkowy dla ustalonej ramki
bx = x(ramka) - mean(x(ramka)); % Usuń wartość średnią
resztkowy = filter([1; a], 1, bx);

%% Wyświetl sygnał resztkowy i jego widmo
figure;
subplot(2, 1, 1);
plot(resztkowy);
title('Sygnał resztkowy dla ustalonej ramki');
xlabel('Próbki');
ylabel('Amplituda');

df = (fpr / length(resztkowy)) / 2;
f = df * (0:length(resztkowy)-1);
Reszt = fft(resztkowy);
[~, maxpos] = max(Reszt);
T = 1 / (2 * pi * f(maxpos));

subplot(2, 1, 2);
plot(f, abs(Reszt));
title('Widmo sygnału resztkowego dla ustalonej ramki');
xlabel('Częstotliwość [Hz]');
ylabel('Amplituda');
