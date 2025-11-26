function plot_loss_vs_distance(distances, losses)
% PLOT_LOSS_VS_DISTANCE - Creates a 2D plot of path loss vs. distance.
%
% SYNTAX:
%   plot_loss_vs_distance(distances, losses)
%
% INPUTS:
%   distances - A vector of distances in kilometers.
%   losses    - A vector of corresponding path loss values in dB.

    % Create a new figure for the plot
    figure('Name', 'Path Loss vs. Distance', 'NumberTitle', 'off');
    
    % Plot the data
    plot(distances, losses, 'b-', 'LineWidth', 1.5);
    
    % Add plot enhancements
    grid on;
    xlabel('Distance (km)');
    ylabel('Path Loss (dB)');
    title('Path Loss vs. Distance');
    axis tight; % Fit axes to the data range
    
    % Add some padding to the y-axis for better visualization
    yl = ylim;
    ylim([yl(1) - 0.1*abs(yl(1))  yl(2) + 0.1*abs(yl(2))]);

end
