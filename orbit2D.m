function [] = orbit2D(pfPar, nFig, firstTime)
%orbit2D(pfPar, nFig, firstTime): permette di stampare in 2D l'orbita di un corpo dati
%i parametri nel SdR Perifocale.
%
%   INPUT:
%       pfPar: parametri nel SdR Perifocale: nell'ordine: [a, e, omega, theta]
%       nFig: ID della figura su cui andare a disegnare l'orbita
%       firstTime: booleano per sapere se è la prima orbita che si disegna
%       sulla data figura, in modo da poter stampare più orbite coplanari
%       nella stessa immagine
%   L'asse x della figura è allineato con la linea dei nodi, che risulta
%   costante per orbite coplanari.    
    
    a = pfPar(1); 
    e = pfPar(2); 
    omega = pfPar(3); 
    theta = pfPar(4); 
    
    thetaV = linspace(0, 360, 200);                               % vettore degli angoli
    p = a*(1-e^2);                                                % semilato retto
    rV = p./(1 + e*cosd(thetaV));                                 % punti dell'ellisse

    xOrb = rV.*cosd(thetaV); 
    yOrb = rV.*sind(thetaV); 
    r2D = [xOrb ; yOrb];

    Rot2D = [cosd(omega) -sind(omega); sind(omega) cosd(omega)];  % matrice di rotazione per allineare l'asse x con la linea dei nodi

    r2D = Rot2D * r2D;                                            % rotazione ellisse

    r0 = Rot2D* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta)]; % posizione satellite
    rP = Rot2D* (p/(1+e))*[1; 0];                                 % posizione pericentro
    rA = Rot2D* (p/(1-e))*[-1; 0];                                % posizione apocentro

    figure(nFig); 
    plot(r2D(1, :),r2D(2, :));                                    % plot orbit
    
    if firstTime                                                  % se è la prima volta che apre la figura disegna la terra
        rt=6371;                                                  % raggio della Terra [km]
        rectangle('Position', [-rt,-rt, 2*rt, 2*rt], ...
            'Curvature', [1 1], 'FaceColor','b');                 % plot terra in scala
        hold on
        grid on;
        title("2D ORBIT");
        xlabel("Line of nodes N [km]");
        ylabel("y [km]");
    end
    
    plot(r0(1), r0(2), 'hr');                                     % plot satellite
    plot(rA(1), rA(2), '.r', 'LineWidth', 4);                     % plot apoapsis
    plot(rP(1), rP(2), '.r', 'LineWidth', 4);                     % plot periapsis
    axis equal;
    xlim([-36e3,+36e3])
    ylim([-36e3,+36e3])
end

