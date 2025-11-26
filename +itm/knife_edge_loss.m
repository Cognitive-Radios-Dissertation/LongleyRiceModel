function J_nu = knife_edge_loss(nu)
% KNIFE_EDGE_LOSS - Calculates single knife-edge diffraction loss.
%
% This function calculates the diffraction loss in dB for a given
% dimensionless Fresnel-Kirchhoff diffraction parameter, nu.
%
% SYNTAX:
%   J_nu = knife_edge_loss(nu)
%
% INPUTS:
%   nu   - The dimensionless diffraction parameter.
%
% OUTPUTS:
%   J_nu - The diffraction loss in dB.
%
% NOTES:
%   This function uses a common and accurate approximation for the
%   Fresnel integral-based loss function J(nu).

    if nu > -0.78
        % For nu > -0.78, use the standard approximation
        J_nu = 6.91 + 20 * log10(sqrt((nu - 0.1)^2 + 1) + nu - 0.1);
    else
        % For nu <= -0.78 (i.e., well into the line-of-sight region),
        % the diffraction loss is negligible.
        J_nu = 0.0;
    end

end
