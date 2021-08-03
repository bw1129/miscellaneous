
nthOrder = 1;
ymax=0.5;
asy = 0.01;
% pulse input
lgth=200;
p=[0 1 zeros(1,lgth-1)];
fntsz = 30;

%xfire 150Hz
rx150Hz=150;
rx150Rate=ceil(1000/rx150Hz);
rx150 = [zeros(1,rx150Rate) ones(1,rx150Rate) ones(1,rx150Rate)*2 ones(1,rx150Rate)*5 zeros(1,lgth) ];

%xfire 50hz
rx50Hz=50;
rx50Rate=ceil(1000/rx50Hz);
rx50 = [zeros(1,rx50Rate) ones(1,rx50Rate) ones(1,rx50Rate)*2 ones(1,rx50Rate)*5 zeros(1,lgth)];

fcutoffs150 =[rx150Hz/10:rx150Hz/10:rx150Hz];
fcutoffs50 = [rx50Hz/10:rx50Hz/10:rx50Hz];

clear lgnd50 lgnd150
for i=1:length(fcutoffs50)
    lgnd50{i} = [int2str(fcutoffs50(i)) 'Hz cutoff'];
    lgnd150{i} = [int2str(fcutoffs150(i)) 'Hz cutoff'];
end

ncols=length(fcutoffs50);
cmap=flipud(colormap(jet)); close
cmap=(downsample(cmap,ceil(length(cmap)/ncols)));


fig=figure('units','normalized','outerposition',[.25 .1 .7 .9]) 


tc=[];tmx=[];
subplot(2,2,1)
for i=1:length(fcutoffs50)
    ir = pt1(p, fcutoffs50(i), 1000, nthOrder);
    h = plot(ir);hold on
    set(h,'linewidth',2,'color',[cmap(i,:)])
    a = find(ir < asy, 2);
    tc(i) = a(2);
    tmx(i) = max(ir);
end
for i=1:length(fcutoffs50)
    h = plot([tc(i) tc(i)], [0 ymax],'--')
    set(h,'linewidth',0.5,'color',[cmap(i,:)])
    h = plot([0 50], [tmx(i) tmx(i)],'--')
    set(h,'linewidth',0.5,'color',[cmap(i,:)])
end
set(gca,'fontsize',fntsz)
title('PT1 impulse response xfire 50hz')
legend(lgnd50)
xlabel('duration')
ylabel('IR')
axis([0 50 0 ymax])

tc=[];tmx=[];
subplot(2,2,2)
for i=1:length(fcutoffs150)
    ir = pt1(p, fcutoffs150(i), 1000, nthOrder);
    h = plot(ir);hold on
    set(h,'linewidth',2,'color',[cmap(i,:)])
    a = find(ir < asy, 2);
    tc(i) = a(2);
    tmx(i) = max(ir);
end
for i=1:length(fcutoffs150)
    h = plot([tc(i) tc(i)], [0 ymax],'--')
    set(h,'linewidth',0.5,'color',[cmap(i,:)])
    h = plot([0 50], [tmx(i) tmx(i)],'--')
    set(h,'linewidth',0.5,'color',[cmap(i,:)])
end
set(gca,'fontsize',fntsz)
title('PT1 impulse response xfire 150hz')
legend(lgnd150)
xlabel('duration')
ylabel('IR')
axis([0 50 0 ymax])

subplot(2,2,3)
for i=1:length(fcutoffs50)
    h = plot(pt1(rx50, fcutoffs50(i), 1000, nthOrder));hold on
    set(h,'linewidth',2,'color',[cmap(i,:)])
end
h=stairs(rx50); set(h,'color','k')
set(gca,'fontsize',fntsz)
title('crossfire 50Hz')
legend(lgnd50)
xlabel('ms')
ylabel('response')
axis([0 lgth 0 7])

subplot(2,2,4)
for i=1:length(fcutoffs150)
    h = plot(pt1(rx150, fcutoffs150(i), 1000, nthOrder));hold on
    set(h,'linewidth',2,'color',[cmap(i,:)])
end
h=stairs(rx150); set(h,'color','k')
set(gca,'fontsize',fntsz)
title('crossfire 150Hz')
legend(lgnd150)
xlabel('ms')
ylabel('response')
axis([0 lgth 0 7])

    
