clear all; close all; clc;

%% 3. Feladat: PI szabályozó (3 tárolós szakasz)
% Szakasz: Wp(s) = 0.5 / ((10s+1)*(5s+1)*(2s+1))
s = tf('s');
Wp = 0.5 / ((10*s+1)*(5*s+1)*(2*s+1));

%% 3.1 Feladat: Póluskiejtés
% Leglassabb pólus: T = 10s.
Ti = 10;
disp(['3.1 Választott Ti: ', num2str(Ti)]);

% Wc = Ap * (1 + 1/(s*Ti))
% A (10s+1) tag kiesik. Marad a szakaszból: 0.5 / ((5s+1)(2s+1)) és az integrátor 1/s.
% Nyílt kör (Ap nélkül): Wo_base = 0.5 / (s * (5s+1) * (2s+1))

%% 3.2 Feladat: Stabilitás határa (Kritikus erősítés)
% A stabilitás határa ott van, ahol a fázistartalék 0 fok (azaz a fázis -180 fok).
% Megnézzük a Bode diagramon, hol metszi a fázis a -180-at, és ott mekkora az erősítés.

W_base = minreal( Wp * (1 + 1/(s*Ti)) ); % Itt Ap = 1-nek vesszük
figure(1);
margin(W_base);
title('3.2 Stabilitás vizsgálata (Ap=1)');
[Gm, Pm, Wcg, Wcp] = margin(W_base);

% Gm (Gain Margin) megmondja, hányszorosára növelhetjük az erősítést a határig.
Ap_max = Gm; 
disp(['3.2 Maximális Ap (Stabilitás határa): ', num2str(Ap_max)]);
% Megjegyzés: Ha Ap < Ap_max, akkor stabil.

%% 3.3 Feladat: Ap hangolása
% Követelmények:
% - Túllövés = 0%
% - Beállási idő < 70s

% PROBALGATAS: Csökkentsd Ap-t a maximumhoz képest jelentősen!
Ap_3_3 = 0.5 * Ap_max; % Biztonsági tartalék, pl. a fele. Próbáld módosítani!

Wc_3_3 = Ap_3_3 * (1 + 1/(s*Ti));
Wo_3_3 = minreal(Wp * Wc_3_3);
T_3_3 = feedback(Wo_3_3, 1);

figure(2);
step(T_3_3);
title(['3.3 Ugrásválasz (Ap=', num2str(Ap_3_3), ')']);
grid on;
info_3_3 = stepinfo(T_3_3);
[Gm3, Pm3, Wcg3, Wcp3] = margin(Wo_3_3);

disp('3.3 Eredmények:');
disp(['   Ap: ', num2str(Ap_3_3)]);
disp(['   Túllövés: ', num2str(info_3_3.Overshoot), ' %']);
disp(['   Beállási idő: ', num2str(info_3_3.SettlingTime), ' s']);
disp(['   Fázistartalék: ', num2str(Pm3), ' fok']);

%% 3.4 Feladat: Diszkretizálás
% Fázistartalék romlás < 0.9 fok
wc = Wcp3;
Ts_max = (0.9 * 2 * pi) / (wc * 180);
Ts = floor(Ts_max * 10) / 10;

disp('3.4 Diszkretizálás:');
disp(['   Ts: ', num2str(Ts), ' s']);

% PI differencia egyenlet (Lásd 1. feladat)
% u[k] = u[k-1] + Ap*(1 + Ts/Ti)*e[k] - Ap*e[k-1]
p1 = Ap_3_3 * (1 + Ts/Ti);
p2 = Ap_3_3;
disp(['   u[k] = u[k-1] + ', num2str(p1), '*e[k] - ', num2str(p2), '*e[k-1]']);
