function [pos,v] = EqMoto(orb, thetaIn, t)

    %Funzione che calcola l'equazione di moto

a = orb(1);
e = orb(2);
i = deg2rad(orb(3));
RAAN = deg2rad(orb(4));
omega = deg2rad(orb(5));
mu = 398600;
thetaIn = deg2rad(thetaIn)

E = 2*atan(sqrt((1-e)/(1+e))*tan(thetaIn/2));       % Calcolo Energia

T = 2*pi*sqrt(a^3/mu); % periodo orbita
n = 2*pi/T; % velocità angolare media

M = E-e*sin(E); % anomalia media

Deltat = M/n; % Deltat per raggiungere theta da theta=0

M = n*(t+Deltat); % anomalia media al timestep successivo

[E]=anomEcc(M,e); % Risoluzione numerica eq di Keplero
theta=2*atan(sqrt((1+e)/(1-e))*tan(E/2));   % trovo il nuovo theta

R = RotPF2GE(rad2deg(i),rad2deg(RAAN),rad2deg(omega)); 

p = a*(1-e^2);

vPF = sqrt(mu/p)*[-sin(theta), e+cos(theta) , 0]';                % velocità nel SdR PF (versori: [e, p, h])
posPF = (p/(1 + e*cos(theta))) * [cos(theta), sin(theta), 0]';   % posizione nel SdR PF (versori: [e, p, h])

v = R*vPF;
pos = R*posPF;

end