%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% A Low-complexity Wavelet-based Visual Saliency Model to Predict Fixations
%  Author: MANJULA NARAYANASWAMY
%  School of Engineering,
%  Robert Gordon University, United Kingdom.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clc; clear; close all;

%% Read single image
[FileName,PathName] = uigetfile({'*.png;*.bmp;*.jpg;*.jpeg;*.gif','Image Files'});
myfile = [PathName FileName];
Irgb = imread(myfile);

tic
%% Convert RGB image to YCbCr colour space
YCBCR = rgb2ycbcr(Irgb);

%% Filter very high frequency noise
YCBCR = imfilter(YCBCR, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

%% Obtain luminance and chrominance channels
Y = double(YCBCR(:,:,1));     % Luminance 
CR = double(YCBCR(:,:,3));    % Red colour difference

%% Biorthogonal wavelet is chosen for decomposition  
wavelet = 'bior4.4'; 

%% Saliency computation
[fmap] = func_compute_saliency(Y, CR, wavelet);

%% 
figure
subplot(2,1,1);
imshow(Irgb); title('Input image');
subplot(2,1,2);
imshow(fmap,[]); title('Final Saliency Map');

toc





    
