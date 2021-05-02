function visTime = visibilityTime(height, zenithalAngle)
% --Inputs--
%   hight - the satellite hight above earth in KM
%   zenithalAngle - zenithal angle in degrees
%
%--outputs--
%   visTime - visibilty time in minutes   
    
    
    % Constants
    R = 6371; % earth radius - [KM]
    M = 5.972e24; % earth mass - [KG]
    G = 6.67408e-20; % gravitational constant - [KM^3 * s^2 / KG]
    
    mu = G*M;
    a = R + height; % setellite hight from center of earth [KM]
    T0 = 2*pi * sqrt(a^3 / mu); % full rotation time [sec]
    
    % calculating view angle:
    % from 5A, page 2, eq 5.42
    ni = a / R;
    H = 1 / ni;
    Z = 1 / tan(deg2rad(zenithalAngle));
    alpha = 2 * atan( (sqrt(1 + Z^2 - H^2) - Z) / (1 + H) );
    
    % calculating visibility time:
    % T = T0 * [view_angle / 2*pi]
    % T = T / 60  (time in minuts)
    visTime = (T0/60) * (2*alpha)/ (2*pi);
end