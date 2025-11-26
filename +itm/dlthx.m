function deltah = dlthx(profile)
% DLTHX - Calculates the terrain irregularity parameter (delta h).
%
% This function implements the dlthx subroutine logic from the Longley-Rice
% model. It quantifies the roughness of the terrain by calculating the
% interdecile range of terrain elevations after removing a linear trend.
%
% SYNTAX:
%   deltah = dlthx(profile)
%
% INPUTS:
%   profile - The terrain profile structure from read_terrain().
%
% OUTPUTS:
%   deltah  - The terrain irregularity parameter in meters.
%
% NOTES:
%   The calculation is performed on a subset of the terrain to avoid
%   biasing the result with the immediate transmitter/receiver sites. This
%   implementation uses the central 80% of the path.
%
% See also: polyfit, polyval, prctile.

    elevations = profile.elev;
    num_points = profile.np + 1;
    xi = profile.xi;
    
    % --- 1. Range Selection ---
    % Select the central 80% of the profile to avoid endpoint bias.
    start_idx = floor(0.1 * num_points) + 1;
    end_idx = floor(0.9 * num_points);
    
    % Ensure indices are valid
    if start_idx >= end_idx
        % If the path is too short, use the whole profile
        start_idx = 1;
        end_idx = num_points;
    end
    
    elev_segment = elevations(start_idx:end_idx);
    dist_segment = (start_idx-1:end_idx-1) * xi;

    % --- 2. Trend Removal (Linear Fit) ---
    % Fit a straight line to the selected profile points.
    p = polyfit(dist_segment, elev_segment, 1);
    
    % --- 3. Residual Calculation ---
    % Calculate the fitted line values at each point.
    fitted_line = polyval(p, dist_segment);
    
    % Calculate the residuals (difference between actual and fitted).
    residuals = elev_segment - fitted_line;
    
    % --- 4. Interdecile Range Calculation ---
    % Find the 10th and 90th percentile values of the residuals.
    v_10 = prctile(residuals, 10);
    v_90 = prctile(residuals, 90);
    
    % --- 5. Result ---
    % Delta h is the difference between the 90th and 10th percentiles.
    deltah = v_90 - v_10;

end
