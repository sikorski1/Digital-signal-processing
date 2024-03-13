clear all; close all;

N = 256;
[x, fs] = audioread('mowa.wav');
length(x)
figure
plot(x, "b-");
xk = [x(25:25+N-1), x(444:444+N-1), x(2910:2910+N-1), x(5124:5124+N-1),x(9278:9278+N-1), x(13421:13421+N-1),x(16555:16555+N-1), x(20001:20001+N-1), x(25331:25331+N-1),x(32323:32323+N-1)];
xkstart = [25, 444, 2910, 5124, 9278, 13421, 16555, 20001, 25331, 32323]
k = 0:N-1;
n = 0:N-1;
A = zeros(N, N);
for k = 0:N-1
    if k == 0
        wk = sqrt(1/N)*cos(pi*k/N*(n+0.5));     % Wartość sk dla k = 0
    else
        wk = sqrt(2/N)*cos(pi*k/N*(n+0.5));     % Wartość sk dla k != 0
    end
  
    A(k+1, :) = wk;
end
fy=(0:N-1);
figure
for m = 1:10
    fx = (xkstart(m):xkstart(m) + N-1);
    y = A*xk(:,m);
    subplot(2,1,1)
    plot(fx, xk(:,m), 'b-o');
    subplot(2,1,2)
    stem(fy, abs(y))
    pause();
    clf;
end