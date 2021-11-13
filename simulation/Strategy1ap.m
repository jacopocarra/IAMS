config; 

%{
Strategia standard 1:
-CAMBIO DI PIANO IN PUNTO PIU LONTANO DEI DUE
-CAMBIO ANOMALIA PERICENTRO
-BITANGENTE ELLITTICA AP

COSTO 11.79
%}

%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'ap' CAMBIO DI PIANO NEL PUNTO PIù LONTANO DA PERICENTRO ORBITA INIZIALE (effettivamente provato)
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, orbFin2(5));
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'ap');
%OCCHIO PERCHè IN 'ap' SE L'APOCENTRO DELL'ORBITA INIZIALE DIVENTA IL PERICENTRO
%DELL'ORBITA DI TRASFERIMENTO VA GIRATO DI 180 OMEGHINO.
orbTrasf(5) = wrapTo360(orbTrasf(5)+180);
thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, 0, 180, orbTrasf(6), orbFin2(6)]; 
Title = 'STRATEGY 1  ap'; 
deltaVtot = deltaV1+deltaV+deltaV2; 
deltaTVolo=tempoVolo(orbFin2, 0, orbFin2(6) );
deltaTtot = deltaT1+deltaT+deltaT2+deltaTVolo; 



orbVett = [orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2];

timeStory = [deltaT1, deltaT, deltaT2, deltaT3, deltaT4];

dVstory = [0, deltaV1, deltaV,  deltaV3, deltaV4];

Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];

%%
close all
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT3, deltaT4, deltaTVolo],Title,Maneuv_name,'dyn',0,[0, deltaV1, deltaV,  deltaV3, deltaV4])
