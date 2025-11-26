function L_fs = free_space_loss(dist_km, freq_mhz)
% FREE_SPACE_LOSS - Calculates free-space path loss.
%
% This function calculates the path loss that would occur if the antennas
% were in a vacuum, based on the Friis transmission equation.
%
% SYNTAX:
%   L_fs = free_space_loss(dist_km, freq_mhz)
%
% INPUTS:
%   dist_km  - The path distance in kilometers.
%   freq_mhz - The frequency in MHz.
%
% OUTPUTS:
%   L_fs     - The free-space path loss in dB.

    % Standard formula for FSPL using distance in km and frequency in MHz.
    % The constant 32.44 comes from 20*log10(4*pi / c) with units conversion.
    L_fs = 32.44 + 20 * log10(dist_km) + 20 * log10(freq_mhz);

end
