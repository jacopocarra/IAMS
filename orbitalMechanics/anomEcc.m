function E = anomEcc(M, e)
%{
    calcola l'anomalia eccentrica dati l'anomalia media e l'eccentricità
    dell'orbita
    FUNZIONA SOLO PER ORBITE ELLITTICHE

%}
    
    
    toll=1e-8;    
    nmax=1e6;    
    
    x0=M;                      % starting point
    
    % declaring parameters and variables
    err=toll+1;
    it=0;
    xvect=[];
    xv=x0;
    
    fun_E=@(x) x-e*sin(x)-M;     % iterating function
    dfun_E=@(x) 1-e*cos(x);    % derivative of fun_E (dfun_E/dx)
    
    while(it<nmax && err>toll)
        dfx=dfun_E(xv);
        if dfx == 0 
            error('Algoritmo fallito a causa della derivata nulla della funzione di iterazione'); 
        else
            xn=xv-fun_E(xv)/dfun_E(xv);
            err=abs(xn-xv);
            xvect=[xvect;xn];
            it=it+1;
            xv=xn;
        end
    end
    

    
    E=xvect(end);
end
