%% Load Args
clear; close all; clc;
load('args.mat');

%% Find Max Bandwith And Rs
% calculate C/No for the initial elevation angle.
elevation = 10 ; 
c_over_n0 = linkBudget( T_Prx , T_Gmax , T_Lftx , T_theta3db , T_theta_misalign, freq , ...
            height ,elevation , R_theta3db , R_theta_misalign , G_over_T);

% Find best bandwidth and symbol rate for for the specified c/N0
% and the selected initial modcod
selected_modcod = MODCODS(4,:);
[bandwidth,Rs] = findMaxBandwidth( c_over_n0 ,roll_off, selected_modcod , im_error , margin);
 
%% Best Modcod for each angle
% Define vector of angles which we find the best modcods for.
elevation_vec = 10:1:90;
modcod_index = zeros(size(elevation_vec));

% For each angle, calculate c/N0 and find the index of the best modcod.  
for i= 1:length(elevation_vec)

c_over_n0 = linkBudget( T_Prx , T_Gmax , T_Lftx , T_theta3db , T_theta_misalign, freq , ...
            height ,elevation_vec(i) , R_theta3db , R_theta_misalign , G_over_T);
        
modcod_index(i) = findModcodForElevation(c_over_n0 , Rs , MODCODS , im_error, margin);

end

% Extract the Spectral Efficiency corresponding the best modcod for each angle. 
modcod_eff = MODCODS(modcod_index,3);

% Create a time vector. Each elemnt in the time vector, is the time it takes 
% to get to the corresponding angle in the elevation vector,
% from the first angle in the elevation vector.
t_vec = deg2time(height,elevation_vec);

% Plot Spectral Efficiency per rotational time.
% The time starts at the initial elevation angle, and end at 90 degrees.
figure;
subplot(2,1,1)
plot(t_vec,modcod_eff,'.-')
title('Spectral Efficency For Best Modcod For Given Degree By Time')
xlabel('Time from start of visibility [minutes]')
ylabel('Spectral Efficency')

subplot(2,1,2)
yyaxis left
plot(t_vec,modcod_index,'.-')
title('Index of Best Modcod For Given Degree By Time')
xlabel('Time from start of visibility [minutes]')
ylabel('Index')
yyaxis right
plot(t_vec,elevation_vec,'.-')
ylabel('Elevation Angle')

figure;
t_vis = [t_vec ,2*t_vec(end)-fliplr(t_vec(1:end-1))];
modcod_eff_vis = [modcod_eff; flipud(modcod_eff(1:end-1))];
plot(t_vis,modcod_eff_vis,'.-','MarkerSize',6)
xlim('auto')
title('Spectral Efficency For Best Modcod For Given Degree By Time','FontSize',11)
xlabel('Time from start of visibility [minutes]','FontSize',11)
ylabel('Spectral Efficency','FontSize',11)
