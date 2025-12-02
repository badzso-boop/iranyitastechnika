clear all; close all; clc;

%% 1. Feladat: PI szabályozó tervezése
% Szakasz átviteli függvénye: Wp(s) = 0.5 / ((5s+1)*(2s+1))
s = tf('s');
Wp = 0.5 / ((5*s+1) * (2*s+1));

disp('1. Feladat: Szakasz pólusai és zérusai:');
zpk(Wp)

%% 1.1 Feladat: Póluskiejtés
% A szabályozó zérusával kiejtjük a szakasz leglassabb pólusát.
% A leglassabb pólus a legnagyobb időállandóhoz tartozik.
% Időállandók: T1 = 5, T2 = 2. -> Ti = 5.
Ti = 5;
disp(['1.1 Választott integrálási időállandó (Ti): ', num2str(Ti)]);

% A szabályozó átviteli függvénye (paraméteres alak):
% Wc = Ap * (1 + 1/(s*Ti)) = Ap * (s*Ti + 1) / (s*Ti)
% Mivel Ti = 5, a számláló (5s+1) kiejti a szakasz (5s+1) tagját.

%% 1.2 Feladat: Ap hangolása (Lassúbb, pontosabb)
% Követelmények:
% - Túllövés = 0%
% - 2%-os beállási idő < 24s
% - Fázistartalék > 60 fok

% Ezt az értéket kézzel/próbálgatással kell beállítani!
Ap_1_2 = 0.8; % KEZDETI TIPP - MÓDOSÍTSD EZT!

Wc_1_2 = Ap_1_2 * (1 + 1/(s*Ti));

% Felnyitott kör
Wo_1_2 = minreal(Wp * Wc_1_2);

% Zárt kör
T_1_2 = feedback(Wo_1_2, 1);

figure(1);
step(T_1_2);
title('1.2 Ugrásválasz (Ap hangolása)');
grid on;
info_1_2 = stepinfo(T_1_2);
disp('1.2 Eredmények:');
disp(['   Ap: ', num2str(Ap_1_2)]);
disp(['   Túllövés: ', num2str(info_1_2.Overshoot), ' %']);
disp(['   Beállási idő: ', num2str(info_1_2.SettlingTime), ' s']);

figure(2);
margin(Wo_1_2);
title('1.2 Bode diagram és Fázistartalék');
[Gm, Pm, Wcg, Wcp] = margin(Wo_1_2);
disp(['   Fázistartalék: ', num2str(Pm), ' fok']);


%% 1.3 Feladat: Ap hangolása (Gyorsabb)
% Követelmények:
% - Beállási idő < 14s
% - Fázistartalék > 60 fok
% - Túllövés > 0% megengedett

% Ezt az értéket növeld addig, amíg a beállási idő kicsi nem lesz, de a fázistartalék még jó!
Ap_1_3 = 1.5; % KEZDETI TIPP - MÓDOSÍTSD EZT!

Wc_1_3 = Ap_1_3 * (1 + 1/(s*Ti));
Wo_1_3 = minreal(Wp * Wc_1_3);
T_1_3 = feedback(Wo_1_3, 1);

figure(3);
step(T_1_3);
title('1.3 Ugrásválasz (Gyorsított)');
grid on;
info_1_3 = stepinfo(T_1_3);

[Gm_3, Pm_3, Wcg_3, Wcp_3] = margin(Wo_1_3);

disp('1.3 Eredmények:');
disp(['   Ap: ', num2str(Ap_1_3)]);
disp(['   Beállási idő: ', num2str(info_1_3.SettlingTime), ' s']);
disp(['   Fázistartalék: ', num2str(Pm_3), ' fok']);
disp(['   Vágási körfrekvencia (wc): ', num2str(Wcp_3), ' rad/s']);

%% 1.4 Feladat: Diszkretizálás
% Követelmény: Fázistartalék romlás < 0.9 fok
% Képlet: delta_phi = (wc * Ts * 180) / (2 * pi) < 0.9
% Ebből Ts kifejezve: Ts < (0.9 * 2 * pi) / (wc * 180)

delta_phi_max = 0.9;
wc = Wcp_3; % A gyorsított rendszer vágási körfrekvenciája
Ts_max = (delta_phi_max * 2 * pi) / (wc * 180);

% Kerekítsük lefelé egy "szép" számra
Ts = floor(Ts_max * 100) / 100; 
if Ts == 0
    Ts = Ts_max; % Ha nagyon kicsi
end

disp('1.4 Diszkretizálás:');
disp(['   Maximális mintavételi idő: ', num2str(Ts_max), ' s']);
disp(['   Választott Ts: ', num2str(Ts), ' s']);

% Szabályozó diszkrét alakja (Euler backward módszerrel, ami kézi számolásnál gyakori)
% s = (1 - z^-1) / Ts
% Wc(z) = Ap * (1 + Ts / (Ti * (1 - z^-1)))
% Rendezzük u[k]-ra:
% U(z)/E(z) = Ap + (Ap*Ts)/(Ti*(1-z^-1))
% U(z)*(1-z^-1) = Ap*(1-z^-1)*E(z) + (Ap*Ts/Ti)*E(z)
% u[k] - u[k-1] = Ap*(e[k] - e[k-1]) + (Ap*Ts/Ti)*e[k]
% u[k] = u[k-1] + Ap*e[k] - Ap*e[k-1] + (Ap*Ts/Ti)*e[k]
% u[k] = u[k-1] + Ap*(1 + Ts/Ti)*e[k] - Ap*e[k-1]

p1 = Ap_1_3 * (1 + Ts/Ti);
p2 = Ap_1_3;

disp('   Differenciálegyenlet:');
disp(['   u[k] = u[k-1] + ', num2str(p1), '*e[k] - ', num2str(p2), '*e[k-1]']);
