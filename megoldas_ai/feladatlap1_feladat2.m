clear all; close all; clc;

%% 2. Feladat: PD szabályozó tervezése
% Szakasz átviteli függvénye: Wp(s) = 5 / ((5s+1)*(2s+1))
s = tf('s');
Wp = 5 / ((5*s+1) * (2*s+1));

%% 2.1 Feladat: Póluskiejtés és Időállandók
% Szabályozó: Wc = Ap * (1 + s*Td / (1 + s*Tc))
% Kiejtjük a szakasz MÁSODIK leglassabb pólusát.
% Időállandók: 5s és 2s.
% Leglassabb: 5s. Második leglassabb: 2s.
% Tehát Td = 2.

Td = 2;
% A feladat kéri: Td = 10 * Tc -> Tc = Td / 10
Tc = Td / 10;

disp('2.1 Paraméterek:');
disp(['   Td (Differenciálási idő): ', num2str(Td)]);
disp(['   Tc (Szűrő időállandó): ', num2str(Tc)]);

%% 2.2 Feladat: Ap hangolása (Gyors, túllövés nélkül)
% Követelmények:
% - Túllövés = 0% (vagy nagyon kicsi)
% - Beállási idő < 2.1 s

% PROBALGATAS:
Ap_2_2 = 1.2; % KEZDETI TIPP

Wc_2_2 = Ap_2_2 * (1 + (s*Td)/(1 + s*Tc));
Wo_2_2 = minreal(Wp * Wc_2_2);
T_2_2 = feedback(Wo_2_2, 1);

figure(1);
step(T_2_2);
title('2.2 Ugrásválasz (Túllövés mentes)');
grid on;
info_2_2 = stepinfo(T_2_2);
disp('2.2 Eredmények:');
disp(['   Ap: ', num2str(Ap_2_2)]);
disp(['   Túllövés: ', num2str(info_2_2.Overshoot), ' %']);
disp(['   Beállási idő: ', num2str(info_2_2.SettlingTime), ' s']);


%% 2.3 Feladat: Ap hangolása (Még gyorsabb)
% Követelmények:
% - Beállási idő < 1.2 s
% - Fázistartalék > 60 fok
% - Túllövés > 0% lehet

% PROBALGATAS: Növeld Ap-t!
Ap_2_3 = 2.5; % KEZDETI TIPP

Wc_2_3 = Ap_2_3 * (1 + (s*Td)/(1 + s*Tc));
Wo_2_3 = minreal(Wp * Wc_2_3);
T_2_3 = feedback(Wo_2_3, 1);

figure(2);
step(T_2_3);
title('2.3 Ugrásválasz (Gyors)');
grid on;
info_2_3 = stepinfo(T_2_3);

figure(3);
margin(Wo_2_3);
[Gm, Pm, Wcg, Wcp] = margin(Wo_2_3);

disp('2.3 Eredmények:');
disp(['   Ap: ', num2str(Ap_2_3)]);
disp(['   Beállási idő: ', num2str(info_2_3.SettlingTime), ' s']);
disp(['   Túllövés: ', num2str(info_2_3.Overshoot), ' %']);
disp(['   Fázistartalék: ', num2str(Pm), ' fok']);


%% 2.4 Feladat: Diszkretizálás
% Fázistartalék romlás < 0.9 fok
delta_phi_max = 0.9;
wc = Wcp; 
Ts_max = (delta_phi_max * 2 * pi) / (wc * 180);

Ts = floor(Ts_max * 1000) / 1000; % 3 tizedesjegyre kerekítve

disp('2.4 Diszkretizálás:');
disp(['   Maximális mintavételi idő: ', num2str(Ts_max), ' s']);
disp(['   Választott Ts: ', num2str(Ts), ' s']);

% PD szabályozó diszkretizálása (Euler backward)
% Wc(s) = Ap * (1 + s*Td / (1 + s*Tc))
% Ez bonyolultabb algebrailag.
% Egyszerűbb felírni tagonként: P + D tag.
% De a feladat "differenciálegyenletet" kér u[k]-ra rendezve.
% Wc(z) = Ap * ( 1 + (Td * (1-z^-1)/Ts) / (1 + Tc * (1-z^-1)/Ts) )
% ... Ez bonyolult levezetést igényelhet a ZH-n. 
% Általános közelítés: u[k] = P_tag + D_tag
% De itt a szűrős alak van: (1+sTc) a nevezőben.

% U(s) = Ap * E(s) + Ap * [ sTd / (1+sTc) ] * E(s)
% A második tag a differenciáló tag szűréssel (D_filt).
% (1+sTc) * U_d(s) = sTd * E(s)
% (1 + Tc(1-z^-1)/Ts) * U_d(z) = Td(1-z^-1)/Ts * E(z)
% (Ts + Tc - Tc*z^-1) * U_d(z) = Td(1-z^-1) * E(z)
% (Ts+Tc) U_d[k] - Tc U_d[k-1] = Td(e[k] - e[k-1])
% U_d[k] = (Tc/(Ts+Tc)) U_d[k-1] + (Td/(Ts+Tc)) (e[k] - e[k-1])
% És u[k] = Ap * (e[k] + U_d[k])

disp('   Tipp: A PD szűrős alakjának differencia egyenlete két lépésben számolható (belső állapot bevezetésével).');
disp('   Ha a tanár a "szokásos" egyszerűsített PD-t kérte (szűrő nélkül), akkor más a képlet.');
disp('   Itt a szűrős alak közelítése:');
c1 = Tc/(Ts+Tc);
c2 = Td/(Ts+Tc);
disp(['   u_d[k] = ', num2str(c1), '*u_d[k-1] + ', num2str(c2), '*(e[k] - e[k-1])']);
disp(['   u[k] = ', num2str(Ap_2_3), ' * (e[k] + u_d[k])']);
