close all
clear all
clc

Wp = tf(10, conv(conv([5, 1], [4, 1]), [2, 1]));

% 1.1 feladat

polusok = pole(Wp);
% Stabil a szakasz, mert minden valos resz negativ!

%1.2 feladat
statikusErosites = dcgain(Wp);

% a statikus erősítés = 10

% PI szabalyzo melynek atviteli fuggvenye:
% Wc (S) = Ap * (1 + 1/Ti*s)

% 1.3 feladat
Ap = 0.035;
Ti = 5; % -> leglassab polus kivalasztasa
% A tervezett szakasz fuggvenye (PI) szabalyzohoz
Wc = tf(Ap/Ti*[Ti, 1], [1, 0]);

% 1.3.2 feladat
% Legyen az Ap parameter kezdetben 0.1. Irja fel a felnyitott kor matlab altal szamitott atviteli fuggvenyet.
% felnyitott kör
Wo = minreal(Wc * Wp);

% 1.3.3 feladat
% Hangolja be a szabalyzoi Ap parameteret e kovetkezo tervezesi felteleke mellett:
% tullovese legyen kisebb mint 2%
% 2%os beallasi ido legyen a leheto legkisebb 35 mp-nel kisebb
% Felnyitott kor fazistartaleka nagyobb mint 65 fok
[Gm, Pm, wcg, wcp] = margin(Wo);

% zart kor
Wry = feedback(Wo, 1, -1);
ugrasInfo = stepinfo(Wry);
tulloves = ugrasInfo.Overshoot
beallasiIdo = ugrasInfo.SettlingTime
fazistartalek = Pm

% 1.3.4 feladat
% Adja meg a zart kor marado hibajat a megfelelo Ap ertek mellett! Miert ennyi ez az ertek?
% -> azert 0 mert a nulla polus eltuntette a marado hibat
maradoHiba = 1-dcgain(Wry)

% 1.3.5
% Adja meg a zart kor tulloveset, elso maximumig terjedo idejet es a 2% os beallasi idot a megfelelo Ap ertek mellett
% itt csak le kellet irni
tulloves = ugrasInfo.Overshoot
beallasiIdo = ugrasInfo.SettlingTime
elsoMaxIdo = ugrasInfo.PeakTime

% 1.3.6 feladat
% atviteli fv referencia ---> u (beavatkozojel)
% Adja meg a beavatkozo jel maximalis erteket megfelelo Ap mellett
Wru = feedback(Wc, Wp, -1);
maxBeavatkozo = stepinfo(Wru).Peak

% 1.3.7 -> rajzold le
figure()
step(Wry)



%%
close all
clear all
clc

Wp = tf(0.5, conv(conv([1, 0], [1, 1]), [4, 1]));

% 2.1 feladat
% Adja meg a szakasz polusait! Dontse el, hogy stabli-e a szakasz, indokolja meg a donteset!
pole(Wp);
% stabil, de a stablitas hataran van mert van benne 0 polus is


% 2.2 feladat
% Adja meg a szakasz korerositeset es statikus erositeset
% statikus erosites vegtelen, ezert -> korerosites -> 0.5
% azert vegtelen mert van nulla polus
statikusErosites = dcgain(Wp);


% 2.3 feladat
% PD szabalyzo

% 2.3.1 feladat
% Valasszuk meg a derivalasi idot Td es a szuro idoallandojat Tc 
% ugy hogy a szabalyzo zerusa kiejtse a szakasz leglassabb polusat 
% es legyen szuroegyutthato N = 10! 
% Irja fel a felnyitott kor atviteli fuggvenyet idoallandos alakban! 
% Ajda meg a Td es Tc erteket!

Ap = 0.6; % -> ez mindig 1-rol indul
N = 10; % -> N = 10
T = 4; % -> Leglassab polus idoallandoja

Tc = T/(N+1); % -> csak jegyezd meg
Td = N * Tc; % -> csak jegyezd meg

Wc = tf(Ap * [Td+Tc, 1], [Tc, 1] ); % -> csak jegyezd meg PD szabalyzohoz

% nyitott kor
Wo = minreal(Wc * Wp);


% 2.3.2 feladat
% zart kor ugrasvalaszanak tullovese legyen kevesebb mint 2%
% a 2%os beallasi ido legyen a lehetoi legkissebb (10mp nel kisebb)
% a felnyiott kor fazistartaleka legyen nagyobb mint 65 fok

[Gm, Pm, wcg, wcp] = margin(Wo);
% zart kor
Wry = feedback(Wo, 1, -1);

ugrasInfo = stepinfo(Wry);
tulloves = ugrasInfo.Overshoot
beallasiIdo = ugrasInfo.SettlingTime
fazistartalek = Pm

% Ap = 0.6, fazistartalek = 68.0419

% 2.3.4 feladat
% Adja meg a zart kor marado hibajat a megfelelo Ap ertek mellett!
maradoHiba = 1 - dcgain(Wry);

% 2.3.5 feladat
tulloves = ugrasInfo.Overshoot
elsoMaxIdo = ugrasInfo.PeakTime
beallasiIdo = ugrasInfo.SettlingTime

% 2.3.6 feladat
% atviteli fv referencia ---> u (beavatkozojel)
% Adja meg a beavatkozo jel maximalis erteket megfelelo Ap mellett
Wru = feedback(Wc, Wp, -1);
maxBeavatkozo = stepinfo(Wru).Peak

% 2.4 feladat
%Vizsgalja meg a zavaras hatasat! Abrazolja jelleghelyesen 
% a zavaro jel es a hibajel kozotti atviteli fuggveny ugrasvalaszat 
% a megfelelo Ap ertek mellett es irja fel az atviteli fuggvenyet!


% Átviteli függvény a zavaró jel (D) és a hibajel (E) között
% Feltételezve, hogy a zavarás a szabályozó kimenetén (szakasz bemenetén) hat.
% E = -Wp * D / (1 + Wc * Wp) = -Wp * D / (1 + Wo)
% Vagy feedback formában:

Wde = -feedback(Wp, Wc); 
% Itt nincs -1 az utolsó paraméterben, 
% ha E/D-t keresünk egy tipik zavaró bevezetésnél

figure()
step(Wde);


%%
clear all
close all
clc

Wp = tf(10, conv(conv([5, 1], [4, 1]), [2, 1]));

%  A P-szabályozó átviteli függvénye egyszerűen egy konstans erősítés (Ap). 
% A feladat azt írja, kezdetben legyen Wc(s) = 1, azaz Ap = 1.
Ap = 0.11;
Wc = Ap;

% 3.1 feladat
% Adja meg a felnyitott kor atviteli fuggvenyet
Wo = minreal(Wp*Wc);

% 3.2 feladat
% Adja meg a vagasi korfrekvenciat a fazistartalekot es az erositestartalekot! 
% Melyik korfrekvencian lenne a rendszer a stabilitas hataran?
[Gm, Pm, wcg, wcp] = margin(Wo);

vagasiKorfrekvencia = wcp;
Fazistartalek = Pm;
erositesTartalek = Gm;
stabilitasHatarFrekvencia = wcg;
%  Ezen a frekvencián a fázis késése pontosan 180 fok. Ha ezen a frekvencián az
% erősítés elérné az 1-et (amit most még nem ér el, mert van "tartalékunk", a Gm), akkor a
% visszacsatolt jel pont fázisban lenne a bemenettel, és a rendszer végtelen oszcillációba kezdene.

% 3.3 feladat
% Donse el, hogy stabil-e a zart kor a Bode tetel segitsegevel! Valazszat indokolja

if Pm > 0 && Gm > 1
    disp('A rendszer STABIL a Bode-tétel szerint.');
end

% 3.3.1 feladat

% Hangolja be a P szabalyzo Ap parameteret a kovetkezo tervezesi feltelek mellett:

% zart kor ugrasvalaszanak tullovese legyen kisebb mint 13%
% a 2%os beallasi ido legyen a leheto legkisebb (23 masodpercnel kisebb)
% a felnyitott kor fazistartaleka legyen nagyobb mint 130 fok

Wry = feedback(Wo, 1, -1);

ugrasInfo = stepinfo(Wry);
tulloves = ugrasInfo.Overshoot;
beallasiIdo = ugrasInfo.SettlingTime;
Fazistartalek = Pm;

% Ap = 0.11


% 3.4 feladat
% Adja meg a zart szabalyozasi kor atviteli fuggvenyet!
%ezt rajzold le
minreal(Wry)

% 3.5 feladat
% Adja meg a zart kor marado hibajat a megfelelo Ap mellett! 
% Miert nem sikerul teljesen eltuntetni a marado hibat?
maradohiba = 1 - dcgain(Wry)
% Azért nem 0 a maradó hiba, mert a P szabályozóban NINCS integráló tag 
% (nincs 1/s pólus), ami a statikus hibát nullára vinné.

% 3.6 feladat
% Adja meg a zart kor tulloveset, elso maximumig terjedo idejet 
% es a 2%!os bneallasi idot a megfelelo Ap mellett!

tulloves = ugrasInfo.Overshoot
beallasiIdo = ugrasInfo.SettlingTime
elsoMaxIdo = ugrasInfo.PeakTime


