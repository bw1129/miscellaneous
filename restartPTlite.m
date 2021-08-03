[F.name, F.path] = uigetfile({'*.BBL;*.BFL;*.TXT'}, 'MultiSelect','on');

%guiHandles.fileA = uicontrol(PTfig,'Style','popupmenu','string',['File A: ' filenameA],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.fileA]);
guiHandles.fileB = uicontrol(PTfig,'Style','popupmenu','string',['File B: ' filenameA],'fontsize',fontsz,'units','normalized','outerposition',[posInfo.fileB]);

guiHandles.fileA = uicontrol('style','list','max',10,...
   'min',1,'fontsize',fontsz,'units','normalized','outerposition',[0.9000    0.8500    0.10    0.100],...
   'string',filenameA);
% listbox

% ncols=8;
% if size(fls,2)>ncols, ncols= size(fls,2); end
% cmap=flipud(colormap(jet));
%       
% cmap=(downsample(cmap,ceil(length(cmap)/ncols)));
% 
% 
% if iscell(fls)
%     for i = 1 : size(fls,2)
%         filenameA=[];
%         filenameA = fls{i};
%         PTload;
%         PTtuningParams;
%     end
% else
%     filenameA=[];
%     filenameA = fls;
%     PTload;
%     PTtuningParams;
% end


