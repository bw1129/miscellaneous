
%Sin = DATmainA.DtermFilt(1,:);
Sin = DATmainA.GyroFilt(1,:); % DtermFilt  GyroFilt

SP = DATmainA.RCRate(1,:);
Th = DATmainA.RCRate(4,:);

clear AmpSpec freq segment_vector segment_length
subsampleFactor=20;
[AmpSpec, freq, segment_vector, segment_length] = PTresonanceCalc(Sin, A_lograte, subsampleFactor);
pwrSpec = AmpSpec.^2;

tm = (1/A_lograte):(1/A_lograte): size(DATmainA.RCRate(1,:),2)/A_lograte;

m=[];
ymax=200;
nStepTraces=10;
j=0;jj=0;

clear binstr binsz st nd a meanSpec
maxDNcut = 350;
nbins=32;
binsz = maxDNcut/nbins;
binrng=[1:binsz:nbins*binsz maxDNcut];
selectBins = find(binrng>20 & binrng<=100);
mainBins = find(binrng<=100);

for i=1:size(AmpSpec,1)
    st(i) = round(segment_vector(i)/A_lograte);
    nd(i) = round((segment_vector(i)+segment_length) / A_lograte);
    
    for k=mainBins
        if i==1, 
            a{k} = find(freq>=binrng(k),1):find(freq>=binrng(k+1),1);
            binstr{k}=[int2str(binrng(k)) '-' int2str(binrng(k+1))];
        end
        meanSpec(i,k) = max(AmpSpec(i,a{k}));
    end
end


%% run it
makeVideo = 1;
yScale = 1;
if makeVideo
    vw = VideoWriter(['SPECsim-TextDisplay' filenameA 'nbins' int2str(nbins)],'MPEG-4');
    vw.Quality = 100;
    vw.FrameRate=20;
    open(vw);
end
 
Fig1=figure('units','pixels','outerPosition',[1 1 1920 1080],'visible', 'on');
for i=1:size(AmpSpec,1)

    subplot(2,1,1) 
    h=plot(tm, Sin);set(h,'linewidth',3)
    hold on
    h=plot(tm, SP);set(h,'linewidth',1.5)
    plot([st(i) st(i)], [-ymax ymax],'k--')
    plot([nd(i) nd(i)], [-ymax ymax],'k--')
    set(gca,'fontsize',30)
    hold off
    axis([tm(1) tm(end) -ymax ymax])
    xlabel('time (ms)')
    ylabel('deg/s')
    legend({'Gyro';'Set point' ;'sliding window'})
    
    
   
%     subplot(2,4,7)
%     
%     h=plot(freq, AmpSpec(i,:));set(h,'linewidth',2)
%     hold on
%     set(gca,'fontsize',30)
%     hold off
%     
%     axis([0 100 0 yScale])
%     xlabel('freq (Hz)')
%     ylabel('Amplitude')
%     title(['Sub-100Hz'])
    
%     subplot(2,15,28)
%     a=segment_vector(i);
%     b=(segment_vector(i)+segment_length);
%     h=bar(1,nanmean(Th(a:b))); 
%     hold on
%     set(h,'FaceColor',[.5 .5 .5])
%     h=errorbar(1,nanmean(Th(a:b)), nanstd(Th(a:b))/sqrt(length(Th(a:b))) );
%     set(h,'color','k')
%     ylabel('% throttle')
%     set(gca,'fontsize',30,'xtick',[])
%     axis([0.8 1.2 0 100])
%     hold off
%     
%     subplot(2,15,30)
%     a=find(freq>=30,1):find(freq>=80,1);
%     meanSpec = max(AmpSpec(i,a));
%     stdSpec = nanstd(AmpSpec(i,a)) / sqrt(length(a));
%     h=bar(1,meanSpec);
%     hold on

    subplot(2,2,4)
    for k=mainBins
        h=bar(k,max(AmpSpec(i,a{k})));hold on
        if ~isempty(find(k==selectBins))
            set(h,'facecolor',[0 .45 .7], 'FaceAlpha',1) 
        else
            set(h,'facecolor',[0 .45 .7], 'FaceAlpha',.1) 
        end
    end
    for k=1:length(selectBins)
        p(k) = [max(AmpSpec(i,a{selectBins(k)}))];
    end
    Freqweights = round((p / max(p)) * 100);
    clear a1
    for k=1:length(selectBins)
        a1{k}=repmat(median(binrng(selectBins(k):selectBins(k)+1)),1,Freqweights(k));
    end
    sumFreqs=0;
    for k=1:length(selectBins)
        sumFreqs = [sumFreqs a1{k}];
    end
    
    weightedMeanFreq = nanmean(sumFreqs);
    h1=text(mainBins(end)*.3, yScale*0.9, ['bins' int2str(selectBins(1)) '-' int2str(selectBins(end)) ' weighted mean freq ' num2str(weightedMeanFreq,4) 'Hz']);
    h2=text(mainBins(end)*.3, yScale*0.84, ['bins' int2str(selectBins(1)) '-' int2str(selectBins(end)) ' mean amplitude ' num2str(nanmean(p),3)]);
    %  h2=text(8, yScale*0.84, ['bins 2-4 weighted mean: amplitude ' num2str(weightedMeanAmp,3)]);
    
    if nanmean(p) >0.2
        col = [1 0 0];
        fweight = 'bold';
    else
        col = [0 0 0];
        fweight = 'normal'
    end 
    set(h1, 'fontsize',20, 'color',[col],'fontweight',fweight)
    set(h2, 'fontsize',20, 'color',[col],'fontweight',fweight)
   
    set(gca,'xtick',[mainBins],'xticklabel',[binstr])
    xtickangle(30)
    ylabel('AmpSpec')
    xlabel('freq bins (Hz)')
    set(gca,'fontsize',24)
    axis([0.5 max(selectBins)+0.5 0 yScale])
  %  plot([weightedMeanFreq weightedMeanFreq], [0 yScale],'r');
    hold off
    
     subplot(2,2,3)
    h=plot(freq, AmpSpec(i,:));set(h,'linewidth',2)
    hold on
    set(gca,'fontsize',24)
    h=plot([weightedMeanFreq weightedMeanFreq], [0 yScale],'r');set(h,'linewidth',2)
    h1=text(weightedMeanFreq, yScale*0.9, ['weighted mean ' num2str(weightedMeanFreq,4) 'Hz']);
    set(h1, 'fontsize',20, 'color',[0 0 0],'fontweight','bold')
    hold off
    axis([0 100 0 yScale])
    xlabel('freq (Hz)')
    ylabel('AmpSpec')
    
    
%         if p > 1.25 
%             h=title(['peak:' num2str(p) ', latency:' num2str(pt) 'ms, *overshoot* '])
%             set(h,'color',[1 0 0])
%         else
%             title(['peak:' num2str(p) ', latency:' num2str(pt) 'ms'])
%         end
    if makeVideo
        mov(i) = getframe(Fig1);
        writeVideo(vw,mov(i)); 
    else
   %   drawnow limitrate
      pause(0.005)
    end

end
if makeVideo
    close(vw);
end
close
