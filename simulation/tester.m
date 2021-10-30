%{
    QUESTO SCRIPT SERVE UNICAMENTE PER INSERIRE I DATI PER TESTARE LE
    FUNZIONI MAN MANO CHE VENGONO CREATE, TUTTO IL CODICE DAL SECONDO
    PARAGRAFO PUO' ESSERE CANCELLATO SENZA PROBLEMI IN OGNI MOMENTO
%}

clc
clear
close all
addpath('..\plot');
addpath('..\orbitalMechanics'); %aggiunti i percorsi per trovare le altre funzioni
global fps;
global myMovie;
global myFig;
myMovie = struct('cdata',[],'colormap',[]);
fps = 100;
%%



mu = 398600;
ptoIniz = [-1.1441403e4 -7.20985180e3 -1.30298510e3 ...
1.2140 -1.7110 -4.7160];                                 % [x y z vx vy vz]
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità

[orbIniz] = GEtoPF(rIniz, vIniz, mu) % da GE coordinate PF

[orbFin1, deltaV1, deltaT1] = cambioInclinazione(orbIniz, rad2deg(3.0250), rad2deg(6.5460e-1))
[orbFin, deltaV, deltaT, thetaman] = cambioAnomaliaPericentro(orbFin1, rad2deg(2.7820))
orbFin2 = [1.9930e4, 1.5160e-1, rad2deg(3.0250), ...
rad2deg(6.5460e-1),  rad2deg(2.7820), rad2deg(2.6190)]';
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaMan] = manovraBitangenteEllittica(orbFin, orbFin2, 'pa')
Title = 'STRATEGY 1';
Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];
 plotOrbit([orbIniz, orbFin1,orbFin, orbTrasf,orbFin2],[orbIniz(6), orbFin1(6), orbFin1(6), thetaman, orbFin(6), thetaMan, thetaMan, orbTrasf(6), orbTrasf(6) orbFin(6)],[deltaT1, deltaT, deltaT2, deltaT3, deltaT4],Title,Maneuv_name,'dyn',0,[0, deltaV1, deltaV, deltaV3, deltaV4])



%% 
clc; 
close all;
clear; 

orbIniz = [15235.66 0.5657 0 0 45 45]; 
%orbFin = [15235.66 0.5657 0 0 0 45]; 

[orbFin, deltaV, deltaT, thetaMan] = cambioAnomaliaPericentro(orbIniz, 0); 


thetaMan
orbFin
deltaV
deltaT






