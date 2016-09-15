function output = rgb_to_ycc( input )
%rgb_to_ycc rgb to y cb cr conversion

    %multiplier matrices
    mux_y = [0.299 0.587 0.114];
    mux_cb = [-0.168736 -0.331264 0.500002];
    mux_cr = [0.5 -0.418688 -0.081312];
    
    %values to be added
    added = [0 128 128];
    
    %initialise space for the output (ycc)
    %a 512*512 by 3 with Y, Cb and Cr saved in the 3 layers
    output = zeros(size(input,1), size(input,2), size(input,3));
    
    %perform calulations
    output(:,:,1) = mux_y(1) .* input(:,:,1) + ...
                    mux_y(2) .* input(:,:,2) + ...
                    mux_y(3) .* input(:,:,3) + added(1);
                
    output(:,:,2) = mux_cb(1) .* input(:,:,1) + ...
                    mux_cb(2) .* input(:,:,2) + ...
                    mux_cb(3) .* input(:,:,3) + added(2);
                
    output(:,:,3) = mux_cr(1) .* input(:,:,1) + ...
                    mux_cr(2) .* input(:,:,2) + ...
                    mux_cr(3) .* input(:,:,3) + added(3);


end

