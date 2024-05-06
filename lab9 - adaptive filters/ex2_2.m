close all
clear all
itask = 1;
ialg = 1;
[s, fpr] = audioread('mowa_3.wav'); s=s';
[sA,fpr] = audioread('mowa_1.wav');   sA=sA';
[sB,fpr] = audioread('mowa_2.wav');   sB=sB';
P = 1;  % opoznienie w probkach
if(itask==1)                                  % TEST 1
    s = sA;                                    % zapamietaj do porownania
    x = sB; Nx = length(x);                    % oryginalny sygnal echa
    d = sA + 0.75*[ zeros(1,P) sB(1:end-P) ];  % dodana "kopia" echa:
end                                           % slabsza (0.25), opozniona (P)
if(itask==2)                            % TEST 2
    x = s; Nx = length(x);               % oryginalny, zaszumiony sygnal mowy
    d = [ x(1+P:length(x)) zeros(1,P) ]; % d = sygnal x przyspieszony o P probek
end
f=0:fpr/500:fpr/2;                      % czestotliwosci dla rysunkow
dt = 1/fpr; t = dt*(0:Nx-1);            % czas dla rysunkow

figure;
subplot(211); plot(t,x); grid; title('WE : sygnal x(n)');
subplot(212); plot(t,d); grid; title('WE : sygnal d(n)'); xlabel('czas (s)'); 
soundsc(d) 
pause()

M = 50;               % liczba wag filtra
mi = 0.134;             % wspolczynnik szybkosci adaptacji ( 0<mi<1)
gamma = 0.001;
bx = zeros(M,1);         % inicjalizacja bufora na probki sygnalu wejsciowego x(n)
h  = zeros(M,1);         % inicjalizacja wag filtra
e = zeros(1,Nx);         % inicjalizacja wyjscia 1
y = zeros(1,Nx);         % inicjalizacja wyjscia 2
for n = 1 : Nx                   % Petla glowna
    bx = [ x(n); bx(1:M-1) ];    % wstawienie nowej probki x(n) do bufora
    y(n) = h' * bx;              % filtracja x(n), czyli estymacja d(n)
    e(n) = d(n) - y(n);          % blad estymacji d(n) przez y(n)
    if (ialg==1)  % LMS  ########
       h = h + ( 2*mi * e(n) * bx );               % LMS  - adaptacja wag filtra
    end      
    if (ialg==2)  % NLMS ########
       eng = bx' * bx;                             % energia sygnalu w buforze bx 
       h = h + ( (2*mi)/(gamma+eng) * e(n) * bx ); % adaptacja wag filtra
    end
end

figure
subplot(211); plot(t,y); grid; title('WY : sygnal y(n) = destim');
subplot(212); plot(t,e); grid; title('WY : sygnal e(n) = d(n)-y(n)');
soundsc(e)
