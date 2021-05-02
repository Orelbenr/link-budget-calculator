function modcod_index = findModcodForElevation(c_over_n0 , Rs , MODCODS , im_error, margin)
% -- inputs --
%   c_over_n0 [dBHz] - Link budget value
%   Rs [MHz] - Symbol Rate
%   MODCODS - Modcod list with all of the modcod details
%   im_error [dB] - Implementaion Error
%   margin [dB] - Link margin
% -- outputs --
%   modcod_index - The index of the best modcode for the input

%%
    % Transfer Units
    Rs = Rs*1e6; %[Hz]
    effective_Eb_n0 = 10.^( ( MODCODS(:,4) + im_error + margin )/10 );
    c_over_n0 = 10^(c_over_n0 /10);
    
    
    %(effective_Eb/N0)*ModcodBitPerSym = (1\Rs)*(C\N0)
    % from 5B, page 25, eq 4.60
    % We calculate the left side of the equation for each modcod, and we 
    % find the modcod which is closest to, but smaller then, the right side of the equation.
    modcodReq = (effective_Eb_n0) .*MODCODS(:,1);

    dif =c_over_n0/Rs  - modcodReq;
    eff = MODCODS(:,3);
    max_eff = max( eff(dif>=0) );
    modcod_index = find(eff==max_eff);

end