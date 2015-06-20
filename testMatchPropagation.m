path(path, './HeapKV');
path(path, './Data Structures/Hash Tables');

% imagePath = '../BustJpg/';
% I1 = rgb2gray(imread([imagePath, 'B22.jpg']));
% I2 = rgb2gray(imread([imagePath, 'B21.jpg']));

imagePath = './';
I1 = imread([imagePath, '159_r0.png']);
I2 = imread([imagePath, '159_r5.png']);


% Match images
x = matchImages2(I1, I2);

p1 = reshape(x(1, :, :), size(x, 2), size(x, 3));
p2 = reshape(x(2, :, :), size(x, 2), size(x, 3));
p1 = [p1(:, 2), p1(:, 1)];
p2 = [p2(:, 2), p2(:, 1)];

% a miracle pls
[map1, map2] = matchPropagation(I1, I2, p1, p2);

% visualize the corresponding points.
coord = [map1(:, 2), map1(:, 1)];
subplot(1, 2, 1); 
imshow(I1);
hold on;
scatter(coord(:, 1), coord(:, 2), 7, '+');
hold off;
coord = [map2(:, 2), map2(:, 1)];
subplot(1, 2, 2);
imshow(I2);
hold on;
scatter(coord(:, 1), coord(:, 2), 7, '+');
hold off;

% visualize the corresponding points.
coord = [map1(:, 2), map1(:, 1)];
subplot(1, 2, 1); 
imshow(I1);
hold on;
scatter(coord(:, 1), coord(:, 2), 7, '+');
hold off;
coord = [map2(:, 2), map2(:, 1)];
subplot(1, 2, 2);
imshow(I2);
hold on;
scatter(coord(:, 1), coord(:, 2), 7, '+');
hold off;

