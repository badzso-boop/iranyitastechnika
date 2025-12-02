close all
clear all
clc

%szakasz
Wp = tf(0.2, conv(conv([1, 1], [10, 1]), [11, 1]))

% PID szabalyozas
N = 10;
T1 = 10;
T2 = 11;

% Tc szamitasa
TcVec = roots([-(N+1), (T1+T2)*(N+1), -(T1*T2)])
% Tc = TcVec(2)

if min(TcVec) > 0
    Tc = min(TcVec)
else 
    if max(TcVec) < 0
        error(['Nem lehet beallitani Tc erteket, modositani kell az N egyutthatot'])
    else
        Tc = max(TcVec);
    end
end

Td = N * Tc
Ti = T1 + T2 - Tc
Ap = 29.396

Wc = Ap/Ti * tf([Ti * (Td+Tc), (Ti + Tc), 1], conv([1, 0], [Tc, 1]))

% felnyitott kor
Wo = minreal(Wc * Wp)

figure()
margin(Wo)
[gm, pm, wcg, wcp] = margin(Wo)

% zart kor
Wry = feedback(Wo, 1, -1)
figure()
step(Wry)

info = stepinfo(Wry)
fazistartalek = pm