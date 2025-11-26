function A_los = alos(profile, prop)
% ALOS - Calculates attenuation for a Line-of-Sight (LOS) path.
%
% This function calculates the attenuation for a path that is determined to
% be Line-of-Sight. In the Longley-Rice model, this is not simply 0 dB.
% Instead, it uses an "extended diffraction" model to ensure a smooth
% transition to trans-horizon paths and to "fill in" the deep nulls that
% would be predicted by a simple two-ray model.
%
% The simplest way to implement this is to call the same diffraction
% routine used for trans-horizon paths. The geometry of an LOS path will
% result in a negative diffraction parameter (nu), and the knife-edge
% loss function will correctly return a small loss value representing the
% "extended diffraction" concept.
%
% SYNTAX:
%   A_los = alos(profile, prop)
%
% INPUTS:
%   profile - The terrain profile structure from read_terrain().
%   prop    - The comprehensive properties structure from qlrpfl.
%
% OUTPUTS:
%   A_los - The line-of-sight attenuation in dB.
%
% See also: adiff.

    % For a line-of-sight path, the attenuation is calculated using the
    % same diffraction model to ensure continuity between regimes.
    A_los = itm.adiff(profile, prop);

end
