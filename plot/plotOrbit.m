function [] = plotOrbit(orbVect,thetaStory,DeltaTStory,Title,ManeuvName,type,vVect,dvVect)

global fps
global myMovie;
global myFig;

myFig = figure;
mu = 398600;
EarthAngVel = 7.2722052e-5;         % velocità angolare terra
font.Size = 8.5;
marker.size = 8;
marker.sizeDyn = 6;
line.Width = 1.2;
leg.Position = [0.8 0.8 0 0]; % indicazione posizione legenda
dt = 60;            % intervallo di tempo, deve stare basso per non perdere informazioni
N = size(orbVect,2);       % numero di colonne del orbVect
set(gcf,'color','w');
grid on;
axis auto;
axis equal;
axis vis3d;
hold on;
axis on;

switch lower(type)
    case {'dyn'}   % caso dinamico
        tVect = 0:dt:10000000;
        L = length(tVect);
        deltaVvect = [];
        [earth] = earth3D(1);
        P1 = earth;
        timeSec = 0;
        timeMin = 0;
        timeHour = 0;
        dVTotPlot = 0;
        
        for ctr = 1:N
            orb = orbVect(:,ctr);
            thetaOrb = thetaStory((2*ctr)-1:2*ctr);
            periodPlot = 2*pi*sqrt((orb(1)^3/mu)/dt);
            colormap.Orbit = summer(floor(periodPlot));
            colormap.Marker = hot(N+2);
            [deltaT] = tempoVolo(orb,thetaOrb(1),thetaOrb(2));     % calcolo il tempo di quest'orbita
            if thetaOrb(1) == thetaOrb(2)
                deltaT = 0;
            else
                tOrbVect = 0:dt:deltaT;    % vettore tempi orbita
                L1 = length(tOrbVect);
                
                r = [];
                v = [];
                velocNorm = [];
                
                for x = 1:L1
                    [rr, vv] = EqMoto(orb, thetaOrb(1), tOrbVect(x));    % CALCOLA r E v IN OGNI PUNTO DELL'ORBITA
                    r = [r, rr];
                    v = [v, vv];
                    velocNorm = [velocNorm, norm(vv)];
                end
                if ctr == 1
                    pointLegend(ctr) = plot3(r(1,1),r(2,1),r(3,1),'d',...
                                              'MarkerSize',marker.sizeDyn,'MarkerFaceColor',...
                                              colormap.Marker(ctr,:));
                    legend(pointLegend(ctr), ManeuvName(ctr), 'AutoUpdate', 'off', 'Location', leg.Position,...
                            'FontSize', font.Size);
                    dVTotPlot = 0;
                    str3 = sprintf("DV TOT:\n   %2.4f  [km/s]", dVTotPlot);
                    annotation('textbox',[.75 .3 0 0],'String',str3,...
                        'FitBoxToText','on','FontSize',font.Size,'BackgroundColor','w');
                    myMovie(1) = getframe(myFig);
                end
                if  ctr ~= 1
                    orb = orbVect(:,ctr);
                    orb(6) = thetaStory(2*(ctr)-1);
                    [rr,vv] = PFtoGE(orb,mu);
                    pointLegend(ctr) = plot3(r(1,1),r(2,1),r(3,1),'d',...
                                              'MarkerSize',marker.sizeDyn,'MarkerFaceColor',...
                                              colormap.Marker(ctr,:));
                    legend(pointLegend(1:ctr), ManeuvName(1:ctr), 'AutoUpdate', 'off', 'Location', leg.Position,...
                            'FontSize', font.Size);
                    dVTotPlot = dVTotPlot + norm(dvVect(:,ctr));
                    str3 = sprintf("DV TOT:\n   %2.4f  [km/s]", dVTotPlot);
                    annotation('textbox',[.75 .3 0 0],'String',str3,...
                        'FitBoxToText','on','FontSize',font.Size,'BackgroundColor','w');
                    myMovie(end+1) = getframe(myFig);
                end   
                L3 = length(r);
                k = 2;
             while k < L3
                    colorIndex = floor((periodPlot-2)*(velocNorm(k)-min(velocNorm))/...
                        (max(velocNorm)-min(velocNorm))+1);
                    stepColor = colormap.Orbit(colorIndex,:);
                    plot3(r(1,k-1:k),r(2,k-1:k),r(3,k-1:k),...
                        'color',stepColor,'LineWidth',line.Width);
                    sat = plot3(r(1,k),r(2,k),r(3,k),'-o','MarkerFaceColor','r',...
                        'MarkerEdgeColor','k');
                    % rotate(P1,[0 0 1],rad2deg(EarthAngVel*dt),[0 0 0]);
                    
                    if r(2,k) > 0
                        Azimut = acos(r(1,k)/norm(r(:,k)));
                    else
                        Azimut = 2*pi - acos(r(1,k)/norm(r(:,k)));
                    end
                    
                    Azimut = Azimut*180/pi + 90;
                    if Azimut > 270
                        Azimut = (540-Azimut);
                    end
                    

                    Azimut = 180 + 90*(Azimut/450);
                    view(Azimut,20);
                    timeSec = timeSec + dt;   % si bugga se dt>60
                    
                    if timeSec >= 60
                        timeSec = timeSec - 60;
                        timeMin = timeMin + 1;
                    end
                    
                    if timeMin >= 60
                        timeMin = timeMin - 60;
                        timeHour = timeHour +1;
                    end
                    rrPlot = [r(1,k);r(2,k);r(3,k)];
                    vvPlot = [v(1,k);v(2,k);v(3,k)];
                    [orbPlot] = GEtoPF(rrPlot,vvPlot,mu);
                    vTheta = sqrt(mu/(orbPlot(1)*(1-orbPlot(2)^2)))*(1+(orbPlot(2)*cos(orbPlot(6))));
                    vR = sqrt(mu/(orbPlot(1)*(1-orbPlot(2)^2)))*(orbPlot(2)*sin(orbPlot(6)));
                    str1 = sprintf("  Time:  \n%d  [h]\n%d  [min]",timeHour,timeMin);
                    annotation('textbox',[.75 .65 0 0],'String',str1,...
                        'FitBoxToText','on','FontSize',font.Size,'BackgroundColor','w');
                    str2 = sprintf("V_t:  %2.4f  [km/s]\nV_r: %2.4f  [km/s]", vTheta, vR);
                    annotation('textbox',[.75 .5 0 0],'String',str2,...
                        'FitBoxToText','on','FontSize',font.Size,'BackgroundColor','w');
                    drawnow limitrate;
                    k = k+1;
                    myMovie(end+1) = getframe(myFig);
                    delete(sat);
             end
             if ctr == N
                 orb(6) = thetaOrb(end);
                [rr, vv] = PFtoGE(orb, mu);
                tTot = sum(DeltaTStory);    % plotto il tempo totale 'barando'
                h = round(tTot/3600);
                minut = round(60*((tTot/3600)-h));
                str1 = sprintf("  Time:  \n%d  [h]\n%d  [min]",h,minut);
                    annotation('textbox',[.75 .65 0 0],'String',str1,...
                        'FitBoxToText','on','FontSize',font.Size,'BackgroundColor','w');
                pointLegend(ctr+1) = plot3(rr(1),rr(2),rr(3),'d',...
                        'MarkerSize',marker.sizeDyn,'MarkerFaceColor',...
                        colormap.Marker(ctr+1,:));
                legend(pointLegend(1:ctr+1),ManeuvName(1:ctr+1),'AutoUpdate',...
                        'off','Location',leg.Position,'FontSize',font.Size);
                myMovie(end+1) = getframe(myFig);
             end
            end
        end
            case {'stat'} % plot statico
        grid off;
        axis off;
        [earth]=earth3D(2);
        title(Title,'FontSize',10);
        pointLegend = [];
        
        dth = pi/180; % delta th per plottare l'orbita (1 grado)
        L = (2*pi)/dth;
        colormap.Orbit = summer(L); % setto i colori che cambiano con v
        colormap.Marker = hot(N+2);
        
        DeltaVVect = [];
        
        % plotto orbite
        for ctr = 1:N
            orb = orbVect(:,ctr); % setto orbita corrente
            thethaOrb = thetaStory((ctr*2)-1:ctr*2); % setto anomalia vera iniziale e finale per l'orbita di riferimento
            if thethaOrb(2) < thethaOrb(1)
                thethaOrb(2) = thethaOrb(2) + 2*pi;
            end
            
            thetaVectTot = thethaOrb(1):dth:thethaOrb(1)+2*pi;
            L = length(thetaVectTot);
            
            if ctr == 1
                % plotto punto iniziale
                orb(6) = thethaOrb(1);
                [rr,vv] = PFtoGE(orb,mu);
                pointLegend(ctr) = plot3(rr(1),rr(2),rr(3),'d',...
                    'MarkerSize',marker.size,'MarkerFaceColor',...
                    colormap.Marker(1,:));
                legend(pointLegend(1:ctr),ManeuvName(1:ctr),'AutoUpdate',...
                    'off','Location',leg.Position,'FontSize',font.Size);
            end
            
            rrVect = [];
            vVect = [];
            vNorm = [];
            
            % calcola orbita
            for k = 1:L
                orb(6) = wrapTo2Pi(thetaVectTot(k));   % lo riporta sempre entro 2pi
                [rr,vv] = PFtoGE(orb,mu);
                rrVect = [rrVect,rr];
                vVect = [vVect,vv];
                vNorm = [vNorm;norm(vv)];
            end
            
            vmax = max(vNorm);
            vmin = min(vNorm);
            
            k = 2;
            
            % plotto orbita
            while k <= L
                
                if thetaVectTot(k)<=thethaOrb(2) % plotto parte di orbita che fa
                    colorIndex = floor((L-2)*(vNorm(k)-vmin)/...
                        (vmax-vmin) + 1);
                    stepColor = colormap.Orbit(colorIndex,:);
                    plot3(rrVect(1,k-1:k),rrVect(2,k-1:k),...
                        rrVect(3,k-1:k),'color',stepColor,...
                        'LineWidth',line.Width);
                    k = k+1;
                    
                else % plotto parte di orbita che non fa (tratteggiata)
                    colorIndex = floor(((L-2))*(vNorm(k)-vmin)/...
                        (vmax-vmin) + 1);
                    stepColor = colormap.Orbit(colorIndex,:);
                    plot3(rrVect(1,[k-1,k]),rrVect(2,[k-1,k]),...
                        rrVect(3,[k-1,k]),'-.','color',...
                        stepColor,'LineWidth',...
                        0.5);
                    k = k+2;
                    
                end
            end
            
            orb(6) = thetaStory(2*ctr);
            [rr,vv] = PFtoGE(orb,mu);
            vPrevious = vv;
            

            
            if ctr == N % plotto ultimo punto con legenda
                orb(6) = thethaOrb(end);
                [rr,vv] = PFtoGE(orb,mu);
                pointLegend(end+1) = plot3(rr(1),rr(2),rr(3),'d',...
                    'MarkerSize',marker.size,'MarkerFaceColor',...
                    [.99, .73, .168]);
                legend(pointLegend(1:end),ManeuvName(1:ctr),'AutoUpdate',...
                    'off','Location',leg.Position,'FontSize',font.Size);
                quiver3(rr(1),rr(2),rr(3),vv(1),vv(2),vv(3),300,...
                    'color','k','lineWidth',1,'MaxHeadSize',7);
            end
            
        end
                tTot = sum(DeltaTStory);
                h = round(tTot/3600);
                minut = round(60*((tTot/3600)-h));
                str1 = sprintf("  Time:  \n%d  [h]\n%d  [min]",h,minut);
                    annotation('textbox',[.75 .65 0 0],'String',str1,...
                        'FitBoxToText','on','FontSize',font.Size,'BackgroundColor','w');
                    view(45,20)
end

writeMP4Movie(myMovie, "strat 5");
end

        
        
            
            
            
            
            