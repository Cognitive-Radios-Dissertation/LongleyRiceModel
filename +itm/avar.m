function Y = avar(prop)
% AVAR - Calculates statistical variability for a given reliability.
%
% This function implements the avar subroutine logic from the Longley-Rice
% model. It computes a statistical adjustment factor (Y) based on the
% desired reliability and the propagation environment.
%
% SYNTAX:
%   Y = avar(prop)
%
% INPUTS:
%   prop - The comprehensive properties structure from qlrpfl. It must
%          contain req_reliability, climate_code, and deltah.
%
% OUTPUTS:
%   Y    - The combined deviation (variability adjustment) in dB.
%
% NOTES:
%   This implementation uses the structural formulas from the ITM guide but
%   employs placeholders for functions that would normally rely on extensive
%   empirical lookup tables (e.g., for time variability).

    % --- 1. Convert Reliability to Standard Normal Deviate ---
    % The user provides a reliability (e.g., 0.9 for 90%). This is
    % converted to a one-sided standard normal deviate (z-score).
    z = norminv(prop.req_reliability);
    
    % For a single reliability value, we use it for all three components.
    z_T = z;
    z_L = z;
    z_S = z;

    % --- 2. Calculate Variability Components ---
    
    % Location Variability (Y_L)
    % For a point-to-point prediction, the location is fixed, so the
    % location variability is typically set to 0.
    Y_L = 0.0;
    
    % Time Variability (Y_T)
    % This is highly dependent on climate and path distance. A full
    % implementation uses empirical data from NBS Tech Note 101.
    % This is a placeholder that captures the general behavior.
    % Maritime climates (6, 7) have higher variability than continental (5).
    climate_factor = 1.0 + 0.5 * (prop.climate_code > 5); % Simple scaling
    Y_T = climate_factor * (prop.d_km / 100.0) * z_T;
    
    % Situation Variability (Y_S)
    % This combines the other variances to estimate the total uncertainty.
    % sigma_S is a base standard deviation for the model's confidence.
    sigma_S = 5.5; % Typical value is 5-6 dB.
    
    % The formula from the implementation guide:
    Y_S_sq_term = sigma_S^2 + (Y_T^2 / (7.8 + z_S^2)) + (Y_L^2 / (24 + z_S^2));
    Y_S = z_S * sqrt(Y_S_sq_term);
    
    % The final combined deviation is Y_S
    Y = Y_S;

end
