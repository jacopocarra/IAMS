function [deltaV, orbTrasf] = manovraBitangenteEllittica(orbIniz, orbFin, type)

    aIniz = orbIniz(1);
    eIniz = orbIniz(2);
    iIniz = orbIniz(3);
    RAANIniz = orbIniz(4);
    omegaIniz = orbIniz(5);
    thetaIniz = orbIniz(6);

    aFin = orbFin(1);
    eFin = orbFin(2);
    iFin = orbFin(3);
    RAANFin = orbFin(4);
    omegaFin = orbFin(5);

    mu = 398600;

    rAIniz = aIniz*(1+e);
    rPIniz = aIniz*(1-e);
    rAFin = aFin*(1+e);
    rPFin = aFin*(1-e);

    switch lower(type)
        case 'pa'           % caso da pericentro orbita 1 a apocentro orbita 2
            if omegaFin ~= omegaIniz
                error('Trasferimento impossibile')
            end
            aTrasf = (rPIniz + rAFin)/2;
            eTrasf = (rAIniz-rPFin)/(rPIniz+rAFin);
            deltaV1 = sqrt(2*mu*((1/rPIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rPIniz)-(1/(2*aIniz))));
            deltaV2 = sqrt(2*mu*((1/rAFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rAFin)-(1/(2*aTrasf))));
            deltaV = abs(deltaV1)+abs(deltaV2);

            orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaFin, thetaFin]';

        case 'ap'       % caso da apocentro orbita 1 a pericentro orbita 2
            if omegaFin ~= omegaIniz
                error('Trasferimento impossibile')
            end
            aTrasf = (rAIniz + rPFin)/2;
            eTrasf = (rAIniz-rPFin)/(rAIniz+rPFin);
            deltaV1 = sqrt(2*mu*((1/rAIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rAIniz)-(1/(2*aIniz))));
            deltaV2 = sqrt(2*mu*((1/rPFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rPFin)-(1/(2*aTrasf))));
            deltaV = abs(deltaV1)+abs(deltaV2);

            orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaFin, thetaFin]';

        case 'aa'       % caso da apocentro orbita 1 a apocentro orbita 2   (quindi omega swappato di 180)
            if omegaFin == omegaIniz
                error('Trasferimento impossibile')
            end
            aTrasf = (rAIniz + rAFin)/2;
            eTrasf = abs(rAIniz-rAFin)/(rAIniz+rAFin);
            deltaV1 = sqrt(2*mu*((1/rAIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rAIniz)-(1/(2*aIniz))));
            deltaV2 = sqrt(2*mu*((1/rAFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rAFin)-(1/(2*aTrasf))));
            deltaV = abs(deltaV1)+abs(deltaV2);        

            orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaFin, thetaFin]';

        case 'pp'       % caso da pericentro orbita 1 a pericentro orbita 2     (quindi omega swappato di 180) 
            if omegaFin == omegaIniz
                error('Trasferimento impossibile')
            end
            aTrasf = (rPIniz + rPFin)/2;
            eTrasf = abs(rPIniz-rAPFin)/(rPIniz+rPFin);
            deltaV1 = sqrt(2*mu*((1/rPIniz)-(1/(2*aTrasf)))) - sqrt(2*mu*((1/rPIniz)-(1/(2*aIniz))));
            deltaV2 = sqrt(2*mu*((1/rPFin)-(1/(2*aFin)))) - sqrt(2*mu*((1/rPFin)-(1/(2*aTrasf))));
            deltaV = abs(deltaV1)+abs(deltaV2);  

            orbTrasf = [aTrasf, eTrasf, iFin, RAANFin, omegaFin, thetaFin]';

end
