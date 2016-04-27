function plotAllFits(fits,lineColors, epnames, maxX)

figure;
set(gcf, 'Renderer', 'OpenGL');
epmax = [];
minX  = 0;
for i = 1:length(fits)
    hold on;
%     minX = ceil(-min([fits{i}.c,0]));
    x = minX:0.1:maxX;
    y = fits{i}(x);
    y = real(y);
    ploth(i) = plot(x,y, 'Color',lineColors(i,:),'linewidth',2,'alpha',0.5);
%     alpha(a, 1)
    epmax(i) = fits{i}(maxX);
end

% [y,sortedorder] = sort(epmax,'descend');
% legend(ploth(sortedorder),{epnames{sortedorder}});
legend(epnames,'Location','SouthEast')
grid on
set(gca,'XLim',[minX,maxX])
set(gca,'YLim',[0,max(epmax)])