function [orbTrasf1,orbTrasf2, deltaVVect, deltaTVect, dealtaV, deltaT] = trasfBiellittico(orbIniz, orbFin,rb)

%calcola costo 
%
%   INPUT
%       orbiIniz: Orbita iniziale, vettore
%       omegaFin: Omega finale desiderato
%
%
%   OUTPUT
%       orbFin: Orbita finale, vettore nel punto di manovra
%       deltaV: Costo deltaV manovra
%       deltaT: Tempo impiegato per raggiungere p.to manovra
%

if wrapTo360(orbIniz(4)-orbFin(4))
mu = 398600;

aIniz=orbIniz(1);
eIniz=orbIniz(2);
omega1=orbIniz(5);
thetaIniz=orbIniz(6);




end