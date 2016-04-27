
function plotFit(x,y, fitresult)
% Plot fit with data
plot(x,y,'.', 'MarkerSize',12,'Color',[0 0.3104 0.7371  ]);
hold on;
h = plot( fitresult, 'predobs');
ydata = get(h,'ydata');
ydata = ydata{1};
legend( gca, 'Sampled data', 'Curve fit','95% prediction interval', 'Location', 'best' );
% Label axes
xlabel( 'Days since release' );
ylabel( 'Number of downloads' );
grid on
plot(x,y,'.', 'MarkerSize',12,'Color',[5,113,176 ]/255);
% x
set(gca,'YLim',[0 max(max(y)*1.1,max(ydata)*1.1)]);
% axis([0 25 500 3500])


