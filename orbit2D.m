function [] = orbit2D(a, e, omega, theta, nEl)

    theta_v = linspace(0, 360, nEl); %array of angles
    p = a*(1-e^2); 
    r_v = p./(1 + e*cosd(theta_v)); % ellipse points

    x_orb = r_v.*cosd(theta_v); 
    y_orb = r_v.*sind(theta_v); 
    r_2D = [x_orb ; y_orb];

    Rot2D = [cosd(omega) -sind(omega); sind(omega) cosd(omega)]; %rotation matrix to allign x-axis to line of nodes n

    r_2D = Rot2D * r_2D;

    r0 = Rot2D* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta)]; %satellite position 
    rP = Rot2D* (p/(1+e))*[1; 0];   %periapsis position
    rA = Rot2D* (p/(1-e))*[-1; 0];  %apoapsis position

    figure(1); 
    plot(r_2D(1, :),r_2D(2, :)); %plot orbit
    hold on
    plot(r0(1), r0(2), 'hr'); %plot satellite
    plot(0,0,'ob','LineWidth', 4); %plot earth
    plot(rA(1), rA(2), '.r'); %plot apoapsis
    plot(rP(1), rP(2), '.r'); %plot periapsis

    grid on; 
    title("2D ORBIT"); 
    xlabel("Line of nodes N [km]"); 
    ylabel("y [km]");
end

