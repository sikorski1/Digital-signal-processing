clear all
close all

[x, fs] = audioread("mowa8000 (1).wav");
hi = zeros(1, 255);
hi(255) = 0.8;
hi(120) = -0.5;
hi(30) = 0.1;

N = fs
d = conv(x, hi, 'same');
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
   
end


subplot(211)
stem(hi)
subplot(212)
stem(h)
figure
plot(e)
figure
plot(y)