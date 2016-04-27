function checkRateData(M,ep)
epData = M(M(:,1)==ep,:);
[fitresult, gof, times, rate] = fitRateData(epData(:,3),epData(:,4));
figure; 
subplot(1,2,1);
plot(times, rate,'Color',[0.0005    0.4120    0.4328],'LineWidth',1);
xlabel('Days since release');
ylabel('Downloads per day');
title(sprintf('Episode %d linear scale',ep));

subplot(1,2,2);
plot(times, rate,'Color',[0.0005    0.4120    0.4328],'LineWidth',1);
set(gca,'XScale','log')
set(gca,'YScale','log')
xlabel('Days since release');
ylabel('Downloads per day');
title(sprintf('Episode %d log scale',ep));
