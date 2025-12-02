clear all
close all
clc

%szakasz
Wp = tf(0.2, conv(conv([1 1],[11 1]),[10 1]))

%PID szabályozó tervezése
N = 10;
T1 = 10;
T2 = 11;

%minimalis fazistartalek
phaseMarginMin = 60;

%maximalis tulloves
overshootMax = 5;

%Tc meghatarozasa
TcVec = roots([-(N+1) (T1+T2)*(N+1) -T1*T2]);

if min(TcVec) > 0
    Tc = min(TcVec)
elseif max(TcVec) > 0
    Tc = max(TcVec)
else
    error('Nem lehet beállítani!')
end

Ti = T1+T2-Tc;
Td = N*Tc;

%szabalyozo atviteli fuggvenye
Wc = tf([Ti*(Td+Tc) Ti+Tc 1],conv([Ti 0],[Tc 1]));

%felnyitott kor
Wo = minreal(Wc*Wp)

%tartalekok
[Gm, Pm, wcg, wcp] = margin(Wo);

%Ap hangolasa
ApBest = 1;
minT2 = Inf;

for Ap = 1:0.01:Gm
    %szabalyozo Ap-vel
    Wc = Ap*tf([Ti*(Td+Tc) Ti+Tc 1],conv([Ti 0],[Tc 1]));
    %felnyitott kor ujraszamitasa
    Wo = minreal(Wc*Wp);
    %fazistartalek ujszamitasa
    [Gm, Pm, wcg, wcp] = margin(Wo);
    if Pm < phaseMarginMin
        break;
    end
    %zart kor jellemzoi
    Wry = feedback(Wo,1,-1);
    info = stepinfo(Wry);
    %tulloves szamitasa
    overshoot = info.Overshoot;
    if overshoot > overshootMax
        break;
    end
    %beallasi ido
    T2 = info.SettlingTime;
    if T2 < minT2
       minT2 = T2; 
       ApBest = Ap;
    end
end

%bahangolt szabalyozo atviteli fuggvenye es jellemzoi
Wc = ApBest*tf([Ti*(Td+Tc) Ti+Tc 1],conv([Ti 0],[Tc 1]));
Wo = minreal(Wc*Wp);
[Gm, Pm, wcg, wcp] = margin(Wo);
Wry = feedback(Wo,1,-1);
info = stepinfo(Wry)

%diszkretizaljuk a szabalyozo atviteli fuggvenyet
%határozzuk meg azt a Ts-t, amivel a fazistartalék romlás maximum 1°
%írjuk fel a szabályozó differencia egyenletét u[k]-ra rendezve

%%

maxRomlas = 1;
TsMax = (2/wcp)*maxRomlas*(pi/180)

Ts = 0.125
%diszkret atviteli fuggveny
Dc = c2d(Wc,Ts,'zoh')
