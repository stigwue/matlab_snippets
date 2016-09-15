
%% initialisation
clearvars;
lenaRGB_source = imread('lena512.tiff');

%% set properties
tests = 0; %0 = tests off, 1 = on

%% seperate image into rgb
lena_rgb_dbl = double(lenaRGB_source);
lena_r_dbl = lena_rgb_dbl(:, :, 1);
lena_g_dbl = lena_rgb_dbl(:, :, 2);
lena_b_dbl = lena_rgb_dbl(:, :, 3);

%% convert rgb to ycc
lena_ycc_dbl = rgb_to_ycc(lena_rgb_dbl);

%% test ycc conversion
if (tests == 1)
    %reverse previous conversion
    lena_rgb_test = ycc_to_rgb(lena_ycc_dbl);
    %test for equality. this might fail if they are not integers
    if (isequal(lena_rgb_dbl, lena_rgb_test))
        disp('success: ycc conversion');
    else
        %randomly pick a cell to display to see they are equal, we'll be
        %able to tell if the sameness test failed because of roundup errors
        disp('test: ycc conversion');
        [indices] = randi([1 size(lena_rgb_test, 1)], 1, 2);
        disp(lena_rgb_dbl(indices(1), indices(2), 2));
        disp(lena_rgb_test(indices(1), indices(2), 2));
    end
end

%% seperate ycc into y, cb and cr
lena_y_dbl = lena_ycc_dbl(:, :, 1);
lena_cb_dbl = lena_ycc_dbl(:, :, 2);
lena_cr_dbl = lena_ycc_dbl(:, :, 3);

%% forward dct
lena_row_size = size(lena_y_dbl, 1);
lena_col_size = size(lena_y_dbl, 2);
%dct on y
lena_y_dbl_dct = zeros(lena_row_size, lena_col_size);
for u = 1:8:lena_row_size
    for v = 1:8:lena_col_size
        lena_y_dbl_dct(u:u+7, v:v+7) = forward_dct(lena_y_dbl(u:u+7, v:v+7));
        %save some time by doing quantization and zigzag here
    end
end
if (tests == 1)
    % test using inverse_dct
    lena_y_dbl_test = zeros(lena_row_size, lena_col_size);
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            lena_y_dbl_test(u:u+7, v:v+7) = inverse_dct(lena_y_dbl_dct(u:u+7, v:v+7));
        end
    end
    %test equality. might fail due to round offs
    if (isequal(lena_y_dbl, lena_y_dbl_test))
        disp('success: dct conversion');
    else
        %randomly display a cell to see equality
        disp('test: dct');
        [indices] = randi([1 size(lena_y_dbl_test, 1)], 1, 2);
        disp(lena_y_dbl(indices(1), indices(2)));
        disp(lena_y_dbl_test(indices(1), indices(2)));
    end
end
%dct on cb
lena_cb_dbl_dct = zeros(lena_row_size, lena_col_size);
for u = 1:8:lena_row_size
    for v = 1:8:lena_col_size
        lena_cb_dbl_dct(u:u+7, v:v+7) = forward_dct(lena_cb_dbl(u:u+7, v:v+7));
    end
end
%dct on cr
lena_cr_dbl_dct = zeros(lena_row_size, lena_col_size);
for u = 1:8:lena_row_size
    for v = 1:8:lena_col_size
        lena_cr_dbl_dct(u:u+7, v:v+7) = forward_dct(lena_cr_dbl(u:u+7, v:v+7));
    end
end


%% loop through qfs
for qf = [5 10 20 30 40 50]
    %% scale quantizer by quality factor
    [y_quan_matrix, c_quan_matrix] = scale_quantization(qf);

    %% quantize y
    %initialise dc and ac vectors
    lena_y_dbl_dct_zigged = struct(...
        'dc', zeros(1, lena_row_size),...
        'ac', zeros(1, lena_row_size * (64 - 1))...
        );
    qi = 1; %quantized block index
    lena_y_dbl_dct_quantized = zeros(size(lena_y_dbl_dct));
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            %quantize
            lena_y_dbl_dct_quantized(u:u+7, v:v+7) = round(lena_y_dbl_dct(u:u+7, v:v+7) ./ y_quan_matrix);
            %zigzag then get dc and ac
            tmp_zigged = zigzag(lena_y_dbl_dct_quantized(u:u+7, v:v+7));
            lena_y_dbl_dct_zigged.dc(qi) = tmp_zigged(1, 1);
            lena_y_dbl_dct_zigged.ac(64*(qi-1)+2 : 64*qi) = tmp_zigged(2:64);
            qi = qi + 1;
        end
    end
    
    %% quantize cb
    %initialise dc and ac vectors
    lena_cb_dbl_dct_zigged = struct(...
        'dc', zeros(1, lena_row_size),...
        'ac', zeros(1, lena_row_size * (64 - 1))...
        );
    qi = 1; %quantized block index
    lena_cb_dbl_dct_quantized = zeros(size(lena_cb_dbl_dct));
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            %quantize
            lena_cb_dbl_dct_quantized(u:u+7, v:v+7) = round(lena_cb_dbl_dct(u:u+7, v:v+7) ./ c_quan_matrix);
            %zigzag then get dc and ac
            tmp_zigged = zigzag(lena_cb_dbl_dct_quantized(u:u+7, v:v+7));
            lena_cb_dbl_dct_zigged.dc(qi) = tmp_zigged(1, 1);
            lena_cb_dbl_dct_zigged.ac(64*(qi-1)+2 : 64*qi) = tmp_zigged(2:64);
            qi = qi + 1;
        end
    end
    
    %% quantize cr
    %initialise dc and ac vectors
    lena_cr_dbl_dct_zigged = struct(...
        'dc', zeros(1, lena_row_size),...
        'ac', zeros(1, lena_row_size * (64 - 1))...
        );
    qi = 1; %quantized block index
    lena_cr_dbl_dct_quantized = zeros(size(lena_cr_dbl_dct));
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            %quantize
            lena_cr_dbl_dct_quantized(u:u+7, v:v+7) = round(lena_cr_dbl_dct(u:u+7, v:v+7) ./ c_quan_matrix);
            %zigzag then get dc and ac
            tmp_zigged = zigzag(lena_cr_dbl_dct_quantized(u:u+7, v:v+7));
            lena_cr_dbl_dct_zigged.dc(qi) = tmp_zigged(1, 1);
            lena_cr_dbl_dct_zigged.ac(64*(qi-1)+2 : 64*qi) = tmp_zigged(2:64);
            qi = qi + 1;
        end
    end

    %% difference encode
    if (tests == 1)
        disp('test: diff en/de-coding');
        %choose random position to test
        [indices] = randi([1 size(lena_y_dbl_dct_zigged.dc, 2)], 1, 1);
        disp(lena_y_dbl_dct_zigged.dc(indices));
    end
    lena_y_dbl_dct_zigged.dc = diff_code(lena_y_dbl_dct_zigged.dc);
    lena_cb_dbl_dct_zigged.dc = diff_code(lena_cb_dbl_dct_zigged.dc);
    lena_cr_dbl_dct_zigged.dc = diff_code(lena_cr_dbl_dct_zigged.dc);


    %% jpeg decoding
    %difference decode
    lena_y_dbl_dct_zigged.dc = diff_decode(lena_y_dbl_dct_zigged.dc);
    %test dc en/de-coding
    if (tests == 1)
        %display content of random position to compare
        disp(lena_y_dbl_dct_zigged.dc(indices));
    end
    lena_cb_dbl_dct_zigged.dc = diff_decode(lena_cb_dbl_dct_zigged.dc);
    lena_cr_dbl_dct_zigged.dc = diff_decode(lena_cr_dbl_dct_zigged.dc);


    %% dezigzag
    %y component
    lena_y_dbl_dct_zagged = zeros(lena_row_size, lena_col_size);
    lena_y_dbl_idct = zeros(lena_row_size, lena_col_size);
    qi = 1; %block index
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            %build back dc & ac components
            tmp_zigged = zeros(1, 64);
            %dc
            tmp_zigged(1) = lena_y_dbl_dct_zigged.dc(qi);
            %ac
            tmp_zigged(2:64) = lena_y_dbl_dct_zigged.ac(64*(qi-1)+2 : 64*qi);
            %dezigzag
            lena_y_dbl_dct_zagged(u:u+7, v:v+7) = dezigzag(tmp_zigged);
            %dequantize
            lena_y_dbl_dct_zagged(u:u+7, v:v+7) = lena_y_dbl_dct_zagged(u:u+7, v:v+7) .* y_quan_matrix;
            %inverse dct
            lena_y_dbl_idct(u:u+7, v:v+7) = inverse_dct(lena_y_dbl_dct_zagged(u:u+7, v:v+7));
            qi = qi + 1;
        end
    end

    %cb component
    lena_cb_dbl_dct_zagged = zeros(lena_row_size, lena_col_size);
    lena_cb_dbl_idct = zeros(lena_row_size, lena_col_size);
    qi = 1; %block index
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            %build back dc & ac components
            tmp_zigged = zeros(1, 64);
            %dc
            tmp_zigged(1) = lena_cb_dbl_dct_zigged.dc(qi);
            %ac
            tmp_zigged(2:64) = lena_cb_dbl_dct_zigged.ac(64*(qi-1)+2 : 64*qi);
            %dezigzag
            lena_cb_dbl_dct_zagged(u:u+7, v:v+7) = dezigzag(tmp_zigged);
            %dequantize
            lena_cb_dbl_dct_zagged(u:u+7, v:v+7) = lena_cb_dbl_dct_zagged(u:u+7, v:v+7) .* c_quan_matrix;
            %inverse dct
            lena_cb_dbl_idct(u:u+7, v:v+7) = inverse_dct(lena_cb_dbl_dct_zagged(u:u+7, v:v+7));
            qi = qi + 1;
        end
    end

    %cr component
    lena_cr_dbl_dct_zagged = zeros(lena_row_size, lena_col_size);
    lena_cr_dbl_idct = zeros(lena_row_size, lena_col_size);
    qi = 1; %block index
    for u = 1:8:lena_row_size
        for v = 1:8:lena_col_size
            %build back dc & ac components
            tmp_zigged = zeros(1, 64);
            %dc
            tmp_zigged(1) = lena_cr_dbl_dct_zigged.dc(qi);
            %ac
            tmp_zigged(2:64) = lena_cr_dbl_dct_zigged.ac(64*(qi-1)+2 : 64*qi);
            %dezigzag
            lena_cr_dbl_dct_zagged(u:u+7, v:v+7) = dezigzag(tmp_zigged);
            %dequantize
            lena_cr_dbl_dct_zagged(u:u+7, v:v+7) = lena_cr_dbl_dct_zagged(u:u+7, v:v+7) .* c_quan_matrix;
            %inverse dct
            lena_cr_dbl_idct(u:u+7, v:v+7) = inverse_dct(lena_cr_dbl_dct_zagged(u:u+7, v:v+7));
            qi = qi + 1;
        end
    end

    %% ycc to rgb convert
    %combine into one
    lena_ycc_dbl_idct = zeros(size(lena_y_dbl_idct, 1), size(lena_y_dbl_idct, 2), 3);
    lena_ycc_dbl_idct(:,:,1) = lena_y_dbl_idct;
    lena_ycc_dbl_idct(:,:,2) = lena_cb_dbl_idct;
    lena_ycc_dbl_idct(:,:,3) = lena_cr_dbl_idct;

    lena_rgb_dbl_recovered = ycc_to_rgb(lena_ycc_dbl_idct);

    %% display picture
    figure
    image(uint8(lena_rgb_dbl_recovered))
    colormap([[0:1/255:1]',[0:1/255:1]', [0:1/255:1]']);
    title(['Lena. qf = ' num2str(qf)]);
end