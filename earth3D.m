function [] = earth3D(nFig)
    
    figure(nFig)
    rt=6371; %earth radius
    [xs,ys,zs]=sphere;
    xs=xs*rt;
    ys=ys*rt;
    zs=-zs*rt;
    earth=surface(xs,ys,zs);    %plot earth
    shading flat;
    imData=imread('map.jpg');
    set(earth,'facecolor','texturemap','cdata',imData,'edgecolor','none');
    axis square
    
    hold on
    grid on
    title("3D ORBIT");  
    xlabel("equinox line [km]"); 
    ylabel("y [km]");
    zlabel("z [km]"); 
    
end

