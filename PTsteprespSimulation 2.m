
Sin = DATmainA.RCRate(1,:);
Sout = DATmainA.GyroFilt(1,:);
tm = (1/A_lograte):(1/A_lograte): size(DATmainA.RCRate(1,:),2)/A_lograte;

clear stepresponse tA segment_vector segment_length
[stepresponse, tA, segment_vector, segment_length] = PTstepcalc2(Sin, Sout, A_lograte);

Fig1=figure('units','pixels','outerPosition',[1 1 1920 1080],'visible', 'on');

vw = VideoWriter(['SRsim-' filenameA],'MPEG-4');
vw.Quality = 100;
vw.FrameRate=20;
open(vw);
m=[];
nStepTraces=10;
j=0;jj=0;
for i=1:size(stepresponse,1)
    subplot(2,1,1)
    st = round(segment_vector(i)/A_lograte);
    nd = round((segment_vector(i)+segment_length) / A_lograte);
    
    h=plot(tm, Sin);set(h,'linewidth',2)
    hold on
    plot(tm, Sout);
    plot([st st], [-500 500],'k--')
    plot([nd nd], [-500 500],'k--')
    set(gca,'fontsize',30)
    hold off
    axis([tm(1) tm(end) -500 500])
    xlabel('time (ms)')
    ylabel('deg/s')
    legend({'Set point'; 'gyro';'sliding window'})
    
    subplot(2,2,4)
    st = round(segment_vector(i)/A_lograte);
    nd = round((segment_vector(i)+segment_length) / A_lograte);
    
    h=plot(tm, Sin);set(h,'linewidth',2)
    hold on
    h=plot(tm, Sout);set(h,'linewidth',2)
    plot([st st], [-500 500],'k--')
    plot([nd nd], [-500 500],'k--')
    set(gca,'fontsize',30)
    hold off
    
    axis([st-round(segment_length/2) nd+round(segment_length/2) nanmean(Sin(st+450:nd-450))-200 nanmean(Sin(st+450:nd-450))+200])
    xlabel('time (ms)')
    ylabel('deg/s')
    title('zoomed')
    
    subplot(2,2,3)
    if ~isempty(m) && ~isempty(find(stepresponse(i,:)))
        if j < nStepTraces
            j=j+1;
        else
            j=1;
        end
        m(j,:)=stepresponse(i,:);
        
        h=plot(tA,nanmean(m)); 
        set(h,'linewidth',6)
        set(gca,'fontsize',30)
        axis([0 300 0 1.8])
        xlabel('time (ms) ')
        ylabel('Response')
        grid on
    end
    if isempty(m)
        j=j+1;
        m=stepresponse(i,:);
        h=plot(tA,m); 
        set(h,'linewidth',6)
        set(gca,'fontsize',30)
        axis([0 300 0 1.8])
        xlabel('time (ms) ')
        ylabel('Response')
        grid on
    end
%     h=plot(tA,m); 
%     set(h,'linewidth',6)
%     set(gca,'fontsize',30)
%     axis([0 300 0 1.8])
%     xlabel('time (ms) ')
%     ylabel('Response')
%     grid on
    if j>1
        jj=jj+1;
        w = find(tA==1):find(tA==100);
        m_mean=nanmean(m);
        p=max(m_mean(w));
        pt=find(nanmean(m) >=.5,1) / A_lograte;
        
        if p > 1.25 
            h=title(['peak:' num2str(p) ', latency:' num2str(pt) 'ms, *overshoot* '])
            set(h,'color',[1 0 0])
        else
            title(['peak:' num2str(p) ', latency:' num2str(pt) 'ms'])
        end
    end
    mov(i) = getframe(Fig1);
    writeVideo(vw,mov(i)); 
   % pause(.2)
end

close(vw);
close
