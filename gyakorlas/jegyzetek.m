% P szabalyzo
Ap = 0.009;
Wc = Ap;

% PI szabalyzo
% Wc (S) = Ap * (1 + 1/Ti*s);
Ap = 1;
Ti = 20;
Wc = Ap * tf([Ti, 1], [Ti, 0]);

% PD szabalyzo
Ap = 0.6; % -> ez mindig 1-rol indul
N = 10; % -> N = 10
T = 4; % -> Leglassab polus idoallandoja

Tc = T/(N+1); % -> csak jegyezd meg
Td = N * Tc; % -> csak jegyezd meg
Wc = tf(Ap * [Td+Tc, 1], [Tc, 1] )

% Diszkret rendszer
maxRomlas = 0.9;
TsMax = (2/wcp) * maxRomlas * (pi/180);
Dc = c2d(Wc, Ts, 'zoh');

% Dc (Z) = 3,46z - 3.239 / z - 1
% Dc (Z^-1) = 3.46 z - 3.23z^-1 / 1 - z^-1 == U / E

% 3.46E - 3.239z^-1E = U - z^-1U
% inverz z transzformálás
% 3.46e[k] - 3.239e[k-1] = u[k] - u[k-1]

% u[k] = 3.46e[k] - 3.239e[k-1] + u[k-1]


statikusErosites = dcgain(Wp);
% felnyitott kör
Wo = minreal(Wc * Wp)
[Gm, Pm, wcg, wcp] = margin(Wo)
vagasiKorfrekvencia = wcp;
Fazistartalek = Pm;
erositesTartalek = Gm;
stabilitasHatarFrekvencia = wcg;
% zárt kör
Wry = feedback(Wc * Wp, 1, -1)
maradoHiba = 1-dcgain(Wry)
ugrasInfo = stepinfo(Wry);
tulloves = ugrasInfo.Overshoot
beallasiIdo = ugrasInfo.SettlingTime
fazistartalek = Pm

% adja meg a beavatkozo jel maximalis erteket
Wru = feedback(Wc, Wp, -1)
stepinfo(Wru)
step(Wru)

% Átviteli függvény a zavaró jel (D) és a hibajel (E) között
Wde = -feedback(Wp, Wc);
figure()
step(Wde);

% Donse el, hogy stabil-e a zart kor a Bode tetel segitsegevel! Valazszat indokolja
if Pm > 0 && Gm > 1
    disp('A rendszer STABIL a Bode-tétel szerint.');
end