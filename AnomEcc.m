function [E] = AnomEcc(M, e)

    % Risolve l'eq di Keplero col metodo di Newton-Rapshon
    
    err=1e-8;    
    nmax=1e6;    
    
    x0=M;                      % starting point
    
    % declaring parameters and variables
    error=err+1;
    it=0;
    xvect=[];
    xv=x0;
    
    fun_E=@(x) x-e*sin(x)-M;     % iterating function
    dfun_E=@(x) 1-e*cos(x);    % derivative of fun_E (dfun_E/dx)
    
    while(it<nmax && error>err)
        dfx=dfun_E(xv);
        if dfx == 0
            error('Algoritmo fallito a causa della derivata nulla della derivata della funzione di iterazione');
        else
            xn=xv-fun_E(xv)/dfun_E(xv);
            error=abs(xn-xv);
            xvect=[xvect;xn];
            it=it+1;
            xv=xn;
        end
    end
    

    
    E=xvect(end);
end