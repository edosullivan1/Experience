clear; close all;

pic = imread('greece.tif');

%Original Picture
figure(1);
image(pic);
colormap(gray(256));
title('Original Image');

%Corrupted Image
load badpicture.mat;
pic2 = imread('badpixels.tif');

figure(2)
image(badpic);
colormap(gray(256));
title('Corrupted Image');

%Forcing Function
load forcing.mat

%convert greece image
original_pic_integer = zeros(720, 1280);
for k = 1:1:921600
    original_pic_integer(k) = int8(pic(k));
end

%Calculate co-ordinates
[p] = find(pic2 == 1);
N = length(p);

n = floor(p / 720) + 1;
m = rem(p, 720);

alpha = 1;
E1 = zeros(N, 1);
E2 = zeros(N, 1);
image_restored = badpic;
image_restored_f = badpic;

%Calculation without f
sum_deviations_sq = zeros(1500,1);
ms_error = zeros(1500,1);
std_error = zeros(1500, 1);

for j = 1:1:1500
    for i = 1:1:N
        E1(i) = image_restored(m(i) - 1, n(i)) + image_restored(m(i) + 1,n(i)) + ... 
            image_restored(m(i), n(i)-1) + image_restored(m(i), n(i) + 1) ...
            - 4 * image_restored(m(i), n(i));
        
        image_restored(m(i), n(i)) = image_restored(m(i), n(i)) + ...
            alpha * (E1(i) / 4);
        
        sum_deviations_sq(j) = sum_deviations_sq(j) + (original_pic_integer(m(i), n(i)) -...
            image_restored(m(i), n(i))) ^ 2;
    end
    ms_error(j) = sum_deviations_sq(j) / N;
    std_error(j) = sqrt(ms_error(j));
end

%Restored image without f
figure(3)
image(image_restored);
colormap(gray(256));
title('Restored Picture');

%Calculations with f

sum_deviations_sq_2 = zeros(1500,1)
mse_2 = zeros(1500,1);
standard_error_2 = zeros(1500, 1);


for j = 1:1:1500
    for i = 1:1:N
        E2(i) = image_restored_f(m(i) - 1, n(i)) + image_restored_f(m(i) + 1,n(i)) + ... 
            image_restored_f(m(i), n(i)-1) + image_restored_f(m(i), n(i) + 1) ...
            - 4 * image_restored_f(m(i), n(i)) - f(m(i), n(i));
        
        image_restored_f(m(i), n(i)) = image_restored_f(m(i), n(i)) + ...
            alpha * (E2(i) / 4);
        
        sum_deviations_sq_2(j) = sum_deviations_sq_2(j) + (original_pic_integer(m(i), n(i)) -...
            image_restored_f(m(i), n(i))) ^ 2;
    end
    mse_2(j) = sum_deviations_sq_2(j)/ N;
    standard_error_2(j) = sqrt(mse_2(j));
end

%Restored image with f
figure(4)
image(image_restored_f);
colormap(gray(256));
title('Restored Picture(with F)');

%std error vs iterations
iterations = 1:1:1500;

figure(5)
h = plot(iterations, std_error, 'r-', iterations, standard_error_2,...
    'b-', 'linewidth', 3.0);
xlabel('Iterations', 'fontsize', 24);
ylabel('Std Error', 'fontsize', 24);
title('Standard Error vs Iterations', 'fontsize', 24);
legend('Without Forcing Function', 'With Forcing Function','Location',...
    'northeast');

