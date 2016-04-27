function dumpfigurestopng(pagename)
mkdir(pagename);
cd(pagename);

figureslist = get(0,'children'); % this mysterious command returns the numbers of all the figures in the workspace
figureslist = sort(figureslist);
for i = 1:length(figureslist)
    imagefilename = [pagename sprintf('%03.0f', i) '.png'];      
    export_fig(imagefilename,'-png','-r150','-painters',figureslist(i))
% print(figureslist(i),'-dpng',imagefilename,'-zbuffer','-r100')
end;

cd('..');