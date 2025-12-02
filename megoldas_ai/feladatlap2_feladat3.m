clear all; close all; clc;

%% Feladatlap 2 - 3. Feladat: P szabályozó
% Szakasz (1. feladatból): Wp(s) = 10 / ((5s+1)*(4s+1)*(2s+1))
s = tf('s');
Wp = 10 / ((5*s+1)*(4*s+1)*(2*s+1));

% Szabályozó: P típus, Wc(s) = Ap.
% 3.1 Felnyitott kör
% Wo = Ap * Wp
disp('3.1 Felnyitott kör: Wo = Ap * 10 / ((5s+1)(4s+1)(2s+1))');

%% 3.2 Határeset (Stabilitás)
% Megnézzük, hol 180 fok a fázis a szakaszban (Ap nem tol fázist).
figure(1);
margin(Wp); 
[Gm, Pm, Wcg, Wcp] = margin(Wp);
% Gm megadja, mennyivel szorozhatjuk meg a rendszert, hogy instabil legyen.
% Tehát a kritikus erősítés: K_krit = Gm.
% Mivel a szakasz statikus erősítése 10, és a Wp-ben benne van, az Ap_krit = Gm értékétől függ.
% Ha a margin parancs a TELJES Wo-ra futna, akkor a Gm az "extra" erősítés lenne.
% Itt a Wp-re futtattuk. Ha Wc = Ap, akkor Wo = Ap * Wp.
% A rendszer akkor instabil, ha |Wo| >= 1 a -180 foknál.
% |Wp| = 1/Gm a -180 foknál (definíció szerint).
% Tehát ha Ap * (1/Gm) = 1 => Ap = Gm.
Ap_krit = Gm;
disp(['3.2 Kritikus Ap (Stabilitás határa): ', num2str(Ap_krit)]);
disp(['   Kritikus körfrekvencia (w_180): ', num2str(Wcg)]);

%% 3.3 Bode tétel
% A Bode stabilitási kritérium szerint a zárt kör akkor stabil, ha a felnyitott kör Bode diagramja
% a vágási körfrekvencián (ahol az erősítés 0 dB) a fázis nagyobb mint -180 fok.
% (Fázistartalék pozitív).

%% 3.3.1 Hangolás
% Követelmények: 
% - Túllövés < 13%
% - Beállási idő < 23 s
% - Fázistartalék > 130 fok (Ez furcsa, P szabályozóval nehéz nagy fázistartalékot elérni, mert nem javít fázist, sőt a szakasz fázisa romlik a frekvenciával).
% Lehet, hogy elírás és 30 fok? Vagy 13 fok?
% Ha 130 fok kell, akkor nagyon kicsi sávszélesség (lassú rendszer) kell, ahol a szakasz fázisa még nem esett be -50 fok alá (-180+130 = -50).
% Nézzük meg, hol -50 a szakasz fázisa. Nagyon alacsony frekvencián.

% PROBALGATAS:
Ap_tuned = 0.05; % Nagyon kicsi erősítés kellhet a nagy fázistartalékhoz.

Wo_tuned = Ap_tuned * Wp;
T_tuned = feedback(Wo_tuned, 1);

figure(2);
margin(Wo_tuned);
[Gm_t, Pm_t, Wcg_t, Wcp_t] = margin(Wo_tuned);

figure(3);
step(T_tuned);
title('3.3.1 Ugrásválasz');
info = stepinfo(T_tuned);

disp('3.3.1 Eredmények:');
disp(['   Ap: ', num2str(Ap_tuned)]);
disp(['   Fázistartalék: ', num2str(Pm_t)]);
disp(['   Beállási idő: ', num2str(info.SettlingTime)]);

%% 3.5 Maradó hiba
% Típus: 0 (Nincs integrátor).
% Hiba = 1 / (1 + K_hurok).
% K_hurok = Ap * K_szakasz = Ap * 10.
err = 1 / (1 + Ap_tuned * 10);
disp(['3.5 Maradó hiba: ', num2str(err)]);
disp('   Indoklás: P szabályozó nem tartalmaz integrátort, így a rendszer típusszáma 0. A hiba nem nulla.');

