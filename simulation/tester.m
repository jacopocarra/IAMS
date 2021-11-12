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

tPlot = [];
vPlot = [];

%% PLOT ORBITA INIZIALE
close all
mu = 398600
% ptoIniz = [-3441.6408 -7752.3491 -3456.8431 ...
% 4.9270 -0.5369 -4.0350];   
% rIniz = [ptoIniz(1) ptoIniz(2) ptoIniz(3)]';                % vettore posizione
% vIniz = [ptoIniz(4) ptoIniz(5) ptoIniz(6)]';                % vettore velocità
[pos, v] = PFtoGE(orbFin, mu)
[orbFin, n, eVEc, h] = GEtoPF(pos, v, mu); % da GE coordinate PF
% earth3D(1);                                              % plot terra
plotOrbit(orbFin,[orbFin(6), orbFin(6)+360],0,'Final orbit',[{'Final point'}],'stat',0,0)
quiver3(0,0,0,eVEc(1),eVEc(2),eVEc(3),70000,'-.','color','b','LineWidth',1);
quiver3(0,0,0,h(1),h(2),h(3),0.25,'-.','color','r','LineWidth',1);
quiver3(0,0,0,n(1),n(2),n(3),15000,'-.','color','g','LineWidth',1);
text(eVEc(1)-15000,eVEc(2)+6500,eVEc(3)+5000,'e','FontSize',12,'color','b');
text(h(1)/4+1000,h(2)/4+1000,h(3)/4+1000,'h','FontSize',12,'color','r');
text(n(1)-13000,n(2)+10000,n(3),'N','FontSize',12,'color','g');


%%



%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'ap' CAMBIO DI PIANO NEL PUNTO PIù LONTANO DA PERICENTRO ORBITA INIZIALE (effettivamente provato)
clc
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, orbFin2(5));
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'ap');
%OCCHIO PERCHè IN 'ap' SE L'APOCENTRO DELL'ORBITA INIZIALE DIVENTA IL PERICENTRO
%DELL'ORBITA DI TRASFERIMENTO VA GIRATO DI 180 OMEGHINO.
orbTrasf(5) = wrapTo360(orbTrasf(5)+180);
thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, 0, 180, orbTrasf(6), orbFin2(6)]
Title = 'STRATEGY 1  ap'
deltaTLast = tempoVolo(orbFin2, 0,orbFin2(6));
% t=duration(0,0,deltaTLast);
deltaVtot = deltaV1+deltaV+deltaV2
deltaTtot = deltaT1+deltaT+deltaT2+deltaTLast
t=duration(0,0,deltaTtot)

tPlot = [tPlot; t];
vPlot = [vPlot; deltaVtot];

Maneuv_name=[{'initial point'};{'change of plane'};{'change of P arg'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'final point'}];
%%
close all
earth3D(1);                                              % plot terra
orbit3D(orbFin1, 1);         % plot 3D orbita iniziale
orbit3D(orbFin3, 1);                                      % plot 3D orbita finale
%%
close all
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT3, deltaT4, deltaTLast],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV3, deltaV4])

%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'pa'
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, orbFin2(5));
[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'pa');

deltaTLast = tempoVolo(orbFin2, 180,orbFin2(6))
% t=duration(0,0,deltaTLast)
deltaVtot = deltaV1+deltaV+deltaV2
deltaTtot = deltaT1+deltaT+deltaT2+deltaTLast
t=duration(0,0,deltaTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale

tPlot = [tPlot; t];
vPlot = [vPlot; deltaVtot];

thetaStory = [orbIniz(6), thetaman1, orbFin1(6), thetaman2, orbFin3(6), thetaman3, thetaman3, orbTrasf(6), orbTrasf(6), orbFin2(6)];
Title = 'STRATEGY 1  pa'
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
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT3, deltaT4, deltaTLast],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV3, deltaV4])

%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'pp'
orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
% per 'aa' e 'pp' bisogna sfasare l'anomalia dei pericentri di 180 gradi
% altrimenti non è possibile farlo. Facendo questo cambia il deltaV dovuto
% al cambio dell'anomalia di pericentro.
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, wrapTo360(orbFin2(5)+180));

[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'pp');
deltaTLast = tempoVolo(orbFin2, 0,orbFin2(6))

deltaVtot = deltaV1+deltaV+deltaV2
deltaTtot = deltaT1+deltaT+deltaT2+deltaTLast
t=duration(0,0,deltaTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale

tPlot = [tPlot; t];
vPlot = [vPlot; deltaVtot];

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
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT, deltaT3, deltaT4],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV3, deltaV4])


%% TRASFERIMENTO CON BITANGENTE ELLITTICA 'aa'

orbFin2 = orbFin; 

[orbFin1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin2(3), orbFin2(4));
% per 'aa' e 'pp' bisogna sfasare l'anomalia dei pericentri di 180 gradi
% altrimenti non è possibile farlo. Facendo questo cambia il deltaV dovuto
% al cambio dell'anomalia di pericentro.
% 
[orbFin3, deltaV, deltaT, thetaman2] = cambioAnomaliaPericentro(orbFin1, wrapTo360(orbFin2(5)+180));

[deltaV2, deltaV3, deltaV4, orbTrasf, deltaT2, deltaT3, deltaT4, thetaman3] = manovraBitangenteEllittica(orbFin3, orbFin2, 'aa');
deltaTLast = tempoVolo(orbFin2, 180,orbFin2(6))

deltaVtot = deltaV1+deltaV+deltaV2
deltaTtot = deltaT1+deltaT+deltaT2+deltaTLast
t=duration(0,0,deltaTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale

tPlot = [tPlot; t];
vPlot = [vPlot; deltaVtot];

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
plotOrbit([orbIniz, orbFin1,orbFin3, orbTrasf,orbFin2],thetaStory,[deltaT1, deltaT,deltaT3, deltaT4],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV, deltaV3, deltaV4])


%%
figure(1)
plot(tPlot(1), vPlot(1), 'd', 'MarkerFaceColor', 'r')
hold on
plot(tPlot(2), vPlot(2), 'd', 'MarkerFaceColor', 'g')
plot(tPlot(3), vPlot(3), 'd', 'MarkerFaceColor', 'b')
plot(tPlot(4), vPlot(4), 'd', 'MarkerFaceColor', 'c')
xlabel('Transfer deltaT [hours & minutes]');
ylabel('deltaV [km/s]');
legend('ap', 'pa', 'pp', 'aa')
grid on
xlim([t(1)-0.1, t(end)+0.01])
ylim([11.5, 12.5])


%% TRASF DIRETTO
close all
orbFin2 = orbFin; 

[orbTrasf, deltaV1, deltaV2, deltaT, thetaT1, thetaT2] = trasfDir(orbIniz,orbFin2); 

orbit3D(orbIniz, 1)
%%
earth3D(1); 
orbit3D(orbTrasf, 1)
%%
orbit3D(orbFin2, 1)
%%
Maneuv_name=[{'first impulse'};{'second impulse'}];
plotOrbit([orbIniz, orbTrasf, orbFin2],[orbIniz(6), orbIniz(6), thetaT1, thetaT2, orbFin2(6), orbFin2(6)],...
            [0, deltaT,0],...
            'Trasf diretto',Maneuv_name, ...
            'stat',0, [0, deltaV1, deltaV2] );



%% STRAT 2-2 AP

dTtot=0;
dVtot=0;

rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
rAllontanamento=0.5e5;

[orb1, deltaV1, deltaT1, thetaman1] = cambioAnomaliaPericentro(orbIniz, 277.7); % 290 scelta arbitraria, otiimo sembra tra tra 289 e 291
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

t=duration(0,0,dTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
dV=dVtot

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

Title = 'STRATEGY 2 - AP';
Maneuv_name=[{'initial point'};{'1st change of P arg'};{'tangent burn'};...
    {'inclination change'};{'1st bitangent burn'};...
    {'2nd bitangent burn'};{'2nd change of P arg'};{'final point'}];          
                                                            % |percorro orbIniz    | percorro orb1     | percorro orb2     | percorro orb3     | %percorro orb4     |%percorro orb5  percorro orb6
plotOrbit([orbIniz, orb1 , orb2 , orb3 ,orb4 , orb5, orbFin],[orbIniz(6), thetaman1, orb1(6), thetaman2, orb2(6), thetaman3, orb3(6), thetaman4,        180, 0 ,            0,thetaman5, orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3, deltaT4, deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4, deltaV5, deltaV6])

%% opt rAllontanamento

dVvect=[];
dTvect=[];
dV2Vect=[];


for rAllontanamento=30000:2000:1000000
    dTtot=0;
    dVtot=0;
    
    rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
    rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
    
    
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
    
    orb5(6)=0;
    [orb6, deltaV6, deltaT6, thetaman5] = cambioAnomaliaPericentro(orb5, orbFin(5));
    dVtot=dVtot+deltaV6;
    dTtot=dTtot+deltaT6;
    deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));
    dTtot=dTtot +deltaT7;
    
    dTvect=[dTvect, dTtot];
    dVvect=[dVvect, deltaV3];
    dV2Vect=[dV2Vect, deltaV2];
    
    

end
rAllontanamento=30000:2000:1000000;
figure(2)
plot(rAllontanamento, dV2Vect, rAllontanamento,dVvect)
%[ax,ay1,ay2]=plotyy(rAllontanamento, dVvect, rAllontanamento, dTvect/3600);
%title('dV and dT over apoapsis radius, with omega=289.5°')
%ylim(ax(1), [0,5])

grid on
legend('dV tangente [km/s]', 'dV piano [km/s]')

%% opt omega
dVvect=[];
dTvect=[];
rAllontanamento=5e4;

for omega=270:0.1:300
    dTtot=0;
    dVtot=0;
    
    rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
    rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
    rAllontanamento=0.5e5;
    
    [orb1, deltaV1, deltaT1, thetaman1] = cambioAnomaliaPericentro(orbIniz, omega); % 290 scelta arbitraria, otiimo sembra tra tra 289 e 291
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
    
    orb5(6)=0;
    [orb6, deltaV6, deltaT6, thetaman5] = cambioAnomaliaPericentro(orb5, orbFin(5));
    dVtot=dVtot+deltaV6;
    dTtot=dTtot+deltaT6;
    
    % orb6 == orbFin a meno del tratto ancora da percorrere -->deltaT7
    
    deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));
    dTtot=dTtot +deltaT7;
    
    dTvect=[dTvect, dTtot];
    dVvect=[dVvect, dVtot];
    
    

end
omega=270:0.1:300;
figure(3)
[ax,ay1,ay2]=plotyy(omega, dVvect, omega, dTvect/3600);
title('dV and dT over omega, with r apoapsis = 5e4 km')
ylim(ax(1), [8.5,9.5])

grid on
legend('dV [km/s]', 'dT [h]')

%%
% orb6 == orbFin a meno del tratto ancora da percorrere -->deltaT7

deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));
%dTtot=dTtot +deltaT7;

t=duration(0,0,dTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
dV=dVtot
    


%% STRATEGY 3


%% STRATEGY 4

[orbTrasf, dV1, dV2, dT] = trasfDir(orbIniz, orbFin); 

earth3D(1)
orbit3D(orbIniz, 1)
orbit3D(orbTrasf,1)
orbit3D(orbFin, 1)

deltaV = dV1 + dV2

%% prova manovra impulsiva con trasf dir

iFin = 70; 
RAANFin = 50; 

[orb2, dV, dT, thetaMan] = cambioInclinazione(orbIniz, iFin, RAANFin);

orb1 = orbIniz; 
orb1(6) = thetaMan; 

[orbTrasf, deltaV1, deltaV2, deltaT, thetaPlot1, thetaPlot2] = trasfDir(orb1,orb2);

earth3D(1);
%%
orbit3D(orbIniz,1)
%%
orbit3D(orb2,1); 
%%
earth3D(2); 
orbit3D(orb1, 2); 
%%
orbit3D(orb2, 2); 
%%
orbit3D(orbTrasf, 2); 
%%
clc
dV
deltaV1 + deltaV2



%% SHAPE-PLANE-W  (pa)   IN PRESENTAZIONE
clc
close all
orbFin(1)/orbIniz(1);   % se < 11.94 non conviene biellittica

orbFin1  = [orbFin(1);orbFin(2);orbIniz(3);orbIniz(4);orbIniz(5);orbIniz(6)];
 [deltaVtot1, deltaV1, deltaV2, orbTrasf, deltaTtot1, deltaT1, deltaT2, thetaMan2] = manovraBitangenteEllittica(orbIniz, orbFin1, 'pa');
[orbFin2, deltaV3, deltaT3, thetaMan3] = cambioInclinazione(orbFin1, orbFin(3), orbFin(4));
[orbFin3, deltaV4, deltaT4, thetaman4] = cambioAnomaliaPericentro(orbFin2, orbFin(5));

deltaVolo = tempoVolo(orbFin, orbFin3(6), orbFin(6));
deltaVtot = deltaVtot1+deltaV3+deltaV4
deltaTVolo=tempoVolo(orbFin3, orbFin3(6), orbFin(6));
deltaTTot = deltaTtot1+deltaT3+deltaT4+deltaTVolo
deltaTTot = deltaTtot1+deltaT3+deltaT4+deltaVolo;
t = duration(0,0,deltaTTot)
Title = 'STRATEGY SHAPE-PLANE-W'

Maneuv_name=[{'initial point'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'change of plane'};{'change of P arg'};...
    {'final point'}];
thetaStory = [orbIniz(6), thetaMan2, thetaMan2, 180, 180, thetaMan3, orbFin2(6),thetaman4, orbFin3(6), orbFin(6) ];
plotOrbit([orbIniz, orbTrasf,orbFin1, orbFin2,orbFin3],thetaStory,[deltaT1, deltaT2, deltaT3, deltaT4, deltaTVolo],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4])


%% SHAPE-PLANE-W  (ap)
clc
close all
orbFin(1)/orbIniz(1);   % se < 11.94 non conviene biellittica

orbFin1  = [orbFin(1);orbFin(2);orbIniz(3);orbIniz(4);orbIniz(5);orbIniz(6)];
 [deltaVtot1, deltaV1, deltaV2, orbTrasf, deltaTtot1, deltaT1, deltaT2, thetaMan2] = manovraBitangenteEllittica(orbIniz, orbFin1, 'ap');
 orbTrasf(5) = wrapTo360(orbTrasf(5)+180);
 [orbFin2, deltaV3, deltaT3, thetaMan3] = cambioInclinazione(orbFin1, orbFin(3), orbFin(4));
[orbFin3, deltaV4, deltaT4, thetaman4] = cambioAnomaliaPericentro(orbFin2, orbFin(5));

deltaVolo = tempoVolo(orbFin, orbFin3(6), orbFin(6));
deltaVtot = deltaVtot1+deltaV3+deltaV4
deltaTTot = deltaTtot1+deltaT3+deltaT4+deltaVolo;
t = duration(0,0,deltaTTot)
Title = 'STRATEGY strana'
Maneuv_name=[{'initial point'};...
    {'first bitangent maneuver'};{'second bitangent maneuver'};...
    {'change of plane'};{'change of P arg'};...
    {'final point'}];
thetaStory = [orbIniz(6), 180, 0, 180, 0, thetaMan3, orbFin2(6),thetaman4, orbFin3(6), orbFin(6) ];
plotOrbit([orbIniz, orbTrasf,orbFin1, orbFin2,orbFin3],thetaStory,[deltaT1,  deltaT2, deltaT3, deltaT4, deltaVolo],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2,  deltaV3, deltaV4])


%% PLANE - SHAPE - W


%% 	CIRCOLARIZATION


[rFin, vFin] = PFtoGE(orbFin, mu); 

h1 = cross(rIniz, vIniz);  %momento angolare prima orbita
h2 = cross(rFin, vFin); %momento angolare seconda orbita

N = cross(h1, h2); 
N = N/norm(N);  %linea intersezione piani due orbite

%----------------CIRCOLARIZZO ORBITA-------------------------------------------
rAIniz = orbIniz(1) * (1 + orbIniz(2));  %raggio apocentro orbita iniziale

[orb2, dV2 , dT2] = manovraTangente(orbIniz, rAIniz, 'apo');   %circolarizzo al pericentro
thetaMan1 = 180; %posizione prima manovra

[e2, v2 ] = PFtoGE([orb2(1), orb2(2), orb2(3), orb2(4), orb2(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

h2 = cross(e2, v2); %momento della q.tà di moto orb 2


thetaMan2 = acosd( dot(e2, N)/norm(e2) );   %posizione seconda manovra

if dot(cross(e2, N), h2) < 0   
    thetaMan2 = 360 - thetaMan2; 
end

if wrapTo360((thetaMan2 + 180) - orb2(6)) < wrapTo360(thetaMan2 - orb2(6))  %scelgo di manovrare nel punto più vicino
    thetaMan2 = wrapTo360(thetaMan2 + 180); 
end

%-----------------------------Alzo apocentro nella dir giusta--------------------------------

rPFin = orbFin(1)*(1 - orbFin(2)); %calcolo il raggio al pericentro dell'orbita finale
a3 = (orb2(1) + rPFin)/2;   %voglio che l'orbita 3 abbia come apocentro un raggio uguale a quello del pericentro dell'orbita 2
[orb3, dV3, dT3] = manovraTangente(orb2, a3, "gen", thetaMan2);  

dT32 = tempoVolo(orb3, orb3(6), orb3(6) + 90);   
orb3(6) = orb3(6) + 90; %mi sposto avanti di 90 gradi e calcolo il tempo che è passato

%--------------------------Cambio piano----------------------------------

[orb4, dV4, dT4, thetaMan4] = cambioInclinazione(orb3, orbFin(3), orbFin(4)); 

%-------------------------Circolarizzazione-----------------

[orb5, dV5 , dT5] = manovraTangente(orb4, rPFin, 'apo');   %circolarizzo al pericentro
thetaMan5 = 180; 

%---------------Manovra finale per raggiungere l'orbita----------------


[e5, v5 ] = PFtoGE([orb5(1), orb5(2), orb5(3), orb5(4), orb5(5), 0], mu);   %calcolo la direzione e il verso dell'eccentricità come se fosse il vettore che punta alla posizione in theta=0

[eFin, ~] = PFtoGE([orbFin(1), orbFin(2), orbFin(3), orbFin(4), orbFin(5), 0], mu);


h5 = cross(e5, v5); %momento della q.tà di moto orb 2


thetaMan6 = acosd( dot(e5, eFin)/(norm(e5)*norm(eFin)) );   %posizione seconda manovra

if dot(cross(e5, eFin), h5) < 0   
    thetaMan6 = 360 - thetaMan6; 
end

%--------------chiusura finale---------------------------------
[orb6, dV6, dT6] = manovraTangente(orb5, orbFin(1), "gen", thetaMan6); 


%%
Title = 'STRATEGY 4 - Circolarization';
Maneuv_name=[{'initial point'};{'Circolarization 1'};{'Rise Apoapsis'};...
    {'Plane change'};{'Circolarization 2'};{'Rise Apoapsis'}; {'Final Point'}];
close all

plotOrbit([orbIniz , orb2 , orb3 ,orb4 , orb5, orb6],...
            [orbIniz(6), thetaMan1,     orb2(6), thetaMan2,    orb3(6)-90,thetaMan4,   orb4(6),thetaMan5,   orb5(6),thetaMan6,  orb6(6), orbFin(6)  ],...
            [dT2, dT3, dT32 + dT4, dT5, dT6, tempoVolo(orb6, orb6(6), orbFin(6))],...
            Title,Maneuv_name,'stat',0,...
            [0, dV2, dV3, dV4, dV5, dV6]); 



%%
earth3D(2); 
orbit3D(orbIniz, 2); 
%%
orbit3D(orb2, 2); 
%%
orbit3D(orb3, 2); 
%%
orbit3D(orb4, 2); 
%% 
orbit3D(orb5, 2); 
%%
orbit3D(orb6, 2); 
%%
orbit3D(orbFin,2); 



%%
deltaV = dV2 + dV3 + dV4 + dV5 + dV6
deltaT = dT2 + dT3 + dT4 + dT5 + dT6

%%



%%  PLANE-SHAPE-W  (CIOE QUELLA DI TOMMI SENZA CAMBIO ANOMALIA PERICENTRO INIZIALE)
% UN PO' PEGGIORE DI QUELLA DI TOMMI, 
% PIU DELTAV E DELTAT

close all
dTtot=0;
dVtot=0;

rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
rAllontanamento=0.5e5;

% [orb1, deltaV1, deltaT1, thetaman1] = cambioAnomaliaPericentro(orbIniz, 290); % 290 scelta arbitraria, otiimo sembra tra tra 289 e 291
% dVtot=dVtot+deltaV1;
% dTtot=dTtot+deltaT1;

orbIniz(6) = orbIniz(6);
[orb2, deltaV2, deltaT2, thetaman2] = manovraTangente(orbIniz, (rPIniz+rAllontanamento)/2, 'per');
dVtot=dVtot+deltaV2;
dTtot=dTtot+deltaT2;
orb2(6) = orb2(6)+180;
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

deltaT7=tempoVolo(orb6, orb6(6), orbFin(6));

close all
Title = 'STRATEGY 2 - AP';
Maneuv_name=[{'initial point'};{'tangent burn'};...
    {'inclination change'};{'1st bitangent burn'};...
    {'2nd bitangent burn'};{'1nd change of P arg'};{'final point'}];          
                                                            % |percorro orbIniz    | percorro orb1     | percorro orb2     | percorro orb3     | %percorro orb4     |%percorro orb5  percorro orb6
plotOrbit([orbIniz,  orb2 , orb3 ,orb4 , orb5, orbFin],[orbIniz(6), 360, orb2(6)-180, thetaman3, orb3(6), thetaman4,        180, 0 ,            0,thetaman5, orb6(6), orbFin(6) ],[deltaT1, deltaT2, deltaT3, deltaT4, deltaT5, deltaT6, deltaT7],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4, deltaV5, deltaV6])

dTtot=dTtot +deltaT7;

t=duration(0,0,dTtot) %trascuro tempo per raggiungere p.to finale esatto, fermo il conto all'inserzione nell'orbita finale
dV=dVtot

%%

%% opt rAllontanamento STRAT 5

dVvect=[];
dTvect=[];
i=2500;

for rAllontanamento=30000:i:100000
    dTtot=0;
    dVtot=0;

    rPIniz=orbIniz(1)*(1-orbIniz(2)^2)/(1+orbIniz(2));
    rAFin=orbFin(1)*(1-orbFin(2)^2)/(1+orbFin(2));
    rAIniz=orbIniz(1)*(1+orbIniz(2));
    

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


    dTvect=[dTvect, dTtot];
    dVvect=[dVvect, dVtot];
    
    

end
rAllontanamento=30000:i:100000;
figure(2)
[ax,ay1,ay2]=plotyy(rAllontanamento, dVvect, rAllontanamento, dTvect/3600);
title('dV and dT over apoapsis radius')
ylim(ax(1), [5,10])

grid on
legend('dV [km/s]', 'dT [h]')





%% PLANE - SHAPE - W  (fa schifo, perchè cambio piano vicino al pianeta)
close all
clc

[orb1, deltaV1, deltaT1, thetaman1] = cambioInclinazione(orbIniz, orbFin(3), orbFin(4));
orb3 = orbFin;
orb3(5) = orb1(5);
orb3(6) = 180;
[deltaVtot1, deltaV2, deltaV3, orbTrasf, deltaTtot1, deltaT2, deltaT3, thetaman2] = manovraBitangenteEllittica(orb1, orb3, 'pa');
[orb4, deltaV4, deltaT4, thetaman3] = cambioAnomaliaPericentro(orb3, orbFin(5));
deltaVolo = tempoVolo(orbFin, orb4(6), orbFin(6));

deltaTtot = deltaTtot1+deltaT1+deltaT4+deltaVolo
deltaVtot = deltaVtot1+deltaV1+deltaV4
t = duration(0,0,deltaTtot)


Title = 'STRATEGY PSW - AP';
Maneuv_name=[{'initial point'};{'inclination change'};...
    {'1st bitangent burn'};...
    {'2nd bitangent burn'};{' change of P arg'};{'final point'}];          
                                                            % |percorro orbIniz    | percorro orb1     | percorro orb2     | percorro orb3     | %percorro orb4     |%percorro orb5  percorro orb6
plotOrbit([orbIniz,  orb1 ,orbTrasf, orb3 , orbFin],[orbIniz(6), thetaman1, orb1(6), 0, 0, 180, 180, thetaman3, orb4(6),  orbFin(6)],[deltaT1, deltaT2, deltaT3, deltaT4, deltaVolo],Title,Maneuv_name,'stat',0,[0, deltaV1, deltaV2, deltaV3, deltaV4])



