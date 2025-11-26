function profile = read_terrain(filename)
% READ_TERRAIN - Loads a terrain profile from a text file.
%
% This function reads a two-column text file containing distance and
% elevation data. It converts this data into a structured format
% consistent with the PFL (Profile) array described in the Longley-Rice
% model documentation.
%
% SYNTAX:
%   profile = read_terrain(filename)
%
% INPUTS:
%   filename - The path to the terrain file. The file should have two
%              columns: distance (in meters) and elevation (in meters).
%
% OUTPUTS:
%   profile  - A structure containing the formatted terrain profile with
%              the following fields:
%              .dist  - The total path distance in meters.
%              .np    - The number of points (intervals) in the profile.
%              .xi    - The step size (resolution) of the profile in meters.
%              .elev  - A row vector containing the elevation data points.
%
% EXAMPLE:
%   p = read_terrain('X.txt');
%
% See also: dlmread, readmatrix.

    % Read the two-column data from the file
    data = dlmread(filename);
    
    % Extract distance and elevation columns
    distances_m = data(:, 1);
    elevations_m = data(:, 2);
    
    % The number of intervals (np) is the number of points minus 1
    num_points = length(elevations_m);
    profile.np = num_points - 1;
    
    % The total path distance is the last distance value
    profile.dist = distances_m(end);
    
    % Calculate the step size (xi) from the first two points.
    % The model assumes a constant step size.
    if num_points > 1
        profile.xi = distances_m(2) - distances_m(1);
    else
        profile.xi = 0;
    end
    
    % Per the FORTRAN PFL array structure, the elev array should contain
    % all elevation points, including the start and end.
    % The format is [z(0), z(1), ..., z(np)]
    % In MATLAB, this is just a 1-based array of all elevation points.
    profile.elev = elevations_m'; % Use a row vector for consistency

end
