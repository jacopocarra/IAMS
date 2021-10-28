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
close all; 

orbit3D([19000, 0.9, 60, , 10, 150],1);
orbit3D([19000, 0.9, 0, 0, 140, 150],1);



