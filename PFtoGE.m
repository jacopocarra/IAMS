function [pos, v] = PFtoGE(a, e, i, RAAN, omega, theta, mu)
%PFtoGE converte delle coordinate dal sistema di riferimento perifocale al
%sistema geocentrico NB ANGOLI IN DEG
%[pos, v] = GEtoPF(a, e, i, RAAN, omega, theta, mu)
%
%   INPUT: 
%       a: semiasse maggiore [km]
%       e: eccentricità
%       i: inclinazione (deg)
%       RAAN: ascensione retta del nodo ascendente (deg)
%       omega: anomalia di pericentro (deg)
%       theta: anomalia reale (deg)
%       mu: costante gravitazionale [km^3/s^2]
%   OUTPUT: 
%       pos: vettore [1x3] posizione iniziale [km]
%       v: vettore [1x3] velocità iniziale [km/s]

    RRAAN = [cosd(RAAN) sind(RAAN) 0  
            -sind(RAAN) cosd(RAAN) 0   
            0 0 1 ];
    
    Ri = [1 0 0
          0 cosd(i) sind(i)
          0 -sind(i) cosd(i)];


    Romega = [cosd(omega) sind(omega) 0
              -sind(omega) cosd(omega) 0
              0 0 1];

    R = (Romega*Ri*RRAAN)';
    %R -> matrice di rotazione totale per passare da GE a PF, ma è una
    %matrice ortogonale, quindi la trasposta è anche l'inversa -> si
    %ottiene direttamente la matrice di rotazione per passare da PF a GE

    p = a*(1-e^2);
    
    vPF = sqrt(mu/p)*[-sind(theta), e+cosd(theta) , 0]';                %velocità nel SdR PF (versori: [e, p, h])
    posPF = (p/(1 + e*cosd(theta))) * [cosd(theta), sind(theta), 0]';   %posizione nel SdR PF (versori: [e, p, h])
    
    v = R*vPF;
    pos = R*posPF;

end

