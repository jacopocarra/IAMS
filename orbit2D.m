function [] = orbit2D(pfPar, nFig, firstTime)
    
    a = pfPar(1); 
    e = pfPar(2); 
    omega = pfPar(3); 
    theta = pfPar(4); 
    
theta_v = linspace(0, 360, 200);                              % vettore degli angoli
p = a*(1-e^2);                                                % semilato retto
r_v = p./(1 + e*cosd(theta_v));                               % punti dell'ellisse

    x_orb = r_v.*cosd(theta_v); 
    y_orb = r_v.*sind(theta_v); 
    r_2D = [x_orb ; y_orb];

Rot2D = [cosd(omega) -sind(omega); sind(omega) cosd(omega)];  % matrice di rotazione per allineare l'asse x con la linea dei nodi

r_2D = Rot2D * r_2D;                                          % rotazione ellisse

r0 = Rot2D* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta)]; % posizione satellite
rP = Rot2D* (p/(1+e))*[1; 0];                                 % posizione pericentro
rA = Rot2D* (p/(1-e))*[-1; 0];                                % posizione apocentro

    figure(nFig); 
plot(r_2D(1, :),r_2D(2, :));                                  % plot orbit
    
if firstTime                                                  % se è la prima volta che apre la figura disegna la terra
rt=6371;                                                      % raggio della Terra [km]
    rectangle('Position', [-rt,-rt, 2*rt, 2*rt], ...
'Curvature', [1 1], 'FaceColor','b');                         % plot terra in scala
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

