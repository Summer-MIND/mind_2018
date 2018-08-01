function bb = bbpower(x, fs, fqrng, fqstep, wav_width, do_log, linefq)

% this function extracts broadband (bb, 70+ Hz) power from a time series in a
% number of distinct sub-bands, and then averages across normalized sub-bands to
% provide an esimate of 'broadband' shifts in power
%
% INPUT
% x = [Nsamp by Nsig] matrix of inputs
% fs = sampling rate
% fqrng = frequency range in which one is to calculate the bb power
% do_log = flag indicating whether to take the logarithm within each band before averaging across bands {TRUE|false}
% fqstep = step size between conseucitve subbands within the frequency
% linefeq = the frequency of line noise (
% wav_width = the width parameter of the wavelet used to estimate power
%
% OUTPUT
%
% bb = log-transformed time-course of broadband power shifts
%

if nargin < 7; linefq = 60; end
if nargin < 6; do_log = true; end
if nargin < 5; wav_width = 6; end
if nargin < 4; fqstep = 5; end
if nargin < 3; fqrng = [70 200]; end

line_param = 5; %frequencies are excluded if they are within 'line_param' Hz of the line noise and its harmonics

[Nsamp, Nsig] = size(x);

if Nsamp < Nsig; fprintf('WARNING: More signals than samples-per-signal. Dimensions of input, x, should be [Nsamples Nsignals].\n'); end

bb = zeros(Nsamp, Nsig);

allfqs = (fqrng(1):fqstep:fqrng(end))';

%remove frequencies near line noise
badfqs = and(allfqs > line_param, abs(mod(allfqs,linefq) - linefq/2) > (linefq/2 - line_param));  %frequencies within a distance "line_param" of line noise and harmonics

% allfqs(badfqs)

% [abs(mod(allfqs,linefq) - linefq/2) allfqs]

allfqs = allfqs(~badfqs);

Nfq = length(allfqs);

aa = zeros(Nsamp, Nsig, Nfq);



for ifq = 1:Nfq
    for isig = 1:Nsig
        [~, mypow] = phasevec_CH(allfqs(ifq), x(:,isig), fs, wav_width);
    %     aa(:,i) = log(mypow);
        aa(:,isig,ifq) = mypow;
    end
end

% aa = bsxfun(@minus, aa, mean(aa));   %subtract the column means from each column;
% aa = bsxfun(@rdivide, aa, std(aa));   %subtract the column means from each
% column;

if do_log
    aa = log(aa);
end


aa = zscore(aa, [], 1);   %maybe consider just dividing by the standard deviation rather than also subtracting out the mean...

bb  = squeeze(mean(aa,3));  %the high freq power modulations == mean of normalized fluctuations in subbands

% bb = log(bb)

