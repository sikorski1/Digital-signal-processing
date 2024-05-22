clear all;
close all;


[data,fs] = audioread('challenge 2024 (1).wav');

values=['1' '2' '3'; '4' '5' '6'; '7' '8' '9'; '*' '0' '#'];

N=length(data);
df = fs/N;
f = 0 : df : fs/2-df;
dt = 1/fs; t = dt*(0:N-1); T=1/fs;

b = 10;

f1 = [697-b, 697+b];
f2 = [770-b, 770+b];
f3 = [852-b, 852+b];
f4 = [941-b, 941+b];
f5 = [1209-b, 1209+b];
f6 = [1336-b, 1336+b];
f7 = [1477-b, 1477+b];
fr = [697,770,852,941,1209,1336,1477];
H = [];
b = [];
a = [];
N=4;
Rp=0.5;
Rs=80;
freq = [f1;f2;f3;f4;f5;f6;f7];
figure
hold on
for i = 1:length(freq)
    [b(:,i), a(:,i)]= ellip(N,Rp, Rs,[freq(i,1), freq(i,2)]/(fs/2),'bandpass');
    z = exp(j*2*pi*f/fs);
    H(:,i) = polyval( b(end:-1:1, i), z ) ./ polyval( a(end:-1:1, i), z);
    plot(f,20*log10(abs(H(:,i)))); xlabel('f [Hz]'); grid; title('|H(f)| [dB]');
    plot([fr(i) fr(i)], [-70, 20], "k")
    xlim([0 1600]);
end
figure
hold on
y = [];
for i = 1:length(freq)
   y(:,i) = filter(b(:,i), a(:,i), data);
   ypart(:,i)   = y(:,i)./max(y(:,i));
   plot(abs(ypart(:,i)));
end
%{
ypart = [];
figure
hold on
for j = 1:length(freq)
    if j < 5
                ypart(:,j)   = y(1500000:length(data),j)./max(y(1500000:length(data),3)); 
            else
                ypart(:,j)   = y(1500000:length(data),j)./max(y(1500000:length(data),5));
    end
   plot(abs(ypart(:,j)));
   pause()
end
%}
l=1;
i=1;
code = "";
prevs = 1;
s = [];
k = [];
for j = 1:4
        s(j) = step(ypart(1:length(data),j),l); 
end
for j = 5:7
        k(j) = step(ypart(1:length(data),j),l) ;
end
smin = min(s);
kmin = min(k);
vmax = max(smin,kmin);
while(i+vmax+100<length(data))
    a1=mean(abs(ypart(1:1+vmax,1)));
    a2=mean(abs(ypart(1:1+vmax,2)));
    a3=mean(abs(ypart(1:1+vmax,3)));
    a4=mean(abs(ypart(1:1+vmax,4)));
    b1=mean(abs(ypart(1:1+vmax,5)));
    b2=mean(abs(ypart(1:1+vmax,6)));
    b3=mean(abs(ypart(1:1+vmax,7)));
    [m, a] = max([a1, a2, a3, a4]);
    [m, b] = max([b1, b2, b3]);
    code(l) = values(a, b);
    i=i+vmax;
    l=l+1;
    s = [];
    k = [];
    ypart = [];

    for j = 1:length(freq)
        if l < 60
        ypart(:,j)   = y(i:length(data),j)./max(y(i:length(data),j));
        else
            if j < 5
                ypart(:,j)   = y(i:length(data),j)./max(y(i:length(data),1)); 
            else
                ypart(:,j)   = y(i:length(data),j)./max(y(i:length(data),5));
            end
        %zmiana usredniania, gdy szum ma wieksze znaczenie
        end
    end

    for j = 1:4
        s(j) = step(ypart(1:length(data)-i,j), l);
    end

    for j = 5:7
        k(j) = step(ypart(1:length(data)-i,j), l);
    end
    smin = min(s);
    kmin = min(k);
    plot([i i], [0 1], "k")
    vmax = max(smin,kmin);
end
strjoin(code, "")
%123456789*0#1#24303680#1471015872*61237*04073*56963*643*175#20*2797478008#*4
