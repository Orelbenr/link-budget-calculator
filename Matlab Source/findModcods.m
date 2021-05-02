function [elevation_vec, modcod_index, modcod_eff, t_vec, Rs, bandwidth] ...
        = findModcods( T_Prx , T_Gmax , T_Lftx , T_theta3db , T_theta_misalign, initial_elevation, elevation_step, ...
                      freq , height , R_theta3db , R_theta_misalign , G_over_T, MODCODS, initial_modcod, ...
                       roll_off,  im_error, margin)
                  
%% Find Max Bandwith And Rs
% calculate C/No for the initial elevation angle.
c_over_n0 = linkBudget( T_Prx , T_Gmax , T_Lftx , T_theta3db , T_theta_misalign, freq , ...
            height ,initial_elevation , R_theta3db , R_theta_misalign , G_over_T);

% Find best bandwidth and symbol rate for for the specified c/N0
% and the selected initial modcod
selected_modcod = MODCODS(initial_modcod,:);
[bandwidth,Rs] = findMaxBandwidth( c_over_n0 ,roll_off, selected_modcod , im_error , margin);
 
%% Best Modcod for each angle
% Define vector of angles which we find the best modcods for.
elevation_vec = initial_elevation:elevation_step:90;
if elevation_vec(end)~=90; elevation_vec=[elevation_vec,90]; end
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