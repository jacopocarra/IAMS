%%% MAIN
%{ 
ANALISI DI MISSIONI SPAZIALI (PROVA FINALE)
Prof. Bernelli

This script allows you to set all the parameters and to run the simulation

VERSION: 
        - version 1: Jacopo Carradori, Riccardo Cadamuro, Tommaso Brombara


%}
clc
clear all
close all
ptoIniz = [1e5 2e5 1e5 -2.5 -2.5 3]; % [x y z vx vy vz]

ptoFin =[];  % [a e i omegagrande omegapiccolo theta]



% a = ptoFin(1);
% e = ptoFin(2);
% i = ptoFin(3);
% omegaGrande = ptoFin(4);
% omegaPiccolo = ptoFin(5);
% theta = ptoFin(6);

r = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';
v = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';
mu = 3986000.4;

[a, e, i, RAAN, omega, theta] = GEtoPF(r, v, mu)

[r1, v1] = PFtoGE(a, e, i, RAAN, omega, theta, mu) %funzioni di test

