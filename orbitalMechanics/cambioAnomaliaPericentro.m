function [OrbFin, deltaV, deltaT] = cambioAnomaliaPericentro(OrbIniz, omegaFin)

%Calcola costo di un cambio di anaomalia di pericentro e restituisce
%l'orbita finale.
%   INPUT
%       OrbiIniz: Orbita iniziale, vettore
%       omegaFin: Omega finale desiderato
%   
%
%   OUTPUT
%       OrbFin: Orbita finale, vettore nel punto di manovra
%       deltaV: Costo deltaV manovra
%       deltaT: Tempo impiegato per raggiungere p.to manovra
%
%

if OrbIniz(3)>90                %da patchare il caso di orbite retrograde
    warning('errore, orbita retrograda')
end
mu = 398600;

aIniz=OrbIniz(1);
eIniz=OrbIniz(2);
omega1=OrbIniz(5);
thetaIniz=OrbIniz(6);

deltaOmega =wrapTo360(omegaFin-omega1);

if deltaOmega>180                                   %evito di effettuare più di mezzo giro, in tal caso
    deltaOmega=360-deltaOmega;                      %giro dalla parte opposta
end

p = aIniz*(1-eIniz^2);
deltaV = abs(2*sqrt(mu/p)*eIniz*sind(deltaOmega/2));    %calcolo modulo di deltaV


OrbFin=OrbIniz; 
OrbFin(5)=omegaFin;

thetaman1=wrapTo360(deltaOmega/2); %prima intersezione dopo peric. OrbIniz
thetaman2=wrapTo360(180+deltaOmega/2);  %seconda intersezione dopo peric. OrbIniz

if thetaIniz<thetaman1 || thetaIniz>thetaman2               %manovro a thetaman1
   OrbFin(6)=wrapTo360 (360-deltaOmega/2);
   thetaman=thetaman1;
else                                                        %manovro a thetaman2
   OrbFin(6)=wrapTo360 (180-deltaOmega/2);
   thetaman=thetaman2;
end
    
deltaT=tempoVolo(OrbIniz, OrbIniz(6),thetaman);             %calcolo deltaT per raggiungere punto di manovra



end
