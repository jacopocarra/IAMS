%{

Calcola i paramentri di un'orbita di trasferimento diretta data l'anomalia
al pericentro (i)

%}


config; 
%%

i = 150;


%% recall dati

 orbit3D(orbIniz,1);
 orbit3D(orbFin, 1);
 earth3D(1); 

 
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


intersection = false; %serve per sapere se interseco la terra

omegaT = i; 


R = RotPF2GE(iT, RAANT, omegaT);   %matrice di rotazione da PF a GE

eTvett = I;     %versore eccentricità nel sistema di riferimento perifocale


eTGEvett = R*eTvett;   %versore eccentricità nello spazio GE


cosTheta1 = (dot(r1Vett, eTGEvett))/(norm(eTGEvett) * r1);     


cosTheta2 = (dot(r2Vett,eTGEvett))/(norm(eTGEvett) * r2);     


if r1*cosTheta1 ~= r2*cosTheta2
    eT = (r2 - r1) / ( r1*cosTheta1 - r2*cosTheta2);


    %commentare questo if per immagini report
    if (eT < 0) %se eccentricità negativa significa che il versore eTGEvett ha verso sbagliato ->  anche i coseni hanno segno sbagliato
        cosTheta1 = -cosTheta1; 
        cosTheta2 = -cosTheta2; 
        eTGEvett = -eTGEvett; 
        eT = -eT;
        %omegaT = wrapTo360(omegaT + 180); 
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



    %if abs(eT) < 1  %lavoro solo con orbite chiuse (DA SISTEMARE!!!  orbit3D e calcoloTempi non funzionano con orbite aperte)



        p = r1*(1 + eT*cosTheta1); %semilato retto

        aT = p / (1 - eT^2); %calcolo semiasse maggiore


        orbTrasfIniz = [aT, eT, iT, RAANT, omegaT, thetaT1];
        orbTrasfFin = [aT, eT, iT, RAANT, omegaT, thetaT2];




        %orbit3D(orbTrasfFin, 1); 

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


                %orbit3D(orbTrasfFin, 1); 

            end

        end         
    %end
end


    
%SE e1=-e2, vuol dire stessa orbita ma con theta1 = =theta2+180 e
%omega1=omega2+180
% il vettore eccentricità va ruotato!
% E' TUTTO CORRETTO, CONFERMATO MILLE VOLTE DA RICCARDO E TOMMASO.
% JACOPO NON AVERE DUBBI IDIOTI

% I DELTAV SONO UGUALI PER OMEGA SFASATI DI 180 GRADI PERCHE' E' LA STESSA
% ORBITA

%%

orbit3D(orbTrasfFin,1); 
