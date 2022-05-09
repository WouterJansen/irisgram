% load a .wav file
% [x, fs] = audioread('sonar.wav');   
[x, fs] = audioread('conquest.mp3');  
% x = x(size(x,1)/27:10:size(x,1)-(size(x,1)/19), 1);                        
x = x(round(size(x,1)/10000):5:size(x,1)- round(size(x,1)/25), 1);                        
%%
% define analysis parameters
xlen = length(x);                   % length of the signal
winlen = 512;                      % window length (recomended to be power of 2) 
olp = 0.5*winlen;                   % overlapping (recomended to be power of 2)
nfft = 128;                        % number of fft points (recomended to be power of 2)

% perform Time-Freq analysis and plot the Irisgram
win = hamming(winlen, 'periodic');
%%
[S, f, t] = irisgram(x, win, olp, nfft, fs, "hot");