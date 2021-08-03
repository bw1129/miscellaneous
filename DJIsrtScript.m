fid = fopen('DJIG1547.srt');
C = textscan(fid, '%s');

Tind=strfind(C{1},'-->');
Tind2=find(not(cellfun('isempty',Tind)));

tm=C{1}(Tind2-1);
tm2=split(tm,':',1)';
tm3=[tm2(:,1:2) split(tm2(:,3),',',1)'];

tm_sec=[(str2num(char(tm3(:,2))) * 60) + str2num(char(tm3(:,3))) + (str2num(char(tm3(:,4))) / 1000)];


BRind=strfind(C{1},'bitrate:');
BRind2=find(not(cellfun('isempty',BRind)));
BRstr=C{1}(BRind2);
BRstr2=split(BRstr,':',1)';
BRstr3=split(BRstr2(:,2),'M',1)';

bitrate=str2num(char(BRstr3(:,1)));