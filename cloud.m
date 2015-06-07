% Teste de conceito - em tese, constroi uma nuvem de pontos a partir das
% imagens.
% ver http://www.mathworks.com/help/vision/examples/stereo-calibration-and-scene-reconstruction.html
I1 = imread('tom/tom_100_25__0_0.tiff');
I2 = imread('tom/tom_100_25__4_0.tiff');

% Calibracao com tabuleiro - nao rolou =//
% [imagePoints, boardSize] = detectCheckerboardPoints(I1, I2);
% squareSize = 10;
% worldPoints = generateCheckerboardPoints(boardSize, squareSize);


[matchedPoints1, matchedPoints2, metric ] = matchImages( I1, I2);

fRANSAC = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-4);

% P = [I | 0] and P' = [[e']×F | e']. - como achar epipola?
stereoParams = 0;%estimateCameraParameters(imagePoints,worldPoints);
% stereoParams = stereoParameters(cameraParameters1,cameraParameters2,rotationOfCamera2,translationOfCamera2)

% Continua normal
disparityMap = disparity(I1,I2);

pointCloud = reconstructScene(disparityMap,stereoParams);

showPointCloud(pointCloud);
