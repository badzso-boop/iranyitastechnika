clear all
close all
clc

% 2022 zh gyakorlása

Wp = tf(100, conv(conv(conv([8, 0], [6, 1]), [8, 1]), [2, 1]));

Ap = 0.009;
Wc = Ap;

% 1.1 feladat
% nyitott kör
Wo = minreal(Wc * Wp)

[Gm, Pm, wcg, wcp] = margin(Wo)

% zárt kör
Wry = feedback(Wc * Wp, 1, -1)

% stabil-e a zárt kör
pole(Wry)


% 2. feladat
maradoHiba = 1-dcgain(Wry)

% 1.4 feladat
stepinfo(Wry)
% tulloves -> % 
% elso maximumig terjedi -> secundum
% 2%os beállási idő -> secundum

% adja meg a beavatkozo jel maximalis erteket
Wru = feedback(Wc, Wp, -1)
stepinfo(Wru)
step(Wru)

%%

close all
clear all
clc

Wp = tf(0.15, conv(conv([15, 1], [20, 1]), [1, 1]))

% pi szabalyzo

Ap = 1
Ti = 20
Wc = Ap * tf([Ti, 1], [Ti, 0])

Wo = minreal(Wp * Wc)

[Gm, Pm, wcg, wcp] = margin(Wo)

Wry = feedback(Wo, 1, -1)

stepinfo(Wry)

maradoHiba = 1-dcgain(Wry)


% diszkret ideju atviteli fuggvenyet, a mintaveteli idot valassza meg ugy
% hogy a fazistartalek romlas legfeljebb 0.9 fok! mekkora a mintaveteli
% ido? Adja meg a szabalyzo differencialegyenletet u[k]-ra rendezve
%TsMax = 2/wcp * 0.9 * pi/180;

TsMax = 2/wcp * deg2rad(0.9)
Ts = 1.28
Dc = c2d(Wc, Ts, 'zoh')


% Dc (Z) = 3,46z - 3.239 / z - 1
% Dc (Z^-1) = 3.46 z - 3.23z^-1 / 1 - z^-1 == U / E

% 3.46E - 3.239z^-1E = U - z^-1U
% inverz z transzformálás
% 3.46e[k] - 3.239e[k-1] = u[k] - u[k-1]

% u[k] = 3.46e[k] - 3.239e[k-1] + u[k-1]
