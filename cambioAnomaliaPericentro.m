function [deltaV2, theta3, theta4] = cambioAnomaliaPericentro(aIniz, eIniz, omega1, omegaFin, theta2)


deltaOmega = omegaFin-omega1;
p = aIniz*(1-eIniz^2);
deltaV2 = 2*sqrt(mu/p)*eIniz*sin(deltaOmega/2);
theta3 = 360 - theta2;
theta4 = theta3 + 180;


end