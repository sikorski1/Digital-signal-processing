clear all;
close all;
z = j*2*pi*[ 5, 15]; z = [ z, conj(z) ]
p = [ -0.5, -1 , -0.5] + j*2*pi*[ 9.5, 10, 10.5 ]; p = [ p, conj(p) ]
b = poly( z );
a = poly( p );

f = 0 : 0.1 : 100;
w = 2*pi*f;
s = j*w;
H = polyval( b, s ) ./ polyval( a, s );
H2 = H./max(H) %normalizacja ampitudy by wynosila 1
figure
plot(real(z),imag(z),'bo',real(p),imag(p),'r*'); grid; xlabel('Re'), ylabel("Im");
title('Zera i bieguny transmitancji');
figure
plot(f, abs(H), 'b.-')
title("abs(H)");
figure
plot(f, abs(H2), 'b.-')
title("abs(H2)");


figure
subplot(211); plot( f, 20*log10( abs(H) ), 'b.-' ); grid; xlabel('f [Hz]'); title('|H(f)| [dB]');
subplot(212); plot( f, angle( H ), 'b.-' ); grid; xlabel('f [Hz]'); title('angle( H(f) ) [rad]');


figure
subplot(211); plot( f, 20*log10( abs(H2) ), 'b.-' ); grid; xlabel('f [Hz]'); title('|H2(f)| [dB]');
subplot(212); plot( f, angle( H2 ), 'b.-' ); grid; xlabel('f [Hz]'); title('angle( H2(f) ) [rad]');
