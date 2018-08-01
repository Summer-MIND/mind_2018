function [ALF, totpow, pspec, fqax] = calcALF(X, fs, ALFthresh, do_hamming)

% function [ALF, totpow, pspec, fqax] = calcALF(X, fs, ALFthresh)
%
% Computes, for each column of the input matrix x, 
% the proportion of total signal power that is below a frequency threshold.
%
%
% INPUT
%
% X             = Nsamp by Nsig, input data matrix (double)
% fs            = sampling rate of BOLD signal (Hz) (double)
% ALFthresh     = ALF frequency threshold (Hz) (double)
% do_hamming    = should we premulitiply with a Hamming window? (boolean)
%
%
%    OUTPUT
%
% ALF           = Nsig by 1 vector of ALF values
% totpow        = Nsig by 1 vector of total power values
% pspec         = 1-sided power spectrum of signal
% fqax          = frequency axis for 1-sided power spectrum
%
% ver: 0.1
% author: C J Honey (April, 2011)


[Nsamp, Nsig] = size(X);

if nargin < 4; do_hamming = false; end
if nargin < 3; ALFthresh = 0.1; end
if nargin < 2; fs = 1; end



if do_hamming  %premultiply with a Hamming window
    X = bsxfun(@minus, X, mean(X));   %remove the mean from each column before tapering/windowing
    X = bsxfun(@times, X, hamming(Nsamp)); %apply Hamming window
end

X = bsxfun(@minus, X, mean(X));   %remove the mean from each column



% dt = 1/fs;          % inverse of sampling frequency
% t = dt*(0:Nsamp-1); % time base ( Note that t(N) = T-dt )
% T = Nsamp*dt;       % total time period spanned by sample
% df = 1/T;           % frequency having one cycle over the full sample length
% f = df*(0:Nsamp-1); % frequency axis of fft

fqs = fs*(0:Nsamp-1)/Nsamp; % frequency axis

% iNyq = ceil(NFFT/2)  %index to the largest positive frequency
% posfqs = fs*(0:iNyq)/Nsamp;  %positive frequencies

Q = fix((Nsamp+2)/2); % ceil((N+1)/2)   %index to the Nyquist frequency
                       % N/2+1 for N even
                       % (N+1)/2 for N odd

fQ = fqs(Q); % (Q-1)*df

% fc = f-fQ; % The "centered" frequency scale (for when using fftshift)

if ALFthresh > fQ
    error(' ALF threshold is %2.2f Hz. \n But sampling rate is %2.2f Hz \n and thus cannot resolve frequencies above %2.2f Hz', ALFthresh, fs, fQ)
end

ALF = zeros(Nsig, 1);  % initialze output matrix
totpow = zeros(Nsig, 1);  % initialze output matrix


lowfqs = and(fqs > 0, fqs <= ALFthresh);  %find indices to freqs between zero and the max ALF frequency


fftX = fft(X);                       %discrete fast fourier transform of X

fqax = fqs(1:Q);
pspec = abs(fftX(1:Q,:)).^2;

totpow(:,1) = sum(pspec(1:Q,:));
ALF(:,1) = sum(pspec(lowfqs,:))./totpow';  %low freq power as a proportion of total power