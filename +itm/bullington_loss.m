function loss = bullington_loss(profile, prop)
% BULLINGTON_LOSS - Calculates diffraction loss using the Bullington method.
%
% This function determines the diffraction loss by constructing a single
% equivalent knife-edge from the terrain profile, as described by the
% Bullington method. It finds the point of maximum path obstruction
% relative to the line-of-sight path.
%
% SYNTAX:
%   loss = bullington_loss(profile, prop)
%
% INPUTS:
%   profile - The terrain profile structure from read_terrain().
%   prop    - The comprehensive properties structure from qlrpfl.
%
% OUTPUTS:
%   loss    - The diffraction loss in dB calculated by the Bullington method.

    % --- 1. Prepare Data ---
    elevations = profile.elev;
    xi = profile.xi;
    np = profile.np;
    dist_m = (0:np) * xi;
    
    % Use effective antenna heights for the calculation
    tx_height = elevations(1) + prop.he(1);
    rx_height = elevations(end) + prop.he(2);
    
    d_total_m = dist_m(end);
    
    % --- 2. Find Point of Maximum Obstruction ---
    
    % Define the line-of-sight path between antenna tops
    los_slope = (rx_height - tx_height) / d_total_m;
    los_path_y = tx_height + los_slope * dist_m;
    
    % Calculate the clearance of the terrain relative to the LOS path
    clearance = elevations - los_path_y;
    
    % Find the maximum obstruction height (h) and its location (d1)
    [h, max_idx] = max(clearance);
    
    % If h is negative, the path is clear, so diffraction loss is zero.
    if h <= 0
        loss = 0.0;
        return;
    end
    
    d1 = dist_m(max_idx);
    d2 = d_total_m - d1;
    
    % Check for edge cases where the obstacle is at the transmitter/receiver
    if d1 == 0 || d2 == 0
        loss = 0.0;
        return;
    end
    
    % --- 3. Calculate Diffraction Loss ---
    
    % Wavelength
    c = 2.99792458e8;
    lambda = c / (prop.freq_mhz * 1e6);
    
    % Dimensionless diffraction parameter 'nu'
    nu = h * sqrt((2 / lambda) * (d_total_m / (d1 * d2)));
    
    % Calculate the final loss using the single knife-edge formula
    loss = itm.knife_edge_loss(nu);

end
