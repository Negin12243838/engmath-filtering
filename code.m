

clc 
clear
% % % % % %  part2_3 _HPF ANF LPF
imagePath = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\pic1.jpg";
% assert(isfile(imagePath), 'Image file not found at the specified path!');
Pic1=imread(imagePath);
Pic1=rgb2(Pic1);
figure;
subplot(1, 3, 1);
imshow(Pic1);
title('Original');
subplot(1, 3, 2); 
filtered_image =HPF(Pic1);
imshow(filtered_image, []);
title('HPF');
subplot(1,3, 3);
filtered_image2 =LPF(Pic1);
imshow(filtered_image2, []);
imshow(filtered_image2);
title('LPF');
%% % % % illustrate the magnitude and the phazor of the image
imagePath2 = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\pic2.jpg"
Pic2=imread(imagePath2);
Pic2 = rgb2gray(Pic2);
imagePath3 = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\pic3.jpg"
Pic3=imread(imagePath3);
Pic3 = rgb2gray(Pic3);
if size(Pic2) ~= size(Pic3)
    Pic3 = imresize(Pic3, size(Pic2));
end
Image_freq2 = fft2(double(Pic2)); 
Image_freq3 = fft2(double(Pic3)); 
phase2 = angle(Image_freq2); 
phase3 = angle(Image_freq3); 
magnitude2 = abs(Image_freq2); 
magnitude3 = abs(Image_freq3); 
figure;
subplot(1, 2, 1);
imshow(phase3, []);  
title('Phase of Pic3');
colormap(jet);            
colorbar;
magnitudeLog3 = log(1 + fftshift(magnitude3));
subplot(1, 2, 2);
imshow(magnitudeLog3, []);
title('Magnitude Spectrum of Pic3');
colormap(jet);            
colorbar;   
f1_new = magnitude2 .* exp(1i * phase3); 
f2_new = magnitude3 .* exp(1i * phase2);

% Compute inverse FFT
new_img1 = real(ifft2(f1_new)); 
new_img2 = real(ifft2(f2_new));

new_img1 = mat2gray(new_img1);
new_img2 = mat2gray(new_img2);
figure;
subplot(1,2,1), imshow(new_img1), title('Mag(Pic2) + Phase(Pic3)');
subplot(1,2,2), imshow(new_img2), title('Mag(Pic3) + Phase(Pic2)');

%% % % % PART3_NOISE
clc
clear 
N1=noise(0.2,1000,"uniform");
N2=noise(0.2,1000,"normal");
N11=noise(0.5,1000,"uniform");
N22=noise(1.3,1000,"uniform");
figure;
subplot(1, 2, 1);
histogram(N1,100);
title('uniform noise');
subplot(1, 2, 2);
histogram(N2,100);
title('normal noise');
means_uniform = zeros(1, 1000);
means_normal = zeros(1, 1000);
for L = 1:1000
    uniform_noise = noise(0.2, L, "uniform");
    normal_noise = noise(0.2, L, "normal");
    means_uniform(L) = noise_sum(uniform_noise);
    means_normal(L) = noise_sum(normal_noise);
    energy_uniform(L)=noise_energy(uniform_noise);
    energy_normal(L)=noise_energy(normal_noise);
    CrossCorrelation_L(L)=CrossCorrelation(uniform_noise,normal_noise);
end
% figure;
% plot(1:1000,means_uniform,'r');
% title('Mean of the uniform noise vector');
% figure;
% plot(1:1000,means_normal,'b');
% title('Mean of the normal noise vector');
% figure;
% plot(1:1000,energy_uniform,'r');
% title('Energy of the uniform noise vector');
% figure;
% plot(1:1000,energy_normal,'b');
% title('Energy of the normal noise vector');
% figure;
% plot(1:1000,CrossCorrelation_L,'b');
% title('CrossCorrelation of noise vector');

t=linspace(0,2,1000);
f0 = 1;
x=sin(2*pi*f0*t);
X_energy=noise_energy(x);
N1_energy=noise_energy(N1);
N2_energy=noise_energy(N2);
N11_energy=noise_energy(N11);
N22_energy=noise_energy(N22);
xn1_energy=noise_energy(x+N1);
xn2_energy=noise_energy(x+N2);
xn11_energy=noise_energy(x+N11);
xn22_energy=noise_energy(x+N22);
figure;
subplot(1, 2, 1);
plot(t,x+N1,'b');
title('x(t) with uniform noise');
subplot(1, 2, 2);
plot(t,x+N2,'r');
title('x(t) with normal noise');
SNR1=10*log(X_energy/(xn1_energy-X_energy));
SNR2=10*log(X_energy/(xn2_energy-X_energy));
SNR11=10*log(X_energy/(xn11_energy-X_energy));
SNR22=10*log(X_energy/(xn22_energy-X_energy));
figure;
SNRs = [SNR1, SNR2];
bar(SNRs);
set(gca, 'XTickLabel', {'SNR1','SNR2'});
xlabel('Signal');
ylabel('SNR');
title('SNR Compare of x_n1 and x_n2');
grid on;
figure;
energies = [X_energy, N1_energy, N2_energy, xn1_energy, xn2_energy];
bar(energies);
set(gca, 'XTickLabel', {'x', 'N1', 'N2', 'x+N1', 'x+N2','SNR1','SNR2'});
xlabel('Signal');
ylabel('Energy');
title('Energy of Signals');
grid on;
figure;
energies2 = [SNR1,SNR11,SNR22];
bar(energies2);
set(gca, 'XTickLabel', {'a=0.2','a=0.5','a=1.3'});
title('SNR of Uniform noise in different a');
grid on;
%% % % Filters part5 
clc 
clear
imagePathn = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\noisy_spine.jpg"
assert(isfile(imagePathn), 'Image file not found at the specified path!');
Picn=imread(imagePathn);
if size(Picn, 3) == 3  
    Picn = rgb2gray(Picn);  
end
imagePathn2 = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\noisy_tumor.jpg"
assert(isfile(imagePathn2), 'Image file not found at the specified path!');
Picn2=imread(imagePathn2);
if size(Picn2, 3) == 3  
    Picn2 = rgb2gray(Picn2);  
end
imagePathn3 = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\tumor_original.jpg"
assert(isfile(imagePathn3), 'Image file not found at the specified path!');
tumor_original=imread(imagePathn3);
if size(tumor_original, 3) == 3  
    tumor_original= rgb2gray(tumor_original);
end
imagePathn4 = "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\spine_MRI_image.jpg"
assert(isfile(imagePathn4), 'Image file not found at the specified path!');
Spine_original=imread(imagePathn4);
Spine_original = imresize(Spine_original, [255, 255]);
if size(Spine_original, 3) == 3  
    Spine_original = rgb2gray(Spine_original);
end
% Step 3: Convert the resized image to grayscale
% Spine_original = double(Spine_original);
figure;
%mean_filter
denoised_image=mean_filter(Picn,1);
denoised_image3=mean_filter(Picn,3);
denoised_image7=mean_filter(Picn,7);
denoised_image2=mean_filter(Picn2,1);
denoised_image23=mean_filter(Picn2,3);
denoised_image27=mean_filter(Picn2,7);
% figure;
% subplot(1, 4, 1);
% imshow(Picn);
% title('the noisy image');
% subplot(1, 4, 2);
% imshow(denoised_image);
% title('with kernel 3*3');
% subplot(1,4,3);
% imshow(denoised_image3);
% title('with kernel 7*7');
% subplot(1,4,4);
% imshow(denoised_image7);
% title('with kernel 15*15');
%Gaussian Filter
denoised_image_gusseian7=gaussian_filter(Picn,7,7);
denoised_image_gusseian3=gaussian_filter(Picn,3,3);
denoised_image_gusseian=gaussian_filter(Picn,1,1);
denoised_image2_gusseian7=gaussian_filter(Picn2,7,7);
denoised_image2_gusseian3=gaussian_filter(Picn2,3,3);
denoised_image2_gusseian=gaussian_filter(Picn2,1,1);
% figure;
% subplot(1, 2, 1);
% imshow(denoised_image3);
% title('mean filter kernel 7*7');
% subplot(1, 2, 2);
% imshow(denoised_image_gusseian3);
% title('gussian filter kernel 7*7');
% figure;
% subplot(1, 4, 1);
% imshow(Picn);
% title('the noisy image');
% subplot(1, 4, 2);
% imshow(denoised_image_gusseian,[]);
% title('with kernel 3*3');
% subplot(1,4,3);
% imshow(denoised_image_gusseian3);
% title('with kernel 7*7');
% subplot(1,4,4);
% imshow(denoised_image_gusseian7);
% title('with kernel 15*15');
 % bilateral_filter
denoised_image_bilateral1=bilateral_filter(Picn,1,10,5);
denoised_image_bilateral3=bilateral_filter(Picn,3,30,5);
denoised_image_bilateral7=bilateral_filter(Picn,7,70,5);
denoised_image2_bilateral1=bilateral_filter(Picn2,1,10,5);
denoised_image2_bilateral3=bilateral_filter(Picn2,3,30,5);
denoised_image2_bilateral7=bilateral_filter(Picn2,7,70,5);
% subplot(1, 3, 1);
% imshow(denoised_image3);
% title('mean filter kernel 7*7');
% subplot(1, 3, 2);
% imshow(denoised_image_gusseian3);
% title('gussian filter kernel 7*7');
% subplot(1, 3, 3);
% imshow(denoised_image_bilateral3);
% title('bilateral filter kernel 7*7');
% figure;
% subplot(1, 4, 1);
% imshow(Picn);
% title('the noisy image');
% subplot(1, 4, 2);
% imshow(denoised_image_bilateral1);
% title('with kernel 3*3');
% subplot(1,4,3);
% imshow(denoised_image_bilateral3);
% title('with kernel 7*7');
% subplot(1,4,4);
% imshow(denoised_image_bilateral7);
% title('with kernel 15*15');
% evaluate 
energy=noise_energy(Spine_original)
[Brain_o_s,Brain_o_p]=compute_snr_psnr(tumor_original,Picn2 );
[Spine_o_s,Spine_o_p]=compute_snr_psnr(Spine_original,Picn);
[Brain_Mean_s,Brain_Mean_p]=compute_snr_psnr(tumor_original,denoised_image7 );
[Brain_Guassian_s,Brain_Guassian_p]=compute_snr_psnr(tumor_original,denoised_image_gusseian7);
[Brain_bilateral_s,Brain_bilateral_p]=compute_snr_psnr(tumor_original, denoised_image_bilateral3);
[Spine_Mean_s,Spine_Mean_p]=compute_snr_psnr(Spine_original,denoised_image27);
[Spine_Guassian_s,Spine_Guassian_p]=compute_snr_psnr(Spine_original,denoised_image2_gusseian7);
[Spain_bilateral_s,Spain_bilateral_p]=compute_snr_psnr(Spine_original,denoised_image2_bilateral3);

% Spine_Mean = @(Spine_original,  denoised_image27) 10 * log10(energy(Spine_original) /noise_energy(Spine_original,  denoised_image27));
%  Brain_Mean=@(tumor_original,  denoised_image7) 10 * log10(energy(tumor_original) /noise_energy(tumor_original, denoised_image7));
% 
figure;
energies = [Brain_o_s,Brain_Mean_s,Brain_Guassian_s,Brain_bilateral_s, Spine_Mean_s,Spine_Guassian_s,Spain_bilateral_s];
bar(energies);
set(gca, 'XTickLabel', {'Brain_o_s','Spine_o_s','Brain_Mean_s','Brain_Guassian','Brain_bilateral', 'Spine_Mean','Spine_Guassian','Spain_bilateral'});
bar(energies);
xlabel('Signal');
ylabel('SNR');
title('SNR');
grid on;
figure;
energies2 = [Brain_Mean_p,Brain_Guassian_p,Brain_bilateral_p, Spine_Mean_p,Spine_Guassian_p,Spain_bilateral_p];
bar(energies2);
set(gca, 'XTickLabel', {'Brain_o','Spine_o','Brain_Mean','Brain_Guassian','Brain_bilateral', 'Spine_Mean','Spine_Guassian','Spain_bilateral'});
xlabel('Signal');
ylabel('Energy');
title('PSNR');
grid on;
%% Adaptive filter 
clc 
clear
brain_img = imread("C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\\noisy_image_50.jpg");
spine_img = imread( "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\tumor_original.jpg");
img_50 = imread( "C:\Users\rakyn\OneDrive\Desktop\HW_term3\EngMathProj\pics\noisy_tumor.jpg");
if size(brain_img, 3) == 3
    brain_img = rgb2gray(brain_img);
end
if size(spine_img, 3) == 3
    spine_img = rgb2gray(spine_img);
end
if size(img_50, 3) == 3
    img_50 = rgb2gray(img_50);
end
window_size = 5;  
alpha = 0.5;    

filtered_brain = adaptive_filter(brain_img, window_size, alpha);
filtered_spine = adaptive_filter(spine_img, window_size, alpha);
filtered_img_50 = adaptive_filter(img_50, window_size, alpha);

figure;
subplot(3,1,1); imshow(filtered_brain); title('Adaptive Filtered 50HZ MRI');
subplot(3,1,2); imshow(filtered_spine); title('Adaptive Filtered Spine MRI');
subplot(3,1,3); imshow(filtered_img_50); title('Adaptive Filtered Brain MRI');

imwrite(filtered_brain, 'filtered_brain_MRI.jpg');
imwrite(filtered_spine, 'filtered_spine_MRI.jpg');
imwrite(filtered_img_50, 'filtered_Image_50HZ.jpg');
brain_img = imread('tumor_original.jpg');
spine_img = imread('original_spine_MRI.jpg');
img_50 = imread('original_spine_MRI.jpg');
if size(brain_img, 3) == 3
    brain_img = rgb2gray(brain_img);
end
if size(spine_img, 3) == 3
    spine_img = rgb2gray(spine_img);
end
if size(img_50, 3) == 3
    img_50 = rgb2gray(img_50);
end
window_size = 5;
alpha = 0.5;

filtered_brain = adaptive_filter(brain_img, window_size, alpha);
filtered_spine = adaptive_filter(spine_img, window_size, alpha);
filtered_img_50 = adaptive_filter(img_50, window_size, alpha);

[snr_brain, psnr_brain] = compute_snr_psnr(brain_img, filtered_brain);
[snr_spine, psnr_spine] = compute_snr_psnr(spine_img, filtered_spine);
[snr_50, psnr_50] = compute_snr_psnr(spine_img, filtered_spine);
figure;
energies2 = [snr_brain,snr_spine,snr_50];
bar(energies2);
set(gca, 'XTickLabel', {'snr_brain','snr_spine','snr_50'});
xlabel('Signal');
ylabel('Energy');
title('SNR');
grid on;
figure;
energies2 = [psnr_brain,psnr_spine,psnr_50];
bar(energies2);
set(gca, 'XTickLabel', {'psnr_brain','psnr_spine','psnr_50'});
xlabel('Signal');
ylabel('Energy');
title('SNR');
grid on;
% FUNCTIONS
function filtered_img = adaptive_filter(img, window_size, alpha)
    img = double(img);
    local_mean = imboxfilt(img, window_size);  
    local_var = imboxfilt(img.^2, window_size) - local_mean.^2; 
    noise_var = mean(local_var(:));  

    gain_factor = max(0, 1 - (noise_var ./ (local_var + 1e-10)));
    filtered_img = local_mean + gain_factor .* (img - local_mean);

    alpha = alpha * (1 - (noise_var / var(img(:))));
    filtered_img = uint8(filtered_img);
end

function rgb2_pic=rgb2(Pic)
if size(Pic, 3) == 3
    rgb2_pic= rgb2gray(Pic);
end
end 
function  filtered_image=HPF(Image)
[m,n]=size(Image);
H=ones(m,n);
for i=101:1000
    for j=101:1000
        H(i,j)=0;
    end 
end 
H_f =fftshift(H);% Shift zero-frequency component to center
Image_f=fft2(double(Image));
B=H_f.*Image_f;
filtered_image=abs(ifft2(B));
end


function  filtered_image=LPF(Image)
[m,n]=size(Image);
H=zeros(m,n);
for i=1:100
    for j=1:100
        H(i,j)=1;
    end 
end 
H_f =fftshift(H);% Shift zero-frequency component to center
Image_f=fft2(double(Image));
B=H_f.*Image_f;
filtered_image=abs(ifft2(B));
end
function noiseV= noise(a, L, type)
    if strcmp(type, 'uniform')
        noiseV = (2*a) * rand(1, L) - a; 
    elseif strcmp(type, 'normal')
        noiseV = a * randn(1, L);

    end
end
function noise_sum=noise_sum(N)
ns=0;
for i=1:length(N)
ns=ns+N(i);
end 
noise_sum=ns/length(N)
end 
function noise_energy=noise_energy(N)
ns=0;
for i=1:length(N)
ns=ns+N(i)*N(i);
end 
noise_energy=ns/length(N)
end
function cross= CrossCorrelation(N1,N2)
cc=0;
for i=1:length(N1)
cc=cc+N1(i)*N2(i);
end 
cross=cc/length(N1)
end 
function filtered_image = mean_filter(pic, k)
[m, n] = size(pic);
filtered_image= zeros(m, n);
    pic = double(pic);  
for i = 1:m
    for j = 1:n
        kernel_sum = 0;  % Reset for each pixel
        count = 0;

        for l = -k:k
            for e = -k:k
                if i+l >= 1 && i+l <= m && j+e >= 1 && j+e <= n
                    kernel_sum = kernel_sum + pic(i+l, j+e);
                    count = count + 1;
                end
            end
        end
        
        filtered_image(i, j) = kernel_sum / count;
    end
end

% Normalize & Convert to uint8
 filtered_image = uint8(255 * mat2gray(filtered_image));
end

% function filtered_image=Gaussian_Filter(pic,a)
% [m,n]=size(pic);
% filtered_image=zeros(m,n);
% for i=1:m
%     for j=1:n
%   filtered_image(i,j)=exp(-1*(i^2+j^2)/(2*a^2))/(2*pi*a^2)
%     end 
% end 
% end
function filtered_image = gaussian_filter(pic, k, sigma)
    [m, n] = size(pic); 
    filtered_image = zeros(m, n); 
       kernel_size = 2 * k + 1;
    gaussian_kernel = zeros(kernel_size, kernel_size);  
    for l = -k:k
        for e = -k:k
            gaussian_kernel(l+k+1, e+k+1) = exp(-(l^2 + e^2) / (2 * sigma^2));
        end
    end
    gaussian_kernel = gaussian_kernel / sum(gaussian_kernel(:));
    for i = 1:m
        for j = 1:n
            kernel_sum = 0;  
            weight_sum = 0; 
            for l = -k:k
                for e = -k:k
                    if i+l >= 1 && i+l <= m && j+e >= 1 && j+e <= n
                        kernel_sum = kernel_sum + pic(i+l, j+e) * gaussian_kernel(l+k+1, e+k+1);
                        weight_sum = weight_sum + gaussian_kernel(l+k+1, e+k+1);
                    end
                end
            end
            filtered_image(i, j) = kernel_sum / weight_sum;
        end
    end
    filtered_image = uint8(filtered_image);
end
function filtered_image = bilateral_filter(pic, k, sigma_s, sigma_r)
pic = double(pic);
    [m, n] = size(pic); 
    filtered_image = zeros(m, n); 
      [X, Y] = meshgrid(-k:k, -k:k);
    G_s = exp(-(X.^2 + Y.^2) / (2 * sigma_s^2));

    for i = 1:m
        for j = 1:n
            W = 0;
            pixel_value = 0;  
            
            for l = -k:k
                for e = -k:k
                    if i+l >= 1 && i+l <= m && j+e >= 1 && j+e <= n
                        
                        G_r =exp(-((pic(i+l, j+e) - pic(i, j))^2) / (2 * sigma_r^2));
                      
             
                        weight = G_s(l+k+1, e+k+1) * G_r;
                     
                        pixel_value = pixel_value + pic(i+l, j+e) * weight;
                        W = W + weight;
                    end
                end
            end
         
            filtered_image(i, j) = pixel_value / W;
        end
    end
     filtered_image = uint8(filtered_image);
end
function [snr_value, psnr_value] = compute_snr_psnr(signal, noisy_signal)
    if ndims(signal) ~= ndims(noisy_signal)
        error("Images have different numbers of dimensions.");
    end
    if ~isequal(size(signal), size(noisy_signal))
        noisy_signal = imresize(noisy_signal, [size(signal,1), size(signal,2)]);
    end

    signal = im2double(signal);
    noisy_signal = im2double(noisy_signal);
    Ex = sum(signal(:).^2);  
    
   EXN = sum( noisy_signal(:).^2);
   EN= EXN-Ex
   EXN = max(EN, eps); 
   snr_value = 10 * log10(Ex / EN);  
    MAX = 1; 
    psnr_value =-10 * log10((MAX^2) / EN);
end


