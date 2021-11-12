config; 

%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'pa'
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, orbFin2(5));
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'pa');

deltaVtot = deltaV1+deltaV+deltaV2;
deltaTtot = deltaT1+deltaT+deltaT2+ tempoVolo(orbFin2, 180, orbFin(6));

thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, thetaman3, orbTrasf(6), orbTrasf(6), orbFin2(6)];

Title = 'STRATEGY 1  PA';

Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];


plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT3, deltaT4, tempoVolo(orbFin2, 180, orbFin(6))],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV3, deltaV4])


















