
%% build test code for zig zag
% test_matrix = zeros(8,8);
% index = 1;
% 
% for r=1:8
%     for c = 1:8
%         test_matrix(r, c) = index;
%         index = index + 1;
%     end
% end
% 
% v = zigzag(test_matrix);

%% test code dezigzag
%test_matrix_recovered = dezigzag(v);

%% complete test
image = [...
    187 188 189 202 209 175 66 41;
    191 186 193 209 193 98 40 39;
    188 187 202 202 144 53 35 37;
    189 195 206 172 58 47 43 45;
    197 204 194 106 50 48 42 45;
    208 204 151 50 41 41 41 53;
    209 179 68 42 35 36 40 47;
    200 117 53 41 34 38 39 63
    ];

% xxx = [image image];
% xxx_dct = zeros(size(xxx));
% xxx_dct(1:8, 1:8) = forward_dct(xxx(1:8, 1:8));
% xxx_dct(1:8, 9:16) = forward_dct(xxx(1:8, 9:16));

%% test rgb <-> ycc
image_ycb = conv_rgb_to_ycc(image, image, image);
image_2 = zeros(8,8,3);
image_2(:,:,1) = image;
image_2(:,:,2) = image;
image_2(:,:,3) = image;
image_ycb_2 = rgb2ycbcr(image_2);


%% dct
image_dct = forward_dct(image);
%image_idct = inverse_dct(image_dct);

%% quantize
qf = 50;
[y_quan_matrix, c_quan_matrix] = scale_quantization(qf);

image_dct_quantized = round(image_dct ./ y_quan_matrix);

%% dequantize
image_dct_dequantized = img_dct_quantized .* y_quan_matrix;

%% idct
image_idct = inverse_dct(image_dct_dequantized);