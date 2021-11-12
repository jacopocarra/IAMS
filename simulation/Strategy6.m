config; 

%% CIRC-BIELL+PLANE+PERI 

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
t6=t;
dV6=dVtot;


%%
Title = 'STRATEGY 5 - CIRC BIELL';
Maneuv_name=[{'initial point'};{'circularization burn'};{'tangent burn'};...
    {'inclination + 1st bitangent'};...
    {'2nd bitangent burn'};{'1st change of P arg'};{'final point'}];           
                                                      % |percorro orbIniz     |percorro orb1       |percorro orb2     | percorro orb4      |%percorro orb5  |percorro orb6
plotOrbit([orbIniz, orb1,  orb2 , orb4  , orb5, orbFin],[orbIniz(6), thetaman1, orb1(6), thetaman2, 0, thetaman3,      180, 0,              180,thetaman5,  orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3,  deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaVReal, deltaV5, deltaV6])
