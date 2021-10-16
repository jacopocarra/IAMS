function [] = earth3D(nFig)

figure(nFig)
rt=6371;                                                               % raggio terrestre
[xs,ys,zs]=sphere;
xs=xs*rt;
ys=ys*rt;
zs=-zs*rt;
earth=surface(xs,ys,zs);                                               % plot terra
shading flat;
imData=imread('map.jpg');                                              % lettura mappa(inserire qua 'nomeMappa.jpg' che deve stare nella stessa cartella)
set(earth,'facecolor','texturemap','cdata',imData,'edgecolor','none'); % incolla mappa su sfera
axis square

hold on
grid on
title("3D ORBIT");
xlabel("equinox line [km]");
ylabel("y [km]");
zlabel("z [km]");

end

