function [x, matchedPoints1, matchedPoints2] = matchImages2( I1, I2)
%MATCHIMAGES Match two images and returns the matched points.
%   The function receives two images, detect some features in them and
%   return two lists with the matched points.
%   Input: two images
%   Output: a set of points and a metric array(dependent on chosen method).
%       - 'x': matrix m-by-n-by-2, where each x(i, j, :) represents the
%       coordinates of the j-th matched point from the i-th projection.
    features = {@(x) detectSURFFeatures(x);...
        @(x) detectHarrisFeatures(x);...
        @(x) detectMSERFeatures(x)};
    x = [];
    
    for i = 1:3
        % Find the features.
        points1 = features{i}(I1);
        points2 = features{i}(I2);

        % Extract the neighborhood features.
        [features1, valid_points1] = extractFeatures(I1, points1);
        [features2, valid_points2] = extractFeatures(I2, points2);

        % Match the features.
        indexPairs = matchFeatures(features1, features2);

        % Retrieve the locations of the corresponding points for each image.
        matchedPoints1 = valid_points1(indexPairs(:, 1), :);
        matchedPoints2 = valid_points2(indexPairs(:, 2), :);

        sizeX = size(x);
        count = matchedPoints1.Count;
        x = [x zeros(2, count, 2)];
        x(1, (sizeX(2)+1):(sizeX(2)+count), :) = matchedPoints1.Location;
        x(2, (sizeX(2)+1):(sizeX(2)+count), :) = matchedPoints2.Location;
    end
end

