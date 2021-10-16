function [] = orbit3D(a, e, i, RAAN, omega, theta, nEl)
    
    theta_v = linspace(0, 360, nEl); %array of angles
    p = a*(1-e^2); 
    r_v = p./(1 + e*cosd(theta_v)); % ellipse points

    x_orb = r_v.*cosd(theta_v); 
    y_orb = r_v.*sind(theta_v); 
    r_2D = [x_orb ; y_orb; zeros(1, nEl)]; 

    R = RotPF2GE(i, RAAN, omega); 

    r_3D = R*r_2D; 
    
    r0 = R* (p/(1+e*cosd(theta)))*[cosd(theta); sind(theta); 0]; %satellite position 
    rP = R* (p/(1+e))*[1; 0; 0];
    rA = R* (p/(1-e))*[-1; 0; 0];

    
    
    figure(2); 
    plot3(r_3D(1,:),r_3D(2,:),r_3D(3, :)); %plot orbit
    hold on
    
    rt=6371; %earth radius
    [xs,ys,zs]=sphere;
    xs=xs*rt;
    ys=ys*rt;
    zs=zs*rt;
    earth=surface(xs,ys,zs);    %plot earth
    shading flat;
    set(earth,'FaceColor',[0 0 1],'FaceAlpha',0.5); 
    
    plot3(r0(1), r0(2), r0(3),  'hr'); %plot satellite
    plot3(rA(1), rA(2), rA(3), '.r'); %plot apoapsis
    plot3(rP(1), rP(2), rP(3), '.r'); %plot periapsis

    grid on; 
    title("3D ORBIT"); 
    xlabel("equinox line [km]"); 
    ylabel("y [km]");
    zlabel("z [km]"); 
    
    axis equal
    
    
    grid on; 
end

