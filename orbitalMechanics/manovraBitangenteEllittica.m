function [deltaV, deltaV1, deltaV2, orbTrasf, deltaT, deltaT1, deltaT2, thetaMan] = manovraBitangenteEllittica(orbIniz, orbFin, type)

format long
%{
Calcolo manovra bitangente ellittica

INPUT: 
        - orbIniz:  [6x1], parametri orbita iniziale
        - orbFin:  [6x1], parametri orbita iniziali, theta deve rimanere
        uguale
        - type: sceglie il caso: 'ap', 'pa', 'pp', 'aa'

OUTPUT: 
        - deltaV: delta velocità totale
        - deltaV1: delta velocità prima tangenza
        - deltaV2: delta velocità seconda tangenza
        - orbTrasf: [6x1], parametri orbita di trasferimento
        - deltaT: calcolo delta tempo (orbita iniziale+orbita di trasferimento)
        - thetaMan: theta di prima manovra
        
%}



aIniz = orbIniz(1);
eIniz = orbIniz(2);
iIniz = orbIniz(3);
RAANIniz = orbIniz(4);
omegaIniz = orbIniz(5);
thetaIniz = orbIniz(6);

aFin = orbFin(1);
eFin = orbFin(2);
iFin = orbFin(3);
RAANFin = orbFin(4);
omegaFin = orbFin(5);

mu = 398600;

rAIniz = aIniz*(1+eIniz);
rPIniz = aIniz*(1-eIniz);
rAFin = aFin*(1+eFin);
rPFin = aFin*(1-eFin);

switch lower(type)
    case 'pa'                                            % caso da pericentro orbita 1 a apocentro orbita 2
        if omegaFin ~= omegaIniz
            error('Trasferimento impossibile')
        end
        thetaMan = 0;
        [deltaT1] = tempoVolo(orbIniz, thetaIniz, thetaMan); % calcolo tempo su orbita 1 da theta a theta di manovra
        
        aTrasf = (rPIniz + rAFin)/2;
        eTrasf = abs(rPIniz-rAFin)/(rPIniz+rAFin);
        deltaV1 = sqrt(2*mu*((1/rPIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rPIniz)-(1/(2*aIniz))));
        deltaV2 = sqrt(2*mu*((1/rAFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rAFin)-(1/(2*aTrasf))));
        deltaV = abs(deltaV1)+abs(deltaV2);
        
        thetaFin = 180;
        
        orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaFin, thetaFin]';
        perTrasf = 2*pi*sqrt(aTrasf^3/mu); % calcolo periodo di trasferimento
        [deltaT2] = perTrasf/2;            % calcolo tempo trasferimento
        
case 'ap'                                  % caso da apocentro orbita 1 a pericentro orbita 2
        if omegaFin ~= omegaIniz
            error('Trasferimento impossibile')
        end
        thetaMan = 180;
        [deltaT1] = tempoVolo(orbIniz, thetaIniz, thetaMan);
        
        aTrasf = (rAIniz + rPFin)/2;
        eTrasf = abs(rAIniz-rPFin)/(rAIniz+rPFin);
        deltaV1 = sqrt(2*mu*((1/rAIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rAIniz)-(1/(2*aIniz))));
        deltaV2 = sqrt(2*mu*((1/rPFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rPFin)-(1/(2*aTrasf))));
        deltaV = abs(deltaV1)+abs(deltaV2);
        
        thetaFin = 0;
        orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaFin, thetaFin]';
                                                            
        perTrasf = 2*pi*sqrt(aTrasf^3/mu);                   % calcolo periodo di trasferimento
        [deltaT2] = perTrasf/2;                              % calcolo tempo trasferimento
case 'aa'                                                    % caso da apocentro orbita 1 a apocentro orbita 2   (quindi omega swappato di 180)
        if omegaFin == omegaIniz
            error('Trasferimento impossibile')
        end
        thetaMan = 180;
        [deltaT1] = tempoVolo(orbIniz, thetaIniz, thetaMan); % calcolo tempo su orbita 1 da theta a theta di manovra
  
        aTrasf = (rAIniz + rAFin)/2;
        eTrasf = abs(rAIniz-rAFin)/(rAIniz+rAFin);
        deltaV1 = abs(sqrt(2*mu*((1/rAIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rAIniz)-(1/(2*aIniz)))));
        deltaV2 = abs(sqrt(2*mu*((1/rAFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rAFin)-(1/(2*aTrasf)))));
        deltaV = abs(deltaV1)+abs(deltaV2);
        
        if rAIniz<rAFin
            omegaTrasf = omegaFin;
        else
            omegaTrasf = omegaIniz;
        end
        
        thetaFin = 180;
        orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaTrasf, thetaFin]';
                                                            
        perTrasf = 2*pi*sqrt(aTrasf^3/mu);                   % calcolo periodo di trasferimento
        [deltaT2] = perTrasf/2;                              % calcolo tempo trasferimento
        
    case 'pp'                                            % caso da pericentro orbita 1 a pericentro orbita 2     (quindi omega swappato di 180)
        if omegaFin == omegaIniz
            error('Trasferimento impossibile')
        end
         thetaMan = 0;
        [deltaT1] = tempoVolo(orbIniz, thetaIniz, thetaMan); % calcolo tempo su orbita 1 da theta a theta di manovra

        aTrasf = (rPIniz + rPFin)/2;
        eTrasf = abs(rPIniz-rPFin)/(rPIniz+rPFin);
        deltaV1 = sqrt(2*mu*((1/rPIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rPIniz)-(1/(2*aIniz))));
        deltaV2 = sqrt(2*mu*((1/rPFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rPFin)-(1/(2*aTrasf))));
        deltaV = abs(deltaV1)+abs(deltaV2);
        
        if rPIniz<rPFin
            omegaTrasf = omegaIniz;
        else
            omegaTrasf = omegaFin;          
        end
        
        thetaFin = 0;
        orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaTrasf, thetaFin]';
                                                            
        perTrasf = 2*pi*sqrt(aTrasf^3/mu);                   % calcolo periodo di trasferimento
        [deltaT2] = perTrasf/2;                              % calcolo tempo trasferimento
        
end
deltaT = deltaT1 + deltaT2;



