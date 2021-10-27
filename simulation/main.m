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
addpath('..\plot');
addpath('..\orbitalMechanics'); %aggiunti i percorsi per trovare le altre funzioni

%% DATI
ptoIniz = [-1.1441403e4 -7.20985180e3 -1.30298510e3 ...
1.2140 -1.7110 -4.7160];                                 % [x y z vx vy vz]
ptoFin = [1.9930e4, 1.5160e-1, rad2deg(3.0250), ...
rad2deg(6.5460e-1),  rad2deg(2.7820), rad2deg(2.6190)];  % [a e i RAAN omega theta]
mu = 398600;                                             % costante gravitazionale



%% ORBITA INIZIALE
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità

[orbIniz] = GEtoPF(rIniz, vIniz, mu) % da GE coordinate PF

%% ORBITA FINALE
aFin = ptoFin(1); 
eFin = ptoFin(2); 
iFin = (ptoFin(3));
RAANFin = (ptoFin(4));
omegaFin = (ptoFin(5));
thetaFin = (ptoFin(6)); 


%% PLOT
% orbit2D( [aIniz, eIniz, omegaIniz, thetaIniz], 1, true);             % plot 2D dell'orbita iniziale
% orbit2D( [aFin, eFin, omegaFin, thetaFin], 3, true);             % plot 2D dell'orbita finale

earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
orbit3D(ptoFin, 1);                                      % plot 3D orbita finale

%{
h = animatedline;

 for k = 1:length(r3D(1,:))
     addpoints(h,r3D(1,k),r3D(2,k),r3D(3,k));
     drawnow
 end
%}


