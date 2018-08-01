function [y, pow] = phasevec_CH(f,s,Fs,width)
% FUNCTION [y,pow] = phasevec(f,s,Fs,width)
%
% Return the phase as a function of time for frequency f. 
% The phase is calculated using Morlet's wavelets. 
%
% INPUT ARGS:
%   f = 8;     % Frequency of interest
%   s = dat;   % The eeg signal to evaluate
%   Fs = 256;  % Sample rate
%   width = 6; % width of Morlet wavelet (>= 5 suggested).
%
% OUTPUT ARGS:
%   y- Phase as a function of time
%   pow- Power as a function of time
%
% Ref: Tallon-Baudry et al., J. Neurosci. 15, 722-734 (1997)
%
% script acquired from Kahana lab
%

dt = 1/Fs;
sf = f/width;
st = 1/(2*pi*sf);

t=-3.5*st:dt:3.5*st;
m = morlet_CH(f,t,width);

y = conv(s,m);
%y = fconv(s,m);

pow = abs(y).^2;
pow = pow(ceil(length(m)/2):length(pow)-floor(length(m)/2));

l = find(abs(y) == 0); 
y(l) = 1;

% normalizes phase estimates to length one
y = y./abs(y);
y(l) = 0;
   
y = angle( y(ceil(length(m)/2):length(y)-floor(length(m)/2)) );
