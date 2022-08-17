function  LTg = Global_masking_threshold(LTq, LTt, LTn)

%LTg = Global_masking_threshold(LTq, LTt, LTn)
%
%   Compute the global masking threshold for the subset of frequency lines 
%   defined in table [1, pp. 117]. It is the sum -- in the normal square
%   amplitude scale of the spectrum -- of the individual masking
%   thresholds and the absolute threshold [1, pp. 114].
%
%   See also Individual_masking_thresholds, Table_absolute_threshold
%   
% The global masking thresholds is computing for the subset of frequencies 
% defined in [1, Table 1.b]. They are the summ of the powers of the  
% corresponding to the individual masking thresholds (LTt, LTn) and the 
% threshold in quiet (LTq). 
%       
% Contribution of the noise components and Threshold in quiet 

%   Authors: Fabien A. P. Petitcolas (fabien22@petitcolas.net)
%            Computer Laboratory 
%            University of Cambridge
%
%            Teddy Furon (furont@thmulti.com)
%            Laboratoire TSI - Telecom Paris
%            UIIS Lab - Thomson multimedia R&D France

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

temp=10 .^ (LTq' ./ 10) + sum(10 .^ (LTn ./ 10)); 

% Contribution of the tonal component 
if not(isempty(LTt))  
	temp = temp + sum(10 .^ (LTt ./ 10), 1); 
end    

LTg = 10 * log10(temp); 

