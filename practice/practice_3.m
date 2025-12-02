close all
clear all
clc

% 3. feladat: 
% legyen a szabalyozando szakasz atviteli fuggvenye
% Wp (S) = 0.5 / (10s+1)*(5s+1)*(2s+1)
% Tervezzen PI szabalyzot a szakaszhoz aminek az atviteli fuggvenye
% Wc = Ap * (1 + 1/sTi)

Wp = tf(0.5, conv(conv([10, 1], [5,1]), [2,1]));

% 3.1 feladat
Ap = 14;
Ti = 10;

% 3.2 feladat
% Mekkora lehet az Ap parameter maximalis erteke, 
% ha azt akarjuk, hogy a zart kor ne legyen instabil? ===> Gm az a max
% felette mar instabil
Wc = Ap / Ti * tf([Ti, 1], [1, 0]);

% felnyitott kor
Wo = minreal(Wc * Wp);
[Gm, Pm, wcg, wcp] = margin(Wo);

% zart kor
Wry = feedback(Wo, 1, -1);
info = stepinfo(Wry);
tulloves = info.Overshoot
beallasiIdo = info.SettlingTime
fazistartalek = Pm
erositesTartalek = Gm


% 3.4 feladat
maxRomlas = 0.9
TsMax = (2/wcp) *maxRomlas * (pi/180)

Ts = 0.8
Dc = c2d(Wc, Ts, 'zoh')