clear all
close all
clc

% 2. feladat: legyen a szabalyozando szakasz atviteli fuggvenye:
% Wp (S) = 5/ (5s+1) * (2s+1)
Wp = tf(5, conv([5, 1], [2, 1]));

% Tervezzen PD szabalyzot a szakaszhot aminek az atviteli fuggvenye:
% Wc = Ap* (1 + Std / Stc + 1) 
% Ertelmezes szerint: Wc = Ap * (s(Td+Tc)+1)/(sTc+1)


% 2.1 feladat
% A szabalyzo zerusaval ejtse ki a szakasz masodik leglassabb polusat.
% A polusok T1=5 (leglassabb) es T2=2 (masodik leglassabb). Tehat Td=2.

% 2.2 feladat
%  Allitsa be az Ap erteket ugy hogy a zart korben ne legyen tulloves, 
% de a zart kor legyen a leheto leggyorsabb (beallasi ido < 2.1 masodprc). 
% Mekkora az Ap erteke?

% 2.2 feladat megoldasa: 1.44


% 2.3 feladat
% Novelje a szabalyzo Ap parameteret addig amig a rendszer gyorsul 
% a zart kor beallasi ideje a leheto legkissebb (1.2 mp-nel kisebb) 
% a felnyitott kor fazoistartaleka nagyobb mint 60 fok 
% a tulloves lehet nagyobb mint 0. 
% Mekkora az Ap erteke? 
% Mekkora a 2%os beallasoi ido a tulloves es a fazistartalek?

% 2.3 feladat megoldasa: Ap = 2.2

%Ap = 1;
%Ap = 1.5;
%Ap = 1.9;
%Ap = 1.8;
%Ap = 2;
Ap = 2.2;
N = 10;
Tc = 2 / (N + 1);
Td = N * Tc;

Wc = Ap * tf([Td+Tc, 1], [Tc, 1]);

Wo = minreal(Wc * Wp);
[Gm, Pm, wcg, wcp] = margin(Wo);

Wry = feedback(Wo, 1, -1);
info = stepinfo(Wry);
tulloves = info.Overshoot
beallasiIdo = info.SettlingTime
fazistartalek = Pm

% 2.4 feladat: 
% Adja meg a szabalyzo diszkret ideju atviteli fuggvenyet! 
% A mintaveteli idot valassza meg ugy, hogy a fazistartalek romlas
%  legfeljebb 0.9 fok legyen. Mekkora a mintaveteli ido?
%  Ajda meg a szabalyzo differencialegyenletet u[k]-ra rendezve.

maxRomlas = 0.9
TsMax = (2/wcp) * maxRomlas * (pi/180);

Ts = 0.0153
Dc = c2d(Wc, Ts, 'zoh')
romlas = (wcp*Ts) / 2 * (180/pi)

% Mintaveteli ido: 0.0153