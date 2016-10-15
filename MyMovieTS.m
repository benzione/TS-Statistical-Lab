clear all;
close all;
clc

numtimes=1;
fps=15;

load('Data/movieUser1TS2');

h=figure('Units','normalized','position',[0.3 0.05 0.35 0.8]);
axis([minX,maxX,minY,maxY]);
xlabel('x (coordinate)');
ylabel('y (coordinate)');
set(gcf, 'PaperSize', [5 7]);
set(gca,'plotboxaspectratio',[3 7 1])
% legend({'Trajectory','Stop area','Current stop'},'Location','best');
% title('Stop points and stop areas of a user on 05/02/2012');
pause
movie(M,numtimes,fps);
