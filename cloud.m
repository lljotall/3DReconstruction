% Teste de conceito - em tese, constroi uma nuvem de pontos a partir das
% imagens.
% ver http://www.mathworks.com/help/vision/examples/stereo-calibration-and-scene-reconstruction.html
I1 = imread('tom/tom_100_25__6_0.tiff');
I2 = imread('tom/tom_100_25__4_0.tiff');

% Erro aqui - nao retorna ponto nenhum :/
[imagePoints, boardSize] = detectCheckerboardPoints(I1, I2);

squareSize = 10;
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

stereoParams = estimateCameraParameters(imagePoints,worldPoints);

disparityMap = disparity(I1,I2);

pointCloud = reconstructScene(disparityMap,stereoParams);

showPointCloud(pointCloud);
