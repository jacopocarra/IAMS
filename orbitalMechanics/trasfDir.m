function [orbTrasf, deltaV1, deltaV2, deltaT, thetaPlot1, thetaPlot2] = trasfDir(orbIniz,orbFin)
%TRASFDIR calcola la manovra di trasferimento diretto fra due punti dati
%   [orbTrasf, deltaV1, deltaV2, deltaT, thetaPlot1, thetaPlot2] = trasfDir(orbIniz,orbFin)
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
%
%   NOTA: se orbIniz e orbFin puntano allo stesso punto, viene calcolato un
%   trasferimento a singolo impulso tra le due orbite quindi non ci sarà
%   nesssuna orbita di trasferimento e l'unico paramentro di interesse sarà
%   deltaV1


%  SPIEGAZIONE PER EVITARE INCOMPRENSIONI:
%  Se nel for dove cambiamo tutti gli omega viene un eccentricità negativa,
%  allora il vettore eccentricità punta all'apocentro e l'angolo omega
%  sarebbe calcolato tra il nodo ascendente e
%  l'apocentro. Per questo non va bene con le nostre definizioni di
%  parametri orbitali. Quindi abbiamo visto che mettendo l'eccentricità
%  positiva e aumentando omeghino e theta di 180°, troviamo la stessa
%  orbita ma con l'anomalia di pericentro corretta, calcolata tra il nodo
%  ascendente e il pericentro. Facendo così però troviamo le orbite (e i
%  deltaV) uguali a quelli che troviamo quando abbiamo gli omeghini>200°.
%  Quindi sarebbe come contare le orbite due volte. Per questo motivo nel
%  report abbiamo colorato l'area di blu. Ci sono poi delle orbite per cui
%  esse sono aperte, e quindi e>1.





%% recall dati

%  orbit3D(orbIniz,1);
%  orbit3D(orbFin, 1);
%  earth3D(1); 
%   eVect = [];
%   omegaVect = [];
%   deltaVvect = [];
%   omegaSC = []; %schianto
%   omegaAP = []; %aperto
%   omegaOK = []; 
 
mu = 398600;
Rt = 6471;   %raggio della Terra in kilometri + 100km di atmosfera
toll = 1e-2; 

%% calcolo piano dell'orbita
orbTrasf = zeros(6, 1); 

I = [1 0 0]';
J = [0 1 0]';
K = [0 0 1]';


[r1Vett, vIniz] = PFtoGE(orbIniz, mu);
[r2Vett, vFin] = PFtoGE(orbFin, mu); %calcolo i vettori raggio delle due orbite


r1 = norm(r1Vett);
r2 = norm(r2Vett); 



if (abs(r1 - r2) < toll)  && (norm(r1Vett - r2Vett)/r1 < toll)  %se i punti di partenza e di arrivo sono coincidenti
    deltaV1 = norm(vFin - vIniz); %calcolo il deltaV come se fosse una manovra a impulso singolo
    deltaT = 0; 
    deltaV2 = 0; 
    thetaPlot1 = orbIniz(6); 
    thetaPlot2 = orbFin(6); 
    %non calcolo nessuna orbita dato che di fatto passa subito a quella
    %finale
    return; 
end


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

step = 1; %step angolare nel calcolo di omega


deltaVOpt = realmax; 


for i = (0:step:359)  %controllo tutti gli omega
    intersection = false; %serve per sapere se interseco la terra

    omegaT = i; 
    
    %omegaVect = [omegaVect ; i]; %aggiorno vettore degli omega
    
    R = RotPF2GE(iT, RAANT, omegaT);   %matrice di rotazione da PF a GE
      
    eTvett = I;     %versore eccentricità nel sistema di riferimento perifocale
    
    
    eTGEvett = R*eTvett;   %versore eccentricità nello spazio GE

    
    cosTheta1 = (dot(r1Vett, eTGEvett))/(norm(eTGEvett) * r1);     
    
   
    cosTheta2 = (dot(r2Vett,eTGEvett))/(norm(eTGEvett) * r2);     
   
   
    if r1*cosTheta1 ~= r2*cosTheta2
        eT = (r2 - r1) / ( r1*cosTheta1 - r2*cosTheta2);
        
        %eVect = [eVect; eT]; %salvo tutte le eT provate
        
        if (eT < 0) %se eccentricità negativa significa che il versore eTGEvett ha verso sbagliato ->  anche i coseni hanno segno sbagliato
            cosTheta1 = -cosTheta1; 
            cosTheta2 = -cosTheta2; 
            eTGEvett = -eTGEvett; 
            eT = -eT;
            omegaT = wrapTo360(omegaT + 180); 
        end
        
        thetaT1 = acosd(cosTheta1); 
        h1 = cross(eTGEvett, r1Vett); 

        if dot(hT,h1) < 0  %se il versore risultante è più vicino al versore -h -> mi trovo nel 3/4  quadrante
            thetaT1 = 360 - thetaT1; 
        end
        
        thetaT2 = acosd(cosTheta2);   %calcolo l'angolo theta 2 (fine manovra di trasferimento)
        h2 = cross(eTGEvett, r2Vett); 

        if dot(hT,h2) < 0  %se il versore risultante è più vicino al versore -h -> mi trovo nel 3/4  quadrante
            thetaT2 = 360 - thetaT2; 
        end
        
        
        
        if abs(eT) < 1  %lavoro solo con orbite chiuse (DA SISTEMARE!!!  orbit3D e calcoloTempi non funzionano con orbite aperte)
            

            
            p = r1*(1 + eT*cosTheta1); %semilato retto

            aT = p / (1 - eT^2); %calcolo semiasse maggiore
            

            orbTrasfIniz = [aT, eT, iT, RAANT, omegaT, thetaT1];
            orbTrasfFin = [aT, eT, iT, RAANT, omegaT, thetaT2];
    
            [~, vTIniz] = PFtoGE(orbTrasfIniz, mu); 
            
            
            [~,vTFin] = PFtoGE(orbTrasfFin, mu); 
            
            %calcolo le velocità in ogni punto

            dVIniz = norm(vIniz - vTIniz); 
            dVFin = norm(vTFin - vFin); 

            deltaV = dVIniz + dVFin;   %deltaV della manovra
            

            rP = p/(1 + abs(eT));  %raggio pericentro
            
%             orbit3D(orbTrasfIniz,1); 
%             quiver3(0,0,0,eTGEvett(1), eTGEvett(2), eTGEvett(3), 15000, '-.'); 
%             orbVect = [orbVect,  orbTrasfIniz']; 
   
            if rP <= Rt  %rischio intersezione fra orbita e Terra

                rVett = p./(1 + eT.*cosd(linspace(thetaT1, thetaT2, 100))); %calcolo la distanza del satellite nell'arco percorso  

                if min(rVett) <= Rt
                    intersection = true;   %mi schianto
                    
                end

            end
            
           
%             if ~intersection
%                 omegaOK = [omegaOK; omegaT]; 
%                 deltaVvect = [deltaVvect; deltaV];  %deltaV accettabili
%             end
            

            if (intersection == false) && deltaV < deltaVOpt %se non mi schianto e il deltaV è conveniente salvo l'orbita

                thetaPlot1 = thetaT1;
                thetaPlot2 = thetaT2;
                deltaVOpt = deltaV; 
                orbTrasf = orbTrasfFin'; %allineato con la fine della manovra
                deltaV1 = dVIniz; 
                deltaV2 = dVFin;
                deltaT = tempoVolo(orbTrasf, thetaT1, thetaT2);
                 
                
            end
%         else            
%            omegaAP = [omegaAP; omegaT]; %salvo gli omega che generano orbite aperte
        end
   end
    
     
    
end

%SE e1=-e2, vuol dire stessa orbita ma con theta1 = =theta2+180 e
%omega1=omega2+180
% il vettore eccentricità va ruotato!
% E' TUTTO CORRETTO, CONFERMATO MILLE VOLTE DA RICCARDO E TOMMASO.
% JACOPO NON AVERE DUBBI IDIOTI

% I DELTAV SONO UGUALI PER OMEGA SFASATI DI 180 GRADI PERCHE' E' LA STESSA
% ORBITA



%% controllo finale di fattibilità

if orbTrasf(1) == 0
    warning('trasferimento diretto impossibile'); 
    deltaV1 = 0; 
    deltaV2 = 0; 
    deltaT = 0; 
end


%   figure(3)
%   h(1) = plot(omegaOK(1:158), deltaVvect(1:158),'Color', [0, 0.4470, 0.7410]);
%   hold on
%   
%   h(2) = plot(omegaOK(159:end), deltaVvect(159:end), 'Color', [0, 0.4470, 0.7410]);
%   h(3) = area([omegaVect(22)-1, omegaVect(201)], [max(deltaVvect), max(deltaVvect)], 18, 'FaceColor', [0 0.4470 0.7410])  %orbite inesistenti
%   h(4) = area([omegaAP(1)-1, omegaAP(11)], [max(deltaVvect), max(deltaVvect)], 18, 'FaceColor', [0.6350 0.0780 0.1840]) %orbite aperte
%   h(5) = area([omegaAP(12)-1, omegaAP(23)+1], [max(deltaVvect), max(deltaVvect)], 18, 'FaceColor', [0.6350 0.0780 0.1840])
%   %[minimo, imin] = min(deltaVvect)
% 
%   h(6) = plot(orbTrasf(5),deltaVOpt, 'd', 'MarkerSize', 8, 'MarkerFaceColor', 'g') 
%   grid on
%   legend(h([1, 3, 4, 6]),'deltaV vs Omega', 'Does not exists', 'Open orbits', 'deltaV min'); 
%   xlabel('Omega (°)'); 
%   ylabel('DeltaV (km/s)'); 
%   
  

end

