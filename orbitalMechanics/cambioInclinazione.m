function [orbFin, deltaV, deltaT, thetaMan] = cambioInclinazione(orbIniz, iFin, RAANFin)

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
%       thetaMan: punto di manovra nell'orbita di partenza





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


    deltaRAAN = wrapTo180(RAANFin - RAANIniz);  
     
    
    
%% calcolo effettivo
    
    if ( (iIniz == 0 || iIniz == 360 || iFin == 0 || iFin == 360) && deltaRAAN ~= 0 ) 
        error('MANOVRA IMPOSSIBILE: impossibile raggiungere inclinazione 0° manovrando fuori dal piano nodale'); 
    end


    alfa = acosd( cosd(iIniz)*cosd(iFin) + sind(iIniz)*sind(iFin)*cosd(deltaRAAN) ); %calcolo l'angolo fra le due orbite alla loro intersezione
    
    if deltaRAAN == 0 %posso manovrare sul piano nodale
        
        thetaMan1 = wrapTo360(-omegaIniz); 
        thetaMan2 = wrapTo360(180 + thetaMan1); %calcolo i due possibili punti di manovra
        omegaFin = omegaIniz; 
        
    else %non manovro sulla linea dei nodi
        sinU1 = (sind(deltaRAAN)/sind(alfa))*sind(iFin);  %angolo che sottende tratto prima della manovra orbIniz
        cosU1 = (cosd(alfa)*cosd(iIniz) - cosd(iFin))/( sind(alfa)*sind(iIniz) );
        
        sinU2 = (sind(deltaRAAN)/sind(alfa))*sind(iIniz) ;  %angolo che sottende tratto prima della manovra orbFin
        cosU2 = ( cosd(iIniz) - cosd(alfa)*cosd(iFin) )/( sind(alfa)*sind(iFin) ); 
       
        u1 = wrapTo360(atan2d(sinU1, cosU1)); 
        u2 = wrapTo360(atan2d(sinU2, cosU2)); 
        
        thetaMan1 = u1 - omegaIniz; %punto di manovra, sarà uguale in entrambe le orbite (vrIniz = vrFin; vTiniz = vTfin -> due punti con le stesse componenti di velocità devono trovarsi nella stessa posizione angolare)
        omegaFin = u2 - thetaMan1;  %variazione anomalia di pericentro nell'orbita obiettivo
        

        thetaMan1 = wrapTo360(thetaMan1); 
        thetaMan2 = wrapTo360(thetaMan1 + 180); %secondo punto di manovra diametralmente opposto
        
        %non serve correggere l'anomalia di pericentro nel caso di manovra
        %nel secondo punto nodale dato che l'orbita di arrivo è la stessa
        
    end
    
    
    %seleziono il punto di manovra più vicino al punto in cui ci si trova,
    %non faccio nessun controllo sul deltaV
    
    if thetaIniz > thetaMan1 && thetaIniz <= thetaMan2
        thetaMan = thetaMan2; 
    else
        thetaMan = thetaMan1; 
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
    
    thetaMan = orbFin(6); 

end