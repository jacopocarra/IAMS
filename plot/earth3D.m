function [earth] = earth3D(nFig)
    %earth = earth3D(nFig)
    %stampa un'immagine della Terra nella figura numero nFig


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
    axis equal
    hold on
    axis_color=[.5 .5 .5];
    axis_width=0.5;
    lun = 13000;

    quiver3(0,0,0,lun,0,0,1.2,'-.','color','k','LineWidth',axis_width+0.5);
    quiver3(0,0,0,0,lun,0,1.2,'-.','color','k','LineWidth',axis_width+0.5);
    quiver3(0,0,0,0,0,lun,1.2,'-.','color','k','LineWidth',axis_width+0.5);
    % quiver3(0,0,0,lun*cos(orb_vect(4,1)),lun*sin(orb_vect(4,1)),0,1.2,'-.','color',axis_color,'LineWidth',axis_width+0.8);
    text(lun+3000,0,0,'I','FontSize',12,'color',axis_color);
    text(0,lun+3000,0,'J','FontSize',12,'color',axis_color);
    text(0,0,lun+3000,'K','FontSize',12,'color',axis_color);
    % text((lun+3000)*cos(0.000293100000000*10000),(lun+3000)*sin(0.000293100000000*10000),0,'RAAN','FontSize',8,'color',axis_color);



    hold on
    grid on
    title("3D ORBIT");
    xlabel("equinox line [km]");
    ylabel("y [km]");
    zlabel("z [km]");

end

