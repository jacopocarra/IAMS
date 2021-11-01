function [orbFin, deltaV , deltaT] = manovraTangente(orbIniz, aFin, type)

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
%       deltaT

    type = lower(type); 
    mu = 398600;

    aIniz = orbIniz(1);
    eIniz = orbIniz(2);
    thetaIniz = wrapTo360(orbIniz(6));
    
    orbFin = orbIniz; 
    orbFin(1) = aFin; 

    switch type
        case 'apo'
            
            r1 = aIniz*(1+eIniz);  %raggio apocentro orbIniz
          
        case 'per'
           
            r1 = aIniz*(1-eIniz);  %raggio pericentro orbIniz
    end
    
    deltaV = abs( sqrt( 2*mu*((1/r1)-(1/(2*aFin))) ) - sqrt( 2*mu*((1/r1)-(1/(2*aIniz))) ) ); %calcolo il deltaV -> essendo in valore assoluto non importa il segno della sottrazione
    
    r2 = 2*aFin - r1; %calcolo il raggio al punto apsidale opposto
    
    if r2 > r1  %per capire che tipo di orbita risulterà
        thetaMan = 0;  %manovro nel pericentro dell'orbita finale
        
        orbFin(2) = (r2 - r1)/(r1 + r2);
        
        if type == "apo"  %se avevo scelto di manovrare nell'apocentro dell'orbita iniziale devo cambiare l'anomalia al pericentro
            orbFin(5) = wrapTo360(180 + orbFin(5));
        end
        
    else
        thetaMan = 180; %manovro nell'apocentro dell'orbita finale
    
        orbFin(2) = (r1 - r2)/(r1 + r2);
        
        if type == "per" %se avevo scelto di manovrare nel pericentro dell'orbita iniziale devo cambiare l'anomalia al pericentro
            orbFin(5) = wrapTo360(180 + orbFin(5)); 
        end
    end 
    
    
    orbFin(6) = thetaMan; 
    
    deltaT = tempoVolo(orbIniz, thetaIniz, thetaMan);

end