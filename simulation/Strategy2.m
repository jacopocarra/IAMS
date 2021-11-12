config;

%% SHAPE-PLANE-W  (pa)

orbFin1  = [orbFin(1);orbFin(2);orbIniz(3);orbIniz(4);orbIniz(5);orbIniz(6)];

[deltaVtot1, deltaV1, deltaV2, orbTrasf, deltaTtot1, deltaT1, deltaT2, thetaMan2] = manovraBitangenteEllittica(orbIniz, orbFin1, 'pa');
orbFin1(6) = 180;  %allineato con la fine della manovra bitangente

[orbFin2, deltaV3, deltaT3, thetaMan3] = cambioInclinazione(orbFin1, orbFin(3), orbFin(4));

[orbFin3, deltaV4, deltaT4, thetaman4] = cambioAnomaliaPericentro(orbFin2, orbFin(5));

deltaVolo = tempoVolo(orbFin, orbFin3(6), orbFin(6));

deltaVtot = deltaVtot1+deltaV3+deltaV4; 

deltaTVolo=tempoVolo(orbFin3, orbFin3(6), orbFin(6));

deltaTTot = deltaTtot1+deltaT3+deltaT4+deltaTVolo;

deltaTTot = deltaTtot1+deltaT3+deltaT4+deltaVolo;


Title = 'STRATEGY SHAPE-PLANE-W';

Maneuv_name=[{'initial point'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'change of plane'};{'change of P arg'};...
    {'final point'}];
thetaStory = [orbIniz(6), thetaMan2, thetaMan2, 180, 180, thetaMan3, orbFin2(6),thetaman4, orbFin3(6), orbFin(6) ];
plotOrbit([orbIniz, orbTrasf,orbFin1, orbFin2,orbFin3],thetaStory,[deltaT1, deltaT2, deltaT3, deltaT4, deltaTVolo],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4])
