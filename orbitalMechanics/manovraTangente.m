function [deltaV, thetaMan, deltaT] = manovraTangente(orbIniz, orbFin)

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
    thetaFin = orbFin(6);

    if thetaIniz == 0
        r = round(aIniz*(1-eIniz));
    elseif thetaIniz == pi
        r = aIniz*(1+eIniz);
    end
    deltaV = abs(sqrt(2*mu*((1/r)-(1/(2*aFin))))-sqrt(2*mu*((1/r)-(1/(2*aIniz)))));
    deltaT = tempoVolo(orbFin, thetaIniz, thetaFin);
    thetaMan = thetaIniz;    
end