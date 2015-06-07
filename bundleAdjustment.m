function [M, X, t] = bundleAdjustment(x)
%BUNDLEADJUSTMENT Recovers camera matrices, 3D matched structure and 
% translation vectors
%   The function receives a matrix with the matched points and returns a
%   matrix with all camera matrices, a matrix with the 3D structure and a
%   matrix with the translation vectors
%   Input:
%       - 'x': matrix m-by-n-by-2 with n > 4, where each x(i, j, :)
%       represents the coordinates of the j-th matched point from the i-th 
%       projection.
%   Output:
%       - 'M': matrix 2*m-by-3 of projections matrices in which each 
%       projection matrix is 2-by-3.
%       - 'X': matrix 3-by-n of 3D structure in which each X(:, j) 
%       representts the j-th matched point in the 3D space.
%       - 't': m-by-2 matrix of translation vectors in which each t(i, :) 
%       represents the image coordinates of the centroid of the projected 
%       points  

[m, n, ~] = size(x);

% Computes translation vectors to centred data and measurement matrix W
t = mean(x, 2);
center = bsxfun(@minus, x, t);
t = [t(:, 1), t(:, 2)];
W = zeros(2*m, n);
W(1:2:end - 1, :) = center(:, :, 1);
W(2:2:end, :) = center(:, :, 2);

% Obtains the matrix of camera matrices M and 3D matched structure X
[U, D, V] = svd(W);
M = bsxfun(@times, U(:, 1:3)', diag(D(:, 1:3)))';
X = V(:, 1:3)';

end