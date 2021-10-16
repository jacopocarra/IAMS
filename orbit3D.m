function [] = orbit3D (pfPar, nFig)
    a = pfPar(1); 
    e = pfPar(2); 
    i = pfPar(3); 
    RAAN = pfPar(4); 
    omega = pfPar(5); 
    theta = pfPar(6); 
    
    theta_v = linspace(0, 360, 200); %array of angles
    p = a*(1-e^2); 
    r_v = p./(1 + e*cosd(theta_v)); % ellipse points

    x_orb = r_v.*cosd(theta_v); 
    y_orb = r_v.*sind(theta_v); 
    r_2D = [x_orb ; y_orb; zeros(1, 200)]; 

    R = RotPF2GE(i, RAAN, omega); 

    r_3D = R*r_2D; 
    
    r0 = R* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta); 0]; %satellite position 
    rP = R* (p/(1+e))*[1; 0; 0];
    rA = R* (p/(1-e))*[-1; 0; 0];
    
    
    figure(nFig); 
    hold on; 
    
    plot3(r_3D(1,:),r_3D(2,:),r_3D(3, :)); %plot orbit
    plot3(r0(1), r0(2), r0(3),  'hr'); %plot satellite
    plot3(rA(1), rA(2), rA(3), '.r'); %plot apoapsis
    plot3(rP(1), rP(2), rP(3), '.r'); %plot periapsis

    
    axis equal

    grid on; 
end

