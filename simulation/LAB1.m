%%% LABORATORIO 1 
%{ 
ANALISI DI MISSIONI SPAZIALI



%}
clc
clear all
close all
ptoIniz = [1e4 2e4 1e4 -2.5 -2.5 3]; % [x y z vx vy vz]

ptoFin =[];  % [a e i omegagrande omegapiccolo theta]



% a = ptoFin(1);
% e = ptoFin(2);
% i = ptoFin(3);
% omegaGrande = ptoFin(4);
% omegaPiccolo = ptoFin(5);
% theta = ptoFin(6);

r = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';
v = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';
mu = 398600.4;
[a, e, i, RAAN, omega, theta] = GEtoPF(r, v, mu)



%{
lat0 = norm(r)*sin(0)
lon0 = norm(r)*sin(0)

uif = uifigure;
g = geoglobe(uif);
geoplot3(g,norm(r)*sin(i),norm(r)*sin(theta),norm(r),'b','Linewidth',5);
campos(g, settings.lat0, settings.lon0, norm(r));
camheading(g, 'auto');
campitch(g, -25);
%}





