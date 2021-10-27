function [deltaV, thetaFin] = manovraTangente(orbIniz, orbFin)

% funziona solo per manovre ad apocentro e pericentro

mu = 398600;

aIniz = orbIniz(1);
eIniz = orbIniz(2);
iIniz = orbIniz(3);
RAANIniz = orbIniz(4);
omegaIniz = orbIniz(5);
thetaIniz = orbIniz(6);

aFin = orbFin(1);
eFin = orbFin(2);

[r, ~] = PFtoGE(orbIniz, mu);

deltaV = abs(sqrt(2*mu*((1/r)-(1/2*aFin)))-sqrt(2*mu*((1/r)-(1/2*aIniz))));

thetaFin = thetaIniz;    