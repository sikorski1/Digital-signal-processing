% ----------------------------------------------------------
% Tabela 19-4 (str. 567)
% �wiczenie: Kompresja sygna�u mowy wed�ug standardu LPC-10
% ----------------------------------------------------------

clc; clear all; clf; close all;

[x,fpr]=audioread('mowa1.wav');% wczytaj sygna� mowy (ca�y)
[cv, fpr2] = audioread('coldvox.wav');
plot(x); title('sygna� mowy');	% poka� go
							% oraz odtw�rz na g�o�nikach (s�uchawkach)

N=length(x);	  % d�ugo�� sygna�u
Mlen=240;		  % d�ugo�� okna Hamminga (liczba pr�bek)
Mstep=180;		  % przesuni�cie okna w czasie (liczba pr�bek)
Np=10;			  % rz�d filtra predykcji
gdzie=Mstep+1;	  % pocz�tkowe po�o�enie pobudzenia d�wi�cznego

lpc=[];								   % tablica na wsp�czynniki modelu sygna�u mowy
s=[];									   % ca�a mowa zsyntezowana
ss=[];								   % fragment sygna�u mowy zsyntezowany
bs=zeros(1,Np);					   % bufor na fragment sygna�u mowy
Nramek=floor((N-Mlen)/Mstep+1);	% ile fragment�w (ramek) jest do przetworzenia

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

x=filter([1 -0.9735], 1, x);	% filtracja wst�pna (preemfaza) - opcjonalna

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

figure; plot(abs(fft(x)));

for  nr = 1 : Nramek
    
    % pobierz kolejny fragment sygna�u
    n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep;
    bx = x(n);
    
    % ANALIZA - wyznacz parametry modelu ---------------------------------------------------
    % Progowanie
    bx = bx - mean(bx);  % usu� warto�� �redni�
    for k = 0 : Mlen-1
        r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
    end
    
     % P=0.3*max(bx);
  subplot(611); plot(n,bx); title('fragment sygna�u mowy');
  subplot(612); plot(n,abs(fft(bx))); title('fragment sygna�u mowy');
   subplot(613); plot(r); title('jego funkcja autokorelacji');
   % hold on;
   %      % Zaznaczenie progów
   %      plot([0, Mlen], [P, P], 'r--', 'LineWidth', 1); % Górny próg
   %     plot([0, Mlen], [-P, -P], 'r--', 'LineWidth', 1); % Dolny próg
   %  hold off;

    
    rr(1:Np,1)=(r(2:Np+1))';
    for m=1:Np
        R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];			% zbuduj macierz autokorelacji
    end
    a=-inv(R)*rr;											% oblicz wsp�czynniki filtra predykcji
    wzm=r(1)+r(2:Np+1)*a;									% oblicz wzmocnienie
    H=freqz(1,[1;a]);	% oblicz jego odp. cz�stotliwo�ciow�
        subplot(614); plot(abs(H)); title('widmo filtra traktu g�osowego');
    
    offset=20; rmax=max( r(offset : Mlen) );	   % znajd� maksimum funkcji autokorelacji
    imax=find(r==rmax);	
    % if ( rmax > 0.35*r(1) ) display("dźwieczna"); else display("bezdźwieczna"); end % g�oska d�wi�czna/bezd�wi�czna?% znajd� indeks tego maksimum
    if ( rmax > 0.35*r(1) ) T=imax; else T=0; end % g�oska d�wi�czna/bezd�wi�czna?
    if (T>80) T=round(T/2); end							% znaleziono drug� podharmoniczn�
    %T=0;							   							% wy�wietl warto�� T
    								
%     if ( T~=0)
%         resztkowy = filter([1;a], 1, x(n));
%         figure; subplot(2, 1, 1); plot(resztkowy);
%         df=(fpr/length(resztkowy))/2; 
%         f = df * (0:length(resztkowy)-1);
%         Reszt = fft(resztkowy);
%         [~,maxpos]=max(Reszt);
%         T=1/(2*pi*f(maxpos));
%         %subplot(2, 1, 2); plot(f, Reszt);
%         
%     end
    
    lpc=[lpc; T; wzm; a; ];								% zapami�taj warto�ci parametr�w
    
    % SYNTEZA - odtw�rz na podstawie parametr�w ----------------------------------------------------------------------
    % T = 0;                                        % usu� pierwszy znak �%� i ustaw: T = 80, 50, 30, 0 (w celach testowych)
    if (T~=0) gdzie=gdzie-Mstep; end					% �przenie�� pobudzenie d�wi�czne
    for n=1:Mstep
        % T = 70; % 0 lub > 25 - w celach testowych
        if( T==0)
            pob=2*(rand(1,1)-0.5);
            %pob=cv(n);
            gdzie=(3/2)*Mstep+1;			% pobudzenie szumowe
        else
            if (n==gdzie) 
                pob=1; 
                gdzie=gdzie+T;	   % pobudzenie d�wi�czne
            else pob=0; 
            end
        end
        ss(n)=wzm*pob-bs*a;		% filtracja �syntetycznego� pobudzenia
        bs=[ss(n) bs(1:Np-1) ];	% przesun�cie bufora wyj�ciowego
    end
     subplot(615); plot(ss); title('zsyntezowany fragment sygna�u mowy');
     subplot(616); plot(abs(fft(ss))); title('zsyntezowany fragment sygna�u mowy');

 % pause()
    s = [s ss];						% zapami�tanie zsyntezowanego fragmentu mowy
end

s=filter(1,[1 -0.9735],s); % filtracja (deemfaza) - filtr odwrotny - opcjonalny

figure; plot(s); title('mowa zsyntezowana');
 % soundsc(x,fpr); 
 % pause(1);
soundsc(s, fpr)
