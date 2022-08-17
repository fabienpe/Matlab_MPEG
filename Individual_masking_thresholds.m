function  [LTt, LTn] = Individual_masking_thresholds(X, Tonal_list, ...
					Non_tonal_list, TH, Map,p)
%[LTt, LTn] = Individual_masking_thresholds(X, Tonal_list, ...
%   					Non_tonal_list, TH, Map,p)
%
%   Compute the masking effect of both tonal and non_tonal components on
%   the neighbouring spectral frequencies [1, pp. 113]. The strength os the
%   masker is summed with the masking index and the masking function.
%
%   Individual masking thresholds for both tonal and non-tonal 
%   components are set to -infinity since the masking function has an
%   infinite attenuation beyond -3 and +8 barks, that is the component
%   has no masking effect on frequencies beyond thos ranges [1, pp. 113--114]

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


global MIN_POWER INDEX BARK TH Map
if isempty(Tonal_list)
   LTt = [];
else
   LTt = zeros(length(Tonal_list(:, 1)), length(TH(:, 1))) + MIN_POWER;
end
LTn = zeros(length(Non_tonal_list(:, 1)), length(TH(:, 1))) + MIN_POWER;

% Only a subset of the samples are considered for the calculation of
% the global masking threshold. The number of these samples depends
% on the sampling rate and the encoding layer. All the information
% needed is in TH which contains the frequencies, critical band rates
% and absolute threshold.

if not(isempty(Tonal_list))
	zi = ones(length(Tonal_list(:, 1)), 1) * TH(:, BARK)';
	%Critical band rate of the frequency considered
   
	zj = TH(Map(Tonal_list(:, INDEX)), BARK) * ones(1, length(TH(:, BARK)));
	%Critical band rate of the masker
	
	dz = zi - zj; % Distance in Bark to the masker 
   
   vf=zeros(size(dz)); 
   
   % Masking function
	XT = X(Tonal_list(:, INDEX)) * ones(1, size(dz, 2));
	
	vf = vf + (17 * (dz + 1) - (0.4 * XT + 6)) .* (( -3 <= dz) & (dz <- 1));
	
	vf = vf + (0.4 * XT + 6) .* dz .* (( -1 <= dz) & (dz < 0));
	
 	vf = vf -(17 * dz .* ((0 <= dz) & (dz < 1))); 
	
	vf = vf + (-(dz - 1) .* (17 - 0.15 * XT) - 17) .* ((1 <= dz) & (dz < 8)); 	
	
	select = (dz >= -3) & (dz < 8);
	avtm = (-1.525 - 0.275 .* zj - 4.5); 
	LTt = (XT + avtm + vf) .* select + MIN_POWER .* (~select); 
end 
   
if not(isempty(Non_tonal_list))
	zi = ones(length(Non_tonal_list(:, 1)), 1) * TH(:, BARK)';
   
   %Critical band rate of the frequency considered
	zj = TH(Map(Non_tonal_list(:, INDEX)), BARK) * ones(1, length(TH(:, BARK)));
   
   %Critical band rate of the masker
	dz = zi - zj; % Distance in Bark to the masker 
   vf = zeros(size(dz)); 
   
   % Masking function 
	XT = X(Non_tonal_list(:, INDEX)) * ones(1, size(dz, 2));
	
	vf = vf + (17 * (dz + 1) - (0.4 * XT + 6)) .* ((-3 <= dz) & (dz < -1));
	
	vf = vf + (0.4 * XT + 6) .* dz .* ((-1 <= dz) & (dz < 0));
	
 	vf = vf - (17 * dz .* ((0 <= dz) & (dz < 1))); 
	
	vf = vf + (-(dz - 1) .* (17 - 0.15 * XT) - 17) .* ((1 <= dz) & (dz < 8)); 	
	
	select = (dz >= -3) & (dz < 8);
	avnm = (-1.525 - 0.175 .* zj - 0.5); 
	LTn = (XT + avnm + vf) .* select + MIN_POWER .* (~select); 
end
