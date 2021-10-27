function [orbFin, deltaV, deltaT] = cambioInclinazione(orbIniz, iFin, RAANFin)

%[orbFin, deltaV, deltaT] = cambioInclinazione(orbIniz, iFin, RAANFin)
%
%calcola il costo di un cambio di inclinazione di un'orbita e restituisce
%l'orbita finale
%
%   INPUT
%       orbiIniz: orbita iniziale, vettore [a, e, i, RAAN, omega, theta]
%       iFin: inclinazione finale desiderata [°]
%       RAANFin: RAAN finale desiderato [°] (se non specificato verrà
%                considerato lo stesso dell'orbita iniziale
%
%   OUTPUT
%       orbFin: Orbita finale, vettore nel punto di manovra [a, e, i, RAAN, omega, theta]
%       deltaV: Costo deltaV manovra
%       deltaT: Tempo impiegato per raggiungere p.to manovra


%   27-10-2021 Riccardo Cadamuro


%% dati iniziali
    mu = 398600;

    aIniz = orbIniz(1);
    eIniz = orbIniz(2);
    iIniz = orbIniz(3);
    RAANIniz = orbIniz(4); 
    omegaIniz = orbIniz(5); 
    thetaIniz=orbIniz(6);
    
    pIniz = aIniz*(1 - eIniz^2); %semilato retto orbita iniziale, per il calcolo del deltaV
    
    if nargin == 2 %non è stato passato RAANFin
        RAANFin = RAANIniz; 
    end
    
    if iFin > 90
        warning('ATTENZIONE: orbita obiettivo retrograda'); 
    end
    
    iFin = wrapTo360(iFin); 
    RAANFin = wrapTo360(RAANFin); %mi accerto di avere valori compresi fra 0 e 360 gradi
    
    vTrasv = @(p, e, x) sqrt(mu/p) * (1 + e*cosd(x));  %calcola la velocità trasversa in un dato punto in una data orbita
    
%% aggiustamento angoli

    deltaRAAN = RAANFin - RAANIniz;  %variazione di RAAN, NON mi serve riportarla nei 360°
    
    if deltaRAAN > 180
        deltaRAAN = deltaRAAN - 360; %considero rotazione esplementare in dir opposta
    elseif deltaRAAN < -180
        deltaRAAN = 360 - deltaRAAN; %come sopra
    end
    
    deltai = iFin - iIniz; 
    
    if deltai > 180
        deltai = deltai - 360; %considero rotazione esplementare in dir opposta
    elseif deltai < -180
        deltai = 360 - deltai; %come sopra
    end
    
%% calcolo effettivo
    
    alfa = acosd( cosd(iIniz)*cosd(iFin) + sind(iIniz)*sind(iFin)*cosd(deltaRAAN) ); %calcolo l'angolo fra le due orbite alla loro intersezione
    
    if deltaRAAN == 0 %posso manovrare sul piano nodale
        
        thetaMan1 = -omegaIniz; 
        thetaMan2 = 180 + thetaMan1; %calcolo i due possibili punti di manovra
                 
    else %non manovro sulla linea dei nodi
        u1 = asind( (sind(deltaRAAN)/sind(alfa))*sind(iFin) );  %angolo che sottende tratto prima della manovra orbIniz
        u2 = asind( (sind(deltaRAAN)/sind(alfa))*sind(iIniz) );  %angolo che sottende tratto prima della manovra orbFin
        
        
        if deltaRAAN*deltai > 0 %mi accerto di scegliere il triangolo sull'emisfero corretto
            thetaMan1 = u1 - omegaIniz; %punto di manovra, sarà uguale in entrambe le orbite (vrIniz = vrFin; vTiniz = vTfin -> due punti con le stesse componenti di velocità devono trovarsi nella stessa posizione angolare)
            omegaFin = u2 - thetaMan1;  %variazione anomalia di pericentro nell'orbita obiettivo
        else
            thetaMan1 = 360 - u1 - omegaIniz;
            omegaFin = 360 - u2 - thetaMan1; %vedi sopra
        end
        
        thetaMan2 = wrapTo360(thetaMan1 + 180); %secondo punto di manovra diametralmente opposto
        
        %non serve correggere l'anomalia di pericentro nel caso di manovra
        %nel secondo punto nodale dato che l'orbita di arrivo è la stessa
        %(?)
        
    end
    
    
    
    vT1 = vTrasv(pIniz, eIniz, thetaMan1); 
    vT2 = vTrasv(pIniz, eIniz, thetaMan2);   %calcolo la velocità trasversa nei due punti nodali
    
    %devo decidere in quale punto manovrare
    if vT1<vT2
        thetaMan = thetaMan1; 
    elseif vT2<vT1
        thetaMan = thetaMan2; %do la priorità al trasferimento meno costoso in termini di velocità
    else %vT2 == vT1
        %in questo caso scelgo il trasferimento meno costoso in termini
        %di tempo

        if thetaIniz > thetaMan1 && thetaIniz <= thetaMan2
            thetaMan = thetaMan2; 
        else
            thetaMan = thetaMan1; 
        end
    end
    
    
    
    vT = vTrasv(pIniz, eIniz, thetaMan); %velocità traversa nel punto di manovra
    
    deltaV = 2 * vT * sind(alfa/2); %calcolo deltaV
    deltaT = tempoVolo(orbIniz, thetaIniz ,thetaMan);%calcolo deltaT per raggiungere punto di manovra

%% output
    
    orbFin = orbIniz;
    orbFin(3) = iFin; 
    orbFin(4) = RAANFin;
    orbFin(5) = wrapTo360(omegaFin); 
    orbFin(6) = wrapTo360(thetaMan);  
    

end