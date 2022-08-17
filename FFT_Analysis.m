function [X, Delta] = FFT_Analysis(Input)

%[X,Delta] = FFT_Analysis(Input)
%
% A Hanning window applied before computing the FFT.
% Finaly, a normalisation  of the sound pressure level is done such that
% the maximum value of the spectrum is 96dB; the number of dB added is 
% stored in Delta output.
%
% One should take care that the Input is not zero at all samples.
% Otherwise W will be -INF for all samples.
%

%   Authors: Fabien A.P. Petitcolas (fabien22@petitcolas.net)
%            Computer Laboratory 
%            University of Cambridge
%
%            Teddy Furon (furont@thmulti.com)
%            Laboratoire TSI - Telecom Paris
%            UIIS Lab - Thomson multimedia R&D France
%

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

global FFT_SIZE MIN_POWER;
Delta = [];
X = [];

% Prepare the Hanning window
h = sqrt(8 / 3) * hanning(FFT_SIZE);

% Power density spectrum
X = max(20 * log10(abs(fft(Input' .* h)) / FFT_SIZE), MIN_POWER);

% Normalization to the reference sound pressure level of 96 dB
Delta = 96 - max(X);
X = X + Delta;
