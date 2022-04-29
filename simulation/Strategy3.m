

path = cd;
if ismac
    if ~isfile(fullfile(path, 'Dati_A2'))
        IAMScheck
        error('data is missing')
    end
else
    if ~isfile(fullfile(path, 'Dati_A2'))
        IAMScheck
        error('data is missing')
    end
end
config;
%% DIRECT TRANSFER
[orbTrasf, dV1, dV2, dT, thetaMan1, thetaMan2] = trasfDir(orbIniz, orbFin); 
deltaV = dV1 + dV2; 

%%
Title = 'STRATEGY 3 - Direct Transfer';

Maneuv_name=[{'Initial point'};{'Final point'};];          

plotOrbit([ orbTrasf ],...
    [thetaMan1, thetaMan2],...
    [dT],...
    Title,Maneuv_name,'dyn',0,...
    [dV1, dV2]); 
