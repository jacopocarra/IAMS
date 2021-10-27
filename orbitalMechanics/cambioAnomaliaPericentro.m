function [orbFin, deltaV, deltaT] = cambioAnomaliaPericentro(orbIniz, omegaFin)

%Calcola costo di un cambio di anaomalia di pericentro e restituisce
%l'orbita finale.
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


mu = 398600;

aIniz=orbIniz(1);
eIniz=orbIniz(2);
omega1=orbIniz(5);
thetaIniz=orbIniz(6);

deltaOmega =wrapTo360(omegaFin-omega1);

if deltaOmega>180                                   %evito di effettuare più di mezzo giro, in tal caso
    deltaOmega=360-deltaOmega;                      %giro dalla parte opposta
end

p = aIniz*(1-eIniz^2);
deltaV = abs(2*sqrt(mu/p)*eIniz*sind(deltaOmega/2));    %calcolo modulo di deltaV


orbFin=orbIniz; 
orbFin(5)=omegaFin;

thetaman1=wrapTo360(deltaOmega/2); %prima intersezione dopo peric. OrbIniz
thetaman2=wrapTo360(180+deltaOmega/2);  %seconda intersezione dopo peric. OrbIniz

if thetaIniz<thetaman1 || thetaIniz>thetaman2               %manovro a thetaman1
   orbFin(6)=wrapTo360 (360-deltaOmega/2);
   thetaman=thetaman1;
else                                                        %manovro a thetaman2
   orbFin(6)=wrapTo360 (180-deltaOmega/2);
   thetaman=thetaman2;
end
    
deltaT=tempoVolo(orbIniz, orbIniz(6),thetaman);             %calcolo deltaT per raggiungere punto di manovra



end
