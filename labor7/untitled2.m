clear all
close all
clc

% szakasz
Wp = tf(0.1, conv([1, 0], conv([1, 1], [2, 1])))

Ap = 1;
N = 10;
T = 1; % leglassabb polus idoallandoja -> legnagyobb szam

Tc = T/(N+1)
Td = N * Tc

% felnyitott kör
Wc = Ap * tf( [ (Td+Tc), 1], [Tc, 1])


% felnyitott kor atviteli fuggvenye
% soros kapcsolasnal szorzas kell
Wo = minreal(Wp * Wc)

% bode diagram
figure()
margin(Wo)

% erosites
[gm, pm, wcg, wcp] = margin(Wo)

% zart kör
Wry = feedback(Wo, 1, -1)

% ugrasvalasz
figure()
step(Wry)
maradoHiba = 1 - dcgain(Wry)
info = stepinfo(Wry)

% atviteli fv a referencia jel es a beavatkozo jel kozott
% atviteli fv r ----> u
Wru = feedback(Wc, Wp, -1)

figure()
step(Wru)

infoWru = stepinfo(Wru);
maximalisBeavatkozoJel = infoWru.Peak

% zavarojel d, hibajel e kozotti atvitali fv
Wde = -feedback(Wp, Wc, -1)

figure()
step(Wde)

