function  LTmin = Minimum_masking_threshold(LTg)
%LTmin = Minimum_masking_threshold(LTg)
%
%   Find the minimum of the global masking threshold for each subband.
%   [1, pp. 114]
%
%   See also Global_masking_threshold

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

global Map FFT_SIZE N_SUBBAND

Subband_size = FFT_SIZE / 2 / N_SUBBAND; 
jnd = 1:Subband_size;
n = 1:N_SUBBAND; % For each subband
ind = Subband_size * (n - 1)' * ones(1, Subband_size) + ones(N_SUBBAND, 1) * jnd;
table = LTg(Map(ind)');
LTmin = min(table);
