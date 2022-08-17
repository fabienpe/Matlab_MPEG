function [DFlags, DTonal_list, DNon_tonal_list] = ...
				Decimation(X,Tonal_list,Non_tonal_list,Flags)
%[DFlags, DTonal_list, DNon_tonal_list]= ...
%			Decimation(X, Tonal_list, Non_tonal_list,Flags)
%
%   Components which are below the auditory threshold or are less than one 
%   half of a critical band width from a neighbouring component are
%   eliminated [1, pp. 113]. DFlags, DTonal_list and DNon_tonal_list
%   contain the list of flags, tonal components and non-tonal components after
%   decimation.
%
%   See also Find_tonal_components
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

global SPL INDEX ATH IRRELEVANT BARK Map TH
DFlags = Flags; % Flags after decimation


% Tonal or non-tonal components are not considered if lower than 
% the absolute threshold of hearing found in TH(:, ATH). 
 
% Non tonal case 
DNon_tonal_list=Non_tonal_list; 
if not(isempty(Non_tonal_list))
	K=Non_tonal_list(:,SPL)<TH(Map(Non_tonal_list(:,INDEX)),ATH);
	Kf=find(K)';
	if Kf,
		DFlags(Non_tonal_list(Kf,1))=IRRELEVANT; 
		DNon_tonal_list(Kf,:)=[];
	end 

end 

% Tonal case (first part) 
DTonal_list =Tonal_list; 
if not(isempty(Tonal_list)) 
	   K = Tonal_list(:,SPL) < TH(Map(Tonal_list(:,1)), ATH); 
	   Kf=find(K)';
	   if Kf,
		   DFlags(Tonal_list(Kf,1))=IRRELEVANT; 
	   	   DTonal_list(Kf,:)=[]; 
	   end 
	% Eliminate tonal components that are less than one half of 
	% critical band width from a neighbouring component. 
	% (second part of tonal case) 

	ind =1:length(DTonal_list(:,1))-1; 
K =(TH(Map(DTonal_list(ind+1,1)),BARK)-TH(Map(DTonal_list(ind,1)),BARK))<0.5;
	Kb=(DTonal_list(ind, SPL) < DTonal_list(ind + 1, SPL));	
	Kf=find(K&Kb)';	      
	if Kf,
		DFlags(DTonal_list(Kf,1)) = IRRELEVANT;
	end 
	Kfb=find(K&~Kb)';
	if Kfb,	       
		DFlags(DTonal_list(Kfb+1,1)) = IRRELEVANT; 
	end 

	Kf=[Kf Kfb];
	DTonal_list(Kf,:)=[];
end;

