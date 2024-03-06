clear all;
close all;
N = 100;
k = 0:N-1;
n = 0:N-1;
fs = 1000;
t = 0:1/1000:0.1-1/1000;
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
f=(0:N-1)*fs/(2*N);
stem(f, abs(y))
xs = S*y;
figure
plot(x, "b-")
hold on
plot(xs, "r--")
err = max(max(abs(x'-xs)));
fprintf('Reconstructed with error: %u\n', err)
f4 = 105;
x2 = A1*sin(2*pi*f1*t)+A2*sin(2*pi*f4*t)+A3*sin(2*pi*f3*t);
y2 = A*x2';
xs2 = S*y2;
err = max(max(abs(x2'-xs2)));
fprintf('Reconstructed with error: %u\n', err)
figure;
stem(f, abs(y2));
title("y ---> f2 = 105Hz")

figure
plot(x2, "b-")
hold on
plot(xs2, "r--")
title("x, xs ---> f2 = 105Hz")

x3 = A1*sin(2*pi*52.5*t)+A2*sin(2*pi*102.5*t)+A3*sin(2*pi*152.5*t);
y3 = A*x3';
xs3 = S*y3;
err = max(max(abs(x3'-xs3)));
fprintf('Reconstructed with error: %u\n', err)
figure;
stem(f, abs(y3));
title("y ---> f1,f2,f3 + 2.5Hz")

figure
plot(x3, "b-")
hold on
plot(xs3, "r--")
title("x, xs ---> f1,f2,f3 + 2.5Hz")