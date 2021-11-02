function [orbTrasf, deltaV1, deltaV2, deltaT, thetaPlot1, thetaPlot2] = trasfDir(orbIniz,orbFin)
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
%       thetaPlot1: theta di inizio orbita trasferimento
%       thetaPlot2: theta di arrivo orbita di trasferimento

%% recall dati
orbit3D(orbIniz,1);
orbit3D(orbFin, 1)
earth3D(1); 
eVect = [];
omegaVect = [];
deltaVvect = [];
mu = 398600;
Rt = 6471;   %raggio della Terra in kilometri + 100km di atmosfera
toll = 1e-3;  %tolleranza nel calcolo delle orbite

%% calcolo piano dell'orbita
 
I = [1 0 0]';
J = [0 1 0]';
K = [0 0 1]';


[r1Vett, ~] = PFtoGE(orbIniz, mu);
[r2Vett, ~] = PFtoGE(orbFin, mu); %calcolo i vettori raggio delle due orbite

r1 = norm(r1Vett);
r2 = norm(r2Vett); 

hT = cross(r1Vett, r2Vett);  
hT = hT / norm(hT);  %versore h dell'orbita di trasferimento

iT = acosd(dot(K, hT)); %inclinazione dell'orbita

nT = cross(K, hT); 
nT = nT / norm(nT);   %versore linea dei nodi 

RAANT = acosd(nT(1)); 

if nT(2) < 0
    RAANT = 360 - RAANT; 
end  % ascensione retta del nodo ascendent

    

%% calcolo effettivo

step = 0.5; %step angolare nel calcolo di omega

orbTrasf = zeros(1, 6); 
deltaVOpt = realmax; 


for i = (0:step:360)  %controllo tutti gli omega
    intersection = false; %serve per sapere se interseco la terra

    omegaT = i; 
    
    R = RotPF2GE(iT, RAANT, omegaT);   %matrice di rotazione da PF a GE
      
    eTvett = I;     %versore eccentricità nel sistema di riferimento perifocale
    
    
    eTGEvett = R*eTvett;   %versore eccentricità nello spazio GE

    
    cosTheta1 = (dot(r1Vett, eTGEvett))/(norm(eTGEvett) * r1);     
    thetaT1 = acosd(cosTheta1); 
      h1 = cross(eTGEvett, r1Vett); 

    if dot(hT,h1) < 0  %se il versore risultante è più vicino al versore -h -> mi trovo nel 3/4  quadrante
        thetaT1 = 360 - thetaT1; 
    end
   
    cosTheta2 = (dot(r2Vett,eTGEvett))/(norm(eTGEvett) * r2);     
    thetaT2 = acosd(cosTheta2);   %calcolo l'angolo theta 2 (fine manovra di trasferimento)
    h2 = cross(eTGEvett, r2Vett); 

    if dot(hT,h2) < 0  %se il versore risultante è più vicino al versore -h -> mi trovo nel 3/4  quadrante
        thetaT2 = 360 - thetaT2; 
    end
    
    
    if r1*cosTheta1 ~= r2*cosTheta2
        eT = (r2 - r1) / ( r1*cosTheta1 - r2*cosTheta2);

        if abs(eT) > 0  %lavoro solo con orbite chiuse (DA SISTEMARE!!!  orbit3D e calcoloTempi non funzionano con orbite aperte)
        
            p = r1*(1 + eT*cosTheta1); %semilato retto

            aT = p / (1 - eT^2); %calcolo semiasse maggiore
            [~, vIniz] = PFtoGE(orbIniz, mu);    
            [~,vFin] = PFtoGE(orbFin, mu); 
            

            orbTrasfIniz = [aT, eT, iT, RAANT, omegaT, thetaT1];
            orbTrasfFin = [aT, eT, iT, RAANT, omegaT, thetaT2];

            [~, vTIniz] = PFtoGE(orbTrasfIniz, mu); 
            
            
            [~,vTFin] = PFtoGE(orbTrasfFin, mu); 
            
            %calcolo le velocità in ogni punto

            dVIniz = norm(vIniz - vTIniz); 
            dVFin = norm(vTFin - vFin); 

            deltaV = dVIniz + dVFin;   %deltaV della manovra
            

            rP = p/(1 + abs(eT));  %raggio pericentro

            if rP <= Rt  %rischio intersezione fra orbita e Terra

                rVett = p./(1 + eT.*cosd(linspace(thetaT1, thetaT2, 100))); %calcolo la distanza del satellite nell'arco percorso  

                if min(rVett) <= Rt
                    intersection = true;   %mi schianto
                end

            end
               
               % per immagine da report levare la seconda condizione
               % dell'if (deltaV<deltaVOpt)
            if (intersection == false) && deltaV < deltaVOpt %se non mi schianto e il deltaV è conveniente salvo l'orbita
                [r1Vtest, ~] = PFtoGE(orbTrasfIniz, mu);
                [r2Vtest, ~] = PFtoGE(orbTrasfFin, mu); 
                omegaVect = [omegaVect, omegaT];
                deltaVvect = [deltaVvect, deltaV];
                eVect = [eVect, eT];
                % orbit3D(orbTrasfIniz, 1);      % plottare

                
                if (norm(r1Vtest - r1Vett)/r1 < toll) && (norm(r2Vtest - r2Vett)/r2 < toll)  
                    thetaPlot1 = thetaT1;
                    thetaPlot2 = thetaT2;
                    deltaVOpt = deltaV; 
                    orbTrasf = orbTrasfFin'; %allineato con la fine della manovra
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

%SE e1=-e2, vuol dire stessa orbita ma con theta1 = =theta2+180 e
%omega1=omega2+180
% E' TUTTO CORRETTO, CONFERMATO MILLE VOLTE DA RICCARDO E TOMMASO.
% JACOPO NON AVERE DUBBI IDIOTI

% I DELTAV SONO UGUALI PER OMEGA SFASATI DI 180 GRADI PERCHE' E' LA STESSA
% ORBITA
orbit3D(orbTrasf,1);
if orbTrasf(2) < 0 
    orbTrasf(2) = -orbTrasf(2);
    orbTrasf(5) = wrapTo360(180+orbTrasf(5));
    orbTrasf(6) = wrapTo360(180+orbTrasf(6));
end
orbit3D(orbTrasf,1);

rp = orbTrasf(1)*(1-orbTrasf(2))
%% controllo finale di fattibilità

if orbTrasf(1) == 0
    warning('trasferimento diretto impossibile'); 
    deltaV1 = 0; 
    deltaV2 = 0; 
    deltaT = 0; 
end

figure(2)
plot(omegaVect, deltaVvect);
[minimo, imin] = min(deltaVvect)
end

