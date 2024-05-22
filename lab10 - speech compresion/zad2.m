clear all; close all;

[x,fpr]=audioread('mowa1.wav'); %czytaj sygnal mowy
[cv, fpr2] = audioread('coldvox.wav');

plot(x); title('sygnal mowy'); pause; %pokaz go
%soudsc(x,fpr); %odtworz
d=0;
N=length(x); %dlugosc sygnalu
Mlen=240; %dlugosc okna Hamminga (ilosc probek)
Mstep=180; %przesuniecie okna w czasie (ilosc probek)
Np=10; %rzad filtra predykcji to zmieniamy na inne wartosci(liczba biegunow filtru)
gdzie=181; %poczatkowe polezenie pobudzenia dzwiecznego

lpc=[]; %tab na wsp modelu sygnalu mowy
s=[]; %cala mowa zsyntezowana
ss=[]; %fragment sygnalu mowy zsyntezowany
bs=zeros(1,Np); %bufor na fragment sygnalu mowy
Nramek=floor((N-240)/180+1); %ile fragmentow jest do przetworzenia

% Sygnał czasowy przed preemfazą
figure;
subplot(2, 1, 1);
plot(x);
title('Sygnał czasowy przed preemfazą');
xlabel('Czas');
ylabel('Amplituda');

% Widmo gęstości widmowej mocy sygnału przed preemfazą
subplot(2, 1, 2);
pwelch(x, [], [], [], fpr);
title('Widmo gęstości widmowej mocy sygnału przed preemfazą');
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość widmowa mocy');

x=filter([1 -0.9735],1,x);  %filtracja wstepna preemfaza - opcjonalna

% Sygnał czasowy p preemfazą
figure;
subplot(2, 1, 1);
plot(x);
title('Sygnał czasowy po preemfazie');
xlabel('Czas');
ylabel('Amplituda');

% Widmo gęstości widmowej mocy sygnału przed preemfazą
subplot(2, 1, 2);
pwelch(x, [], [], [], fpr);
title('Widmo gęstości widmowej mocy sygnału po preemfazie');
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość widmowa mocy');

for i=1:240
    w(i)=0.54-0.46*cos(2*pi*i/240);
end

x = x .* w; % zastosuj okno Hamminga na całym sygnale

% Projektujemy filtr FIR dolnoprzepustowy
fs = fpr; % Częstotliwość próbkowania
f_cutoff = 900; % Górna granica częstotliwości
order = 100; % Rząd filtra
b = fir1(order, f_cutoff/(fs/2)); % Projektowanie filtru FIR

dzwieczny_wyswietlony=false;
bezdzwieczny_wyswietlony=false;

figure;
for nr=1:Nramek
    %pobranie kolejnego fragmentu sygnalu
    n=1+(nr-1)*Mstep :Mlen +(nr-1)*Mstep;
    bx=x(n);

   
    % Zastosowanie filtru FIR
    bx = filter(b, 1, bx);

    s2=bx;
    P=0.3*max(bx);
    for i=1:240
        if bx(i)>=P
            bx(i)=bx(i)-P;
        elseif bx(i)<=-P
            bx(i)=bx(i)+P;
        else
            bx(i)=0;
        end
    end
    s3=bx;

    bx=bx-mean(bx); %usun wartosc srednia

    for k=0:Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    

    offset=20; rmax=max(r(offset:Mlen)); %maks funkcji autokorelacji
    imax=find(r==rmax); %index maximum
    T=imax;
    if(rmax>0.35*r(1)) 
        T=imax;
        %T=round(T/2); %obnizenie f tonu podstawowego dwukrotnie
        %T=80; %stala wartosc tonu podstawowego
        %rmax=round(rmax/2);
        d=d+1;
        dzwiek='Dzwieczny';
        dzwieczny = true;
    else
        T=0;
        dzwiek='Bezdziweczny';
        bezdzwieczny = false;
    end %gloska dzwieczna/bezdziweczna?

    if(T>80) 
        T=round(T/2); 
    end %znaleziona druga podharmoniczna
    %T=0;
    rr(1:Np,1)=(r(2:Np+1))';

    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];  %zbuduj macierz autokorelacji
    end
    
    a=-inv(R)*rr; %wsp filtra predykcji
    wzm=r(1)+r(2:Np+1)*a; %oblicz wzmocnienie
    
    figure;
    subplot(411); plot(n,bx); title('fragment sygnalu mowy-',dzwiek);
    subplot(412); plot(r); title('jego funkcja autokorelacji');
    %hold on;
        % Zaznaczenie progów
     %   plot([0, Mlen], [P, P], 'r--', 'LineWidth', 1); % Górny próg
      %  plot([0, Mlen], [-P, -P], 'r--', 'LineWidth', 1); % Dolny próg
   % hold off;

    subplot(413);
    [H, w] = freqz(1, [1;a]); %oblicz odp czestotliwosciowa
    f_hz=w*(fpr/(2*pi));
    plot(f_hz,abs(H)); title('Widmo filtra traktu glosowego'); xlabel('Częstotliwość [Hz]'); ylabel('Amplituda');

     if ( T~=0)
         figure;
         resztkowy = filter([1;a], 1, x(n));
         subplot(2, 1, 1); plot(resztkowy);
         df=(fpr/length(resztkowy))/2; 
         f = df * (0:length(resztkowy)-1);
         Reszt = fft(resztkowy);
         [~,maxpos]=max(Reszt);
         T=1/(2*pi*f(maxpos));
         subplot(2, 1, 2); plot(f, Reszt);
         
     end

    lpc=[lpc;T;wzm;a;];  %zapamietaj wartosci parametrow

    % SYNTEZA - odtworz na podstawie parametrow ----------------------------------------------------------------------
    %T=0;                                        % usun pierwszy znak "%" i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end					%"przenies" pobudzenie dzwieczne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            %pob=2*(rand(1,1)-0.5);
            pob=cv(n);
            gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            if (n==gdzie) 
                pob=1; 
                gdzie=gdzie+T;	   % pobudzenie dzwieczne
            else 
                pob=0; 
            end
        end
        ss(n)=wzm*pob-bs*a;		% filtracja "syntetycznego" pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesunciecie bufora wyjsciowego
    end
    subplot(414); plot(ss); title('zsyntezowany fragment sygnalu mowy'); 
 pause;
    s = [s ss];						% zapamietanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure; plot(s); title('mowa zsyntezowana');
%soundsc(x,fpr); 
% pause(1);
soundsc(s, fpr)


    
    



