function [fitresult gof] = fitViewData(x,y, numToFit)
    if ~exist('numToFit')
        numToFit = size(x,1);
    end
    x2 = x(1:numToFit);
    y2 = y(1:numToFit);
    [fitresult, gof] = createFit(x2, y2, numToFit);
%     crossesat = exp((4000-fitresult.b)/fitresult.a) - fitresult.c;
%     fprintf('a\tb\tc\t2\t8\t30\t90\tcrosses 4000\n')
%     fprintf('%.2f\t%.2f\t%.2f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\n',fitresult.a,fitresult.b,fitresult.c, feval(fitresult,2), feval(fitresult,8), feval(fitresult,30), feval(fitresult,90), crossesat)
    

function [fitresult, gof] = createFit(x, y, numToFit)
%CREATEFIT(X,Y)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 09-Jul-2015 11:15:29



% Set up fittype and options.
ft = fittype( 'a*log(x+c)+b', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );
opts.Display = 'off';
% opts.StartPoint = [0.485375648722841 0.8002804688888 0.141886338627215];
% opts.StartPoint = [350 2000 -1];
% opts.Lower = [100 1000 -3];
% opts.Upper = [1000 3000 3];
opts.StartPoint = [500.2 1732.93	0];
% opts.Lower = [100 1000 -min(x)+0.1];
% opts.Upper = [1000 3000 5];
opts.Lower = [100 1000 0];
opts.Upper = [1000 3000 0.01];

% Fit model to data.
[fitresult, gof] = fit( x, y, ft, opts );
