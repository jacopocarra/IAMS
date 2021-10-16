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

    plot3(r3D(1,:),r3D(2,:),r3D(3, :));                       % plot orbita
    plot3(r0(1), r0(2), r0(3),  'hr');                           % plot satellite
    plot3(rA(1), rA(2), rA(3), '.r');                            % plot apocentro
    plot3(rP(1), rP(2), rP(3), '.r');                            % plot pericentro
    legend('Orbita','Satellite','Apocentro','Pericentro')
    view(45,15)                                                  % impostazioni visualizzazione
    axis equal

    grid on;


end

