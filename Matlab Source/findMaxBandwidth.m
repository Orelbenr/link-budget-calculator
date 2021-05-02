function [bandwidth,Rs] = findMaxBandwidth( c_over_n0 ,roll_off, modcod , im_error , margin)
% --inputs--
%   c_over_n0 [dBHz] - Link budget value
%   roll_of - Window rolloff factor
%   modcod - All of the modcod's details
%   im_error [dB] - Modcod implimantion error
%   margin [dB] - Link Margin
%
%--outputs--
%   bandwidth [MHz] - Maximum Bandwidth
%   Rs [MHz] - Maximum Symbol Rate
 
  % Extract parameters from modcod 
  modcod_Eb_n0 = modcod(4); % [dB] - Modcod ideal Eb/N0 
  modcod_bitPerSymbol = modcod(1); % Number of bits sent in a symbol

  % Eb/N0 = (1/Rb)*(C/N0)
  % from 5B, page 25, eq 4.60
  Rb =10^( ( c_over_n0 - modcod_Eb_n0 - margin - im_error )/10 ); %[Hz]
  
  Rs= (Rb / modcod_bitPerSymbol)*1e-6; % [MHz]
  
  %occupied bandwidth
  %from 3A, page 19
  bandwidth= Rs*(1+roll_off); % [MHz]
 
end