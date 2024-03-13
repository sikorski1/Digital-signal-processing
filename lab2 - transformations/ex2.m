clear all;
close all;
N = 20;
k = 0:N-1;
n = 0:N-1;
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
I = S*A;
A*A'
mesh(I);
x = randn(1, 20);
X = A*x';

xs=S*X;
xs = xs';
err = max(abs(x-xs))
A2 = randn(20);
A2*A2'

S2 = A2';
I2 = A2*S2;

x2 = xs;
X2 = A2*x2';
xs2 = S2*X2;


A3= zeros(N, N);
for k = 0:N-1
    if k == 0
        wk = sqrt(1/N);     % Wartość sk dla k = 0
    else
        wk = sqrt(2/N)*cos(pi*(k+0.25)/N*(n+0.5));     % Wartość sk dla k != 0
    end
  
    A3(k+1, :) = wk;
end


S3 = A3';
X3 = A3*x';
xs3 = S3*X3;
err = max(abs(x-xs))
err2 = max(abs(x2-xs2'))
err3= max(abs(x-xs3'))
