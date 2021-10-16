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
ptoIniz = [-1.1441403e4 -7.20985180e3 -1.30298510e3 1.2140 -1.7110 -4.7160]; % [x y z vx vy vz]




r = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]'
v = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]'
mu = 398600;



[a, e, i, RAAN, omega, theta] = GEtoPF(r, v, mu)  %coordinate PF


orbit2D(a, e, omega, theta, 1000); %

orbit3D(a, e,i, RAAN, omega,  theta, 1000); 










