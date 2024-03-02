fs1 = 10000; %czestotliwosc probkowania
n1 = 0:10000;
t1 = 1/fs1*n1;
fn = 50; %czestotliwosc nosna
fm = 1; %czestotliwosc modulujaca
df = 5; %glebokosc modulacji
x1 = sin(2*pi*fm*t1);
y1 = sin(2*pi*fn*t1+df*sin(2*pi*fm*t1));
plot(t1, x1, "b-")
hold on
plot(t1, y1, "r-")

fs2 = 25;
n2 = 0:25;
t2= 1/fs*n;
y2 = sin(2*pi*fn*t2+df*sin(2*pi*fm*t2));
figure
plot(t2, y2, "r-")

% Generowanie widma gęstości mocy
[f1,pxx1] = pwelch(y1);
[f2,pxx2] = pwelch(y2);
% Wyświetlenie widma
figure
plot(f1, 10*log10(pxx1), "b-"); % wykres w skali logarytmicznej
hold on
plot(f2, 10*log10(pxx2), "r-")
