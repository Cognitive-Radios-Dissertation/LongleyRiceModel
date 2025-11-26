function A_diff = adiff(profile, prop)
% ADIFF - Calculates diffraction loss for a trans-horizon path.
%
% This function now acts as a wrapper for the selected diffraction model.
% As requested, it now uses the Bullington method to find an equivalent
% single knife-edge and calculate the diffraction loss.
%
% SYNTAX:
%   A_diff = adiff(profile, prop)
%
% INPUTS:
%   profile - The terrain profile structure from read_terrain().
%   prop    - The comprehensive properties structure from qlrpfl.
%
% OUTPUTS:
%   A_diff - The diffraction loss in dB.
%
% See also: bullington_loss, knife_edge_loss.

    % The diffraction model has been replaced with the Bullington method.
    A_diff = itm.bullington_loss(profile, prop);

end