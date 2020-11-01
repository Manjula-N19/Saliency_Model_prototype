function [fmap] = func_compute_saliency(Y, CR, wavelet)

[ROW,COL,DIM] = size(Y);
%% Compute saliency map 

N = round(log2(max(ROW,COL))); % Obtain the value of N, where N is the number of decomposition scales

%% Apply DWT (Discrete Wavelet Transform) on each channel at N scales

% Y channel decomposition
[caY, chY, cvY, cdY, RowDataY, ColDataY]  = createWaveletMap(Y, N, wavelet);
% CR channel decomposition
[caCR,chCR,cvCR,cdCR,RowDataCR,ColDataCR] = createWaveletMap(CR, N, wavelet);

%% Perform inverse DWT at N levels
C = zeros(ROW,COL);

for i = 1:length(caY)
    N = i;
    
    %% Feature map of luminance channel
    y = createFeatureMap(chY, cvY, cdY, RowDataY, ColDataY, ROW, COL, N, wavelet);

    %% Feature map of chrominance channel
    cr = createFeatureMap(chCR,cvCR,cdCR,RowDataCR,ColDataCR, ROW, COL, N, wavelet);
    
    %% Calculate entropy of feature map at each level
    eny = entropy(y);
    encr = entropy(cr);  
    
    %% Obtain weighted feature maps
    y = y*eny;
    cr = cr*encr;
        
    %% Combining feature maps at each level    
    LS = abs(y) + abs(cr); 
    
    %% Combined the maps at N levels      
    C = C + LS;
end

%% Smoothing operation
C = imfilter(C, fspecial('gaussian', 5, 5), 'symmetric', 'conv');

%% Normalisation and enhancement
fmap = log(mat2gray(C) + 1);

end

