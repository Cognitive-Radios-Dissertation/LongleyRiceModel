function visualize_path(terrain_profile, prop)
% VISUALIZE_PATH - Creates a plot of the terrain profile and radio path.
%
% This function generates a visualization of the propagation path, including
% the terrain, antenna locations, line-of-sight path, and radio horizons.
%
% SYNTAX:
%   visualize_path(terrain_profile, prop)
%
% INPUTS:
%   terrain_profile - The terrain profile structure from read_terrain().
%   prop            - The comprehensive properties structure from qlrpfl.

    % --- Prepare Data ---
    elev = terrain_profile.elev;
    xi = terrain_profile.xi;
    np = terrain_profile.np;
    dist_m = (0:np) * xi;
    dist_km = dist_m / 1000;
    
    % Antenna positions
    tx_pos = [0, elev(1) + prop.hg(1)];
    rx_pos = [dist_km(end), elev(end) + prop.hg(2)];
    
    % Horizon data
    tx_horizon_dist_km = prop.dl(1) / 1000;
    rx_horizon_dist_km = prop.d_km - (prop.dl(2) / 1000);
    
    % Line of Sight (LOS) path
    los_path_y = linspace(tx_pos(2), rx_pos(2), np + 1);

    % --- Create Figure ---
    figure('Name', 'Longley-Rice Path Profile', 'NumberTitle', 'off');
    hold on;

    % --- 1. Plot Terrain ---
    % Use 'area' to fill the terrain profile
    area(dist_km, elev, 'FaceColor', [0.6 0.4 0.2], 'EdgeColor', 'none', 'DisplayName', 'Terrain Profile');

    % --- 2. Plot Antennas ---
    plot(tx_pos(1), tx_pos(2), '^', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'DisplayName', 'Transmitter');
    plot(rx_pos(1), rx_pos(2), 'v', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'DisplayName', 'Receiver');

    % --- 3. Plot Line of Sight (LOS) ---
    plot(dist_km, los_path_y, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Line of Sight');

    % --- 4. Plot Horizon Lines ---
    % Tx Horizon
    tx_horizon_line_y = tx_pos(2) + tan(prop.the(1)) * dist_m(1:find(dist_km >= tx_horizon_dist_km, 1));
    plot(dist_km(1:length(tx_horizon_line_y)), tx_horizon_line_y, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Tx Radio Horizon');
    
    % Rx Horizon
    rx_elev_rev = fliplr(elev);
    rx_dist_rev_m = (0:np) * xi;
    rx_horizon_idx = find(rx_dist_rev_m >= prop.dl(2), 1);
    rx_horizon_line_y = rx_pos(2) + tan(prop.the(2)) * rx_dist_rev_m(1:rx_horizon_idx);
    plot(fliplr(dist_km(end-rx_horizon_idx+1:end)), rx_horizon_line_y, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Rx Radio Horizon');
    
    % --- 5. Plot First Fresnel Zone (60% clearance) ---
    c = 2.99792458e8;
    lambda = c / (prop.freq_mhz * 1e6);
    fresnel_radius = 0.6 * sqrt(lambda * (dist_m(2:end-1) .* fliplr(dist_m(2:end-1))) / dist_m(end));
    plot(dist_km(2:end-1), los_path_y(2:end-1) + fresnel_radius, 'k:', 'DisplayName', '60% Fresnel Zone');
    plot(dist_km(2:end-1), los_path_y(2:end-1) - fresnel_radius, 'k:');

    % --- Final Touches ---
    hold off;
    grid on;
    xlabel('Distance (km)');
    ylabel('Elevation (m)');
    title('Longley-Rice Path Visualization');
    legend('show', 'Location', 'northeast');
    axis tight; % Adjust axis to fit data
    
    % Add a bit of vertical padding to the plot
    yl = ylim;
    ylim([yl(1) yl(2) + 0.1 * (yl(2)-yl(1))]);
end
