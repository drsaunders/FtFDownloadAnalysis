%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fight the Future podcast download analysis

close all
%%
startDate = datenum('29-Mar-2015');

fid = fopen('download_data.csv', 'rt');
a = textscan(fid, '%f %s %f %f', ...
      'Delimiter',',', 'CollectOutput',1, 'HeaderLines',1);
fclose(fid);
M = [a{1} datenum(a{2}) a{3}];


fid = fopen('episode_info.csv', 'rt');
a = textscan(fid, '%d %s %s %d', ...
      'Delimiter',',','HeaderLines',1);
fclose(fid);
epnames = a{2};
releasedates = datenum(a{3});
bookonly = a{4};

for i = 1:length(epnames)
    epnames{i} = sprintf('%2d %s',i,epnames{i});
end

numeps = max(M(:,1));
saturation = 100;
luminance = 60;
% lineColors = [linspace(0,360,numeps+1)', ones(numeps+1,1)*saturation, ones(numeps+1,1)*luminance];
lineColors = [linspace(0,360,10)', ones(10,1)*saturation, ones(10,1)*40];
lineColors = lineColors(1:(end-1),:);
lineColors = [lineColors; lineColors];
lineColors(1:9,3) = 70;

lineColors = lineColors(1:(end-1),:);
lineColors = husls2rgb(lineColors);

%%
% All real data curves
figure;
for i = 1:numeps
    plot(M(M(:,1)==i, 2)-startDate, M(M(:,1)==i, 4), '.-','Color',lineColors(i,:),'MarkerSize',10,'LineWidth',1);
    hold on;
end
xlabel('Days since podcast launch');
ylabel('Number of downloads');

%%
% Example of complete fit
figure
exampleEp = 2;  % and 10
exData = M(M(:,1)==exampleEp,:);
[fitresult gof] = fitViewData(exData(:,3),exData(:,4));
plotFit(exData(:,3),exData(:,4),fitresult);


% Example of fit with partial data
figure
subsetSize = 10;
plot(exData(:,3),exData(:,4),'.','MarkerSize',12,'Color',[146,197,222]/255);
hold on
[fitresult gof] = fitViewData(exData(:,3),exData(:,4),subsetSize);
plotFit(exData(1:subsetSize,3),exData(1:subsetSize,4),fitresult);
legend off;
legend({'Sampled data','Data used in fit','Curve fit','95% prediction interval'},'Location','SouthEast')
%%
% Compute the fits
fits = {};
gofs = {};
for i = 1:numeps
    i
    selData = M(M(:,1)==i,:);
    [fits{i} gofs{i}] = fitViewData(selData(:,3),selData(:,4));
    fits{i};
end

%%
% Plot all the fits (whole time range)
maxX = max(M(:,3));
plotAllFits(fits,lineColors,epnames, maxX);
%%
% Plot all the fits (first 30 days only)
maxX = 30;
plotAllFits(fits,lineColors,epnames, maxX);

%%
% Area plot of downloads at target time points


figure;
targetvals = [2 8 30 90];

daycolors = [186,228,179
116,196,118
49,163,84
0,47,25];
daycolors = daycolors / 255;
eptargetvals = [];
daylabels = {};

for j = length(targetvals):-1:1
    for i = 1:numeps
        eptargetvals(i,j) = real(fits{i}(targetvals(j)));
    end
end

[y,sortorder] = sort(eptargetvals(:,1),'descend');
for j = length(targetvals):-1:1
    area(eptargetvals(sortorder,j),'FaceColor',daycolors(j,:),'EdgeColor',[0,0,0])
    hold on;
    legendentries{j} =  sprintf('Day %d',targetvals(j));
end


set(gcf,'Position',[1 1 660 397]);
xticklabel_rotate(1:17, 90, epnames(sortorder));
% set(gca,'XTick',1:17,'XTickLabel',epnames)
legend(fliplr(legendentries),'Location','SouthWest');
grid on;
set(gca,'layer','top');
ylabel( 'Cumulative number of downloads' );


projectedvals = [];
for i = 2:length(targetvals)
    projectedvals(:,i-1) = (eptargetvals(sortorder,1) - mean(eptargetvals(:,1))) + mean(eptargetvals(:,i));
    plot(projectedvals(:,i-1),':k','LineWidth',1.5);
end
%%
% Effect of book-only analysis

whichTime = 1;
book = eptargetvals(logical(bookonly),whichTime);
movie = eptargetvals(~logical(bookonly),whichTime);
% p = ranksum(book, movie);
[h,p] = ttest2(book, movie, [],[],'unequal');
% fprintf('Median day 2 book-only = %.1f, median day 2 movie = %.1f, Wilcoxon p value = %.3f\n',median(book),median(movie),p);
fprintf('Mean day 2 book-only = %.1f, Mean day 2 movie = %.1f, Welch''s t p value = %.3f\n',mean(book),mean(movie),p);


whichTime = 4;
book = eptargetvals(logical(bookonly),whichTime);
movie = eptargetvals(~logical(bookonly),whichTime);
[h,p] = ttest2(book, movie, [],[],'unequal');
% p = ranksum(book, movie);
% fprintf('Median day 90 book-only = %.1f, median day 90 movie = %.1f, Wilcoxon p value = %.3f\n',median(book),median(movie),p);
fprintf('Mean day 90 book-only = %.1f, Mean day 90 movie = %.1f, Welch''s t p value = %.3f\n',mean(book),mean(movie),p);


%%
% Downloads by episode number

figure; 
coolscatter(1:size(eptargetvals,1),eptargetvals(:,1)')
ylim = get(gca,'YLim');
set(gca,'YLim',[0 3000]);
set(gca,'XLim',[1,17])
grid on
xticklabel_rotate(1:17, 90, epnames);
ylabel( 'Number of downloads at Day 2' );


figure; 
coolscatter(1:size(eptargetvals,1),eptargetvals(:,4)')
ylim = get(gca,'YLim');
set(gca,'YLim',[0 4000]);
set(gca,'XLim',[1,17])
grid on
xticklabel_rotate(1:17, 90, epnames);
ylabel( 'Number of downloads at Day 90' );

%%
% Example rate data

ep = 6;
checkRateData(M,ep);
axis([1  404.0015    1.4531  282.9791])
% ep = 9;
% checkRateData(M,ep);


%%
% Download spike analysis
isspike = zeros(numeps,50);
for ep = 1:numeps
    epData = M(M(:,1)==ep,:);
    [fitresult, gof, times, rate] = fitRateData(epData(:,3),epData(:,4));

    for i = 1:(length(times)-1)
        if i >= 6 && times(i) >= 5
            [fitresult2, gof, times2, rate2] = fitRateData(epData(:,3),epData(:,4),i);
            nextX = times(i+1);
            nextY = rate(i+1);
            predints = predint(fitresult, nextX, 0.95);
            minY = predints(1);
            maxY = predints(2);
            if nextY > maxY
                fprintf('%.1f   %.1f   %.1f   %.1f\n', nextX, minY, nextY, maxY);
                isspike(ep, i+1) = 1;
            end
        end
    end
end
%%
% Show the one example of a spike that I found
% Linear version
figure; 
ep = 10;
epData = M(M(:,1)==ep,:);

[fitresult, gof, times, rate] = fitRateData(epData(:,3),epData(:,4));
plotFit(times,rate,fitresult);
plot(times,rate,'.-','Color',[146,197,222]/255);
plot(times(1:9),rate(1:9),'.-','MarkerSize',12,'Color',[5,113,176 ]/255);
plot(times(logical(isspike(10,:))),rate(logical(isspike(10,:))),'.r','MarkerSize',20);
ylabel( 'Downloads per day' );

axis([1 220 0 1000])
%%
% Log version
figure
plotFit(times,rate,fitresult);
plot(times,rate,'.-','Color',[146,197,222]/255);
plot(times(1:9),rate(1:9),'.-','MarkerSize',12,'Color',[5,113,176 ]/255);
plot(times(logical(isspike(10,:))),rate(logical(isspike(10,:))),'.r','MarkerSize',20);
set(gca,'XScale','log')
set(gca,'YScale','log')
grid off
legend( gca, {'Sampled data', 'Curve fit','95% prediction interval'}, 'Location', 'best' );
axis([1 220 0 1000])
ylabel( 'Downloads per day' );

%% 
% Small multiples of rate
% figure
% for i = 1:numeps
%     subplot(4,5,i);
%     epData = M(M(:,1)==i,:);
%     [times, rate] = getRateData(epData(:,3),epData(:,4));
%     plot(times,rate,'-','MarkerSize',12,'Color',[5,113,176 ]/255);
%     axis([1 220 0 1000])
%     set(gca,'XScale','log')
%     set(gca,'YScale','log')
%     title(epnames{i});
% end
%     

%%
applystyletofigures
dumpfigurestopng('figures')

