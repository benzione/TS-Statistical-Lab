clear all;
close all;
clear clc;

result=cell(2,3);
for user=1:1
    str=strcat({'Data\RegHourModedataTS'},{num2str(user)});
    load(str{1});
    
    [cosinParaNormal1,cosinParaNormal2,dataTS]=FFTEyal(user,dataTS,startH,'Normal');
    [Q_loc_estimate1]=kalmanEyal2d(dataTS);
    dataTS2=[Q_loc_estimate1,dataTS(3:end,3:end)];
    [cosinParaKalman1,cosinParaKalman2,dataTS2]=FFTEyal(user,dataTS2,startH,'Kalman');
    
    nt=dataTS(:,5)+1;
    nt2=nt.^2;
    nt3=nt.^3;
    
    kt=dataTS2(:,5)-1;
    kt2=kt.^2;
    kt3=kt.^3;
    
    nxcos1=cosinParaNormal1(1,1)*...
        cos((2*pi*nt/cosinParaNormal1(1,2))+cosinParaNormal1(1,3));
    nxcos2=cosinParaNormal1(2,1)*...
        cos((2*pi*nt/cosinParaNormal1(2,2))+cosinParaNormal1(2,3));
    nxcos3=cosinParaNormal1(3,1)*...
        cos((2*pi*nt/cosinParaNormal1(3,2))+cosinParaNormal1(3,3));
    
    nycos1=cosinParaNormal2(1,1)*...
        cos((2*pi*nt/cosinParaNormal2(1,2))+cosinParaNormal2(1,3));
    nycos2=cosinParaNormal2(2,1)*...
        cos((2*pi*nt/cosinParaNormal2(2,2))+cosinParaNormal2(2,3));
    nycos3=cosinParaNormal2(3,1)*...
        cos((2*pi*nt/cosinParaNormal2(3,2))+cosinParaNormal2(3,3));
    
    kxcos1=cosinParaKalman1(1,1)*...
        cos((2*pi*kt/cosinParaKalman1(1,2))+cosinParaKalman1(1,3));
    kxcos2=cosinParaKalman1(2,1)*...
        cos((2*pi*kt/cosinParaKalman1(2,2))+cosinParaKalman1(2,3));
    kxcos3=cosinParaKalman1(3,1)*...
        cos((2*pi*kt/cosinParaKalman1(3,2))+cosinParaKalman1(3,3));
    
    kycos1=cosinParaKalman2(1,1)*...
        cos((2*pi*kt/cosinParaKalman2(1,2))+cosinParaKalman2(1,3));
    kycos2=cosinParaKalman2(2,1)*...
        cos((2*pi*kt/cosinParaKalman2(2,2))+cosinParaKalman2(2,3));
    kycos3=cosinParaKalman2(3,1)*...
        cos((2*pi*kt/cosinParaKalman2(3,2))+cosinParaKalman2(3,3));
    
%     [pacfxn,~,boundsxn] = parcorr(dataTS(:,1),30);
%     [pacfxk,~,boundsxk] = parcorr(dataTS2(:,1),30);
%     [pacfyn,~,boundsyn] = parcorr(dataTS(:,2),30);
%     [pacfyk,~,boundsyk] = parcorr(dataTS2(:,2),30);
%     
%     indxn=find(pacfxn(2:end)<boundsxn(1));
%     indxk=find(pacfxk(2:end)<boundsxk(1));
%     indyn=find(pacfyn(2:end)<boundsyn(1));
%     indyk=find(pacfyk(2:end)<boundsyk(1));
%     
%     if ~isempty(indxn)
%         if ~isempty(indyn)
%             if indxn(1)<indyn(1)
%                 lagn=indxn(1);
%             else
%                 lagn=indyn(1);
%             end
%         else
%             lagn=indxn(1);
%         end
%     else
%         if ~isempty(indyn)
%             lagn=indyn(1);
%         else
%             lagn=[];
%         end
%     end
%     
%     if ~isempty(indxk)
%         if ~isempty(indyk)
%             if indxk(1)<indyk(1)
%                 lagk=indxk(1);
%             else
%                 lagk=indyk(1);
%             end
%         else
%             lagk=indxk(1);
%         end
%     else
%         if ~isempty(indyk)
%             lagk=indyk(1);
%         else
%             lagk=[];
%         end
%     end
    ninteraction=dataTS(:,3).*dataTS(:,4);
    kinteraction=dataTS2(:,3).*dataTS2(:,4);
    ntindep=[nt,nt2,nt3];
    ktindep=[kt,kt2,kt3];
    tstr=[{'t'},{'t^2'},{'t^3'}];    
    [ntdata]=mvregressMy(ntindep,dataTS(:,1:2));
    [ktdata]=mvregressMy([kt,kt2,kt3],dataTS2(:,1:2));
    
    ncosindep=[nxcos1,nxcos2,nxcos3,nycos1,nycos2,nycos3];
    kcosindep=[kxcos1,kxcos2,kxcos3,kycos1,kycos2,kycos3];
    cosstr=[{'xcos1'},{'xcos2'},{'xcos3'},{'ycos1'},{'ycos2'},{'ycos3'}];
    [ncdata]=mvregressMy(ncosindep,dataTS(:,1:2));
    [kcdata]=mvregressMy(kcosindep,dataTS2(:,1:2));
    
    ntmodel1= ntdata.PValueChi(2:end)<=0.05;
    ktmodel1= ktdata.PValueChi(2:end)<=0.05;
    
    ncosmodel=ncdata.PValueChi(2:end)<=0.05;
    kcosmodel=kcdata.PValueChi(2:end)<=0.05;
    
    ntindep=ntindep(:,ntmodel1');
    ktindep=ktindep(:,ktmodel1');
    
    ncosindep=ncosindep(:,ncosmodel');
    kcosindep=kcosindep(:,kcosmodel');
    
    nstr1=[{'con'},tstr(ntmodel1),cosstr(ncosmodel),{'NOP'},{'NOC'}];
    kstr1=[{'con'},tstr(ktmodel1),cosstr(kcosmodel),{'NOP'},{'NOC'}];
    nfinalM=[ntindep,ncosindep,dataTS(:,3:4),ninteraction];
    kfinalM=[ktindep,kcosindep,dataTS2(:,3:4),kinteraction];
    [ndata]=mvregressMy(nfinalM,dataTS(:,1:2));
    [kdata]=mvregressMy(kfinalM,dataTS2(:,1:2));
    
    ntmodel2=ndata.PValueChi<=0.05;
    ktmodel2=kdata.PValueChi<=0.05;
    
%     nstr2=[nstr1(ntmodel2),{num2str(ntdata3.adjR2(1))},{num2str(ntdata3.adjR2(2))}];
%     kstr2=[kstr1(ktmodel2),{num2str(ktdata3.adjR2(1))},{num2str(ktdata3.adjR2(2))}];
    userdata(user).nstr=nstr1;
    userdata(user).kstr=kstr1;
    userdata(user).nmodel=ntmodel2;
    userdata(user).kmodel=ktmodel2;  
    userdata(user).ndata=ndata;
    userdata(user).kdata=kdata;
    userdata(user).ntmodel=ntmodel1;
    userdata(user).ktmodel=ktmodel1; 
    userdata(user).ntdata=ntdata;
    userdata(user).ktdata=ktdata;
    userdata(user).ncmodel=ncosmodel;
    userdata(user).kcmodel=kcosmodel; 
    userdata(user).ncdata=ncdata;
    userdata(user).kcdata=kcdata;
    userdata(user).ncosx=cosinParaNormal1;
    userdata(user).kcosx=cosinParaNormal2;
    userdata(user).ncosy=cosinParaKalman1;
    userdata(user).kcosy=cosinParaKalman2;
end
 clearvars -except userdata;