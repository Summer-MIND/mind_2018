function [lagcc, lagccblockvals] = lagcorr(x,y,lags, Nblock)

% quick and dirty function to calculate lagged correlations
%
%
% lagcc = values of correlation coefficients
%
% Nblocks = number of blocks into which to divide data, if you want to
% calculate correlations in blocks and take the median. default = 1 (no
% subdivision of the data )

if nargin < 4; Nblock = 1; end
if nargin < 3; lags = -10:10; end

  
Nlag = length(lags);
Nsamp = length(x);

lagcc = zeros(Nlag,1);
lagccblockvals = zeros(Nlag,Nblock);

x = x(:);
y = y(:);

for ilag = 1:Nlag
    shift = lags(ilag);
    
    t1 = 1 : (Nsamp - abs(shift));
    t2 = (1 + abs(shift) ) :  Nsamp;
    if Nblock == 1 %standard correlations
        if shift > 0
            lagcc(ilag) = corr(x(t1), y(t2));
        elseif shift < 0
            lagcc(ilag) = corr(x(t2), y(t1));
        elseif shift == 0
            lagcc(ilag) = corr(x,y);
        else
            lagcc = NaN;
        end
    else  %block correlations
        if shift > 0
            [lagcc(ilag), lagccblockvals(ilag,:)]  = blockCorr(x(t1), y(t2), Nblock);
        elseif shift < 0
            [lagcc(ilag), lagccblockvals(ilag,:)] = blockCorr(x(t2), y(t1), Nblock);
        elseif shift == 0
            [lagcc(ilag), lagccblockvals(ilag,:)] = blockCorr(x,y, Nblock);
        else
            lagcc = NaN;
        end
    end
        
end


