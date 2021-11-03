%{
    QUESTO SCRIPT SERVE UNICAMENTE PER INSERIRE I DATI PER TESTARE LE
    FUNZIONI MAN MANO CHE VENGONO CREATE, TUTTO IL CODICE DAL SECONDO
    PARAGRAFO PUO' ESSERE CANCELLATO SENZA PROBLEMI IN OGNI MOMENTO
%}

clc
clear
close all
addpath('..\plot');
addpath('..\orbitalMechanics'); %aggiunti i percorsi per trovare le altre funzioni

%%
global fps;
global myMovie;
global myFig;
myMovie = struct('cdata',[],'colormap',[]);
fps = 100;
%% dati


mu = 398600; 
ptoIniz = [-3441.6408 -7752.3491 -3456.8431 ...
            4.9270 -0.5369 -4.0350];                                 % [x y z vx vy vz]
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità
orbIniz = GEtoPF(rIniz, vIniz, mu);  % da GE coordinate PF


orbFin = [12930.0, 0.2055, rad2deg(1.5510), rad2deg(2.6830),  rad2deg(0.4098), rad2deg(1.6940)]';  % [a e i RAAN omega theta]        

%% PLOT ORBITA INIZIALE
close all
mu = 398600
ptoIniz = [-3441.6408 -7752.3491 -3456.8431 ...
4.9270 -0.5369 -4.0350];   
rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità

[orbIniz, n, eVEc, h] = GEtoPF(rIniz, vIniz, mu); % da GE coordinate PF
earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
quiver3(0,0,0,eVEc(1),eVEc(2),eVEc(3),150000,'-.','color','b','LineWidth',1);
quiver3(0,0,0,h(1),h(2),h(3),0.25,'-.','color','r','LineWidth',1);
quiver3(0,0,0,n(1),n(2),n(3),15000,'-.','color','g','LineWidth',1);
text(eVEc(1),eVEc(2)+10000,eVEc(3)+5000,'e','FontSize',12,'color','b');
text(h(1)/4+1000,h(2)/4+1000,h(3)/4+1000,'h','FontSize',12,'color','r');
text(n(1)+13000,n(2)+10000,n(3),'N','FontSize',12,'color','g');


%%
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4))
[orbFin3, deltaV, deltaT, thetaman] = cambioAnomaliaPericentro(orbFin1, orbFin2(5))
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaMan] = manovraBitangenteEllittica(orbFin3, orbFin2, 'pa')
Title = 'STRATEGY 1';
Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];
earth3D(1);                                              % plot terra
orbit3D(orbIniz, 1);         % plot 3D orbita iniziale
orbit3D(orbFin2, 1);                                      % plot 3D orbita finale

plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],[orbIniz(6), orbFin1(6), orbFin1(6), thetaman, orbFin3(6), thetaMan, thetaMan, orbTrasf(6), orbTrasf(6) orbFin2(6)],[deltaT1, deltaT, deltaT2, deltaT3, deltaT4],Title,Maneuv_name,'dyn',0,[0, deltaV1, deltaV, deltaV2, deltaV3, deltaV4])



%% TRASF DIRETTO
close all
orbFin2 = orbFin; 

[orbTrasf, deltaV1, deltaV2, deltaT, thetaT1, thetaT2] = trasfDir(orbIniz,orbFin2); 

%{
orbIniz = orbFin; 
orbIniz(3) = wrapTo360(180 - orbIniz(3));
orbIniz(4) = wrapTo360(180 + orbIniz(4));
orbIniz(5) = wrapTo360(180 + orbIniz(5)); 
%}
%%
earth3D(2); 
orbit3D(orbIniz, 2)
orbit3D(orbFin2,2 )
 orbit3D(orbTrasf, 2)
hold on
quiver3(0,0,0,eTGEvett(1),eTGEvett(2),eTGEvett(3),15000,'-.','color','b','LineWidth',1.5);
quiver3(0,0,0,hT(1)*10000,hT(2)*10000,hT(3)*10000,1,'-.','color','r','LineWidth',1.5);
quiver3(0,0,0,nT(1)*10000,nT(2)*10000,nT(3)*10000,1,'-.','color','g','LineWidth',1.5);

hold off
%%
plotOrbit(orbTrasf,[thetaT1, thetaT2],deltaT,'diretto',[{'inizio'}, {'fine'}],'dyn',[0 0],[deltaV1, deltaV2])
%% 

% ptoFin = [1.9930e4, 1.5160e-1, rad2deg(3.0250), ...
% rad2deg(6.5460e-1),  rad2deg(2.7820), rad2deg(2.6190)]; 
% orbit3D (ptoFin, 4);
% orbit3D (orbTrasf, 4);
% orbit3D (orbFin, 4);


%% 

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

t=duration(0,0,dTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
%dV=dVtot

%%
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

%%

Title = 'STRATEGY 2 - PA';
Maneuv_name=[{'initial point'};{'1st change of P arg'};{'tangent burn'};...
    {'inclination change'};{'1st bitangent burn'};...
    {'2nd bitangent burn'};{'2nd change of P arg'};{'final point'}];          
                                                            % |percorro orbIniz    | percorro orb1     | percorro orb2     | percorro orb3     | %percorro orb4     |%percorro orb5  percorro orb6
plotOrbit([orbIniz, orb1 , orb2 , orb3 ,orb4 , orb5, orbFin],[orbIniz(6), thetaman1, orb1(6), thetaman2, orb2(6), thetaman3, orb3(6), thetaman4,        0, 180 ,            180,thetaman5, orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3, deltaT4, deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'dyn',0,[0, deltaV1, deltaV2, deltaV3, deltaV4, deltaV5, deltaV6])
% CORRETTA PORCODDIO SE CE NE HO MESSO DI TEMPO


%% STRATEGY 3


%% STRATEGY 4

[orbTrasf, dV1, dV2, dT] = trasfDir(orbIniz, orbFin); 

earth3D(1)
orbit3D(orbIniz, 1)
orbit3D(orbTrasf,1)
orbit3D(orbFin, 1)

deltaV = dV1 + dV2



