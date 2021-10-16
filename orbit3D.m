function [] = orbit3D (pfPar, nFig)

a = pfPar(1);
e = pfPar(2);
i = pfPar(3);
RAAN = pfPar(4);
omega = pfPar(5);
theta = pfPar(6);

theta_v = linspace(0, 360, 200);                             % vettore angoli da 0 a 360
p = a*(1-e^2);                                               % semilato retto
r_v = p./(1 + e*cosd(theta_v));                              % punti dell'ellisse

x_orb = r_v.*cosd(theta_v);                                  % punti x dell'ellisse
y_orb = r_v.*sind(theta_v);                                  % punti y dell'ellisse
r_2D = [x_orb ; y_orb; zeros(1, 200)];                       % ellisse nel piano

R = RotPF2GE(i, RAAN, omega);                                % matrice di rotazione da perifocale a geocentrico

r_3D = R*r_2D;                                               % rotazione ellisse nello spazio

r0 = R* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta); 0]; % posizione satellite
rP = R* (p/(1+e))*[1; 0; 0];                                 % posizione pericentro
rA = R* (p/(1-e))*[-1; 0; 0];                                % posizione apocentro


figure(nFig);
hold on;

plot3(r_3D(1,:),r_3D(2,:),r_3D(3, :));                       % plot orbita
plot3(r0(1), r0(2), r0(3),  'hr');                           % plot satellite
plot3(rA(1), rA(2), rA(3), '.r');                            % plot apocentro
plot3(rP(1), rP(2), rP(3), '.r');                            % plot pericentro

view(45,15)                                                  % impostazioni visualizzazione
axis equal

grid on;
end

