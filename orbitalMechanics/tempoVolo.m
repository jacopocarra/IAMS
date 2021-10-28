function [deltaT] = tempoVolo(orbita, thetaIniz,thetaFin)

a = orbita(1);
e = orbita(2);
i = orbita(3);
RAAN = orbita(4);
omegaPiccola = orbita(5);
mu = 398600;

if thetaIniz == thetaFin
    deltaT = 0;
end


T = 2*pi*sqrt((a^3)/mu);
if thetaIniz >= 2*pi
    thetaIniz = thetaIniz - 2*pi;
end

if thetaFin >= 2*pi
    thetaFin = thetaFin - 2*pi;
end



    EIniz = 2*atan(sqrt((1-e)/(1+e))*tan(thetaIniz/2));
    EFin =  2*atan(sqrt((1-e)/(1+e))*tan(thetaFin/2));
    MIniz = EIniz-e*sin(EIniz);
    MFin = EFin-e*sin(EFin);
    if thetaFin>thetaIniz
        deltaT = sqrt(a^3/mu)*abs(MFin-MIniz);
    elseif thetaFin ~= thetaIniz
        deltaT = sqrt(a^3/mu)*abs(MFin-MIniz)+T;
    end

end

