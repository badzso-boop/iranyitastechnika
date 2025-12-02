clear all
close all
clc

% szakasz
Wp = tf(0.2, conv(conv([1, 1], [11, 1]), [10, 1]))

% PID szabalyzo tervezese
N = 10;
T1 = 10;
T2 = 11;

% minimalis fazistartalek
phaseMarginMin = 60;
% maximalis tulloves
overshootMax = 5;

% tc meghatarozasa
TcVec = roots([-(N+1), (T1+T2)*(N+1), -T1*T2]);

if min(TcVec) > 0
    Tc = min(TcVec)
else 
    if max(TcVec) < 0
        error(['Nem lehet beallitani Tc erteket, modositani kell az N egyutthatot'])
    else
        Tc = max(TcVec);
    end
end

Ti = T1+T2-Tc;
Td = N*Tc;

%szabalyzo atviteli fuggvenye
Wc = tf([Ti*(Td+Tc), Ti+Tc, 1], conv([1, 0], [Tc, 1]));

% felnyitott kor
Wo = minreal(Wc * Wp)

%tartalek
[Gm, Pm, wcg, wcp] = margin(Wo);

%Ap hangolasa
ApBest = 1;
minT2 = Inf;

for Ap=1:0.01:Gm
    % szabalyozo ap-vel
    Wc = Ap*tf([Ti*(Td+Tc), Ti+Tc, 1], conv([1, 0], [Tc, 1]));
    %felnyitott kor ujraszamitasa
    Wo = minreal(Wc * Wp);
    %fazistartalek ujraszamitasa
    [Gm, Pm, wcg, wcp] = margin(Wo);
    if Pm < phaseMarginMin
        break;
    end

    % zart kor jellemzoi
    Wry = feedback(Wo, 1, -1);
    info = stepinfo(Wry);
    %tulloves szamitasa
    overshoot = info.Overshoot;
    if overshoot > overshootMax
        break
    end
    % beallasi ido
    T2 = info.SettlingTime;
    if T2 < minT2
        minT2 = T2;
        ApBest = Ap;
    end
end

ApBest

%behangolt szabalyozo atviteli fuggvenye
Wc = ApBest*tf([Ti*(Td+Tc), Ti+Tc, 1], conv([1, 0], [Tc, 1]));
Wo = minreal(Wc * Wp);
[Gm, Pm, wcg, wcp] = margin(Wo);