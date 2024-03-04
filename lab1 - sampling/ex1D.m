clear all;
close all;
fs1 = 10000; %czestotliwosc probkowania
t1 = 0:1/fs1:1-1/fs1;
fn = 50; %czestotliwosc nosna
fm = 1; %czestotliwosc modulujaca
df = 5; %glebokosc modulacji
x1 = sin(2*pi*fm*t1);
y1 = sin(2*pi*fn*t1+df*sin(2*pi*fm*t1));
plot(t1, x1, "b-")
hold on
plot(t1, y1, "r-")

fs2 = 25;
t2= 0:1/fs2:1-1/fs2;

y2 = sin(2*pi*fn*t2+df*sin(2*pi*fm*t2));
figure
plot(t1, y1, "b-")
hold on
plot(t2, y2, "r-")

% Generowanie widma gęstości mocy
pxx1 = pwelch(y1);
pxx2 = pwelch(y2);
% Wyświetlenie widma
figure
plot(pxx1, "b-"); 
figure
plot(pxx2, "r-")
