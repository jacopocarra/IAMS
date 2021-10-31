function [orbTrasf, deltaV1, deltaV2, deltaT] = trasfDir(orbIniz,orbFin)
%TRASFDIR calcola la manovra di trasferimento diretto fra due punti dati
%
%   Input
%       orbIniz: orbita di partenza
%       orbFin: orbita di arrivo
%   Output    
%       orbTrasf: orbita di trasferimento
%       deltaV1: deltaV di inserizione nell'orbita di trasferimento
%       deltaV2: deltaV di inserizione nell'orbita obiettivo
%       deltaT: tempo di volo nell'orbita di trasferimento
%

%% recall dati

mu = 398600;
Rt = 6471;   %raggio della Terra in kilometri + 100km di atmosfera
toll = 1e-3;  %tolleranza nel calcolo delle orbite

%% calcolo piano dell'orbita
 


[r1Vett, ~] = PFtoGE(orbIniz, mu);
[r2Vett, ~] = PFtoGE(orbFin, mu); %calcolo i vettori raggio delle due orbite

r1 = norm(r1Vett);
r2 = norm(r2Vett); 

hT = cross(r1Vett, r2Vett);  
hT = hT / norm(hT);  %versore h dell'orbita di trasferimento

iT = acosd(hT(3)); %inclinazione dell'orbita

nT = cross([0 0 1]', hT); 
nT = nT / norm(nT);   %versore linea dei nodi 

RAANT = acosd(nT(1)); 

if nT(2) < 0
    RAANT = 360 - RAANT; 
end  % ascensione retta del nodo ascendent

    

%% calcolo effettivo

step = 0.5; %step angolare nel calcolo di omega

orbTrasf = zeros(1, 6); 
deltaVOpt = realmax; 

intersection = false; %serve per sapere se interseco la terra

for i = (0:step:360)  %controllo tutti gli omega
    
    omegaT = i; 
    
    R = RotPF2GE(iT, RAANT, omegaT);   %matrice di rotazione da PF a GE
      
    eTvett = [1 0 0]';     %versore eccentricità nel sistema di riferimento perifocale
    
    
    eTGEvett = R*eTvett;   %versore eccentricità nello spazio GE

    
    cosTheta1 = (eTGEvett' * r1Vett)/(norm(eTGEvett) * r1);     
    thetaT1 = acosd(cosTheta1); 
    
    h1 = cross(eTGEvett, r1Vett); 
    h1 = h1/norm(h1);  %versore normale al piano dell'orbita, mi serve per disambiguare il coseno
    
    if norm(h1-hT) > norm(h1 + hT)  %se il versore risultante è più vicino al versore -h -> mi trovo nel 3/4  quadrante
        thetaT1 = 360 - thetaT1; 
    end
    
    
    
    cosTheta2 = (eTGEvett' * r2Vett)/(norm(eTGEvett) * r2);     
    thetaT2 = acosd(cosTheta2);   %calcolo l'angolo theta 2 (fine manovra di trasferimento)
    
    h2 = cross(eTGEvett, r2Vett); 
    h2 = h2/norm(h2);  %versore normale al piano dell'orbita, mi serve per disambiguare il coseno
    
    if norm(h2-hT) > norm(h2 + hT)  %se il versore risultante è più vicino al versore -h -> mi trovo nel 3/4  quadrante
        thetaT2 = 360 - thetaT2; 
    end
    
    if r1*cosTheta1 ~= r2*cosTheta2
        
        eT = (r2 - r1) / ( r1*cosTheta1 - r2*cosTheta2);   
        
        if eT < 1  %lavoro solo con orbite chiuse (DA SISTEMARE!!!  orbit3D e calcoloTempi non funzionano con orbite aperte)
        
            if eT<0  %giro l'orbita
                omegaT = wrapTo360(180 + omegaT);
                eT = -eT; 
            end
    
            p = r1*(1 + eT*cosTheta1); %semilato retto

            aT = p / (1 - eT^2); %calcolo semiasse maggiore
            
            orbTrasfIniz = [aT, eT, iT, RAANT, omegaT, thetaT1];
            orbTrasfFin = [aT, eT, iT, RAANT, omegaT, thetaT2];

            [~, vIniz] = PFtoGE(orbIniz, mu); 
            [~, vTIniz] = PFtoGE(orbTrasfIniz, mu); 

            [~,vTFin] = PFtoGE(orbTrasfFin, mu); 
            [~,vFin] = PFtoGE(orbFin, mu); 
            %calcolo le velocità in ogni punto

            dVIniz = norm(vIniz - vTIniz); 
            dVFin = norm(vTFin - vFin); 

            deltaV = dVIniz + dVFin;   %deltaV della manovra


            rP = p/(1 + eT);  %raggio pericentro

            if rP <= Rt  %rischio intersezione fra orbita e Terra

                rVett = p./(1 + eT.*cosd(linspace(thetaT1, thetaT2, 100))); %calcolo la distanza del satellite nell'arco percorso  

                if min(rVett) <= Rt
                    intersection = true;   %mi schianto
                end
            end


            if (intersection == false) && (deltaV < deltaVOpt) %se non mi schianto e il deltaV è conveniente salvo l'orbita
                
                [r1Vtest, ~] = PFtoGE(orbTrasfIniz, mu);
                [r2Vtest, ~] = PFtoGE(orbTrasfFin, mu); 
                
                if (norm(r1Vtest - r1Vett)/r1 < toll) && (norm(r2Vtest - r2Vett)/r2 < toll)  
                    
                    deltaVOpt = deltaV; 
                    orbTrasf = orbTrasfFin; %allineato con la fine della manovra
                    deltaV1 = dVIniz; 
                    deltaV2 = dVFin;
                    deltaT = tempoVolo(orbTrasf, thetaT1, thetaT2); 
                else
                    warning('Errore di calcolo'); 
                end
            end
        end
   end
    
     
    
end

%% controllo finale di fattibilità

if orbTrasf(1) == 0
    warning('trasferimento diretto impossibile'); 
    deltaV1 = 0; 
    deltaV2 = 0; 
    deltaT = 0; 
end

end

