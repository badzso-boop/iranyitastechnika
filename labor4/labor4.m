clear all
close all
clc

% szakasz atviteli fv
Wp = tf(1, conv([1,1],[10,1]))

% p szabalyzo atviteli fv
Wc = 1.5 % tf(1.5, 1)

% felnyitott kor atviteli fv
Wo = Wc * Wp

% zart kor atviteli fv
Wry = feedback(Wo, 1, -1)

%ugrasvalaszok
figure()
step(Wo)
hold on
%figure()
step(Wry)
legend('Felnyitott kör', 'Zárt kör')

%zart kor stepinfo
info = stepinfo(Wry)
T2 = info.SettlingTime
tulloves = info.Overshoot
elsoMaxIdo = info.PeakTime

%maximalis beavatkozo jel 
% - a referencia jel(r) es a beavatkozo jel (u) kozotti atviteli fv
Wru = feedback(Wc, Wp, -1)
figure()
step(Wru)
% -stepinfo peak
infoWru = stepinfo(Wru)
maxBeavatkozoJel = infoWru.Peak