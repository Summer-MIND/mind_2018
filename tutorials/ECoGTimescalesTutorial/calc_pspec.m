function [pspec, fqax] = calc_pspec(X, fs, do_hamming)

% function [pspec, fqax] = calc_pspec(X, fs, do_hamming)
%
% Computes, for each column of the input matrix x, the power spectrum of
% the signal.
%
%    INPUT
%
% X             = Nsamp by Nsig, input data matrix (double)
% fs            = sampling rate of BOLD signal (Hz) (double)
% do_hamming    = should we premulitiply with a Hamming window? (boolean)
%
%    OUTPUT
%
% pspec         = 1-sided power spectrum of signal
% fqax          = frequency axis for 1-sided power spectrum
%
% ver: 0.1
% author: C J Honey (April, 2011)

[Nsamp, Nsig] = size(X);

if nargin < 3; do_hamming = false; end
if nargin < 2; fs = 1; end


if do_hamming  %premultiply with a Hamming window
    X = bsxfun(@minus, X, mean(X));   %remove the mean from each column before tapering/windowing
    X = bsxfun(@times, X, hamming(Nsamp)); %apply Hamming window
end

X = bsxfun(@minus, X, mean(X));   %remove the mean from each column
fqs = fs*(0:Nsamp-1)/Nsamp; % frequency axis
Q = fix((Nsamp+2)/2); % ceil((N+1)/2)   %index to the Nyquist frequency
                       % N/2+1 for N even
                       % (N+1)/2 for N odd
                      
fQ = fqs(Q); % (Q-1)*df

fftX = fft(X) / Nsamp;  %discrete fast fourier transform of X

fqax = fqs(1:Q);  %frequency axis including only positive frequencies
pspec = abs(fftX(1:Q,:)).^2;

