% Test_MPEG
%
% Main script - fs = 44100; bitrate = 128;
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

clear;

% Input Wave file
file = 'filename.wav'

% Load tables and global constants
global FFT_SIZE MIN_POWER NOT_EXAMINED IRRELEVANT INDEX SPL TONAL BARK
global NON_TONAL TH Map CB ATH N_SUBBAND
load('const.mat');

% Main Loop
for OFFSET = 1:512:fs*30;

	Input=wavread(file,[OFFSET OFFSET+511])';

%%% Psychoacoustic analysis.

	% Compute the FFT for time frequency conversion [1, pp. 110].
	[X, Delta] = FFT_Analysis(Input);
	   
	% Find the tonal (sine like) and non-tonal (noise like) components
   	% of the signal [1, pp. 111--113]
	[Flags Tonal_list Non_tonal_list] = Find_tonal_components(X');

	% Decimate the maskers: eliminate all irrelevant maskers [1, pp. 114]
	[Flags Tonal_list Non_tonal_list] = ...
	Decimation(X, Tonal_list, Non_tonal_list, Flags);

	% Compute the individual masking thresholds [1, pp. 113--114]
 
	[LTt, LTn] = Individual_masking_thresholds(X, Tonal_list, Non_tonal_list);
	% Compute the global masking threshold [1, pp. 114]
   	LTg = Global_masking_threshold(LTq, LTt, LTn);
   	   
   	% Determine the minimum masking threshold in each subband [1, pp. 114]
   	LTmin = Minimum_masking_threshold(LTg);

%%% Extra processing (e.g. watermarking)

	% Add your code here
	
end;
