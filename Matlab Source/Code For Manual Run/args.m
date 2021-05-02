clear;
%% Transimter
T_Gmax= 23.5 ; %dBi - Transmiter Antena Gain (9A - page 10)
T_Prx = 10*log10(0.6); % dBW - Transmiter Output Power (9A - page 10)
T_theta3db= 10.2; %degrees - Transmiter HPBW (9A - page 10)
T_theta_misalign= 1 ; %degrees - Transmiter maximum misalignment angle (Link Budget Paremeters)
T_EIRP = 20 ; %dBW - Transmiter EIRP (9A - page 10)
T_Lftx = T_Prx + T_Gmax - T_EIRP ; %dB - Transmiter to Antena losses

%% Reciever
height = 800 ; % km - Satellite's height relative to the earth's surface (Link Budget Paremeters)
R_theta3db= 0.28; %degrees - Reciever HPBW (9A - page 4)
R_theta_misalign= 0.03 ; %degrees - Reciever maximum misalignment angle (Link Budget Paremeters)
G_over_T = 28.5 ; % dB/K - Reciever figure of merit (9A - page 4)

%% Other Parameters
freq = 26.8; % GHz - Trasmited frequency (Link Budget Paremeters)
im_error = 1.5; % dB  - Implementaion Error (Link Budget Paremeters)
margin = 6 ; % dB - Link margin (Link Budget Paremeters)
roll_off = 0.2; % Roll off factor (Link Budget Paremeters)
%% DVB-S2 MODCODS 
    %from 3C - page 36
    MODCODS=[
 %    Bit/Symbol, Code Rate, Spectral Efficency, Es/N0
        2 ,1/4,  0.490243, -2.35
        2 ,1/3,  0.656448, -1.24
        2 ,2/5,  0.789412, -0.30
        2 ,1/2,  0.988858, 1.00
        2 ,3/5,  1.188304, 2.23
        2 ,2/3,  1.322253, 3.10
        2 ,3/4,  1.487473, 4.03
        2 ,4/5,  1.587196, 4.68
        2 ,5/6,  1.654663, 5.18
        2 ,8/9,  1.766451, 6.20
        2 ,9/10, 1.788612, 6.42
        3 ,3/5,  1.779991, 5.50
        3 ,2/3,  1.980636, 6.62
        3 ,3/4,  2.228124, 7.91
        3 ,5/6,  2.478562, 9.35
        3 ,8/9,  2.646012, 10.69
        3 ,9/10, 2.679207, 10.98
        4 ,2/3,  2.637201, 8.97
        4 ,3/4,  2.966728, 10.21
        4 ,4/5,  3.165623, 11.03
        4 ,5/6,  3.300184, 11.61
        4 ,8/9,  3.523143, 12.89
        4 ,9/10, 3.567342, 13.13
        5 ,3/4,  3.703295, 12.73
        5 ,4/5,  3.951571, 13.64
        5 ,5/6,  4.119540, 14.28
        5 ,8/9,  4.397854, 15.69
        5 ,9/10, 4.453027, 16.05 ];
    
    %change Es/N0 to Eb/N0
    MODCODS(:,4) = MODCODS(:,4) - 10*log10(MODCODS(:,1) );
    
%% Save Args To Mat File
save('args.mat')