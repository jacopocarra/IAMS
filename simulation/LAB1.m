%%% LABORATORIO 1 
%{ 
ANALISI DI MISSIONI SPAZIALI



%}
clc
clear all
close all
ptoIniz = [1e4 2e4 1e4 -2.5 -2.5 3]; % [x y z vx vy vz]

ptoFin =[];  % [a e i omegagrande omegapiccolo theta]


r = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';
v = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';
mu = 398600.4;
[a, e, i, RAAN, omega, theta] = GEtoPF(r, v, mu)








