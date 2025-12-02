clear all; close all; clc;

%% Feladatlap 2 - 2. Feladat: PD szabályozó (Integráló szakaszhoz?)
% Szakasz a leírás alapján: Wp(s) = 0.5 / (s * (s+1) * (4s+1))
% (Feltételezve, hogy a "s*1" elírás és (s+1)-et jelent, vagy 1s+1-et)
s = tf('s');
Wp = 0.5 / (s * (s+1) * (4*s+1));

%% 2.1 Pólusok, Stabilitás
p = pole(Wp);
disp('2.1 Pólusok:');
disp(p);
% Van egy pólus a 0-ban (integrátor). Ez a stabilitás határa (Ljapunov értelemben instabil/határeset, BIBO instabil).
disp('   Stabilitás: A szakasz a 0-ban lévő pólus miatt önmagában nem stabil (integráló jellegű).');

%% 2.3 PD Tervezés
% Wc = Ap * (1 + sTd / (1 + sTc))
% 2.3.1 Póluskiejtés: Leglassabb stabil pólus.
% Pólusok: 0 (nincs időállandó), -0.25 (T=4), -1 (T=1).
% Leglassabb a T=4. -> Td = 4.
Td = 4;
% Szűrés: N = 10 -> Tc = Td/10 = 0.4.
Tc = 0.4;

disp(['2.3.1 Td: ', num2str(Td), ', Tc: ', num2str(Tc)]);

%% 2.3.3 Hangolás
% Túllövés < 2%, Beállás < 10s, PM > 65 fok.

% PROBALGATAS:
Ap_tuned = 0.8; % TIPP

Wc_tuned = Ap_tuned * (1 + (s*Td)/(1 + s*Tc));
Wo_tuned = minreal(Wp * Wc_tuned);
T_tuned = feedback(Wo_tuned, 1);

figure(1);
margin(Wo_tuned);
[Gm, Pm, Wcg, Wcp] = margin(Wo_tuned);

figure(2);
step(T_tuned);
title('2.3.3 Ugrásválasz');
info = stepinfo(T_tuned);

disp('2.3.3 Eredmények:');
disp(['   Ap: ', num2str(Ap_tuned)]);
disp(['   Fázistartalék: ', num2str(Pm)]);
disp(['   Túllövés: ', num2str(info.Overshoot)]);

%% 2.4 Zavarás vizsgálata
% Zavart jel és hibajel közötti átvitel (Wde).
% E(s) = - Wp / (1 + WpWc) * D(s)  (Ha a zavarás a bemeneten van? Vagy kimeneten?)
% A feladat szövege nem pontosítja a zavarás helyét, de általában a beavatkozó jelhez adják vagy a kimenethez.
% "Zavaro jel es a hibajel kozotti atviteli fuggveny".
% Ha kimeneti zavarás (Ye): E = -1/(1+L) * Ye.
% Ha bemeneti zavarás (Di): E = -P/(1+L) * Di.
% A "Labor 5" példák alapján általában bemeneti terhelés zavarás szokott lenni (Load Disturbance).
% Akkor W_de = - Wp / (1 + Wp*Wc)
% Vagy a kódban: Wde = -feedback(Wp, Wc, -1)  <- Ez a megoldas/pi_szabalyzo_tervezes.m mintában volt!
% Tehát használjuk azt a mintát.

Wde = -feedback(Wp, Wc_tuned); % Figyelem: feedback(sys1, sys2) = sys1 / (1+sys1*sys2).
% A mínusz előjel a különbségképzőből jön (e = r - y).
figure(3);
step(Wde);
title('2.4 Zavarás elhárítás (Lépés zavar)');
