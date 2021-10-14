function [pos, v] = PFtoGE(a, e, i, RAAN, omega, theta, mu)
%GEtoPF converte delle coordinate dal sistema di riferimento perifocale al
%sistema geocentrico NB ANGOLI IN DEG
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

RRAAN=[cosd(RAAN) sind(RAAN) 0
        -sind(RAAN) cosd(RAAN) 0   
          0 0 1 ];
Ri=[1 0 0
    0 cosd(i) sind(i)
    0 -sind(i) cosd(i)];
Romega=[cosd(omega) sind(omega) 0
        -sind(omega) cosd(omega) 0
         0 0 1];
Rtot=(Romega*Ri*RRAAN)'; %già trasposta

p=a*(1-e^2);

vE=-sqrt(mu/p)*sind(theta);
vP=sqrt(mu/p)*(e+cosd(theta));

v=Rtot*[vE, vP, 0]';
pos=Rtot*(p/(1+e*cosd(theta)))*[cosd(theta), sind(theta), 0]';

end

