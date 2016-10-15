clear all;
clear clc;

load('Data/CoorUser1_1');
load('Data/sizeMap1');

R=size(coorOld,1);
% rR=randperm(R);
% coorOld=coorOld(rR(1:floor(R*0.3)),:);
% coorNew=coorNew(rR(1:floor(R*0.3)),:);

img=imread('Accessory/tmp3.png');
k=1;
for i=1:4:R
    disp(i);
    h=figure('Units','normalized','position',[0.3 0.05 0.35 0.8]);
    % h=figure;
    imagesc([minX,maxX], [minY,maxY], img);
    % imagesc([5,1], [20,1], img);
    hold on;
    plot(coorOld(i,1),coorOld(i,2),'kx',coorNew(i,1),coorNew(i,2),'ko');
    % axis equal; 
    axis manual;
    axis([minX,maxX,minY,maxY]);
    set(gcf, 'PaperSize', [5 7]);
    set(gca,'plotboxaspectratio',[3 7 1])
    legend({'True Stop','Predict Stop'}...
        ,'Location','SouthWest');
    M(k)=getframe;
    k=k+1;
    close(h);
end
save('Data/movieUser1TS2','M','minX','maxX','minY','maxY');