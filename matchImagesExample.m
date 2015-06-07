% Read the stereo images.
I1 = imread('tom/tom_100_25__0_5.tiff');
I2 = imread('tom/tom_100_25__0_8.tiff');

% Match images
[ matchedPoints1, matchedPoints2, metric ] = matchImages( I1, I2, 'SURF' );

% Visualize the corresponding points.
coord = matchedPoints1.Location
subplot(1, 2, 1); 
imshow(I1);
hold on;
scatter(coord(:, 1), coord(:, 2), 5);
hold off;
coord = matchedPoints2.Location;
subplot(1, 2, 2);
imshow(I2);
hold on;
scatter(coord(:, 1), coord(:, 2), 5);
hold off;
