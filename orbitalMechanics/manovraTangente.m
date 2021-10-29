function [deltaV, thetaMan, deltaT, deltaT1, deltaT2] = manovraTangente(orbIniz, orbFin, type)

%{
   'apo' --> manovra all'apocentro (theta = 180);
   'peri' --> manovra al pericentro (theta = 0);
   'general' --> manovra generica tangente nel punto di theta dell'orbita 1

   In 'apo' e 'peri' va automaticamente dal theta dell'orbita al theta di
   manovra
%}

    mu = 398600;

    aIniz = orbIniz(1);
    eIniz = orbIniz(2);
    iIniz = orbIniz(3);
    RAANIniz = orbIniz(4);
    omegaIniz = orbIniz(5);
    thetaIniz = wrapTo360(orbIniz(6));

    aFin = orbFin(1);
    eFin = orbFin(2);
    thetaFin = orbFin(6);
    
switch lower(type)
    case 'apo'
        thetaMan = 180;
        r = aIniz*(1+eIniz);
        deltaT1 = tempoVolo(orbIniz, thetaIniz, thetaMan);
        deltaV = abs(sqrt(2*mu*((1/r)-(1/(2*aFin))))-sqrt(2*mu*((1/r)-(1/(2*aIniz)))));
    case 'peri'
        thetaMan = 0;
        r = aIniz*(1-eIniz);
        deltaT1 = tempoVolo(orbIniz, thetaIniz, thetaMan);
        deltaV = abs(sqrt(2*mu*((1/r)-(1/(2*aFin))))-sqrt(2*mu*((1/r)-(1/(2*aIniz)))));
    case 'general'
        thetaMan = thetaIniz;
        r = aIniz*(1-eIniz^2)/(1+eIniz*cosd(thetaMan));
        vr = sqrt(mu/p)*eIniz*sind(thetaMan);
        vTheta = sqrt(mu/p)*(1+eIniz*cosd(thetaMan));
        v1 = sqrt(2*mu*((1/r)-(1/(2*aIniz))));
        gamma = atand(vr/vTheta);
        v2 = sqrt(2*mu*((1/r)-(1/(2*aFin))));
        deltaT1 = 0;
        deltaV = sqrt(v1^2+v2^2-v1*v2*cosd(gamma));
end
   
    deltaT2 = tempoVolo(orbFin, thetaMan, thetaFin);
    deltaT = deltaT1+deltaT2;
     
end