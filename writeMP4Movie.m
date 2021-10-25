function writeMP4Movie(theMovie, fileName)

%{
NON VA TOCCATA LA FIGURA DURANTE IL PLOT

%}

global myMovie;
global fps;

fps = 24;
if length(theMovie) > 1
        writerObj = VideoWriter( fileName, 'MPEG-4');
        writerObj.Quality = 100;
        writerObj.FrameRate = fps;
        
        open( writerObj );        
   
        writeVideo( writerObj, theMovie );
        disp(sprintf('%s was written', writerObj.Filename))
        close( writerObj );
   
else
    warning('ERROR writing movie!')
end

end
