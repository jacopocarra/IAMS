%%% MAIN
%{ 
ANALISI DI MISSIONI SPAZIALI (PROVA FINALE)
Prof. Bernelli

This script allows you to set all the parameters and to run the simulation

VERSION: 
        - version 1: Jacopo Carradori, Riccardo Cadamuro, Tommaso Brombara


%}
clc
clear
close all
addpath('..\plot');
addpath('..\orbitalMechanics'); %aggiunti i percorsi per trovare le altre funzioni

%% DATI
ptoIniz = [-3441.6408 -7752.3491 -3456.8431 ...
4.9270 -0.5369 -4.0350];                                 % [x y z vx vy vz]
orbFin = [12930.0, 0.2055, rad2deg(1.5510)...
rad2deg(2.6830),  rad2deg(0.4098), rad2deg(1.6940)]';  % [a e i RAAN omega theta]
mu = 398600;                                             % costante gravitazionale



%% ORBITA INIZIALE
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità

[orbIniz] = GEtoPF(rIniz, vIniz, mu); % da GE coordinate PF

%% ORBITA FINALE
aFin = orbFin(1); 
eFin = orbFin(2); 
iFin = (orbFin(3));
RAANFin = (orbFin(4));
omegaFin = (orbFin(5));
thetaFin = (orbFin(6)); 


%% PLOT
% orbit2D( [aIniz, eIniz, omegaIniz, thetaIniz], 1, true);             % plot 2D dell'orbita iniziale
% orbit2D( [aFin, eFin, omegaFin, thetaFin], 3, true);             % plot 2D dell'orbita finale

earth3D(2);                                              % plot terra
orbit3D(orbIniz, 2);         % plot 3D orbita iniziale
orbit3D(orbFin, 2);                                      % plot 3D orbita finale

%{
h = animatedline;

 for k = 1:length(r3D(1,:))
     addpoints(h,r3D(1,k),r3D(2,k),r3D(3,k));
     drawnow
 end
%}


%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'ap' CAMBIO DI PIANO NEL PUNTO PIù LONTANO DA PERICENTRO ORBITA INIZIALE (effettivamente provato)
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, orbFin2(5));
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'ap');
%OCCHIO PERCHè IN 'ap' SE L'APOCENTRO DELL'ORBITA INIZIALE DIVENTA IL PERICENTRO
%DELL'ORBITA DI TRASFERIMENTO VA GIRATO DI 180 OMEGHINO.
orbTrasf(5) = wrapTo360(orbTrasf(5)+180);
thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, 0, 180, orbTrasf(6), orbFin2(6)]
Title = 'STRATEGY 1  ap'
deltaVtot = deltaV1+deltaV+deltaV2
deltaT = deltaT1+deltaT+deltaT2

Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];
%%
close all
earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
orbit3D(orbFin2, 1);                                      % plot 3D orbita finale
%%
close all
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT2, deltaT3, deltaT4],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV,  deltaV3, deltaV4])




%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'pa'
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, orbFin2(5));
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'pa');

deltaVtot = deltaV1+deltaV+deltaV2
deltaTtot = deltaT1+deltaT+deltaT2+ tempoVolo(orbFin2, 180, orbFin(6))

thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, thetaman3, orbTrasf(6), orbTrasf(6), orbFin2(6)];
Title = 'STRATEGY 1  PA'
Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];

%%
close all
earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
orbit3D(orbFin2, 1);                                      % plot 3D orbita finale
%%
close all
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT3, deltaT4, tempoVolo(orbFin2, 180, orbFin(6))],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV3, deltaV4])




%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'pp'
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
% per 'aa' e 'pp' bisogna sfasare l'anomalia dei pericentri di 180 gradi
% altrimenti non è possibile farlo. Facendo questo cambia il deltaV dovuto
% al cambio dell'anomalia di pericentro.
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, wrapTo360(orbFin2(5)+180));

[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'pp');

deltaVtot = deltaV1+deltaV+deltaV2
deltaT = deltaT1+deltaT+deltaT2
thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, 0, 180, orbTrasf(6), orbFin2(6)];
Title = 'STRATEGY 1  pp'
Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];

%%
close all
earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
orbit3D(orbFin2, 1);                                      % plot 3D orbita finale
%%
close all
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT2, deltaT3, deltaT4],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV2, deltaV3, deltaV4])




%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'aa'

orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
% per 'aa' e 'pp' bisogna sfasare l'anomalia dei pericentri di 180 gradi
% altrimenti non è possibile farlo. Facendo questo cambia il deltaV dovuto
% al cambio dell'anomalia di pericentro.
% 
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, wrapTo360(orbFin2(5)+180));

[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'aa');

deltaVtot = deltaV1+deltaV+deltaV2
deltaT = deltaT1+deltaT+deltaT2

thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), 180, 0, 180, orbTrasf(6), orbFin2(6)];
Title = 'STRATEGY 1 aa'
Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];

%%
close all
earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
orbit3D(orbFin2, 1);                                      % plot 3D orbita finale
%%
close all
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT2, deltaT3, deltaT4],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV2, deltaV3, deltaV4])




%% STRAT 2-1 PA - calcolo

dTtot=0;
dVtot=0;

rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
rAllontanamento=0.5e5;

[orb1, deltaV1, deltaT1, thetaman1] = cambioAnomaliaPericentro(orbIniz, 290); % 290 scelta arbitraria, otiimo sembra tra tra 289 e 291
dVtot=dVtot+deltaV1;
dTtot=dTtot+deltaT1;


[orb2, deltaV2, deltaT2, thetaman2] = manovraTangente(orb1, (rPIniz+rAllontanamento)/2, 'per');
dVtot=dVtot+deltaV2;
dTtot=dTtot+deltaT2;

[orb3, deltaV3, deltaT3, thetaman3] = cambioInclinazione(orb2, orbFin(3), orbFin(4));
dVtot=dVtot+deltaV3;
dTtot=dTtot+deltaT3;

orb5=orbFin;
orb5(5)=wrapTo360(orb3(5)); %sfasare di 180 per aa e pa, lasciare così per ap e pa

[deltaV, deltaV4, deltaV5, orb4, deltaT, deltaT4, deltaT5, thetaman4] = manovraBitangenteEllittica(orb3, orb5, 'pa');
dVtot=dVtot+deltaV4+deltaV5;
dTtot=dTtot+deltaT4+deltaT5;


[orb6, deltaV6, deltaT6, thetaman5] = cambioAnomaliaPericentro(orb5, orbFin(5));
dVtot=dVtot+deltaV6;
dTtot=dTtot+deltaT6;

% orb6 == orbFin a meno del tratto ancora da percorrere -->deltaT7

deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));
%dTtot=dTtot +deltaT7;

tStrat2PA=duration(0,0,dTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
dVstrat2PA=dVtot

%% strat 2-1 -plot statico
earth3D(1); 
orbit3D(orbIniz, 1)

%thetaman1
orbit3D(orb1, 1)

%thetaman2
orbit3D(orb2, 1)

%thetaman3
orbit3D(orb3, 1)

%thetaman4
orbit3D(orb4, 1)

%thetaman5
orbit3D(orb5, 1)

orbit3D(orb6,1 )
orbit3D(orbFin, 1) %uguale a orb6 ma con theta diverso

%% strat 2-1 -plot dinamico

Title = 'STRATEGY 2 - PA';
Maneuv_name=[{'initial point'};{'1st change of P arg'};{'tangent burn'};...
    {'inclination change'};{'1st bitangent burn'};...
    {'2nd bitangent burn'};{'2nd change of P arg'};{'final point'}];          
                                                            % |percorro orbIniz    | percorro orb1     | percorro orb2     | percorro orb3     | %percorro orb4     |%percorro orb5  percorro orb6
plotOrbit([orbIniz, orb1 , orb2 , orb3 ,orb4 , orb5, orbFin],[orbIniz(6), thetaman1, orb1(6), thetaman2, orb2(6), thetaman3, orb3(6), thetaman4,        0, 180 ,            180,thetaman5, orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3, deltaT4, deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4, deltaV5, deltaV6])


%% STRAT 2-2 AP -calcolo

dTtot=0;
dVtot=0;

rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
rAllontanamento=5e4; % arbitrario, trade-off tra tempo e costo in deltaV 

[orb1, deltaV1, deltaT1, thetaman1] = cambioAnomaliaPericentro(orbIniz, 289.5); % 290 scelta arbitraria, otiimo sembra tra tra 289 e 291
dVtot=dVtot+deltaV1;
dTtot=dTtot+deltaT1;


[orb2, deltaV2, deltaT2, thetaman2] = manovraTangente(orb1, (rPIniz+rAllontanamento)/2, 'per');
dVtot=dVtot+deltaV2;
dTtot=dTtot+deltaT2;

[orb3, deltaV3, deltaT3, thetaman3] = cambioInclinazione(orb2, orbFin(3), orbFin(4));
dVtot=dVtot+deltaV3;
dTtot=dTtot+deltaT3;

orb5=orbFin;
orb5(5)=wrapTo360(orb3(5)); %sfasare di 180 per aa e pp, lasciare così per ap e pa

[deltaV, deltaV4, deltaV5, orb4, deltaT, deltaT4, deltaT5, thetaman4] = manovraBitangenteEllittica(orb3, orb5, 'ap');
dVtot=dVtot+deltaV4+deltaV5;
dTtot=dTtot+deltaT4+deltaT5;


[orb6, deltaV6, deltaT6, thetaman5] = cambioAnomaliaPericentro(orb5, orbFin(5));
dVtot=dVtot+deltaV6;
dTtot=dTtot+deltaT6;

% orb6 == orbFin a meno del tratto ancora da percorrere -->deltaT7

deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));
dTtot=dTtot +deltaT7;

tStrat2AP=duration(0,0,dTtot) %non trascuro!!! %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
dVstratAP=dVtot

%% Strat 2-2 AP -polt orbite
earth3D(1); 
orbit3D(orbIniz, 1)

%thetaman1
orbit3D(orb1, 1)

%thetaman2
orbit3D(orb2, 1)

%thetaman3
orbit3D(orb3, 1)

%thetaman4
orbit3D(orb4, 1)

%thetaman5
orbit3D(orb5, 1)

orbit3D(orb6,1 )
orbit3D(orbFin, 1)

%% Strat 2-2 AP plot dinamico

Title = 'STRATEGY 2 - AP';

Maneuv_name=[{'initial point'};{'1st change of P arg'};{'tangent burn'};...
    {'inclination change'};{'1st bitangent burn'};...
    {'2nd bitangent burn'};{'2nd change of P arg'};{'final point'}];          
                                                            % |percorro orbIniz    | percorro orb1     | percorro orb2     | percorro orb3     | %percorro orb4     |%percorro orb5  percorro orb6
plotOrbit([orbIniz, orb1 , orb2 , orb3 ,orb4 , orb5, orbFin],[orbIniz(6), thetaman1, orb1(6), thetaman2, orb2(6), thetaman3, orb3(6), thetaman4,        180, 0 ,            0,thetaman5, orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3, deltaT4, deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4, deltaV5, deltaV6])


%% TRASFERIMENTO DIRETTO
[orbTrasf, dV1, dV2, dT, thetaMan1, thetaMan2] = trasfDir(orbIniz, orbFin); 

earth3D(3)
orbit3D(orbIniz, 3)
orbit3D(orbTrasf,3)
orbit3D(orbFin, 3)

deltaV = dV1 + dV2
dT

Title = 'STRATEGY 3 - Direct Transfer';

Maneuv_name=[{'Initial orbit periapsis'};{'Initial point'};{'Final point'}; {'Final orbit apoapsis'};];          

plotOrbit([orbIniz, orbTrasf , orbFin],...
    [0, orbIniz(6),     thetaMan1, thetaMan2,     orbFin(6), 180],...
    [0, dT, 0],...
    Title,Maneuv_name,'stat',0,...
    [0, dV1, dV2]); 



%% STRAT 5 CIRC-BIELL+PLANE+PERI 

close all
dTtot=0;
dVtot=0;

rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
rAIniz=orbIniz(1)*(1+orbIniz(2));
rAllontanamento=0.5e5;

[orb1, deltaV1, deltaT1, thetaman1] = manovraTangente(orbIniz,rAIniz, 'apo'); %circolarizzato
dVtot=dVtot+deltaV1;
dTtot=dTtot+deltaT1;
orb1(6)= wrapTo360(orb1(5)); %ridefinisco theta rispetto a N
omegaIniz=orbIniz(5);

orb1(5)=0;  %setto omega a zero

%
[rFin, vFin] = PFtoGE(orbFin, mu); 

h1 = cross(rIniz, vIniz);  %momento angolare orbIniz
h2 = cross(rFin, vFin); %momento angolare orbFin

N = cross(h1, h2); 
N = N/norm(N);  %linea intersezione piani due orbite

[e2, v2] = PFtoGE([orb1(1), orb1(2), orb1(3), orb1(4), orb1(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

h2 = cross(e2, v2); %momento della q.tà di moto orb Fin

thetaMan2 = acosd( dot(e2, N)/norm(e2) );   %posizione seconda manovra

if dot(cross(e2, N), h2) < 0   
    thetaMan2 = 360 - thetaMan2; 
end

if wrapTo360((thetaMan2 + 180) - orb1(6)) < wrapTo360(thetaMan2 - orb1(6))  %scelgo di manovrare nel punto più vicino
    thetaMan2 = wrapTo360(thetaMan2 + 180); 
end

%

[orb2, deltaV2, deltaT2, thetaman2] = manovraTangente(orb1, (rAIniz+rAllontanamento)/2, 'gen', wrapTo360(thetaMan2));
dVtot=dVtot+deltaV2;
dTtot=dTtot+deltaT2;

orb2(6) = wrapTo360(orb2(6));

[orb3, deltaV3, deltaT3, thetaman3] = cambioInclinazione(orb2, orbFin(3), orbFin(4));
%dVtot=dVtot+deltaV3;
dTtot=dTtot+deltaT3;

orb5=orbFin;
orb5(5)=wrapTo360(orb3(5)+180); %sfasare di 180 per aa e pp, lasciare così per ap e pa
orb5(6)=180;

[deltaV, deltaV4, deltaV5, orb4, deltaT, deltaT4, deltaT5, thetaman4] = manovraBitangenteEllittica(orb3, orb5, 'aa');
%dVtot=dVtot+deltaV4+deltaV5;
dTtot=dTtot+deltaT5; %+deltaT4

[orbInutile, deltaVReal, deltaVInutile, deltaTInutile, thetaPlot1, thetaPlot2] = trasfDir([orb2(1), orb2(2), orb2(3), orb2(4), orb2(5), 180]',orb4);
dVtot=dVtot+deltaVReal+deltaV5;

[orb6, deltaV6, deltaT6, thetaman5] = cambioAnomaliaPericentro(orb5, orbFin(5));
dVtot=dVtot+deltaV6;
dTtot=dTtot+deltaT6;

deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));
dTtot=dTtot +deltaT7;

t=duration(0,0,dTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
dVtotCircBiell=dVtot

%%
close all
Title = 'STRATEGY 5 - CIRC BIELL';
Maneuv_name=[{'initial point'};{'circularization burn'};{'tangent burn'};...
    {'inclination + 1st bitangent'};...
    {'2nd bitangent burn'};{'1st change of P arg'};{'final point'}];           
                                                      % |percorro orbIniz     |percorro orb1       |percorro orb2     | percorro orb4      |%percorro orb5  |percorro orb6
plotOrbit([orbIniz, orb1,  orb2 , orb4  , orb5, orbFin],[orbIniz(6), thetaman1, orb1(6), thetaman2, 0, thetaman3,      180, 0,              180,thetaman5,  orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3,  deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaVReal, deltaV5, deltaV6])


