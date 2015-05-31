function [ matchedPoints1, matchedPoints2, metric ] = matchImages( I1, I2, varargin )
%MATCHIMAGES Match two images and returns the matched points.
%   The function receives two images, detect some features in them and
%   return two lists with the matched points.
%   Input: two images and an optional method
%       Method options:
%       - 'Harris' (default): corner features
%       - 'SURF': object features (used to detect scaling, rotating and translating)
%   Output: a set of points and a metric array(dependent on chosen method).
%       The points may contain a set of fields, and the most useful one is 
%   'Location', which contains the pixels coordinates in the original image.
%       The metric array contains the distance between features. The
%   smaller it is, the closer the features it represents.
    
    % Find the features.
    if length(varargin) >= 1 && strcmp(varargin(1), 'SURF')
        points1 = detectSURFFeatures(I1);
        points2 = detectSURFFeatures(I2);
    else %Harris
        points1 = detectHarrisFeatures(I1);
        points2 = detectHarrisFeatures(I2);
    end
    
    % Extract the neighborhood features.
    [features1, valid_points1] = extractFeatures(I1, points1);
    [features2, valid_points2] = extractFeatures(I2, points2);

    % Match the features.
    [indexPairs, metric] = matchFeatures(features1, features2);

    % Retrieve the locations of the corresponding points for each image.
    matchedPoints1 = valid_points1(indexPairs(:, 1), :);
    matchedPoints2 = valid_points2(indexPairs(:, 2), :);
end

