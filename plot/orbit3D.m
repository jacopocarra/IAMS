function [] = orbit3D (pfPar, nFig)
%orbit3D(pfPar, nFig): permette di stampare in 3D l'orbita di un corpo dati
%i parametri nel SdR Perifocale.
%
%   INPUT:
%       pfPar: parametri nel SdR Perifocale: nell'ordine: [a, e, i, RAAN,
%       omega, theta]
%       nFig: ID della figura su cui andare a disegnare l'orbita
%   ATTENZIONE: prima di chiamare questa funzione è consigliato chiamare
%       earth3D in modo da stampare anche la Terra come riferimanto

    a = pfPar(1);
    e = pfPar(2);
    i = pfPar(3);
    RAAN = pfPar(4);
    omega = pfPar(5);
    theta = pfPar(6);

    thetaV = linspace(0, 360, 200);                             % vettore angoli da 0 a 360
    p = a*(1-e^2);                                               % semilato retto
    rV = p./(1 + e*cosd(thetaV));                              % punti dell'ellisse

    xOrb = rV.*cosd(thetaV);                                  % punti x dell'ellisse
    yOrb = rV.*sind(thetaV);                                  % punti y dell'ellisse
    r2D = [xOrb ; yOrb; zeros(1, 200)];                       % ellisse nel piano

    R = RotPF2GE(i, RAAN, omega);                                % matrice di rotazione da perifocale a geocentrico

    r3D = R*r2D;                                               % rotazione ellisse nello spazio

    r0 = R* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta); 0]; % posizione satellite
    rP = R* (p/(1+e))*[1; 0; 0];                                 % posizione pericentro
    rA = R* (p/(1-e))*[-1; 0; 0];                                % posizione apocentro


    figure(nFig);
    hold on;
    plot3(r3D(1,:),r3D(2,:),r3D(3, :), 'LineWidth', 1);       % plot orbita
    
    
% DA SCOMMENTARE DUE LINEE SUCCESSIVE SE SI VUOLE METTERE MARKER SATELLITE
    plot3(r0(1), r0(2), r0(3),  'd', 'MarkerSize', 8, 'MarkerFaceColor', [0.8500 0.3250 0.0980], 'MarkerEdgeColor', [0 0.4470 0.7410]);                           % plot satellite
    text(r0(1)-1000, r0(2)-1000, r0(3)-1000,'Satellite','FontSize',12,'color',[0.8500 0.3250 0.0980])

 
 
    % plot3(rA(1), rA(2), rA(3), '.r');                            % plot apocentro
     plot3(rP(1), rP(2), rP(3), '.r');                            % plot pericentro
    
    view(45,15)                                                  % impostazioni visualizzazione
 
     for i=1:199
        if r3D(3,i)<=0 && r3D(3,i+1)>0
             plot3(r3D(1,i), r3D(2,i), r3D(3,i), 'm^');         % plotta nodo ascendente (approssimato)
%         else
%            if r3D(3,i)>=0 && r3D(3,i+1)<0
%                plot3(r3D(1,i), r3D(2,i), r3D(3,i), 'mv');         % plottanodo discendente (approssimato)
%            end
         end
     end
    
    
%     if norm(rA)<norm(rP)
%         plot3(rA(1), rA(2), rA(3), '.r');                            % plot apocentro
%     else
%         plot3(rP(1), rP(2), rP(3), '.r');                            % plot pericentro
%     end


    axis equal

    grid on;


end

