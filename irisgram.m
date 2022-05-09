%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Circular Spectrogram (Irisgram)           %
%              with MATLAB Implementation              %
%                                                      %
% Author: Ph.D. Eng. Hristo Zhivomirov        08/21/17 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S, f, t] = irisgram(x, win, olp, nfft, fs, map)

% function: [S, f, t] = irisgram(x, win, olp, nfft, fs)
% x - signal in the time domain
% win - window function in the time domain
% olp - number of overlapping samples
% nfft - number of FFT points
% fs - sampling frequency, Hz
% S - STFT matrix (only unique points, time across columns, freq across rows)
% f - frequency vector, Hz
% t - time vector, s

%% perform the time-frequency analysis
% spectrogram computation
[~, f, t, PSD] = spectrogram(x, win, olp, nfft, fs);

% convert to amplitude spectrum in dB
S = 20*log10(sqrt(PSD.*enbw(win, fs))*sqrt(2));

% memory optimization
clear PSD

%% prepare the plot
% prepare the polar coordinates
theta = -linspace(-pi, pi, length(t));
% rho = f;
rho = max(f)/5 + f;
[T, R] = meshgrid(theta, rho);
[X, Y] = pol2cart(T, R);

% memory optimization
clear T R

% restrict the dynamic range to 120 dB
% (if there is a need)
Smax = max(S(:));
Smin = min(S(:));
if Smax - Smin > 70
    Smin = Smax - 70;
end

% restrict the noise corner to -120 dB
% (if there is a need)
Smin = max(Smin, -120);

% remove all spectral components bellow determined Smin
% (if there is a need)
S(S < Smin) = Smin;

%% plot the Iris Spectrogram
% plot the figure
figure
surf(X, Y, S)
shading interp
cmap = colormap(map);
colormap(cmap(17:end, :))
axis image
axis off
view(90, 90)

% show the colorbar
colorbar off;
end
% %% set the datatip UpdateFcn
% cursorMode = datacursormode(gcf);
% set(cursorMode, 'UpdateFcn', {@datatiptxt, t, f})

% %% check for a function output
% if ~nargout
%     clear S f t 
% end
% 
% end
% 
% function text_to_display = datatiptxt(~, hDatatip, t, f)
% 
% % determine the current datatip position
% pos = get(hDatatip, 'Position');
% 
% % convert the position into time and freq location
% [theta, rho] = cart2pol(pos(1), pos(2));
% t0 = max(t) * (-theta + pi)/(2*pi);
% f0 = rho;
% 
% % form the X and Y axis datatip labels
% text_to_display = {['Time, s: ' num2str(t0)],...
%                    ['Frequency, Hz: ' num2str(f0)],...
%                    ['Magnitude, dB: ' num2str(pos(3))]};
% 
% end
