%%% MAIN
%{ 
ANALISI DI MISSIONI SPAZIALI (PROVA FINALE)
Prof. Bernelli

This script allows you to set all the parameters and to run the simulation

VERSION: 
        - version 1: Jacopo Carradori, Riccardo Cadamuro, Tommaso Brombara


%}
clc
clear
close all
ptoIniz = [-1.1441403e4 -7.20985180e3 -1.30298510e3 1.2140 -1.7110 -4.7160]; % [x y z vx vy vz]

ptoFin = [1.9930e4, 1.5160e-1, rad2deg(3.0250), rad2deg(6.5460e-1),  rad2deg(2.7820), rad2deg(2.6190)]; 




r1 = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]'
v1 = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]'
mu = 398600;

[a1, e1, i1, RAAN1, omega1, theta1] = GEtoPF(r1, v1, mu)  %coordinate PF

a2 = ptoFin(1); e2 = ptoFin(2); 
i2 = rad2deg(ptoFin(3)); RAAN2 = rad2deg(ptoFin(4)); omega2 = rad2deg(ptoFin(5)); theta2 = rad2deg(ptoFin(6));  %dati punto finale

orbit2D( [a1, e1, omega1, theta1], 1, true); %
orbit2D( [a2, e2, omega2, theta2], 3, true); %

earth3D(2); 
orbit3D([a1, e1,i1, RAAN1, omega1,  theta1], 2); 
orbit3D(ptoFin, 2); 








