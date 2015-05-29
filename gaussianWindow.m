% Build a gaussian window

function w = gaussianWindow(size, stdDev)

Index = zeros(size*size, 2);
[Index(:,1), Index(:,2)] = ind2sub([size, size], 1:size*size);
Index = Index - ceil(size/2);

ww = exp(-(Index(:,1).*Index(:,1) + Index(:,2).*Index(:,2))./ ...
    (2*stdDev*stdDev));

w = reshape(ww, size,size);

end