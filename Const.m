% const.m
%
% To edit values stored in const.mat

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


%%% Global constant values

FFT_SHIFT   = 384;
FFT_SIZE    = 512;
FFT_OVERLAP = (FFT_SIZE - FFT_SHIFT) / 2;

N_SUBBAND = 32;

% Flags for tonal analysis
NOT_EXAMINED = 0;
TONAL        = 1;
NON_TONAL    = 2;
IRRELEVANT   = 3;

MIN_POWER = -200;

% Indices used in tables like the threshold table
% or in the list of tonal and non-tonal components.
INDEX = 1;
BARK  = 2;
SPL   = 2;
ATH   = 3;



%%% Load tables

[TH, Map, LTq] = Table_absolute_threshold(1, fs, 128); % Threshold in quiet 
CB = Table_critical_band_boundaries(1, fs); 

C  = Table_analysis_window;
C  = [0 C];
C  = flipud(C(:));
