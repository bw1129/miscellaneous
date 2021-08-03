
%Sin = DATmainA.DtermFilt(1,:);
Sin = DATmainA.DtermFilt(1,:); % DtermFilt  GyroFilt

SP = DATmainA.RCRate(1,:);
Th = DATmainA.RCRate(4,:);

clear AmpSpec freq segment_vector segment_length
[AmpSpec, freq, segment_vector, segment_length] = PTresonanceCalc(Sin, A_lograte);

tm = (1/A_lograte):(1/A_lograte): size(DATmainA.RCRate(1,:),2)/A_lograte;

Fig1=figure('units','pixels','outerPosition',[1 1 1920 1080],'visible', 'on');

vw = VideoWriter(['SPECsim-' filenameA '2'],'MPEG-4');
vw.Quality = 100;
vw.FrameRate=30;
open(vw);
m=[];
ymax=200;
nStepTraces=10;
j=0;jj=0;
yScale = 2;

for i=1:size(AmpSpec,1)
    subplot(2,1,1)
    st = round(segment_vector(i)/A_lograte);
    nd = round((segment_vector(i)+segment_length) / A_lograte);
    
    h=plot(tm, Sin);set(h,'linewidth',3)
    hold on
    h=plot(tm, SP);set(h,'linewidth',1.5)
    hold on
    plot([st st], [-ymax ymax],'k--')
    plot([nd nd], [-ymax ymax],'k--')
    set(gca,'fontsize',30)
    hold off
    axis([tm(1) tm(end) -ymax ymax])
    xlabel('time (ms)')
    ylabel('deg/s')
    legend({'Gyro';'Set point' ;'sliding window'})
    
    subplot(2,2,3)
    st = round(segment_vector(i)/A_lograte);
    nd = round((segment_vector(i)+segment_length) / A_lograte);
    
    h=plot(freq, AmpSpec(i,:));set(h,'linewidth',2)
    hold on
    set(gca,'fontsize',30)
    hold off
    
    axis([0 A_lograte*1000 0 yScale])
    xlabel('freq (Hz)')
    ylabel('Amplitude')
    
    subplot(2,4,7)
    
    h=plot(freq, AmpSpec(i,:));set(h,'linewidth',2)
    hold on
    set(gca,'fontsize',30)
    hold off
    
    axis([0 100 0 yScale])
    xlabel('freq (Hz)')
    ylabel('Amplitude')
    title(['Sub-100Hz'])
    
    subplot(2,15,28)
    a=segment_vector(i);
    b=(segment_vector(i)+segment_length);
    h=bar(1,nanmean(Th(a:b))); 
    hold on
    set(h,'FaceColor',[.5 .5 .5])
    h=errorbar(1,nanmean(Th(a:b)), nanstd(Th(a:b))/sqrt(length(Th(a:b))) );
    set(h,'color','k')
    ylabel('% throttle')
    set(gca,'fontsize',30,'xtick',[])
    axis([0.8 1.2 0 100])
    hold off
    
    subplot(2,15,30)
    a=find(freq>=30,1):find(freq>=80,1);
    meanSpec = max(AmpSpec(i,a));
    stdSpec = nanstd(AmpSpec(i,a)) / sqrt(length(a));
    h=bar(1,meanSpec);
    hold on
%     set(h,'FaceColor',[0 .45 .74])
%     h=errorbar(1,meanSpec, stdSpec);
%    set(h,'color','k')
    ylabel('peak 30-80Hz')
    set(gca,'fontsize',30,'xtick',[])
    axis([0.8 1.2 0 yScale])
    hold off
    
    
        
%         if p > 1.25 
%             h=title(['peak:' num2str(p) ', latency:' num2str(pt) 'ms, *overshoot* '])
%             set(h,'color',[1 0 0])
%         else
%             title(['peak:' num2str(p) ', latency:' num2str(pt) 'ms'])
%         end
    mov(i) = getframe(Fig1);
    writeVideo(vw,mov(i)); 
   % pause(.2)
end

close(vw);
close
