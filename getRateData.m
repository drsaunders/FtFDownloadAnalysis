function [times, rate] = getRateData(x,y)

times = (x(1:end-1)+x(2:end))/2;
rate = diff(y)./diff(x);
    
