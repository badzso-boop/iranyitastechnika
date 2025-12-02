clear all 
close all
clc

%szakasz
Wp = tf(0.1,conv(conv([1 0],[1 1]),[2 1]))

%PD szabalyozo
Ap = 2.5; %4.39 (T = 2)
N = 10;
T = 1;

Tc = T/(N+1)
Td = N*Tc

Wc = tf(Ap*[Td+Tc 1], [Tc 1])

%felnyitott kor
Wo = minreal(Wp*Wc)

%Bode
figure()
margin(Wo)
[Gm, Pm, wcg, wcp] = margin(Wo)

%zart kor
Wry = feedback(Wo, tf(1,1),-1)
figure()
step(Wry)
maradoHibaWry = 1-dcgain(Wry)
info = stepinfo(Wry)

%referencia jel --> beavatkozo jel
Wru = feedback(Wc,Wp,-1)
figure()
step(Wru)
beavatkozoInfo = stepinfo(Wru) %-->Peak

%zavaro jel --> hibajel (zavaras hatasa a hibara)
Wde = -feedback(Wp, Wc, -1)
figure()
step(Wde)
zavaroInfo = stepinfo(Wde)
