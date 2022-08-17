function Test_MPEG
   
%   Author: Fabien A. P. Petitcolas
%           Computer Laboratory
%           University of Cambridge
%
%   Copyright (c) 1998--2001 by Fabien A. P. Petitcolas
%   $Header: /Matlab MPEG/Test_MPEG.m 7     7/07/01 1:27 Fabienpe $
%   $Id: Test_MPEG.m,v 1.3 1998-06-24 10:21:06+01 fapp2 Exp $

%   References:
%    [1] Information technology -- Coding of moving pictures and associated
%        audio for digital storage media at up to 1,5 Mbits/s -- Part3: audio.
%        British standard. BSI, London. October 1993. Implementation of ISO/IEC
%        11172-3:1993. BSI, London. First edition 1993-08-01.
%
%   Legal notice:
%    This computer program is based on ISO/IEC 11172-3:1993, Information
%    technology -- Coding of moving pictures and associated audio for digital
%    storage media at up to about 1,5 Mbit/s -- Part 3: Audio, with the
%    permission of ISO. Copies of this standards can be purchased from the
%    British Standards Institution, 389 Chiswick High Road, GB-London W4 4AL, 
%    Telephone:+ 44 181 996 90 00, Telefax:+ 44 181 996 74 00 or from ISO,
%    postal box 56, CH-1211 Geneva 20, Telephone +41 22 749 0111, Telefax
%    +4122 734 1079. Copyright remains with ISO.
%-------------------------------------------------------------------------------
Common;

% Build a demo sample
fs = 44100;
f = [1500 1700 1800 2000 10000 11000 12000 13000];
a = [   1    2    1   .5     2   1.5     3     1];
t = 0:1/fs:1;
x = randn(size(t));
for i = 1:length(f),
   x = x + a(i) * sin(2 * pi * f(i) * t);
end
x = x / max(abs(x));
%[x fs] = wavread('svega');

% Load tables.
[TH, Map, LTq] = Table_absolute_threshold(1, fs, 128); % Threshold in quiet
CB = Table_critical_band_boundaries(1, fs);
C = Table_analysis_window;

% Process the input vector x.
for OFFSET = 1:384:length(x) - 384;
   S = [];

%%% Subband filter analysis. Layer 1 uses 12 samples per subband.
   
   % Analysis subband filtering [1, pp. 67].
   for i = 0:11,
      S = [S; Analysis_subband_filter(x, OFFSET + 32 * i, C)];
   end
   
   % Scalefactor calculation [1, pp. 70].
   scf = Scale_factors(S);
   
%%% Psychoacoustic analysis.

	% Compute the FFT for time frequency conversion [1, pp. 110].
	X = FFT_Analysis(x, OFFSET);
   
   % Determine the sound pressure level in each  subband [1, pp. 110].
   Lsb = Sound_pressure_level(X, scf);
   
   % Find the tonal (sine like) and non-tonal (noise like) components
   % of the signal [1, pp. 111--113]
   [Flags Tonal_list Non_tonal_list] = Find_tonal_components(X, TH, Map, CB);
   
   % Decimate the maskers: eliminate all irrelevant maskers [1, pp. 114]
   [Flags Tonal_list Non_tonal_list] = ...
      Decimation(X, Tonal_list, Non_tonal_list, Flags, TH, Map);
   
   % Compute the individual masking thresholds [1, pp. 113--114]
   [LTt, LTn] = ...
      Individual_masking_thresholds(X, Tonal_list, Non_tonal_list, TH, Map);
   
   % Compute the global masking threshold [1, pp. 114]
   LTg = Global_masking_threshold(LTq, LTt, LTn);
   
   if (DRAW)
      disp('Global masking threshold');
      hold on;
      plot(TH(:, INDEX), LTg, 'k--');
      hold off;
      title('Masking components and masking thresholds.');
   end
   
   % Determine the minimum masking threshold in each subband [1, pp. 114]
   LTmin = Minimum_masking_threshold(LTg, Map);
   if (DRAW)
      figure; plot(LTmin); title('Minimum masking threshold');
      xlabel('Subband number'); ylabel('dB'); pause;
   end
   
   % Compute the singal-to-maks ratio
   SMRsb = Lsb - LTmin;
end
