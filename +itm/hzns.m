function [dl, the] = hzns(profile, he, N_s)
% HZNS - Calculates radio horizon distances and elevation angles.
%
% This function implements the hzns (horizons) subroutine logic from the
% Longley-Rice model. It scans a terrain profile to find the maximum
% elevation angle, which defines the radio horizon, accounting for
% atmospheric refractivity (i.e., effective Earth curvature).
%
% SYNTAX:
%   [dl, the] = hzns(profile, he, N_s)
%
% INPUTS:
%   profile - The terrain profile structure from read_terrain().
%   he      - A 2-element vector with the effective heights of the
%             transmitter and receiver in meters, [he1, he2].
%   N_s     - The surface refractivity in N-units.
%
% OUTPUTS:
%   dl      - A 2-element vector of horizon distances in meters, [dl1, dl2].
%   the     - A 2-element vector of horizon elevation angles in radians,
%             [the1, the2].
%
% NOTES:
%   The calculation is performed for the transmitter (forward) and then
%   for the receiver (backward).

    % --- Calculate Effective Earth Radius ---
    R_a = 6371000; % Actual Earth radius in meters
    gamma_a = 1 / R_a;
    
    % The formula for effective curvature is given in the guide.
    % N1 is a constant, typically 179.3 from NBS Tech Note 101.
    N1 = 179.3; 
    gamma_e = gamma_a * (1 - 0.04665 * exp(-N_s / N1));
    
    % The term used in the horizon angle formula is 1 / (2 * a_e), which
    % is equivalent to gamma_e / 2.
    earth_curvature_term = gamma_e / 2.0;

    % --- Prepare terrain data ---
    elev = profile.elev;
    xi = profile.xi;
    np = profile.np;
    distances = (0:np) * xi;

    % Initialize output arrays
    dl = zeros(1, 2);
    the = zeros(1, 2);

    % --- Transmitter Horizon Calculation ---
    % Total elevation of Tx = ground elevation + effective height
    ztx = elev(1) + he(1);
    max_angle = -inf;
    horizon_idx = 1;

    % Iterate from the first point *after* the transmitter to the end
    for i = 2:(np + 1)
        di = distances(i);
        if di == 0, continue; end
        
        % Formula for elevation angle to point i
        angle = (elev(i) - ztx) / di - earth_curvature_term * di;
        
        if angle > max_angle
            max_angle = angle;
            horizon_idx = i;
        end
    end
    dl(1) = distances(horizon_idx);
    the(1) = max_angle;

    % --- Receiver Horizon Calculation ---
    % Reverse the profile for the receiver's perspective
    elev_rev = fliplr(elev);
    
    % Total elevation of Rx = ground elevation + effective height
    zrx = elev_rev(1) + he(2);
    max_angle = -inf;
    horizon_idx = 1;
    
    % Iterate from the first point *after* the receiver (in reversed profile)
    for i = 2:(np + 1)
        di = distances(i); % Distances are relative from the antenna
        if di == 0, continue; end
        
        % Formula for elevation angle to point i
        angle = (elev_rev(i) - zrx) / di - earth_curvature_term * di;
        
        if angle > max_angle
            max_angle = angle;
            horizon_idx = i;
        end
    end
    dl(2) = distances(horizon_idx);
    the(2) = max_angle;

end
