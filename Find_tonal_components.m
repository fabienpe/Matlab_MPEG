function [Flags, Tonal_list, Non_tonal_list] = Find_tonal_components(X)

% [Flags, Tonal_list, Non_tonal_list] = Find_tonal_components(X)
%
% Identifie and list both tonal and non - tonal components of the audio
% signal. It is assume in this implementation that the frequency
% sampling fs is 44100 Hz. Details bare given in [1, pp. 112].
%
% See also Decimation


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

global FFT_SIZE MIN_POWER NOT_EXAMINED IRRELEVANT INDEX SPL TONAL BARK
global NON_TONAL TH Map CB


% List tonal components and compute sound pressure level 
jnd = 1:254;
ind = 2:256;
delay_1 = ceil(0.5 + sign(X(ind) - X(ind - 1)) / 2);
Flags = [0 delay_1(jnd) &~ delay_1(jnd + 1) 0];

ind = 3:254;
Flags = Flags .* [0 0 ceil(0.5 + sign(X(ind) - X(ind - 2) - 7) / 2) 0 0];
Flags = Flags .* [0 0 ceil(0.5 + sign(X(ind) - X(ind + 2) - 7) / 2) 0 0];

ind = 63:253; B = zeros(1, 3);
[ones(1, 253 - size(ind, 2)) ceil(0.5 + sign(X(ind) - X(ind - 3) - 7) / 2) B];
Flags = Flags .* ans;
[ones(1, 253 - size(ind, 2)) 2.* ceil(0.5 + sign(X(ind) - X(ind + 3) - 7) / 2) B];
Flags = Flags .* ans;

ind = 127:252; B = zeros(1, 4);
[ones(1, 252 - size(ind, 2)) ceil(0.5 + sign(X(ind) - X(ind - 4) - 7) / 2) B];
Flags = Flags.*ans;
[ones(1, 252 - size(ind, 2)) ceil(0.5 + sign(X(ind) - X(ind + 4) - 7) / 2) B];
Flags = Flags.*ans;

ind = 127:251;B = zeros(1, 5);
[ones(1, 251 - size(ind, 2)) ceil(0.5 + sign(X(ind) - X(ind - 5) - 7) / 2) B];
Flags = Flags.*ans;
[ones(1, 251 - size(ind, 2)) ceil(0.5 + sign(X(ind) - X(ind + 5) - 7) / 2) B];
Flags = Flags.*ans;

ind = 127:250;B = zeros(1, 6);
[ones(1, 250 - size(ind, 2)) ceil(0.5 + sign(X(ind) - X(ind - 6) - 7) / 2) B];
Flags = Flags.*ans;
[ones(1, 250 - size(ind, 2)) 3.*ceil(0.5 + sign(X(ind) - X(ind + 6) - 7) / 2) B];
Flags = Flags.*ans;

K = find(Flags)';

if K, 
	Flags(1, K + 1) = IRRELEVANT;
	Flags(1, K - 1) = IRRELEVANT;
	Flags(1, K - 2) = IRRELEVANT;
	Flags(1, K + 2) = IRRELEVANT
	Tonal_list(:, INDEX) = K;
   Tonal_list(:, SPL) = 10.*log10(10.^(X(K - 1) / 10) + 10.^(X(K) / 10) + ...
      						10.^(X(K + 1) / 10))';
else
	Tonal_listr = [];
end

K = find(Flags == 2)';
if K, 
	Flags(1, K - 3) = IRRELEVANT;
	Flags(1, K + 3) = IRRELEVANT;
	Flags(1, K) = TONAL;
end

K = find(Flags == 6)';
if K, 
	Flags(1, K - 2) = IRRELEVANT;
	Flags(1, K + 2) = IRRELEVANT;
	Flags(1, K - 3) = IRRELEVANT;
	Flags(1, K + 3) = IRRELEVANT;
	Flags(1, K - 4) = IRRELEVANT;
	Flags(1, K + 4) = IRRELEVANT;
	Flags(1, K - 5) = IRRELEVANT;
	Flags(1, K + 5) = IRRELEVANT;
	Flags(1, K - 6) = IRRELEVANT;
	Flags(1, K + 6) = IRRELEVANT;
	Flags(1, K) = TONAL;
end
F = Flags;

% List the non tonal components and compute power 
% All the spectral lines that have not been examined during the previous 
% search are summed together to form the non - tonal component. 

Non_tonal_list = []; 
for i = 1:length(CB(:, 1)) - 1 
   % For each critical band, compute the power 
   % in non - tonal components 
   
   	K = TH(CB(i), INDEX):TH(CB(i + 1), INDEX) - 1; % In each critical band 
	Kf = find([ones(1, K(1) - 1) Flags(K) ones(1, length(Flags) - K(length(K)))] == 0)';
	if Kf,      
		power = 10*log10(sum([10.^(X(Kf) / 10) 10^(MIN_POWER / 10)]));     
		weight = sum(10.^(X(Kf) / 10).*(TH(Map(Kf), BARK)' - i));     
 		Flags(1, Kf) = IRRELEVANT; 	
		index = K(1) + round(weight / 10^(power / 10)*(K(length(K)) + 1 - K(1)));
	else 
		index  = round(mean([K(1) K(length(K)) + 1]));
		power = MIN_POWER;
 	end
	index = max(min(index, length(Flags)), 1);
	if Flags(index) == TONAL
		index = index + 1;
	end
	Non_tonal_list(i, INDEX) = index; 
   	Non_tonal_list(i, SPL) = power; 
   	Flags(index) = NON_TONAL; 
end 
    
% The index number for the non tonal component is the index nearest 
% to the geometric of the critical band 
% For each subband 
%   - index of the non - tonal component 
%   - sound pressure level of this component
