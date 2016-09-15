function output = ycc_to_rgb( input )
%ycc_to_rgb rgb to r g b conversion
    
    %multiplier matrices
    mux_r = [1.0 0.0 1.40210];
    mux_g = [1.0 -0.34414 -0.71414];
    mux_b = [1.0 1.77180 0.0];
    
    %initialise space for the output (rgb)
    %a 512*512 by 3 with R, G and B saved in the 3 layers
    output = zeros(size(input,1), size(input,2), size(input,3));
    
    %perform calulations
    output(:,:,1) = round(mux_r(1) .* input(:,:,1) + ...
                    mux_r(2) .* (input(:,:,2) - 128) + ...
                    mux_r(3) .* (input(:,:,3) - 128));
                
    output(:,:,2) = round(mux_g(1) .* input(:,:,1) + ...
                    mux_g(2) .* (input(:,:,2) - 128) + ...
                    mux_g(3) .* (input(:,:,3) - 128));
                
    output(:,:,3) = round(mux_b(1) .* input(:,:,1) + ...
                    mux_b(2) .* (input(:,:,2) - 128) + ...
                    mux_b(3) .* (input(:,:,3) - 128));


end