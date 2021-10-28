function [orbTrasf1,orbTrasf2, deltaVVect, deltaTVect, deltaV, deltaT] = trasfBiellittico(orbIniz, orbFin,rT)

%calcola costo 
%
%   INPUT
%       orbiIniz: Orbita iniziale, vettore
%       orbFin: orbita finale desiderato
%       rT: raggio orbita di trasferimento
%
%   OUTPUT
%       orbFin: Orbita finale, vettore nel punto di manovra
%       deltaV: Costo deltaV manovra
%       deltaT: Tempo impiegato per raggiungere p.to manovra
%
%   ESEGUE LA MANOVRA DAL PERICENTRO DELL'ORBITA INIZIALE

%% controllo

deltaOmega = wrapTo360(orbIniz(4)-orbFin(4));   %differenza di anomalia di pericentro
if (deltaOmega ~= 0 || deltaOmega~= 360 || deltaOmega ~= 180) || (orbIniz(3) ~= orbFin(3)) || (orbIniz(4) ~= orbIniz(4))  %controlla bene
    error('Orbite non allineate, eseguire una manovra di cambio anomalia al pericentro'); 
    return; 
end

%% recall dati

aIniz=orbIniz(1);
eIniz=orbIniz(2);
thetaIniz=orbIniz(6);

aFin=orbFIn(1);
eFin=orbFin(2);
mu=398600;

vP = @(p, e) sqrt(mu/p)*(1 + e);  %velocità al pericentro di una data orbita
vA = @(p, e) sqrt(mu/p)*(1 - e);  %velocità all'apocentro di una data orbita
ecc = @(rA, rP) (rP - rA)/(rP + rA); %eccentricità
p = @(a, e) a*(1-e^2);  %semilato retto

%% manovra pericentro -> rT

pIniz = aIniz*(1-eIniz^2); 
rPIniz = pIniz/(1+eIniz); 

vPIniz = vP(pIniz, eIniz);   %velocità al pericentro nell'orbita iniaizle

aT1 = (rPIniz + rT)/2;   %semiasse maggiore orbita di trasferimento 1
eT1 = (rT - rPIniz)/(rT + rPIniz);  %eccentricità trsf 1
pT1 = aT1*(1 - eT1^2); %semilato retto 

if rPIniz < rT  %mi trovo al pericentro dell'orbita di trasferimento
    vP1 =  vP(pT1, eT1);  %velocità iniziale del trasferimento 
    vA1 =  vA(pT1, eT1);  %velocità finale del trasferimento
else
    error('SVEJATE FORA! COSJON!'); 
end

deltaV1 = abs(vP1 - vPIniz);  %deltaV nel primo punto di manovra

orbTrasf1 = [aT1, eT1, orbIniz(3), orbIniz(4), orbIniz(5), 0];    %theta nel primo punto di manovra

%% caratterizzo orbita finale

pFin = aFin*(1-eFin^2); 
rPFin = pFin/(1+eFin); 
rAFin = pFin/(1-eFin); 

%% manovra rT -> orb finale



if deltaOmega == 180 %Se le due orbite sono ruotate di 180 gradi manovro dall'apocentro della prima orbita di trasferimento all'aopocentro dell'orbota finale
    
    aT2 = (rT + rAFin)/2; %semiasse orbita di trasferimento 2
    vAFin = vA(pFin, eFin); 

    
    if rT > rAFin %(orb trasf 2) Apocentro -> Pericentro 
        
        eT2 = ecc(rT, rAFin);    
        pT2 = p(aT2, eT2); 
        
        vA2 = vA(pT2, eT2);   %velocità inserzione trasferimento 2
        deltaV2 = abs(vA2 - vA1);  %deltaV trasf 2
        
        vP2 = vP(pT2, eT2); 
        
        deltaV3 = abs(vP2 - vAFin);   %frenata inserzione orbita obiettivo
        
        orbTrasf2 = [aT2, eT2, orbIniz(3), orbIniz(4), orbIniz(5), 180]; %caratterizzo orbita di trasferimento 2
        
        
    else %(orb trasf) 2 Pericentro -> Apocentro
        warning('meno efficiente di una bitangente')
        eT2 = ecc(rAFin, rT); 
        pT2 = p(aT2, eT2); 
        
        vP2 = vP(pT2, eT2); %velocità inserizione trasferimento 2
        deltaV2 = abs(vP2 - vA1);  %deltaV trasf 2
        
        
        vA2 = vA(pT2, eT2); %velocità apocentro orbita di trasferimento -> punto di incontro con orbita obiettivo 
        
        deltaV3 = abs(vAFin - vA2);  %deltaV inserzione orbita obiettivo
        
        orbTrasf2 = [aT2, eT2, orbIniz(3), orbIniz(4), orbIniz(5), 0];
                
    end
    
    
else %Se le due orbite sono allineate manovro dall'apocentro della prima orbita di trasferimento al pericentro dell'orbita finale

    
    aT2 = (rT + rPFin)/2; %semiasse orbita di trasferimento 2
    vPFin = vP(pFin, eFin); %velocità al pericentro dell'orbita finale
    
    
    if rT > rPFin %(orb trasf 2) Apocentro -> Pericentro 
        
        eT2 = ecc(rT, rAFin);    
        pT2 = p(aT2, eT2); 
        
        vA2 = vA(pT2, eT2);   %velocità inserzione trasferimento 2
        deltaV2 = abs(vA2 - vA1);  %deltaV trasf 2
        
        vP2 = vP(pT2, eT2); 
        
        deltaV3 = abs(vP2 - vPFin);   %frenata inserzione orbita obiettivo
        
        orbTrasf2 = [aT2, eT2, orbIniz(3), orbIniz(4), orbIniz(5), 180]; %caratterizzo orbita di trasferimento 2
        
        
    else %(orb trasf) 2 Pericentro -> Apocentro
        warning('meno efficiente di una bitangente')
        eT2 = ecc(rAFin, rT); 
        pT2 = p(aT2, eT2); 
        
        vP2 = vP(pT2, eT2); %velocità inserizione trasferimento 2
        deltaV2 = abs(vP2 - vA1);  %deltaV trasf 2
        
        
        vA2 = vA(pT2, eT2); %velocità apocentro orbita di trasferimento -> punto di incontro con orbita obiettivo 
        
        deltaV3 = abs(vPFin - vA2);  %deltaV inserzione orbita obiettivo
        
        orbTrasf2 = [aT2, eT2, orbIniz(3), orbIniz(4), orbIniz(5), 0];
                
    end
    
 deltat1 = tempoVolo(orbIniz,thetaIniz, 0);    % t per raggiungere pericentro orbita iniziale
 deltat2 = 0.5* sqrt(aT1^3/mu);                 % metà orbita di trasf 1
 deltat3 = 0.5* sqrt(aT2^3/mu);                 % metà orbita di trasf 2
 deltaTVect = [deltat1; deltat2;deltat3];
 deltaT= deltat1 + deltat2 + deltat3;
    
 deltaVVect = [deltaV1; deltaV2; deltaV3];
 deltaV = deltaV1 + deltaV2 + deltaV3;
    
end


end