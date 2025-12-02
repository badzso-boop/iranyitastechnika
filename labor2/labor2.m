clear all
close all
clc

%parameterek
m = 100;
k = 150;
b = 2 * sqrt(k * m);


mech = tf(1, [m, b, k])

% polusok
p = pole(mech)

%statikus erosites
K = dcgain(mech)

% ugrasvalasz
figure()
step(mech)

%impulzus valasz
figure()
impulse(mech)

% polus zerus
figure()
pzmap(mech)

%bode
figure()
bode(mech)