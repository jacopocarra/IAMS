function [deltaT] = tempoVolo(orbita, thetaIniz,thetaFin)

a = orbita(1);
e = orbita(2);

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


if thetaIniz>pi                                                 %se sono oltre pi uso formula alternativa
    EIniz = 2*atan(sqrt((1-e)/(1+e))*tan((2*pi-thetaIniz)/2));
    MIniz = EIniz-e*sin(EIniz);
    t1 = T- sqrt(a^3/mu)*MIniz;
else
    EIniz = 2*atan(sqrt((1-e)/(1+e))*tan(thetaIniz/2));
    MIniz = EIniz-e*sin(EIniz);
    t1 = sqrt(a^3/mu)*MIniz;
end


if thetaFin>pi                                                  %se sono oltre pi uso formula alternativa
    EFin = 2*atan(sqrt((1-e)/(1+e))*tan((2*pi-thetaFin)/2));
    MFin = EFin-e*sin(EFin);
    t2 = T - sqrt(a^3/mu)*MFin;    
else
    EFin =  2*atan(sqrt((1-e)/(1+e))*tan(thetaFin/2));
    MFin = EFin-e*sin(EFin);
    t2 = sqrt(a^3/mu)*MFin;
end


if thetaFin>thetaIniz                                           %se non passo dal pericentro
    deltaT = t2 - t1;
elseif thetaFin ~= thetaIniz                                    %se passo dal pericentro
    deltaT = t2 - t1 + T;
end

end

