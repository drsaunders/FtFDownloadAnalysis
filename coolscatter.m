function coolscatter(datax,datay)
fontsize = 14;
plot(datax,datay,'.','MarkerSize',15,'Color',[0.7371         0    0.3104])
set(gcf,'color',[1 1 1])
box off
set(gca,'TickDir','out');
set(gca,'FontSize',fontsize);

p = polyfit(datax, datay,1);
myrange = get(gca,'XLim');
x = myrange(1):0.1:myrange(2);
hold on; plot(x, polyval(p, x),'k','LineWidth',1);

[R p] = corrcoef(datax,datay);
Rsq = R(2,1)^2;
p = p(2,1);
ax = axis;
text(((ax(2)-ax(1))*0.5)+ax(1),ax(4),sprintf('R^2 = %.3f, p = %.3f',Rsq,p),'FontSize',fontsize)
