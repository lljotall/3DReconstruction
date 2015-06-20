function s = confidence(I)
I = I - min(I(:));
I = I ./ max(I(:));

f1 = [0 1 0; 0 -1 0; 0 0 0];
f2 = [0 0 0; 1 -1 0; 0 0 0];
f3 = [0 0 0; 0 -1 1; 0 0 0];
f4 = [0 0 0; 0 -1 0; 0 1 0];

s = max(max(max(filter2(f1, I), filter2(f2, I)), filter2(f3, I)), filter2(f4, I));
end