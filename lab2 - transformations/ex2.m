clear all;
close all;
N = 20;
k = 0:N-1;
n = 0:N-1;
A = zeros(N, N);
A(1, :) = sqrt(1/N);
for k = 0:N-1
    if k == 0
        sk = sqrt(1/N);     % Wartość sk dla k = 0
    else
        sk = sqrt(2/N);     % Wartość sk dla k != 0
    end
    wk = sk*cos(pi*k/N*(n+0.5));
    
    A(k+1, :) = wk;
end
S = A';
I = S*A;
x = randn(20);
X = A*x';

xs=S*X
xs = xs'