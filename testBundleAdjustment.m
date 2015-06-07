function error = testBundleAdjustment(x)
%TESTBUNDLEADJUSTMENT receives the same matrix as the function 
% BUNDLEADJUSTMENT and computes the mean error of the recontruction of the 
% projection points with the outputs from that function

[X, M, t] = bundleAdjustment(x);
[m, n, ~] = size(x);

xout = zeros(m, n, 2);
for i=1:m
   MM = M(2*i-1:i*2, :);
   for j=1:n
        XX = X(:, j);
        xap = MM*XX + t(i, :)';
        xout(i, j, 1) = xap(1);
        xout(i, j, 2) = xap(2);
   end 
end

error = mean(abs((xout(:) - x(:))./x(:)));

end