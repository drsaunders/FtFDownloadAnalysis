function applystyletofigures

fontsize = 10;
figureslist = get(0,'children'); % this mysterious command returns the numbers of all the figures in the workspace
figureslist = sort(figureslist);
for i = 1:length(figureslist)
    set(figureslist(i),'color','w')
    set(findall(figureslist(i),'-property','FontSize'),'FontSize',9)
end;
