clc; 
clear; 
close all; 

addpath("..\orbitalMechanics"); 
addpath("..\plot"); 

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

%% orbite di lavoro

orb1 = orbIniz; 
orb1(1) = aFin; 
orb1(2) = eFin; 

[deltaV1, deltaV11, deltaV12, orbTrasf1, deltaT1, deltaT11, deltaT12, thetaMan] = manovraBitangenteEllittica(orbIniz, orb1, 'pa'); 

%%
orb1(6) = 180; 
[orb2, dV2, dT2, thetaMan2] = cambioInclinazione(orb1, iFin, RAANFin); 

%%

[orb3, dV3, dT3, thetaMan3] = cambioAnomaliaPericentro(orb2, omegaFin); 


%%
close
earth3D(1); 
orbit3D(orbIniz, 1); 
%%
orbit3D(orbTrasf1, 1); 
%%
orbit3D(orb1, 1); 



















