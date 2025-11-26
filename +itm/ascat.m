function A_scat = ascat(prop)
% ASCAT - Calculates tropospheric scatter loss.
%
% This function is a placeholder for a full implementation of the
% tropospheric scatter model as described in Longley-Rice. A full
% implementation involves complex empirical formulas based on scatter angle,
% atmospheric parameters, and frequency.
%
% This placeholder returns a simplified empirical result that ensures
% scatter loss is only dominant at very large distances.
%
% SYNTAX:
%   A_scat = ascat(prop)
%
% INPUTS:
%   prop - The comprehensive properties structure from qlrpfl.
%
% OUTPUTS:
%   A_scat - The approximated scatter loss in dB.

    d_km = prop.d_km;
    f_MHz = prop.freq_mhz;

    % This is a simplified placeholder formula. A full implementation would
    % calculate the scatter angle and use detailed empirical curves.
    % This formula provides a high loss value that scales with distance
    % and frequency, ensuring it only contributes at very long ranges.
    
    A_scat = 130.0 + 20 * log10(f_MHz) + 10 * log10(d_km);
    
    if A_scat < 0
        A_scat = 0;
    end

    % fprintf('Note: ascat is using a simplified placeholder formula.\n');
end
