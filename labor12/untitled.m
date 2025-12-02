clear all
close all
clc

Wp = tf(0.5, conv([5, 1], [2, 1]))

Ap = 1.8
Ti = 5

% Wc = Ap * tf([Ti, 1], [Ti, 0])
Wc = Ap/Ti * tf([Ti, 1], [1, 0])

% 1.1 feladat
Wo = minreal(Wc * Wp)

figure()
margin(Wo)
[Gm, Pm, wcg, wcp] = margin(Wo)

Wry = feedback(Wo, 1, -1)
figure()
step(Wry)

info = stepinfo(Wry)

% 1.4 feladat
maxRomlas = 0.9
TsMax = (2/wcp) * maxRomlas *(pi/180)
Ts = 0.18
Dc = c2d(Wc, Ts, 'zoh')
romlas = (wcp*Ts) / 2 *(180/pi)


%% 2. feladat pd szabalyzo
clear all
close all
clc

Wp = tf(5, conv([5, 1], [2, 1]))

Ap = 2.2
N = 10
Tc = T / (N + 1)
Td = N * Tc

Wc = Ap * tf([Td+Tc, 1], [Tc, 1])

Wo = minreal(Wc * Wp)

figure()
margin(Wo)
[Gm, Pm, wcg, wcp] = margin(Wo)
Wry = feedback(Wo, 1, -1)
info = stepinfo(Wry)

maxRomlas = 0.9
TsMax = (2/wcp) *maxRomlas * (pi/180)

Ts = 0.015
Dc = c2d(Wc, Ts, 'zoh')

romlas = (wcp*Ts) / 2 * (180/pi)

%% harmadik

clear all
close all
clc

Wp = tf(0.5, conv([10, 1], [5,1], [2,1]))

Ap = 1
Ti = 10
Wc = Ap / Ti * tf([Ti, 1], [1, 0])

Wo = minreal(Wc * Wp)

figure()
margin(Wo)
[Gm, Pm, wcg, wcp] = margin(Wo)

Wry = feedback(Wo, 1, -1)

info = stepinfo(Wry)
maxRomlas = 0.9
TsMax = (2/wcp) *maxRomlas * (pi/180)

Ts = 0.8
Dc = c2d(Wc, Ts, 'zoh')

% u[k] = u[k-1] + 1.8 e[k] - 1.735e[k-1]