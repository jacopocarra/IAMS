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

orbIniz = [19000, 0.1, 30, 45, 10, 0]; 

RAAN2 = 60; 
i2 = 30; 

[orbFin, deltaV, deltaT] = cambioInclinazione(orbIniz, i2, RAAN2); 
earth3D(1); 
orbit3D(orbIniz,1);
orbit3D(orbFin,1);

deltaV

%%
clear; 
clc; 

orbIniz = [42164, 0, 28, 0, 0 , 0]; 

RAAN2 = 0; 
i2 = 0; 

[orbFin, deltaV, deltaT] = cambioInclinazione(orbIniz, i2); 
