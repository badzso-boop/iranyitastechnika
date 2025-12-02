clear all; close all; clc;

%% Feladatlap 2 - 1. Feladat: PI szabályozó
% Szakasz: Wp(s) = 10 / ((5s+1)*(4s+1)*(2s+1))
Wp = tf(10, conv([5, 1], conv([4, 1], [2, 1])))

%% 1.1 Szakasz vizsgálata
disp('1.1 Pólusok:');
p = pole(Wp);
disp(p);
if all(real(p) < 0)
    disp('   A szakasz STABIL (minden pólus valós része negatív).');
else
    disp('   A szakasz INSTABIL.');
end

%% 1.2 Statikus erősítés
% S -> 0 esetén Wp(0) = 10 / (1*1*1) = 10.
K_stat = dcgain(Wp);
disp(['1.2 Statikus erősítés (K): ', num2str(K_stat)]);

%% 1.3 PI Tervezés
% 1.3.1 Póluskiejtés: Leglassabb (5s). -> Ti = 5.
Ti = 5;
disp(['1.3.1 Választott Ti: ', num2str(Ti)]);
% Nyílt kör: Wo = Ap * (1/s) * (10 / ((4s+1)(2s+1)))
% (Az 5s+1 kiesett, a Ti*s a nevezőben maradt, de a számlálóban az (1+sTi) kiejtette. 
% Pontosabban: Wc = Ap * (1+sTi)/(sTi).
% Wo = Wp * Wc = [10 / ((5s+1)(4s+1)(2s+1))] * [Ap * (5s+1)/(5s)] 
%    = Ap * 10 / (5s * (4s+1) * (2s+1)) = Ap * (2/s) * 1/((4s+1)(2s+1))
disp('   Egyszerűsített alakban (Ap=1): 2 / (s * (4s+1) * (2s+1))');

% 1.3.2 Kezdeti Ap = 0.1
Ap_init = 0.1;
Wc_init = Ap_init * (1 + 1/(s*Ti));
Wo_init = minreal(Wp * Wc_init);
disp('1.3.2 Matlab TF (Ap=0.1):');
% zpk(Wo_init)

% 1.3.3 Hangolás
% Követelmények: Túllövés < 2%, Beállás < 35s, PM > 65 fok.
% PROBALGATAS:
Ap_tuned = 0.4; % TIPP

Wc_tuned = Ap_tuned * (1 + 1/(s*Ti));
Wo_tuned = minreal(Wp * Wc_tuned);
T_tuned = feedback(Wo_tuned, 1);

figure(1);
margin(Wo_tuned);
[Gm, Pm, Wcg, Wcp] = margin(Wo_tuned);

figure(2);
step(T_tuned);
title('1.3.3 Ugrásválasz');
info = stepinfo(T_tuned);

disp('1.3.3 Eredmények:');
disp(['   Ap: ', num2str(Ap_tuned)]);
disp(['   Fázistartalék: ', num2str(Pm)]);
disp(['   Túllövés: ', num2str(info.Overshoot)]);
disp(['   Beállási idő: ', num2str(info.SettlingTime)]);

%% 1.3.4 Maradó hiba
% Rendszer típusa: 1 (van egy integrátor a nevezőben a nyílt körben a PI miatt).
% 1-es típusú rendszer hibaállandója egységugrásra 0.
err = 1 - dcgain(T_tuned);
disp(['1.3.4 Maradó hiba: ', num2str(err)]);
disp('   Indoklás: A nyílt kör tartalmaz integrátort (1/s), így a rendszer típusszáma 1. Egységugrás követésekor a hiba 0.');

%% 1.3.6 Beavatkozó jel maximuma
% U(s) = Wru(s) * R(s) = (Wc / (1 + Wc*Wp)) * (1/s)
Wru = feedback(Wc_tuned, Wp);
figure(3);
step(Wru);
title('1.3.6 Beavatkozó jel (u)');
u_info = stepinfo(Wru);
disp(['1.3.6 Beavatkozó jel max (Peak): ', num2str(u_info.Peak)]);
