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

%%

%orbIniz = [7686, 94/1281, 60, 30, 45, 180]; 
%orbIniz = [8168.52,0.18859, 0, 0, -90 , 268]; 
orbIniz = [19000, 0.1, 30, 45, 10 180]; 

%RAAN2 = 60; 
%i2 = 60; 

RAAN2 = 35; 
i2 = 0; 

[orbFin, deltaV, deltaT] = cambioInclinazione(orbIniz, i2, RAAN2); 
earth3D(1); 
orbit3D(orbIniz,1);
orbit3D(orbFin,1);
deltaV
deltaT
%orbit3D([19000, 0.1, 0, 0, 10, 150],1);


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






