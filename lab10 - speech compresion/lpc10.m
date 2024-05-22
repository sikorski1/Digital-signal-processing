% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% cwiczenie: Kompresja sygnalu mowy wedlug standardu LPC-10
% ----------------------------------------------------------

clc; clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav');	      % wczytaj sygnal mowy (caly)
% [cv, fpr2] = audioread('coldvox.wav');
plot(x); title('sygnal mowy');	      % pokaz go
							          % oraz odtworz na glosnikach (sluchawkach)

N=length(x);	  % dlugosc sygnalu
Mlen=240;		  % dlugosc okna Hamminga (liczba probek)
Mstep=180;		  % przesuniecie okna w czasie (liczba probek)
Np=10;			  % rzabiegltra predykcji
gdzie=Mstep+1;	  % poczatkowe polozenie pobudzenia dzwiecznego

lpc=[];								   % tablica na wspoczynniki modelu sygnalu mowy
s=[];								   % cala mowa zsyntezowana
ss=[];								   % fragment sygnalu mowy zsyntezowany
bs=zeros(1,Np);					       % bufor na fragment sygnalu mowy
Nramek=floor((N-Mlen)/Mstep+1);        % ile fragmentow (ramek) jest do przetworzenia
x=filter([1 -0.9735], 1, x);	       % filtracja wstepna (preemfaza) - opcjonalna

figure(1); plot(abs(fft(x))); title("Widmo sygnału mowy");

for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygnalu
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    % Progowanie
    bx = bx - mean(bx);  % usun wartosc srednia
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end

    figure(2);
    set(figure(2),'units','points','position',[0,0,1440,750]);
    subplot(411); plot(n,bx); title('fragment sygnalu mowy');
    subplot(412); plot(r); title('jego funkcja autokorelacji');
    
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];		   % zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;									   % oblicz wspolczynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;							   % oblicz wzmocnienie
    H=freqz(1,[1;a]);                                  % oblicz jego odp. czestotliwosciowa
    subplot(413); plot(abs(H)); title('widmo filtra traktu glosowego');

    offset=20; rmax=max( r(offset : Mlen) );	       % znajdz maksimum funkcji autokorelacji
    imax=find(r==rmax);								   % znajdz indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end      % gloska dzwieczna/bezdzwieczna?     if (T>80) T=round(T/2); end					   % znaleziono druga podharmoniczna
%     T							   					   % wyswietl wartosc T
   
%     if ( T~=0)
%         resztkowy = filter([1;a], 1, x(n));
%         figure(3); subplot(2, 1, 1); plot(resztkowy);
%         df=(fpr/length(resztkowy))/2; 
%         f = df * (0:length(resztkowy)-1);
%         Reszt = fft(resztkowy);
%         [~,maxpos]=max(Reszt);
%         T=1/(2*pi*f(maxpos));
%         %subplot(2, 1, 2); plot(f, Reszt);
%         
%     end
    
    lpc=[lpc; T; wzm; a; ];						       % zapamietaj wartosci parametrow
    
    % SYNTEZA - odtworz na podstawie parametrow ----------------------------------------------------------------------
    % T = 0;                                           % usun pierwszy znak "%" i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end				   % "przenies" pobudzenie dzwieczne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            pob=2*(rand(1,1)-0.5); 
%             pob=cv(n);
            gdzie=(3/2)*Mstep+1;           % pobudzenie szumowe
        else
            if (n==gdzie) 
                pob=1; 
                gdzie=gdzie+T;	           % pobudzenie dzwieczne
            else pob=0; 
            end
        end
        ss(n)=wzm*pob-bs*a;		           % filtracja syntetycznego pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	           % przesunecie bufora wyjsciowego
    end
    subplot(414); plot(ss); title('zsyntezowany fragment sygnalu mowy'); 
    pause(0.01)
    s = [s ss];						       % zapamietanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure(4); plot(s); title('mowa zsyntezowana');
% soundsc(x,fpr); 
% pause;
soundsc(s, fpr)
