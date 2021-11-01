function [orbFin, deltaV , deltaT, thetaMan] = manovraTangente(orbIniz, aFin, type)

%   [orbFin, deltaV , deltaT] = manovraTangente(orbIniz, aFin, type)
%   Calcola una manovra tangente
%   
%   Input: 
%       orbIniz: orbita iniziale
%       aFin: semiasse maggiore orbita obiettivo
%       type:   'apo': manovro in corrispondenza dell'apocentro
%               'per': manovro in corrispondenza del pericentro
% 
%   Output: 
%       orbFin: orbita finale (theta in corrispondenza della fine della
%               manovra)
%       deltaV
%       deltaT: per arrivare dal punto di partenza al punto di manovra
%       thetaMan: punto di manovra nell'orbita di partenza

    type = lower(type); 
    mu = 398600;

    aIniz = orbIniz(1);
    eIniz = orbIniz(2);
    thetaIniz = wrapTo360(orbIniz(6));
    
    orbFin = orbIniz; 
    orbFin(1) = aFin; 

    switch type
        case 'apo'
            thetaMan = 180; %manovro nell'apocentro dell'orbita
            r1 = aIniz*(1+eIniz);  %raggio apocentro orbIniz
          
        case 'per'
            thetaMan = 0;  %manovro nel pericentro dell'orbita 
            r1 = aIniz*(1-eIniz);  %raggio pericentro orbIniz
    end
    
    deltaV = abs( sqrt( 2*mu*((1/r1)-(1/(2*aFin))) ) - sqrt( 2*mu*((1/r1)-(1/(2*aIniz))) ) ); %calcolo il deltaV -> essendo in valore assoluto non importa il segno della sottrazione
    deltaT = tempoVolo(orbIniz, thetaIniz, thetaMan);
    
    
    r2 = 2*aFin - r1; %calcolo il raggio al punto apsidale opposto
    
    if r2 >= r1 
        %manovro nel pericentro dell'orbita finale
        orbFin(6) = 0; 
        orbFin(2) = (r2 - r1)/(r1 + r2);
        
        if type == "apo"  %se avevo scelto di manovrare nell'apocentro dell'orbita iniziale devo cambiare l'anomalia al pericentro
            orbFin(5) = wrapTo360(180 + orbFin(5));
        end
        
    else
        %manovro nell'apocentro dell'orbita finale
        orbFin(6) = 180; 
        orbFin(2) = (r1 - r2)/(r1 + r2);
        
        if type == "per" %se avevo scelto di manovrare nel pericentro dell'orbita iniziale devo cambiare l'anomalia al pericentro
            orbFin(5) = wrapTo360(180 + orbFin(5)); 
        end
    end 
    


end