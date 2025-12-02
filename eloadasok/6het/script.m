clear all
close all
clc

%szakasz
Wp = tf(10, conv(conv([1 1],[2 1]),[5 1]))

%PI szablyozó 
Ap = 0.12; 
Ti = 5;
Wc = tf((Ap/Ti)*[Ti 1],[1 0])

%felnyitott kor (poluskiejtes --> minreal)
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

%zavaro jel --> hibajel (zavarar hatasa a hibara)
Wde = -feedback(Wp, Wc, -1)
figure()
step(Wde)
zavaroInfo = stepinfo(Wde)



