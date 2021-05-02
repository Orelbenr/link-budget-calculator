function c_over_n0 = linkBudget( T_Prx , T_Gmax , T_Lftx , T_theta3db , T_theta_misalign, ...
                                 freq , height ,elevation , R_theta3db , R_theta_misalign , G_over_T)

% --inputs--
%   T_Prx [dBW] - Transmiter Input Power
%   T_Gmax [dBi] - Transmiter Antena Gain
%   T_Lftx [dB] - Transmiter to antena losses
%   T_theta3db [degrees] - Transmiter HPBW/2
%   T_theta_misalign [degrees] - Transmiter maximum misalignment angle
%   height [km] - Satellite's height relative to the earth's surface
%   freq [GHz] - Transmition frequency
%   elevation [degrees] - Satellite's angle above the horizon relative to the earth station
%   R_theta3db [degrees] - Receiver HPBW/2
%   R_theta_misalign [degrees] - Receiver maximum misalignment angle
%   G_over_T [dB/K] - Receiver's figure of merit
%
%--outputs--
%   c_over_n0 [dbHz] - Link budget value

%%  Calculating EIRP [dBW]:
    % from 5A, page 13, eq 5.16
    EIRP = T_Prx + T_Gmax - T_Lftx;
    
%%  Calculating Path Losses:
    %------ Calculate Transmiter and receiver depointing losses -----
    % from 5A, page 13, eq 5.18
    Lt = 12 * ( T_theta_misalign / T_theta3db )^2  ; % [dB] - Trasmiter Depointing Loss
    Lr = 12 * ( R_theta_misalign / R_theta3db )^2 ; % [dB] - Receiver Depointing Loss
    
    %----- Free space loss Calculation -----
    % Constants:
    earthRad= 6371; %[km] - earth's radius
    c=299792458 *1e-3;% [km/s] - speed of light
    a=earthRad+height; % [km] - Satellit's distance from the center of the earth 
    
    % Calculating view angle, that is the angle of the satelaite reletive to the center of the earth:
    % from 5A, page 2, eq 5.42
    H = earthRad / a;
    Z = 1 / tan(deg2rad(90-elevation));
    alpha = 2 * atan( (sqrt(1 + Z^2 - H^2) - Z) / (1 + H) );
    if elevation == 90 ; alpha =0; end 

    
    % Calculating the distance of the satellite from earth station
    % Using cosine theorem
    R= sqrt( earthRad^2 + a^2 - 2*earthRad*a*cos(alpha) ); % [km]
    
    % Calculate wavelength
    lambda= c / (freq *1e9) ; %[km]
    
    % Calcuate free space loss [dB]
    % from 5A, page 10, right after eq 5.13 
    Lfs=10*log10( ( 4*pi*R / lambda )^2 ); % [dB]
    
    %----- Calculating Atmospheric Loss -----
    % Atmosphiric loss Corresponding to various satelite elevations
    % from 5A - page 45 figure 5.30
    La_values = [ 10   , 20   , 30   , 90   ;  ...  % [degrees] -  Elevation 
                  1.28 , 0.68 , 0.45 , 0.21 ] ;  % [dB] - Atmospheric loss
    
    % We used curve fitting to find an aproximate curve
    La = 12.14 / elevation + 0.06505;
    
    %----- Total Path Loss -----
    % from 5A - page 12, eq 5.14 (we also include depointing losses)
    L = Lt + Lr + Lfs + La; % [dB]
    
%% Figure Of Merit (G/T)
    % 99.5% Link Availability (Rain)
    % from 9A, page 4

%% Calculate Link Budget (C/N0)
   % boltzman's contant
   kb = 1.38064852 * 10^(-23); % [( m^2 kg )/( s^2 K^1 )] 
   
   %from 5A - page 25, eq 5.37   
   c_over_n0 =    EIRP - L + G_over_T - 10*log10(kb) ; %[dBHz]
end
