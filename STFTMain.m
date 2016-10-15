clear all;
Type1={'Mean','Mode'};
Metod1={'linear','nearest'};
for user=1:3
    clearvars -except user Metod1 Type1;
    clear clc;
    close all;
    intervalT=1;
    fs=1/(intervalT);
    for it=1:2
        for im=1:2
            str=strcat({'data\Hour'},Type1{it},{'dataTS'},{num2str(user)});
            load(str{1});
            str=strcat('data\Hournumofsample',num2str(user));
            load(str);
            
            t=dataTS(1,3):intervalT:dataTS(end,3);

            vq = interp1(dataTS(:,3),dataTS(:,1:2)...
                ,t,Metod1{im});

            x=floor(vq);
            xa=x(:,1)-mean(x(:,1));
            figure
            subplot(2,1,1)
            plot(t,x(:,1))
            xlabel('Time (hours)')
            ylabel('Coordinate x')
            str=strcat({'STFT '},Type1{it},{' '},Metod1{im},{' for every '}...
                    ,{num2str(intervalT)},{' hours and '},{num2str(length(x))}...
                    ,{' sampels size of user '},{num2str(user)});
            title(str{1});
            R=size(x,1);
            numberOfwindow=7;

            % figure;
            subplot(2,1,2)
            windowsize = 24;
            % windowsize=20;
            window = hanning(windowsize);
            nfft = windowsize;
            noverlap = windowsize-1;
            [S,F,T] = spectrogram(xa,window,noverlap,nfft,fs);
            imagesc(T,F,log10(abs(S)))
            set(gca,'YDir','Normal')
            xlabel('Time (hours)')
            ylabel('Freq (Hz)')
%             str=strcat({'STFT '},Type1{it},{' '},Metod1{im},{' for every '}...
%                     ,{num2str(intervalT)},{' hours '},{num2str(length(x))}...
%                     ,{' sampels size of user '},{num2str(user)});
%             p=mtit(str{1},...
%                 'fontsize',11,'color','b',...
%                 'xoff',0,'yoff',-2);
%             % refine title using its handle <p.th>
%             set(p.th,'edgecolor',.5*[1 1 1]);


            str=strcat({'Graph\STFT'},Type1{it},Metod1{im},...
                {'spectrumUser'},{num2str(user)},{'.jpg'});
            saveas(gcf,str{1});
            close(gcf)
        end
    end
end