% % Read the stereo images.
% I1 = imread('159_i110.png');
% I2 = imread('159_i120.png');
% 
% % Match images
% x = matchImages2( I1, I2);
% 
% % Visualize the corresponding points.
% coord = x(1,:,:);
% subplot(1, 2, 1); 
% imshow(I1);
% hold on;
% scatter(coord(1,:, 1), coord(1,:, 2), 5);
% hold off;
% coord = x(2,:,:);
% subplot(1, 2, 2);
% imshow(I2);
% hold on;
% scatter(coord(1,:, 1), coord(1,:, 2), 5);
% hold off;
% 
% [X, M, t] = bundleAdjustment(x);
X = [0 0 0 0 1 1 1 1;0 0 1 1 0 0 1 1;0 1 0 1 0 1 0 1];%[1 3 2 3 2 -1; 0 0 2 5 4 -1; 0 0 0 1 2 -1];
figure;scatter3(X(1,:), X(2, :), X(3,:));
hoho = 'hoho1'

power = ones(length(X),1);
F = scatteredInterpolant(X(1,:)', X(2,:)', X(3,:)', power, 'natural');

max_x = max(X(1,:)); min_x = min(X(1,:));
max_y = max(X(2,:)); min_y = min(X(2,:));
max_z = max(X(3,:)); min_z = min(X(3,:));

stepSize = (abs(min_x)-abs(max_x))*.1;
xi = min_x:abs(stepSize):max_x;
yi = min_y:abs(stepSize):max_y;
zi = min_z:abs(stepSize):max_z;

hoho = 'hoho2'

[qx,qy,qz] = meshgrid(xi,yi,zi);
qV = F(qx,qy,qz);

hoho = 'hoho3'
figure;
p2 = patch(isosurface(qx,qy,qz,qV,1),'FaceColor','blue',...
 'EdgeColor','none');