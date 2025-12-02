clear all
close all
clc

% 1. feladat: legyen a szabalyozando szakasz atviteli fuggvenye
% Wp (S) = 0.5 / (5s+1) * (2s+1)

% Szakasz amit szabalyozni akarunk
Wp = tf(0.5, conv([5, 1], [2, 1]));


% Tervezzen PI szabalyzot a szakaszhoz aminek az atviteli fuggvenye: 
% Wc = Ap * (1 + 1/sTi)

%Ap = 1;
%Ap = 1.3;
%Ap = 1.5
%Ap = 1.7
Ap = 2;

% 1.1 feladat: 
% A szabalyzo zerusaval ejtsuk ki a szakasz leglassab polusat. Adja meg a Ti idoallando erteket.

Ti = 5;
Wc = Ap * tf([Ti, 1], [Ti, 0]);


% 1.2 feladat: 
% Allitsa be a szabalyzo Ap parameteret:
% a zart kor urasvalaszanak tullovese 0%
% a 2%os beallasi ido a leheto legkissebb (kevesebb mint 24 masodperc)
% a felnyitott kor fazistartaleka nagyobb mint 60 fok

% Felnyitott kör
Wo = minreal(Wc * Wp);
%figure()
%margin(Wo)

[Gm, Pm, wcg, wcp] = margin(Wo);

% Zárt kör negatív visszacsatolással
Wry = feedback(Wo, 1, -1);

% feladat megoldasahoz szukseges parameterek, ezeket hangolod az Ap-vel
info = stepinfo(Wry);
tulloves = info.Overshoot
beallasiIdo = info.SettlingTime
fazistartalek = Pm

%figure()
%step(Wry)


% 1.2 feladat megoldasa: Ap = 1.3

% 1.3 feladat: Novelje a szabalyzo Ap parameteret addig amig a rendszer gyorsul
% zart kor beallasi ideje a leheto legkissebb (kissebb mint 14 masodperc)
% a tulloves nagyobb lehet mint 0%
% a felnyitott kor fazistartaleka nagyobb mint 60 fok


% 1.3 feladat megoldasa: Ap = 2


% 1.4 feladat
% Ajda meg a szabalyzo diszkret ideju atviteli fuggvenyet!
% A mintaveteli idot valassza meg ugy hogy a fazistartalek romlas legfeljebb 0.9 fok legyen. 
% Mekkora a mintaveteli ido? 
% Adja meg a szabalyzo diferenciaegyenletet u[k] -ra rendezve ahol k a legnagyobb utem.

maxRomlas = 0.9;
TsMax = (2/wcp) * maxRomlas * (pi/180);
Ts = 0.16;
Dc = c2d(Wc, Ts, 'zoh');
romlas = (wcp * Ts) / 2 * (180/pi)

% 1.4 feladat megoldasa: a mintaveteli ido 0.16