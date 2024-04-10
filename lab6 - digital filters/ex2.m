clear all;
close all;


[data,fs] = audioread('s4.wav');

values=['1' '2' '3'; '4' '5' '6'; '7' '8' '9'; '*' '0' '#'];

N=length(data);
df = fs/N;
f = 0 : df : fs/2-df;
dt = 1/fs; t = dt*(0:N-1); T=1/fs;
figure
plot(t, data);
figure
spectrogram( data, 4096, 4096-512, [0:5:2000], fs )
title("Wykres częstotliwościowy sygnału")

%39335
fg = [697 770 852 941 1209 1336 1477];
freq_indices = round(fg/fs*N) + 1;
dft_data = goertzel(data,freq_indices);
figure
stem(fg,abs(dft_data))
xlabel('Frequency (Hz)')
title('DFT Magnitude')



f1 = [682, 712];
f2 = [755, 785];
f3 = [837, 867];
f4 = [926, 956];
f5 = [1194, 1224];
f6 = [1321, 1351];
f7 = [1462, 1492];
fr = [697,770,852,941,1209,1336,1477];
H = [];
b = [];
a = [];
N2=4;
Rp=1;
Rs=40;
freq = [f1;f2;f3;f4;f5;f6;f7];
figure
hold on
for i = 1:length(freq)
    [b(:,i), a(:,i)]= ellip(N2,Rp, Rs,[freq(i,1), freq(i,2)]/(fs/2),'bandpass');
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
   y(:,i)   = y(:,i)./max(y(:,i));
   plot(abs(y(:,i)));
   plot([23300 23300], [0 0.01], "k")
   pause()
end

step=round((0.9*N)/5)-1;
l=1;
i=1;    
while(i+step<length(data))
    a1=mean(abs(y(i:i+step,1)));
    a2=mean(abs(y(i:i+step,2)));
    a3=mean(abs(y(i:i+step,3)));
    a4=mean(abs(y(i:i+step,4)));
    b1=mean(abs(y(i:i+step,5)));
    b2=mean(abs(y(i:i+step,6)));
    b3=mean(abs(y(i:i+step,7)));
    [m, a] = max([a1, a2, a3, a4]);
    [m, b] = max([b1, b2, b3]);
    code(l) = values(a, b);
    i=i+step;
    l=l+1;
end
disp(code);