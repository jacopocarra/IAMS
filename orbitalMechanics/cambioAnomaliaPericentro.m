function [orbFin, deltaV, deltaT, thetaman] = cambioAnomaliaPericentro(orbIniz, omegaFin)
%[orbFin, deltaV, deltaT, thetaman] = cambioAnomaliaPericentro(orbIniz, omegaFin, nman)
%Calcola costo di un cambio di anaomalia di pericentro e restituisce
%l'orbita finale.
%   INPUT
%       orbiIniz: Orbita iniziale, vettore
%       omegaFin: Omega finale desiderato
%
%   OUTPUT
%       orbFin: Orbita finale, vettore nel punto di manovra
%       deltaV: Costo deltaV manovra
%       deltaT: Tempo impiegato per raggiungere p.to manovra
%       thetaman: punto di manovra rispetto all'orbita di partenza
%
%   Nota: manovra eseguita al punto più vicino

%% recall dati
mu = 398600;

aIniz=orbIniz(1);
eIniz=orbIniz(2);
omega1=wrapTo360(orbIniz(5));  
thetaIniz=wrapTo360(orbIniz(6));  %mi accerto di avere angoli fra 0 e 360 

p = aIniz*(1-eIniz^2);

%% aggiustamento angoli

deltaOmega =wrapTo360(omegaFin-omega1); % tra 0 e 360

%% calcolo effettivo

deltaV = abs(2*sqrt(mu/p)*eIniz*sind(deltaOmega/2));        %calcolo modulo di deltaV che è indipendente dal punto di manovra (cambia solo il verso)


    
orbFin=orbIniz;
orbFin(5)=omegaFin;

thetaman1=wrapTo360(deltaOmega/2);                          %prima intersezione dopo peric. OrbIniz
thetaman2=wrapTo360(180+deltaOmega/2);                      %seconda intersezione dopo peric. OrbIniz
%misurati rispetto all'orbita di partenza


if thetaIniz<thetaman1 || thetaIniz>thetaman2               %manovro a thetaman1
    orbFin(6)=wrapTo360 (-deltaOmega/2);
    thetaman=thetaman1;
else                                                        %manovro a thetaman2
    orbFin(6)=wrapTo360 (180-deltaOmega/2);
    thetaman=thetaman2;
end
deltaT=tempoVolo(orbIniz, orbIniz(6),thetaman);             %calcolo deltaT per raggiungere punto di manovra

end
