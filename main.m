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

%% DATI
ptoIniz = [-1.1441403e4 -7.20985180e3 -1.30298510e3 ...
1.2140 -1.7110 -4.7160];                                 % [x y z vx vy vz]
ptoFin = [1.9930e4, 1.5160e-1, rad2deg(3.0250), ...
rad2deg(6.5460e-1),  rad2deg(2.7820), rad2deg(2.6190)];  % [a e i RAAN omega theta]
mu = 398600;                                             % costante gravitazionale



%% ORBITA INIZIALE
r1 = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
v1 = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità

[a1, e1, i1, RAAN1, omega1, theta1] = GEtoPF(r1, v1, mu) % da GE coordinate PF

%% ORBITA FINALE
a2 = ptoFin(1); 
e2 = ptoFin(2); 
i2 = (ptoFin(3));
RAAN2 = (ptoFin(4));
omega2 = (ptoFin(5));
theta2 = (ptoFin(6)); 


%% PLOT
orbit2D( [a1, e1, omega1, theta1], 1, true);             % plot 2D dell'orbita iniziale
orbit2D( [a2, e2, omega2, theta2], 3, true);             % plot 2D dell'orbita finale

earth3D(2);                                              % plot terra
orbit3D([a1, e1,i1, RAAN1, omega1,  theta1], 2);         % plot 3D orbita iniziale
orbit3D(ptoFin, 2);                                      % plot 3D orbita finale








