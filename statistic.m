str=strcat('Data\RegHourModedataTS1');
load(str);
sH=startH(3);
T=1;
time2sec=3600;
t=dataTS(1,5):T:dataTS(end,5);

vq = interp1(dataTS(:,5),dataTS(:,1:4)...
    ,t,'linear');
vq=floor(vq);
vararray=zeros(5,4);
vararray(1,:)=mean(dataTS(:,1:4));
vararray(2,:)=mode(dataTS(:,1:4));
vararray(3,:)=median(dataTS(:,1:4));
vararray(4,:)=min(dataTS(:,1:4));
vararray(5,:)=max(dataTS(:,1:4));
namesarray=[{'X'},{'Y'},{'NOP'},{'NOC'}];
for i=1:4
    figure
    hist(vq(:,i))
    xlabel(namesarray{i})
    ylabel('Frequency')
    str=strcat('Graph\hist_variable'...
        ,num2str(i),'.jpg');
    saveas(gcf,str);
    close(gcf)
end
