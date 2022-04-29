

path = cd;
if ismac
    if ~isfile(fullfile(path, 'Dati_A2'))
        IAMScheck
        error('data is missing')
    end
else
    if ~isfile(fullfile(path, 'Dati_A2'))
        IAMScheck
        error('data is missing')
    end
end 

config; 
%% caso 5a **************************************************************************************************************

[rFin, vFin] = PFtoGE(orbFin, mu); 

h1 = cross(rIniz, vIniz);  %momento angolare prima orbita
h2 = cross(rFin, vFin); %momento angolare seconda orbita

N = cross(h1, h2); 
N = N/norm(N);  %linea intersezione piani due orbite

%----------------CIRCOLARIZZO ORBITA-------------------------------------------
rAIniz = orbIniz(1) * (1 + orbIniz(2));  %raggio apocentro orbita iniziale

[orb2, dV2 , dT2] = manovraTangente(orbIniz, rAIniz, 'apo');   %circolarizzo all'apocentro
thetaMan1 = 180; %posizione prima manovra

orb2(6) = wrapTo360(orb2(6) + orb2(5)); 
orb2(5) = 0;   %aggiusto i parametri orbitali delle orbite circolari

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

%dV4 = dV41 + dV42; %errata

dT4 = dT41;  

orb31 = orb3; 
orb31(6) = thetaMan4; 
[~, dV4D1, dV4D2, dTdiretto, ~, ~] = trasfDir(orb31, orb4); 
dV4 = dV4D1 + dV4D2; 

orb4(6) = wrapTo360(orb4(6) + orb4(5)); 
orb4(5) = 0;  %aggiusto i parametri orbitali delle orbite circolari

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
Maneuv_name=[{'initial point'};{'1st circularization'};{'1st tangent burn'};...
    {'Plane change & 2nd circularization'};{'2nd tangent burn'}; {'Final Point'}];


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
