clear all
close all
clc

%szakasz
Wp = tf(10, conv(conv([1 1],[2 1]), [5 1]))

%P szab
Ap = 1;
Wc = Ap

%felnyitott kor
Wo = Wc*Wp

%zart kor
Wry = feedback(Wo, 1, -1)

%stabilitas Bode tetel ertelmeben
figure()
bode(Wo)
figure()
margin(Wo)
[Gm, Pm, wcg, wcp] = margin(Wo)
%Gm - gain margin: erosites tartalek
%Pm - phase margin: fazistartalek
%wcg - erosites tartalekhoz tartozo frekvencia
%wcp - fazistartalekhoz tartozo frekvencia - vagasi korfrekvencia

%ugrasvalasz
figure()
step(Wry)

%polusok
p = pole(Wry)

%marado hiba
e = 1-dcgain(Wry)

%stepinfo
info = stepinfo(Wry)


