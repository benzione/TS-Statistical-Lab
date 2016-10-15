clear all;
close all;
clc;

x=[141121,176871;140736,176871];


Lat=32.1760168;
Lon=34.9161061;
[x1,y1,utmzone]=ll2utm(Lat,Lon);

itmX=x(:,1)+50000;
itmY=x(:,2)+500000;
xold1=488398+itmX;
xold2=2885689+itmY;

coorOld=utm2ll(xold1,xold2,utmzone);