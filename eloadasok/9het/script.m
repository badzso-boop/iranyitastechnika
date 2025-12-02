clear all
close all
clc

%szakasz
Wp = tf(0.2, conv(conv([1 1], [10 1]),[11 1]))

%szabalyozo PID
N = 10;
T1 = 10;
T2 = 11;

TcVec = roots([-(N+1) (T1+T2)*(N+1) -(T1*T2)])
%el kell dontenunk hogy melyiket valasztjuk

%Tc = TcVec(2)
if min(TcVec) > 0 
    Tc = min(TcVec)
else
    if max(TcVec) < 0
        error(['Ne lehet beállítani. N modosítása javasolt!'])
    else
        Tc = max(TcVec)
    end
end

Ti = T1+T2-Tc
Td = N*Tc

Ap = 29.396
Wc = Ap/Ti*tf([Ti*(Td+Tc) Ti+Tc 1], conv([1 0], [Tc 1]))

%felnyitott kor
Wo = minreal(Wc*Wp)

%Bode
figure()
margin(Wo)
[Gm, Pm, wcg,wcp] = margin(Wo)

%zart kor
Wry = feedback(Wo, 1, -1)
figure()
step(Wry)

%informaciok zart korrol
infoWry = stepinfo(Wry)
