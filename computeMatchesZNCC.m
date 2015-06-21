function [zncc, np1, np2] = computeMatchesZNCC(I1, p1, I2, p2, windowSize)

[maxRow, maxCol] = size(I1);
npoints = size(p1, 1);
zncc = zeros(1, npoints);

p1 = uint32(round(p1));
p2 = uint32(round(p2));

% compute windows limits
windows1(:, :, 1) = p1 - windowSize;
windows1(:, :, 2) = p1 + windowSize;
windows1(windows1(:, :, 1) < 1) = 1;
windows1(windows1(:, 1, 2) > maxRow, 1, 2) = maxRow;
windows1(windows1(:, 2, 2) > maxCol, 2, 2) = maxCol;

windows2(:, :, 1) = p2 - windowSize;
windows2(:, :, 2) = p2 + windowSize;
windows2(windows2(:, :, 1) < 1) = 1;
windows2(windows2(:, 1, 2) > maxRow, 1, 2) = maxRow;
windows2(windows2(:, 2, 2) > maxCol, 2, 2) = maxCol;

np1 = [];
np2 = [];
for i=1:npoints
    w1 = I1(windows1(i, 1, 1):windows1(i, 1, 2), windows1(i, 2, 1):windows1(i, 2, 2));
    w2 = I2(windows2(i, 1, 1):windows2(i, 1, 2), windows2(i, 2, 1):windows2(i, 2, 2));
    
    if size(w1, 1) == size(w2, 1) && size(w1, 2) == size(w2, 2)
        zncc(i) = computeZNCC(w1, w2);
        np1(i, :) = p1(i, :);
        np2(i, :) = p2(i, :);
    end
end

end