clear all
close all
clc

%szakasz
Wp = tf(10, conv(conv([1, 1], [2, 1]), [5, 1]))

% ha arányos a hibajellel akkor P szabalyozo !!!4
Ap = 1;
Wc = Ap

%felnytitott kor
Wo = Wc * Wp

% Zart kor
% a kimeneti jelet figyeljunk ezert az elso parameter az elorecsatolt ag, a
% masodik paramtere a visszacsatolo ag ami ha ures => 1 es utana a
% visszacsatolas merteke -1/1
Wry = feedback(Wo, 1, -1)

% A bode tetelt a felnyitott korre hivjuk mindig
% stabilitas a bode tetel ertelmeben

figure()
bode(Wo) % nem ad nekem eleg infot csak rajzolgat kis benacska
figure()
margin(Wo);
% gainmargin (erosites tartalek) (a figureba dB a valtozoba numerikus), 
% painmargin (fazistartalek), 
% erosites tartalekhoz tartozo frekvencia, fazistartalek frekvencia


% Gm - gain margin: erosites tartalek
% Pm - phase margin: fazistartalek
% wcg: erosites tartalekhoz tartozo frekvencia
% wcp - fazistartalekhoz tartozo frekvencia - vagasi korfrekvencia
[Gm, Pm, wcg, wcp] = margin(Wo)

% ha az Ap-t a gainmarginre allitom akkor elerjuk a vilagbeket ergo tokeletes
% oszcillator

%ugrasvalasz a zart korre
figure()
step(Wry)

% zart kor polusai -> komplex konjugalt parnak kene benne lennie
p = pole(Wry)

% marado hiba a rendszernek
e = 1-dcgain(Wry)

%stepinfo
info = stepinfo(Wry)



% Tervezesi Feltetelek
% T 2% < 17s
% overshoot < 24%
% PM > 65 fok