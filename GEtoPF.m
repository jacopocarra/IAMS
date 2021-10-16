function [a, e, i, RAAN, omega, theta] = GEtoPF(r, v, mu)
%GEtoPF converte delle coordinate dal sistema di riferimento geocentrico
%equatoriale in quello perifocale
%[a, e, i, RAAN, omega, theta] = GEtoPF(r, v, mu)
%   INPUT:
%       r: vettore [1x3] posizione iniziale [km]
%       v: vettore [1x3] velocità iniziale [km/s]
%       mu: costante gravitazionale [km^3/s^2]
%
%   OUTPUT:
%       a: semiasse maggiore [km]
%       e: eccentricità
%       i: inclinazione (°)
%       RAAN: ascensione retta del nodo ascendente (°)
%       omega: anomalia di pericentro (°)
%       theta: anomalia reale (°)

h = cross(r,v);                                % momento quantità di moto

i = acosd(h(3)/norm(h));                       % inclinazione

ev = cross(v, h)/mu - r/norm(r);               % vettore eccentricità
e = norm(ev);                                  % eccentricità


a = mu/( (2*mu/norm(r)) - norm(v)^2 );         % semiasse maggiore

n=cross([0 0 1]', h);                          % linea dei nodi
n = n/norm(n);

RAAN = acosd(n(1));                            % ascensione retta del nodo ascendente
if n(2) <0
    RAAN = 360 - RAAN;
end

omega = acosd( ( (ev')*n )/e );                % anomalia di pericentro
if ev(3) < 0
    omega = 360 - omega;
end


theta = acosd( ((ev')*r)/(norm(ev)*norm(r)) ); % anomalia vera

vr = r'*v;
if vr<0
    theta = 360 - theta;
end



end

