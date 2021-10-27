function R = RotPF2GE(i, RAAN, omega)
% R = ROTPF2GE(alfa, beta, gamma)
%   This function returns the rotation matrix from the Perifocal coordinate
%   system (PF) to the geocentric coordinates system (GE)
%   INPUT
%       i: orbit inclination (deg)
%       RAAN: right ascension of the ascending node (deg)
%       omega:  argument of periapsis (deg)
%   OUTPUT:    
%       R: rotation matrix
%
%   Note: R^(-1) = R^T to calcolate the matrix from GE to PF 

    
    RRAAN = [cosd(RAAN) sind(RAAN) 0  
            -sind(RAAN) cosd(RAAN) 0   
            0 0 1 ];
    
    Ri = [1 0 0
          0 cosd(i) sind(i)
          0 -sind(i) cosd(i)];


    Romega = [cosd(omega) sind(omega) 0
              -sind(omega) cosd(omega) 0
              0 0 1];

    R = (Romega*Ri*RRAAN)';

end

