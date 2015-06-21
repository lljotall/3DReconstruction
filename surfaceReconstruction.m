% Read the stereo images.
% I1 = imread('159_r0.png');
% I2 = imread('159_r10.png');

I1 = rgb2gray(imread('../AppleJpg/A17.jpg'));
I2 = rgb2gray(imread('../AppleJpg/A18.jpg'));

% Match images
x = matchImages2( I1, I2);

% Visualize the corresponding points.
coord = x(1,:,:);
subplot(1, 2, 1); 
imshow(I1);
hold on;
scatter(coord(1,:, 1), coord(1,:, 2), 5);
hold off;
coord = x(2,:,:);
subplot(1, 2, 2);
imshow(I2);
hold on;
scatter(coord(1,:, 1), coord(1,:, 2), 5);
hold off;

[X, M, t] = bundleAdjustment(x);

DT = delaunayTriangulation(X(1,:)',X(2,:)',X(3,:)');

figure;tetramesh(DT);

tri = delaunay(X');
figure;scatter3(X(1,:), X(2, :), X(3,:));
xlabel('x');
ylabel('y');
zlabel('z');
%tetramesh(tri,X');
sizeTri = size(tri);
P1 = [reshape(tri(:, 1:3), [1, 3*sizeTri(1)]) ...
    reshape(tri(:, 1:2), [1, 2*sizeTri(1)]) ...
    reshape(tri(:, 1), [1, sizeTri(1)])];
P2 = [reshape(tri(:, 2:4), [1, 3*sizeTri(1)]) ...
    reshape(tri(:, 3:4), [1, 2*sizeTri(1)]) ...
    reshape(tri(:, 4), [1, sizeTri(1)])];

dists = sqrt(sum((X(:, P1)-X(:, P2)).^2));
graph = sparse([P1 P2], [P2 P1], [dists dists]);
T = graphminspantree(graph, 'Method', 'Kruskal');
indexes = find(T);
sizeT = size(T);
pairs = [rem(indexes, sizeT(1)) ceil(indexes/sizeT(1))];
pairs(pairs == 0) = sizeT(1);

figure;
plot3([X(1, pairs(:, 1)')' X(1, pairs(:, 2)')'],...
    [X(2, pairs(:, 1)')' X(2, pairs(:, 2)')'],...
    [X(3, pairs(:, 1)')' X(3, pairs(:, 2)')'] );