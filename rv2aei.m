function [a, e, i, omegaGrande, omegaPiccola, theta] = rv2aei(r, v, mu)

%{
This function allows to change from geocentric to perifocal system

INPUTS: 
        - r: raggio
        - v: 
        - mu:
OUTPUTS: 
        - a:
        - e:
        - i:
        - omegaGrande:
        - omegaPiccola:
        - theta: 



REVISION: 
        - release, 14/10/2021
                   Jacopo Carradori, Tommaso Brombara, Riccardo Cadamuro

%}

hVet = cross(r, v);
h = hVet(3);
eVet = cross(v, hVet)/mu-r/norm(r);
e = norm(eVet);
a = mu/((2*mu)/norm(r)-norm(v)^2);
N = cross([0 0 1]', hVet)/norm(cross([0 0 1]', hVet));
i = acosd((hVet(3))/norm(hVet));
omegaGrande = acosd(N(1));
if N(2)<0 
    omegaGrande = 360 - omegaGrande;
end
omegaPiccola = acosd(eVet'*N/norm(eVet'));
if eVet(3)<0
    omegaPiccola = 360 - omegaPiccola ;
end
theta = acosd(eVet'*r/(norm(eVet)*norm(r)));
p = a*(1-e^2);
rDot = r'*v;
if rDot<0
    theta = 360 - theta ;
end
