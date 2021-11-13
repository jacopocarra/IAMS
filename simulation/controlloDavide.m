%% Prova davide
%strat2b
clc
orbIniz = [8152.98231, 0.0911, rad2deg(0.41898), rad2deg(1.31816), rad2deg(1.48374), rad2deg(0.01418)]';
orbFin = [12220, 0.3198, rad2deg(1.553), rad2deg(2.931), rad2deg(1.47), rad2deg(1.401)]';
tempoVolo(orbIniz, orbIniz(6), orbIniz(6)+180)
%cambio piano
%cambio w
%cambio shape
orbIniz(6)= orbIniz(6)+180
[orb2, deltaV1, deltaT1, thetaMan1] = cambioInclinazione(orbIniz, orbFin(3), orbFin(4))
tempoVolo(orb2, orb2(6), orb2(6)+180)
orb2(6) = orb2(6)+180
[orb3, deltaV2, deltaT2, thetaman2] = cambioAnomaliaPericentro(orb2, orbFin(5))
[deltaV, deltaV3, deltaV4, orbTrasf, deltaT, deltaT3, deltaT4, thetaMan4] = manovraBitangenteEllittica(orb3, orbFin, 'pa')
