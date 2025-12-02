clear all % torli a valtozokat
close all % bezarja az abrakat
clc % torli a commandot

%matrixok bevitele
A = [2,5,2.3; 1, 0, 3; 0, -4.1, 5]
B = [1;-1;-2]
C = [-1,-2,3]
D = 0

% rendszer allapotteres leirassal
r = ss(A, B, C, D) % Create state-space system representation

% stabilitas
s = eig(A)

% ugrasvalasz
figure()
step(r)

%impulzusvalasz
figure()
impulse(r)

% atalakitas transferCuntion-re
rTF = tf(r)
rTF = tf(ss(A, B, C, D))


%%

clear all
close all
clc

%rendszer atviteli fuggenye
r = tf(2, [1,11,42.25,54.75])

%polusok
p = pole(r)

%zerusok
z = zero(r)


%abrazoljuk a rsz polusait es zerusait
figure()
pzmap(r)

%statikus erosites
K = dcgain(r)

%ugrasvalasz
figure()
step(r)

%%
clear all
close all
clc

%idoallandos alakban bevitt transfer function
r = tf(2, conv(conv([3,1],[5,1]),[10,1]) )

%% 
clear all
close all
clc

%polus-zerus erosites alak
z = []
p = [-3, -4+1.5i, -4-1.5i]
k = 2

%polus-zerus eloszlas
r = zpk(z,p,k)