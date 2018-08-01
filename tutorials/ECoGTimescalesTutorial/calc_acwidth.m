function [acw, xc] = calc_acwidth(x, p)

%[acw] = calc_acwidth(x, p)
%
% INPUT
% x = time series [Nsamples x Nsignals]
% p = parameter for autocorrelation fall-off
%
% OUTPUT
% acw = index at which the autocorrelation of x becomes <= p
% xc = autocorrelation function of the last column of data

if nargin < 2;
    p = exp(-1);
end

[Nsamp, Nsig] = size(x);
acw = NaN(Nsig,1);
x = zscore(x);

for isig = 1:Nsig
    xc = xcorr(x(:,isig), 'coeff');
    tmp = find( xc(Nsamp:end) < p, 1);
    if isfinite(tmp)
        acw(isig) = tmp-1;
    end
end

