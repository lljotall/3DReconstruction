% PATH settings
path(path, 'C:\Users\lljotall\Documents\Unicamp\11\EA979\Projeto\3DReconstruction\HeapKV');
path(path, 'C:\Users\lljotall\Documents\Unicamp\11\EA979\Projeto\3DReconstruction\Data Structures\Hash Tables');

% Read the stereo images.
I1 = imread('tom/tom_100_25__0_0.tiff');
I2 = imread('tom/tom_100_25__0_5.tiff');

% Match images
[ matchedPoints1, matchedPoints2, metric ] = matchImages( I1, I2, 'SURF' );

% Visualize the corresponding points.
% figure; showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);

[seed, local] = matchPropagation(I1, I2, matchedPoints1, matchedPoints2);