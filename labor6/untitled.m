clear all
close all
clc

% szakasz
Wp = tf(10, conv(conv([1, 1], [2, 1]), [5, 1]))

% szabalyozo (PI)
Ap = 0.12;
Ti = 5; % mert az 5 a leglassabb fuggveny mert az idoallandoja a legnagybb
Wc = tf( (Ap/Ti) * [Ti, 1], [1, 0] )

% felnyitott kor
Wo = Wc * Wp
%Wo = minreal(Wc * Wp)

% erosites es fazistartalek
figure()
margin(Wo)
[gm, pm, wcg, wcp] = margin(Wo)

% legfeljebb 0.75-re kell allitani az Ap-t hogy oszcillaljon a rendszer =>
% 1-nel mennyi a gm


% zart kor ugrasvalasza
Wry = feedback(Wo, 1, -1)

% ugrasvalasz
figure()
step(Wry)

%zart kor marado hiba, tulloves, 2%os beallasi ido

%marado hiba
e = 1-dcgain(Wry)

info = stepinfo(Wry);
tulloves = info.Overshoot
T2 = info.SettlingTime
pm


% atviteli fv a referencia jel es a beavatkozo jel kozott
% atviteli fv r ----> u
Wru = feedback(Wc, Wp, -1)
figure()
step(Wru) % egysegnyi bemenetre a kontroller milyen kimenetet fog adni

% a beavatkozo jel maximalis erteke kell
infoWru = stepinfo(Wru)
maximalisBeaatkozoJel = infoWru.Peak

% zavarojel (d) es a hibajel (e) kozotti atviteli fv
Wde = -feedback(Wp, Wc, -1)
% egysegugrasnyi zavaras akkor a hibaval ez lesz
figure()
step(Wde)

% egysegugras zavarojel hiba maximumat
infoWde = stepinfo(Wde)
maxHibaJel = infoWde.Peak

