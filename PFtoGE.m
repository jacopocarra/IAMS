function [pos, v] = PFtoGE(a, e, i, RAAN, omega, theta)
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
%       mu: costante gravitazionale [km^3/s^2] (solo se diversa da quella terreste)
%   OUTPUT:
%       pos: vettore [1x3] posizione iniziale [km]
%       v: vettore [1x3] velocità iniziale [km/s]
if nargin == 6
    mu = 398600;
end
R = RotPF2GE(i,RAAN,omega);

p = a*(1-e^2);

vPF = sqrt(mu/p)*[-sind(theta), e+cosd(theta) , 0]';                % velocità nel SdR PF (versori: [e, p, h])
posPF = (p/(1 + e*cosd(theta))) * [cosd(theta), sind(theta), 0]';   % posizione nel SdR PF (versori: [e, p, h])

v = R*vPF;
pos = R*posPF;

end

