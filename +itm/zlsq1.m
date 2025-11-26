function he = zlsq1(profile, hg, antenna_idx)
% ZLSQ1 - Calculates effective antenna height using least-squares fit.
%
% This function implements the zlsq1 subroutine logic described in the
% Longley-Rice model. It calculates the effective antenna height by
% performing a linear least-squares regression on the foreground terrain
% and determining the height of the antenna's radiation center above this
% fitted line.
%
% SYNTAX:
%   he = zlsq1(profile, hg, antenna_idx)
%
% INPUTS:
%   profile     - The terrain profile structure from read_terrain().
%   hg          - The structural height of the antenna above ground (meters).
%   antenna_idx - The index of the antenna (1 for Tx, 2 for Rx).
%
% OUTPUTS:
%   he          - The calculated effective antenna height in meters.
%
% NOTES:
%   The "range of interest" for the regression is a key parameter.
%   This implementation fits the line to the entire path profile from
%   the antenna's perspective. More complex implementations might use a
%   shorter range (e.g., to the horizon).
%
% See also: polyfit, polyval.

    elevations = profile.elev;
    num_points = profile.np + 1;
    xi = profile.xi; % Step size in meters

    % Create a vector of distances for the x-axis of the regression
    distances = (0:num_points-1) * xi;

    if antenna_idx == 1 % Transmitter
        % Use the profile as is
        z_ground = elevations(1);
        elev_segment = elevations;
        dist_segment = distances;
    elseif antenna_idx == 2 % Receiver
        % Reverse the profile to calculate from the receiver's perspective
        z_ground = elevations(end);
        elev_segment = fliplr(elevations);
        dist_segment = distances; % Distances are relative from the antenna
    else
        error('Invalid antenna_idx. Must be 1 (Tx) or 2 (Rx).');
    end

    % Perform a linear least-squares regression (degree 1 polynomial)
    % p(1) is the slope (m), p(2) is the y-intercept (c)
    p = polyfit(dist_segment, elev_segment, 1);

    % The "effective ground plane" (z_eff) is the value of the fitted
    % line at the antenna's location (x=0). This is the y-intercept.
    z_eff = p(2);

    % The antenna's radiation center is its ground elevation + structural height
    z_radiation_center = z_ground + hg;

    % Effective height is the difference between the radiation center
    % and the effective ground plane elevation.
    he = z_radiation_center - z_eff;

end
