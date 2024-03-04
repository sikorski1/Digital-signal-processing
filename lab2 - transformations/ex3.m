clear all;
close all;
N = 1000;
k = 0:N-1;
n = 0:N-1;
fs = 1000;
t = 0:1/1000:1-1/1000;
f1 = 50;
f2 = 100;
f3 = 150;
A1 = 50;
A2 = 100;
A3 = 150;
x = A1*sin(2*pi*f1*t)+A2*sin(2*pi*f2*t)+A3*sin(2*pi*f3*t);
A = zeros(N, N);
for k = 0:N-1
    if k == 0
        wk = sqrt(1/N);     % Wartość sk dla k = 0
    else
        wk = sqrt(2/N)*cos(pi*k/N*(n+0.5));     % Wartość sk dla k != 0
    end
  
    A(k+1, :) = wk;
end
S = A';
counter = 1;
for i = 1:N
    plot(1:N, A(i, :), "b-");
    hold on
    plot(1:N, S(:, i), "r--");
    title(counter);
    counter = counter + 1;
    %pause()
    clf;
end

y = A*x';
figure;
f=(0:N-1)*fs/N;
plot(f, y)
xs = S*y;
figure
plot(t, x, "b-")
hold on
plot(t, xs, "r--")
f4 = 105;
x2 = A1*sin(2*pi*f1*t)+A2*sin(2*pi*f4*t)+A3*sin(2*pi*f3*t);
y2 = A*x2';
xs2 = S*y2;
figure;
plot(f, y2);
title("y ---> f2 = 105Hz")

figure
plot(t, x2, "b-")
hold on
plot(t, xs2, "r-")
title("x, xs ---> f2 = 105Hz")

x3 = A1*sin(2*pi*52.5*t)+A2*sin(2*pi*102.5*t)+A3*sin(2*pi*152.5*t);
y3 = A*x3';
xs3 = S*y3;

figure;
plot(f, y3);
title("y ---> f1,f2,f3 + 2.5Hz")

figure
plot(t, x3, "b-")
hold on
plot(t, xs3, "r-")
title("x, xs ---> f1,f2,f3 + 2.5Hz")