% Read the stereo images.
I1 = imread('159_i110.png');
I2 = imread('159_i120.png');

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

aS = alphaShape(X', 2);

plot(aS);