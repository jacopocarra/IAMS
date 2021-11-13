%{
IMPOSTA I PARAMETRI BASE CHE SERVONO PER TUTTE LE 
STRATEGIE
%}

clc
clear
close all
addpath('..\plot');
addpath('..\orbitalMechanics'); %aggiunti i percorsi per trovare le altre funzioni
format long g
%% VARIABLES FOR VIDEO
global fps;
global myMovie;
global myFig;
myMovie = struct('cdata',[],'colormap',[]);
fps = 100;
%% DATI
ptoIniz = [-3441.6408 -7752.3491 -3456.8431 ...
4.9270 -0.5369 -4.0350];                                 % [x y z vx vy vz]
orbFin = [12930.0, 0.2055, rad2deg(1.5510)...
rad2deg(2.6830),  rad2deg(0.4098), rad2deg(1.6940)]';  % [a e i RAAN omega theta]
mu = 398600;                                             % costante gravitazionale



%% ORBITA INIZIALE
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità

[orbIniz] = GEtoPF(rIniz, vIniz, mu); % da GE coordinate PF

%% ORBITA FINALE
aFin = orbFin(1); 
eFin = orbFin(2); 
iFin = (orbFin(3));
RAANFin = (orbFin(4));
omegaFin = (orbFin(5));
thetaFin = (orbFin(6)); 