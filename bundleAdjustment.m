function [M, X, t] = bundleAdjustment(x)
%BUNDLEADJUSTMENT Recovers camera matrixes, 3D matched structure and 
% shift vectors
%   The function receives a matrix with the matched points and returns a
%   matrix with all camera matrixes, a matrix with the 3D structure and a
%   matrix with the translation vectors
%   Input:
%       - 'x': matrix m-by-n-by-2 with n > 4, where each x(i, j, :)
%       represents the coordinates of the j-th matched point from the i-th 
%       projection.
%   Output:
%       - 'M': matrix of projections matrixes. Each projections matrix is
%       2-by-3.
%       - 'X': matrix of 3D structure. Each X(:, j) representts the
%       j-th matched point in the 3D space.
%       - 't': matrix of translation vectors. Each t(i, :) represents the
%       image coordinates of the centroid of the projected points  

[m, n, ~] = size(x);

% Computes translation vector to centred data and measurement matrix W
t = mean(x, 2);
center = bsxfun(@minus, x, t);
t = [t(:, 1), t(:, 2)];
W = zeros(2*m, n);
W(1:2:end - 1, :) = center(:, :, 1);
W(2:2:end, :) = center(:, :, 2);

% Obtains the camera matrixes M and 3D matched structure
[U, D, V] = svd(W);
M = bsxfun(@times, U(:, 1:3)', diag(D(:, 1:3)))';
X = V(:, 1:3)';

end