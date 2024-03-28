clear all;
close all;
N1 = 2; 
N2 = 4;
N3 = 6;
N4 = 8;
f0 = 100;
R = 2*pi*f0;
fi1 = pi/2  + pi/N1*1/2 + (0:N1-1)*pi/N1;
fi2 = pi/2  + pi/N2*1/2 + (0:N2-1)*pi/N2;
fi3 = pi/2  + pi/N3*1/2 + (0:N3-1)*pi/N3;
fi4 = pi/2  + pi/N4*1/2 + (0:N4-1)*pi/N4;

f = 0 : 0.1 : 1000;
w = 2*pi*f;
s = j*w;

p1 = R * exp(j*fi1);
a1 = poly( p1 );
b1 = prod( -p1 ); z1 = roots( b1 );
H1 = polyval( b1, s ) ./ polyval( a1, s );
H1 = H1./max(H1);

p2 = R * exp(j*fi2);
a2 = poly( p2 );
b2 = prod( -p2 ); z2 = roots( b2 );
H2 = polyval( b2, s ) ./ polyval( a2, s );
H2 = H2./max(H2);

p3 = R * exp(j*fi3);
a3 = poly( p3 );
b3 = prod( -p3 ); z3 = roots( b3 );
H3 = polyval( b3, s ) ./ polyval( a3, s );
H3 = H3./max(H3);

p4 = R * exp(j*fi4);
a4 = poly( p4 );
b4 = prod( -p4 ); z4 = roots( b4 );
H4 = polyval( b4, s ) ./ polyval( a4, s );
H4 = H4./max(H4);

figure('Name',"Filtry Butterworth LP");
set(figure(3),'units','points','position',[0,400,400,350]);
subplot(2,2,1);
plot(real(p1),imag(p1),'b x');
title('Butterworth LP N=2');
xlim(max(abs(xlim)).*[-1 1]);

subplot(2,2,2);
plot(real(p2),imag(p2),'b x');
title('Butterworth LP N=4');
xlim(max(abs(xlim)).*[-1 1])

subplot(2,2,3);
plot(real(p3),imag(p3),'b x');
title('Butterworth LP N=6');
xlim(max(abs(xlim)).*[-1 1])

subplot(2,2,4);
plot(real(p4),imag(p4),'b x');
title('Butterworth LP N=8');
xlim(max(abs(xlim)).*[-1 1])

figure
grid
hold on
plot( f, 20*log10( abs(H1) ), 'b-' ); grid; xlabel('f [Hz]'); title('|H1(f)| [dB]');
pause()
plot( f, 20*log10( abs(H2) ), 'g-' ); grid; xlabel('f [Hz]'); title('|H2(f)| [dB]');
pause()
plot( f, 20*log10( abs(H3) ), 'r-' ); grid; xlabel('f [Hz]'); title('|H3(f)| [dB]');
pause()
plot( f, 20*log10( abs(H4) ), 'k-' ); grid; xlabel('f [Hz]'); title('|H4(f)| [dB]');
legend('N=2','N=4','N=6','N=8');
pause()

figure
hold on
grid
plot( f,  abs(H1) , 'b-' ); grid; xlabel('f [Hz]'); title('|H1(f)|');
pause()
plot( f,  abs(H2) , 'g-' ); grid; xlabel('f [Hz]'); title('|H2(f)|');
pause()
plot( f,  abs(H3) , 'r-' ); grid; xlabel('f [Hz]'); title('|H3(f)| ');
pause()
plot( f,  abs(H4) , 'k-' ); grid; xlabel('f [Hz]'); title('|H4(f)| ');
legend('N=2','N=4','N=6','N=8');
pause()

figure
hold on
grid
plot( f,  angle(H1) , 'b-' ); grid; xlabel('f [Hz]'); title('|H1(f)| [dB]');
pause()
plot( f,  angle(H2) , 'g-' ); grid; xlabel('f [Hz]'); title('|H2(f)| [dB]');
pause()       
plot( f,  angle(H3) , 'r-' ); grid; xlabel('f [Hz]'); title('|H3(f)| [dB]');
pause()
plot( f,  angle(H4) , 'k-' ); grid; xlabel('f [Hz]'); title('|H4(f)| [dB]');
legend('N=2','N=4','N=6','N=8');
pause()


[b2, a2] = zp2tf(z2, p2', 1);   % Konwersja z biegunów do jw
sys = tf(b2, a2);               % Transmitancja
figure('Name','Odpowiedź impulsowa filtru N=4');
impulse(sys);
figure("Name","Odpowiedź filtru N=4 na skok jednostkowy");
step(sys);


  