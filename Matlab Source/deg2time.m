function t = deg2time(height, elevation)
% This fucntion gets a vector of elevations and calculates a vector of times in minutes.
% Each elemnt in the time vector, is the time it takes to get to the corresponding angle
% in the elevation vector, from the first angle in the elevation vector.
%
% --Inputs--
%   height - the satellite hight above earth in KM
%   elevation - elevation angle vector in degrees
%
%--outputs--
%   t - time vector in minutes   
    
    
    % Constants
    R = 6371; % earth radius - [KM]
    M = 5.972e24; % earth mass - [KG]
    G = 6.67408e-20; % gravitational constant - [KM^3 * s^2 / KG]
    
    mu = G*M;
    a = R + height; % setellite hight from center of earth [KM]
    T0 = 2*pi * sqrt(a^3 / mu); % full rotation time [sec]

    zenithal_vec = 90- elevation;
    
    % calculating view angle:
    % from 5A, page 2, eq 5.42
    ni = a / R;
    H = 1 / ni;
    Z = 1 ./ tan(deg2rad(zenithal_vec));
    alpha = 2 * atan( (sqrt(1 + Z.^2 - H^2) - Z) / (1 + H) );
    alpha(zenithal_vec==0)=0;
    % calculating time:
    % T = T0 * [view_angle / 2*pi]
    % T = T / 60  (time in minuts)
    t = (T0/60) * (alpha(1)-alpha)/ (2*pi);
end