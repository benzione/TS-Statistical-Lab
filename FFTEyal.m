function [cosinPara1,cosinPara2,dataTS]=FFTEyal(user,dataTS,startH,type)
%     intervalT=3600;
    sH=startH(3);
    T=1;
    time2sec=3600;
    t=dataTS(1,5):T:dataTS(end,5);
    [t2,it2]=setdiff(t,dataTS(:,5));
    [t3,it3]=setdiff(t,t2);

    len=length(t);
    t1=0:len-1;

    vq = interp1(dataTS(:,5),dataTS(:,1:4)...
        ,t,'linear');
    x=floor(vq(:,1:2));

    xM1=mean(x(:,1));
    x1=x(:,1)-xM1;
    xt2=x1(it2);
    xt3=x1(it3);

    y1=fft(x1);
    
    
%     yc=compress(y,0.8);

    herz=t1*(1/(T*time2sec))/(length(t));

    figure('units','normalized','outerposition',[0 0 1 1])

    subplot(2,1,1)
    if ~isempty(t2)
        plot(t-t(1)+sH,x1+xM1,'-',(t2-t(1)+sH),xt2+xM1,'*g',t3-t(1)+sH,xt3+xM1,'*r')
        legend('Coordinate x','Interpolation x','Real x')
    else
        plot(t-t(1)+sH,x1+xM1,'-',t3-t(1)+sH,xt3+xM1,'*r')
    end
    xlabel('Time (hour)')
    ylabel('Coordinate')
    str=strcat({type},{' FFT for every '}...
        ,{num2str(T)},{' hours and '}...
        ,{num2str(round(length(xt2)/length(x1)*100))},...
        {'% missing data of '},{num2str(length(x1))}...
        ,{' sampels size of user '},{num2str(user)});
    title(str{1})
    yabs=abs(y1(1:ceil(len/2)))/max(abs(y1));
    [~,Idx]=sort(yabs(1:ceil(len/2)),'descend');
    subplot(2,1,2)        

    plot(herz(1:ceil(len/2)),yabs)
    xlabel('Herz')
    ylabel('Amplitude')
    str1='The main cosin function f(t)=';
    str2='';
    tmphour1=1./herz;
    tmphour2=tmphour1/3600;
    tmphour3=round(tmphour2*100)/100;
    cosinPara1=zeros(3);
    for j=1:3
        if j<=length(Idx) && tmphour3(Idx(j))~=inf
            if j>1
                str2='+';
            end

            xphase=angle(y1(Idx(j)));
            str1=strcat(str1,str2,num2str(round(yabs(Idx(j))*100)/100)...
                ,'*cos((2*\pi*t/',num2str(tmphour3(Idx(j))),...
                ')+',num2str(round(xphase*100)/100),')');
            cosinPara1(j,1)=round(yabs(Idx(j))*100)/100;
            cosinPara1(j,2)=tmphour3(Idx(j));
            cosinPara1(j,3)=round(xphase*100)/100;
        end
    end
    title(str1)

    tmphour4 = abs(tmphour3-24);
    [~, ihdx] = min(tmphour4(1:ceil(len/2)));
    str=strcat({'\bullet\leftarrow '},...
        {num2str(tmphour3(ihdx))},...
        {' hours'});
    text(herz(ihdx),yabs(ihdx),str...
        ,'VerticalAlignment','middle');

    tmphour4 = abs(tmphour3-120);
    [~, ihdx] = min(tmphour4(1:ceil(len/2)));
    str=strcat({'\bullet\leftarrow '},...
        {num2str(tmphour3(ihdx))},...
        {' hours'});
    text(herz(ihdx),yabs(ihdx),str...
        ,'VerticalAlignment','middle');

    tmphour4 = abs(tmphour3-168);
    [~, ihdx] = min(tmphour4(1:ceil(len/2)));
    str=strcat({'\bullet\leftarrow '},...
        {num2str(tmphour3(ihdx))},...
        {' hours'});
    text(herz(ihdx),yabs(ihdx),str...
        ,'VerticalAlignment','middle');

    str=strcat('Graph\FFT',type,num2str(T),'hourUser'...
        ,num2str(user),'.jpg');
    saveas(gcf,str);
    close(gcf)
    
    
    
    xM2=mean(x(:,2));
    x2=x(:,2)-xM2;
    y2=fft(x2);
    yabs2=abs(y2(1:ceil(len/2)))/max(abs(y2));
    [~,Idx2]=sort(yabs2(1:ceil(len/2)),'descend');
    cosinPara2=zeros(3);
    for j=1:3
        if j<=length(Idx2) && tmphour3(Idx2(j))~=inf
            xphase=angle(y1(Idx2(j)));
            cosinPara2(j,1)=round(yabs2(Idx2(j))*100)/100;
            cosinPara2(j,2)=tmphour3(Idx2(j));
            cosinPara2(j,3)=round(xphase*100)/100;
        end
    end
    dataTS=[x,vq(:,3:end),t'];
end
