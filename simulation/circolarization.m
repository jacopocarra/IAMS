clc
clear
close all
addpath('..\plot');
addpath('..\orbitalMechanics'); %aggiunti i percorsi per trovare le altre funzioni

%%
global fps;
global myMovie;
global myFig;
myMovie = struct('cdata',[],'colormap',[]);
fps = 100;
%% dati


mu = 398600; 
ptoIniz = [-3441.6408 -7752.3491 -3456.8431 ...
            4.9270 -0.5369 -4.0350];                                 % [x y z vx vy vz]
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità
orbIniz = GEtoPF(rIniz, vIniz, mu);  % da GE coordinate PF


orbFin = [12930.0, 0.2055, rad2deg(1.5510), rad2deg(2.6830),  rad2deg(0.4098), rad2deg(1.6940)]';  % [a e i RAAN omega theta]        
%% MANOVRA 1 ************************************************************************************************** 
%{
[rFin, vFin] = PFtoGE(orbFin, mu); 

h1 = cross(rIniz, vIniz);  %momento angolare prima orbita
h2 = cross(rFin, vFin); %momento angolare seconda orbita

N = cross(h1, h2); 
N = N/norm(N);  %linea intersezione piani due orbite

%----------------CIRCOLARIZZO ORBITA-------------------------------------------
rAIniz = orbIniz(1) * (1 + orbIniz(2));  %raggio apocentro orbita iniziale

[orb2, dV2 , dT2] = manovraTangente(orbIniz, rAIniz, 'apo');   %circolarizzo all'apocentro
thetaMan1 = 180; %posizione prima manovra

[e2, v2] = PFtoGE([orb2(1), orb2(2), orb2(3), orb2(4), orb2(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

h2 = cross(e2, v2); %momento della q.tà di moto orb 2


thetaMan2 = acosd( dot(e2, N)/norm(e2) );   %posizione seconda manovra

if dot(cross(e2, N), h2) < 0   
    thetaMan2 = 360 - thetaMan2; 
end

if wrapTo360((thetaMan2 + 180) - orb2(6)) < wrapTo360(thetaMan2 - orb2(6))  %scelgo di manovrare nel punto più vicino
    thetaMan2 = wrapTo360(thetaMan2 + 180); 
end

%-----------------------------Alzo apocentro nella dir giusta--------------------------------

rPFin = orbFin(1)*(1 - orbFin(2)); %calcolo il raggio al pericentro dell'orbita finale
a3 = (orb2(1) + rPFin)/2;   %voglio che l'orbita 3 abbia come apocentro un raggio uguale a quello del pericentro dell'orbita finale
[orb3, dV3, dT3] = manovraTangente(orb2, a3, "gen", thetaMan2);  

dT32 = tempoVolo(orb3, orb3(6), orb3(6) + 90);   
orb3(6) = orb3(6) + 90; %mi sposto avanti di 90 gradi e calcolo il tempo che è passato

%--------------------------Cambio piano e circolarizzo----------------------------------

[orb41, dV41, dT41, thetaMan4] = cambioInclinazione(orb3, orbFin(3), orbFin(4)); %cambio piano all'apocentro
[orb4, dV42 , dT42] = manovraTangente(orb41, rPFin, 'apo');   %circolarizzo all'apocentro
dV4 = dV41 + dV42; 
dT4 = dT41; 

%---------------Manovra finale per raggiungere l'orbita----------------


[e4, v4 ] = PFtoGE([orb4(1), orb4(2), orb4(3), orb4(4), orb4(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

[eFin, ~] = PFtoGE([orbFin(1), orbFin(2), orbFin(3), orbFin(4), orbFin(5), 0], mu);


h4 = cross(e4, v4); %momento della q.tà di moto orb 4


thetaMan5 = acosd( dot(e4, eFin)/(norm(e4)*norm(eFin)) );   %posizione seconda manovra

if dot(cross(e4, eFin), h4) < 0   
    thetaMan5 = 360 - thetaMan5; 
end

%--------------chiusura finale---------------------------------
[orb5, dV5, dT5] = manovraTangente(orb4, orbFin(1), "gen", thetaMan5); 


%%
Title = 'STRATEGY 4 - Circolarization';
Maneuv_name=[{'initial point'};{'Circolarization 1'};{'Rise Apoapsis'};...
    {'Plane change & Circolarization 2'};{'Rise Apoapsis'}; {'Final Point'}];


plotOrbit([orbIniz , orb2 , orb3 ,orb4 , orb5],...
            [orbIniz(6), thetaMan1,     orb2(6), thetaMan2,    orb3(6)-90,thetaMan4,   orb4(6),thetaMan5,    orb5(6), orbFin(6)  ],...
            [dT2, dT3, dT32 + dT4, dT5, tempoVolo(orb5, orb5(6), orbFin(6))],...
            Title,Maneuv_name,'dyn',0,...
            [0, dV2, dV3, dV4, dV5]); 



%%
earth3D(2); 
orbit3D(orbIniz, 2); 
%%
orbit3D(orb2, 2); 
%%
orbit3D(orb3, 2); 
%%
orbit3D(orb4, 2); 
%% 
orbit3D(orb5, 2); 
%%
orbit3D(orb6, 2); 
%%
orbit3D(orbFin,2); 
%%
deltaV1 = dV2 + dV3 + dV4 + dV5 
deltaT1 = dT2 + dT3 + dT32 + dT4 + dT5 + tempoVolo(orb5, orb5(6), orbFin(6))
%}
%% MANOVRA 2 **************************************************************************************************************
[rFin, vFin] = PFtoGE(orbFin, mu); 

h1 = cross(rIniz, vIniz);  %momento angolare prima orbita
h2 = cross(rFin, vFin); %momento angolare seconda orbita

N = cross(h1, h2); 
N = N/norm(N);  %linea intersezione piani due orbite

%----------------CIRCOLARIZZO ORBITA-------------------------------------------
rAIniz = orbIniz(1) * (1 + orbIniz(2));  %raggio apocentro orbita iniziale

[orb2, dV2 , dT2] = manovraTangente(orbIniz, rAIniz, 'apo');   %circolarizzo all'apocentro
thetaMan1 = 180; %posizione prima manovra

[e2, v2] = PFtoGE([orb2(1), orb2(2), orb2(3), orb2(4), orb2(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

h2 = cross(e2, v2); %momento della q.tà di moto orb 2


thetaMan2 = acosd( dot(e2, N)/norm(e2) );   %posizione seconda manovra

if dot(cross(e2, N), h2) < 0   
    thetaMan2 = 360 - thetaMan2; 
end

if wrapTo360((thetaMan2 + 180) - orb2(6)) < wrapTo360(thetaMan2 - orb2(6))  %scelgo di manovrare nel punto più vicino
    thetaMan2 = wrapTo360(thetaMan2 + 180); 
end

%-----------------------------Alzo apocentro nella dir giusta--------------------------------

rAFin = orbFin(1)*(1 + orbFin(2)); %calcolo il raggio al pericentro dell'orbita finale
a3 = (orb2(1) + rAFin)/2;   %voglio che l'orbita 3 abbia come apocentro un raggio uguale a quello dell'apocentro dell'orbita finale
[orb3, dV3, dT3] = manovraTangente(orb2, a3, "gen", thetaMan2);  

dT32 = tempoVolo(orb3, orb3(6), orb3(6) + 90);   
orb3(6) = orb3(6) + 90; %mi sposto avanti di 90 gradi e calcolo il tempo che è passato

%--------------------------Cambio piano e circolarizzazione nello stesso punto----------------------------------

[orb41, dV41, dT41, thetaMan4] = cambioInclinazione(orb3, orbFin(3), orbFin(4)); %manovra eseguita all'apocentro
[orb4, dV42 , dT42] = manovraTangente(orb41, rAFin, 'apo');   %circolarizzo all' apocentro

dV4 = dV41 + dV42;

dT4 = dT41;  

orb31 = orb3; 
orb31(6) = thetaMan4; 
[~, dV4D1, dV4D2, ~, ~, ~] = trasfDir(orb31, orb4); 
dV4D = dV4D1 + dV4D2; 

%---------------Manovra finale per raggiungere l'orbita----------------

[e4, v4 ] = PFtoGE([orb4(1), orb4(2), orb4(3), orb4(4), orb4(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

[rFin, ~] = PFtoGE([orbFin(1), orbFin(2), orbFin(3), orbFin(4), orbFin(5), 180], mu);


h4 = cross(e4, v4); %momento della q.tà di moto orb 5


thetaMan5 = acosd( dot(e4, rFin)/(norm(e4)*norm(rFin)) );   %posizione seconda manovra

if dot(cross(e4, rFin), h4) < 0   
    thetaMan5 = 360 - thetaMan5; 
end

%--------------chiusura finale---------------------------------
[orb5, dV5, dT5] = manovraTangente(orb4, orbFin(1), "gen", thetaMan5); 


%%
Title = 'STRATEGY 4 - Circolarization';
Maneuv_name=[{'initial point'};{'Circolarization 1'};{'Rise Apoapsis'};...
    {'Plane change & Circolarization 2'};{'Decrease Periapsis'}; {'Final Point'}];


plotOrbit([orbIniz , orb2 , orb3 ,orb4 , orb5],...
            [orbIniz(6), thetaMan1,     orb2(6), thetaMan2,    orb3(6)-90,thetaMan4,   orb4(6),thetaMan5,  orb5(6), orbFin(6)  ],...
            [dT2, dT3, dT32 + dT4, dT5 , tempoVolo(orb5, orb5(6), orbFin(6))],...
            Title,Maneuv_name,'stat',0,...
            [0, dV2, dV3, dV4, dV5]); 



%%
earth3D(3); 
orbit3D(orbIniz, 3); 
%%
orbit3D(orb2, 3); 
%%
orbit3D(orb3, 3); 
%%
orbit3D(orb4, 3); 
%% 
orbit3D(orb5, 3); 
%%
orbit3D(orbFin,3); 
%%

deltaV2 = dV2 + dV3 + dV4 + dV5 
deltaT2 = dT2 + dT3 + dT32 + dT4  + dT5 + tempoVolo(orb5, orb5(6), orbFin(6))




