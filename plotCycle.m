ACCoff=DATmainA.debug(1,:);
ACCon=DATmainB.debug(1,:);
figure;

subplot(221)
plot(ACCon)
title('Accelerometer ON (8k/2k/2k)')
axis([0 12000 100 550])

subplot(222)
plot(ACCoff)
axis([0 12000 100 550])
title('Accelerometer OFF (8k/2k/2k)')

FEAToff=DATmainB.debug(1,:);
subplot(223)
plot(FEAToff)
axis([0 18000 495 550])
title('Features OFF (2k/2k/2k)')

ACCandFEAToff=DATmainB.debug(1,:);
subplot(224)
plot(ACCandFEAToff)
axis([0 18000 495 550])
title('Accelerometer and Features OFF (2k/2k/2k)')


%% 8 2 2
debugNONE=diff(tta);
debugGYROSCALED=diff(ttb);

numError1=length(find(diff(debugNONE>550)==1));
t1=length(debugNONE) / 2000;

numError2=length(find(diff(debugGYROSCALED>550)==1));
t2=length(debugGYROSCALED) / 2000;

figure
subplot(211)
plot(debugNONE)
title('BF4.2 debug NONE (8k/2k/2k)')
axis([0 18000 495 650])
h=text(50, 640, ['mean ' int2str(mean(debugNONE)) ';median ' int2str(median(debugNONE)) ';mode ' int2str(mode(debugNONE)) '; standard deviation ' int2str(std(debugNONE)) '; errors/sec ' int2str(numError1/t1)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

subplot(212)
plot(debugGYROSCALED)
axis([0 18000 495 650])
title('BF4.2 debug GYRO_SCALED (8k/2k/2k)')
h=text(50, 640, ['mean ' int2str(mean(debugGYROSCALED)) ';median ' int2str(median(debugGYROSCALED)) ';mode ' int2str(mode(debugGYROSCALED)) '; standard deviation ' int2str(std(debugGYROSCALED)) '; errors/sec ' int2str(numError2/t2)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

%% 8 4 2 dshot 300 
debugNONE=diff(tta);
debugGYROSCALED=diff(ttb);

numError1=length(find(diff(debugNONE>550)==1));
t1=length(debugNONE) / 2000;

numError2=length(find(diff(debugGYROSCALED>550)==1));
t2=length(debugGYROSCALED) / 2000;

figure
subplot(211)
plot(debugNONE)
title('BF4.2 debug NONE (8k/4k/2k)')
axis([0 18000 495 650])
h=text(50, 640, ['mean ' int2str(mean(debugNONE)) ';median ' int2str(median(debugNONE)) ';mode ' int2str(mode(debugNONE)) '; standard deviation ' int2str(std(debugNONE)) '; errors/sec ' int2str(numError1/t1)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

subplot(212)
plot(debugGYROSCALED)
axis([0 18000 495 650])
title('BF4.2 debug GYRO_SCALED (8k/4k/2k)')
h=text(50, 640, ['mean ' int2str(mean(debugGYROSCALED)) ';median ' int2str(median(debugGYROSCALED)) ';mode ' int2str(mode(debugGYROSCALED)) '; standard deviation ' int2str(std(debugGYROSCALED)) '; errors/sec ' int2str(numError2/t2)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)



%% 8 4 2 dshot 600 
debugNONE=diff(tta);
debugGYROSCALED=diff(ttb);

numError1=length(find(diff(debugNONE>550)==1));
t1=length(debugNONE) / 2000;

numError2=length(find(diff(debugGYROSCALED>550)==1));
t2=length(debugGYROSCALED) / 2000;

figure
subplot(211)
plot(debugNONE)
title('BF4.2 debug NONE (8k/4k/2k dhot600)')
axis([0 18000 495 650])
h=text(50, 640, ['mean ' int2str(mean(debugNONE)) ';median ' int2str(median(debugNONE)) ';mode ' int2str(mode(debugNONE)) '; standard deviation ' int2str(std(debugNONE)) '; errors/sec ' int2str(numError1/t1)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

subplot(212)
plot(debugGYROSCALED)
axis([0 18000 495 650])
title('BF4.2 debug GYRO_SCALED (8k/4k/2k dshot600)')
h=text(50, 640, ['mean ' int2str(mean(debugGYROSCALED)) ';median ' int2str(median(debugGYROSCALED)) ';mode ' int2str(mode(debugGYROSCALED)) '; standard deviation ' int2str(std(debugGYROSCALED)) '; errors/sec ' int2str(numError2/t2)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)




%% 8 8 2
debugNONE=diff(tta);
debugGYROSCALED=diff(ttb);

numError1=length(find(diff(debugNONE>550)==1));
t1=length(debugNONE) / 2000;

numError2=length(find(diff(debugGYROSCALED>550)==1));
t2=length(debugGYROSCALED) / 2000;

figure
subplot(211)
plot(debugNONE)
title('BF4.2 debug NONE (8k/8k/2k)')
axis([0 18000 495 650])
h=text(50, 640, ['mean ' int2str(mean(debugNONE)) ';median ' int2str(median(debugNONE)) ';mode ' int2str(mode(debugNONE)) '; standard deviation ' int2str(std(debugNONE)) '; errors/sec ' int2str(numError1/t1)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

subplot(212)
plot(debugGYROSCALED)
axis([0 18000 495 650])
title('BF4.2 debug GYRO_SCALED (8k/8k/2k)')
h=text(50, 640, ['mean ' int2str(mean(debugGYROSCALED)) ';median ' int2str(median(debugGYROSCALED)) ';mode ' int2str(mode(debugGYROSCALED)) '; standard deviation ' int2str(std(debugGYROSCALED)) '; errors/sec ' int2str(numError2/t2)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)


%% 8 4 2 dshot 300 - ACC off (idea for optimizing for debugging)
debugNONE=diff(tta);
debugGYROSCALED=diff(ttb);

numError1=length(find(diff(debugNONE>550)==1));
t1=length(debugNONE) / 2000;

numError2=length(find(diff(debugGYROSCALED>550)==1));
t2=length(debugGYROSCALED) / 2000;

figure
subplot(211)
plot(debugNONE)
title('BF4.2 debug NONE (8k/4k/2k) | dshot300 | ACC off')
axis([0 18000 495 650])
h=text(50, 640, ['mean ' int2str(mean(debugNONE)) ';median ' int2str(median(debugNONE)) ';mode ' int2str(mode(debugNONE)) '; standard deviation ' int2str(std(debugNONE)) '; errors/sec= ' num2str(numError1/t1)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

subplot(212)
plot(debugGYROSCALED)
axis([0 18000 495 650])
title('BF4.2 debug GYRO_SCALED (8k/4k/2k) | dshot300 | ACC off')
h=text(50, 640, ['mean ' int2str(mean(debugGYROSCALED)) ';median ' int2str(median(debugGYROSCALED)) ';mode ' int2str(mode(debugGYROSCALED)) '; standard deviation ' int2str(std(debugGYROSCALED)) '; errors/sec= ' num2str(numError2/t2)])
set(h,'fontsize',30)
set(gca,'fontsize', 30)

