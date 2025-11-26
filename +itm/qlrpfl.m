function prop_out = qlrpfl(profile, prop_in)
% QLRPFL - Master preparatory routine for Longley-Rice terrain analysis.
%
% This function orchestrates the calls to the preparatory subroutines
% (zlsq1, hzns, dlthx) to calculate various effective geometric parameters
% from the terrain profile. It follows the "Quick LR Profile" logic.
%
% SYNTAX:
%   prop_out = qlrpfl(profile, prop_in)
%
% INPUTS:
%   profile  - The terrain profile structure from read_terrain().
%   prop_in  - The input parameter structure defined in the main script.
%              It must contain hg (structural heights) and N_s 
%              (surface refractivity).
%
% OUTPUTS:
%   prop_out - A new structure containing all fields from prop_in, plus the
%              newly calculated effective parameters:
%              .he      - 2-element vector of effective antenna heights [m].
%              .dl      - 2-element vector of horizon distances [m].
%              .the     - 2-element vector of horizon elevation angles [rad].
%              .deltah  - Terrain irregularity parameter [m].
%              .d_km    - Total path distance in kilometers.
%
% See also: zlsq1, hzns, dlthx.

    % Copy all input properties to the output structure
    prop_out = prop_in;
    
    % Add terrain profile distance to the structure for convenience
    prop_out.d_m = profile.dist;
    prop_out.d_km = profile.dist / 1000.0;
    
    % --- 1. Calculate Effective Antenna Heights (zlsq1) ---
    % This must be done first, as effective heights are inputs to hzns.
    he(1) = itm.zlsq1(profile, prop_in.hg(1), 1); % For Tx
    he(2) = itm.zlsq1(profile, prop_in.hg(2), 2); % For Rx
    prop_out.he = he;
    
    % --- 2. Calculate Horizon Parameters (hzns) ---
    % Uses the effective heights just calculated.
    [dl, the] = itm.hzns(profile, prop_out.he, prop_in.N_s);
    prop_out.dl = dl;
    prop_out.the = the;
    
    % --- 3. Calculate Terrain Irregularity (dlthx) ---
    deltah = itm.dlthx(profile);
    prop_out.deltah = deltah;

end
