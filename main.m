function main(varargin)

switch length(varargin)
    case 0
        path = './';
        fileExtension = '.tiff';
        matchAlgorithm = 'HARRIS';
    case 1
        path = [char(varargin(1)), '/'];
        fileExtension = '.tiff';
        matchAlgorithm = 'HARRIS';
    case 2
        path = [char(varargin(1)), '/'];
        fileExtension = char(varargin(2));
        matchAlgorithm = 'HARRIS';
    case 3
        path = [char(varargin(1)), '/'];
        fileExtension = char(varargin(2));
        matchAlgorithm = char(varargin(3));
end

images = dir([path, '*', fileExtension]);
nimages = size(images, 1);

structure3D = [];
for i=1%:nimages-1
    % Reads images
    im1 = imread([path, images(i).name]);
    im2 = imread([path, images(i + 1).name]);
    

    % Matches those images
    [matchedPoints1, matchedPoints2, metric] = matchImages( im1, im2, ...
        matchAlgorithm);
    
    % Executes matchPropagtion
    
    % Computes Quasi-dense point correspondences 
    
    % Extracts 3D structure
    if (matchedPoints1.Count > 3)
        x = zeros(2, matchedPoints1.Count, 2);
        x(1, :, :) = matchedPoints1.Location;
        x(2, :, :) = matchedPoints2.Location;
        [X, M, t] = bundleAdjustment(x);
        structure3D = [structure3D, X];
    end
    
    % Visualize the corresponding points.
    coord = matchedPoints1.Location
    subplot(1, 2, 1); 
    imshow(im1);
    hold on;
    scatter(coord(:, 1), coord(:, 2), 5);
    hold off;
    coord = matchedPoints2.Location;
    subplot(1, 2, 2);
    imshow(im2);
    hold on;
    scatter(coord(:, 1), coord(:, 2), 5);
    hold off;
    
    figure;
    scatter3(X(1,:), X(2,:), X(3,:));
end

end
