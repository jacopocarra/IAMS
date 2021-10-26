function [OrbFin, deltaV2] = cambioAnomaliaPericentro(OrbIniz, omegaFin)

%Calcola costo di un cambio di anaomalia di pericentro e restituisce
%l'orbita finale.
%   INPUT
%   -Orbita iniziale, vettore nel punto d'intersezione scelto
%   -omega finale desiderato
%   -
%
%   OUTPUT
%   -Prbita finale, vettore
%   -Costo deltaV manovra
%   -
%


%idea: chiamare funzione che trova theta di intersezione tra prbita di
%partenza e di arrivo per poter passare un'orbita generica e non già nel
%punto di manovra

aIniz=OrbIniz(1);
eIniz=OrbIniz(2);
omega1=OrbIniz(5);

deltaOmega = omegaFin-omega1;
p = aIniz*(1-eIniz^2);
deltaV2 = abs(2*sqrt(mu/p)*eIniz*sin(deltaOmega/2));
% theta3 = 360 - theta2;            %di questi non ho capito l'utilità
% theta4 = theta3 + 180;

OrbFin=OrbIniz;
OrbFin(5)=omegaFin;
OrbFin(6)=OrbIniz(6)+deltaOmega;

end