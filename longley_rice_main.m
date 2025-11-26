% Main script for the Longley-Rice Irregular Terrain Model
% 
% This script defines the input parameters, calls the necessary functions
% to run the model, and outputs the final path loss.

clear; clc; 

% -------------------------------------------------------------------------
% Define Input Parameters
% -------------------------------------------------------------------------

% --- User-Defined Parameters ---
prop.freq_mhz = 970.0;      % Frequency in MHz
prop.hg(1) = 52.0;          % Transmitter antenna height above ground (meters)
prop.hg(2) = 2.4;         % Receiver antenna height above ground (meters)

% --- Default Parameters (from ITM documentation) ---
% Polarization: 0 for Horizontal, 1 for Vertical
prop.polarization = 0;

% Climate Code: 1-7 (e.g., 5 for Continental Temperate)
% 1: Equatorial (Congo)
% 2: Continental Subtropical (Sudan)
% 3: Maritime Subtropical (West Coast of Africa)
% 4: Desert (Sahara)
% 5: Continental Temperate (Central North America, Interior of Australia)
% 6: Maritime Temperate, over land (UK and West Coast of North America/Europe)
% 7: Maritime Temperate, over sea
prop.climate_code = 5;

% Surface Refractivity (N-units)
prop.N_s = 301.0;

% Ground Permittivity (Dielectric Constant)
prop.epsilon_r = 15.0;

% Ground Conductivity (Siemens/meter)
prop.sigma = 0.005;

% Reliability and Confidence (Quantiles)
% The model calculates a distribution of loss values. These inputs specify
% what point on the distribution to calculate. 0.5 is the median.
prop.req_reliability = 0.5; % Time/situation/location reliability (e.g., 0.9 = 90%)

% -------------------------------------------------------------------------
% Load and Prepare Terrain Profile
% -------------------------------------------------------------------------
% This function will load the terrain data from data/X.txt and format it
% into the structure required by the model.
disp('Loading terrain profile...');
terrain_profile = utils.read_terrain('data/X.txt');
disp('Terrain profile loaded.');

% -------------------------------------------------------------------------
% Execute Longley-Rice Model
% -------------------------------------------------------------------------

% 1. qlrpfl: Preparatory calculations for effective heights, horizons, etc.
disp(' ');
disp('--- Running Preparatory Terrain Analysis ---');
prop_effective = itm.qlrpfl(terrain_profile, prop);
fprintf('Effective Tx Height (he1): %.2f m\n', prop_effective.he(1));
fprintf('Effective Rx Height (he2): %.2f m\n', prop_effective.he(2));
fprintf('Tx Horizon Distance (dl1):   %.2f km\n', prop_effective.dl(1)/1000);
fprintf('Rx Horizon Distance (dl2):   %.2f km\n', prop_effective.dl(2)/1000);
fprintf('Terrain Irregularity (Delta h): %.2f m\n', prop_effective.deltah);

% 2. lrprop: Core propagation loss calculation for reference attenuation.
disp(' ');
disp('--- Running Core Propagation Model ---');
A_ref = itm.lrprop(terrain_profile, prop_effective); % Reference Attenuation in dB
fprintf('Reference Attenuation (A_ref): %.2f dB\n', A_ref);

% 3. avar: Statistical variability calculation.
disp(' ');
disp('--- Calculating Statistical Variability ---');
A_var = itm.avar(prop_effective); % Variability adjustment in dB
fprintf('Variability Adjustment (A_var): %.2f dB for %.2f reliability\n', A_var, prop.req_reliability);

% 4. Calculate final path loss
disp(' ');
disp('--- Calculating Final Path Loss ---');
L_fs = utils.free_space_loss(prop_effective.d_km, prop_effective.freq_mhz);

% The final loss is Free Space Loss + Reference Attenuation + Variability.
% A positive variability value from avar() increases the total path loss
% to meet the required reliability.
L_b = L_fs + A_ref + A_var;

fprintf('Free Space Path Loss (L_fs):   %.2f dB\n', L_fs);
fprintf('Total Path Loss (L_b):         %.2f dB\n', L_b);

% 5. Generate Visualization
disp(' ');
disp('--- Generating Path Visualization ---');
utils.visualize_path(terrain_profile, prop_effective);
disp('Plot generation complete.');

% -------------------------------------------------------------------------
% Generate Path Loss vs. Distance Data
% -------------------------------------------------------------------------
disp(' ');
disp('--- Calculating Path Loss vs. Distance (this may take a moment) ---');

num_points_total = terrain_profile.np + 1;
distances_km = zeros(1, num_points_total);
path_losses_db = zeros(1, num_points_total);

% Start loop from the second point to avoid zero distance
for i = 2:num_points_total
    % Create a temporary sub-profile for the calculation
    sub_profile.np = i - 1;
    sub_profile.xi = terrain_profile.xi;
    sub_profile.dist = terrain_profile.xi * (i - 1);
    sub_profile.elev = terrain_profile.elev(1:i);
    
    % Run the full calculation for this sub-path
    prop_loop = itm.qlrpfl(sub_profile, prop);
    A_ref_loop = itm.lrprop(sub_profile, prop_loop);
    A_var_loop = itm.avar(prop_loop);
    L_fs_loop = utils.free_space_loss(prop_loop.d_km, prop_loop.freq_mhz);
    L_b_loop = L_fs_loop + A_ref_loop + A_var_loop;
    
    % Store results
    distances_km(i) = prop_loop.d_km;
    path_losses_db(i) = L_b_loop;
    
    % Print progress
    if mod(i, 50) == 0
        fprintf('Calculating for point %d of %d...\n', i, num_points_total);
    end
end

disp('Path loss calculation complete.');

% 6. Plot Path Loss vs. Distance
utils.plot_loss_vs_distance(distances_km, path_losses_db);
