function dct_array = forward_dct( input_array )
%forward_dct Performs DCT on an 8*8 matrix, returns an 8*8 too

dct_array = zeros(8, 8);
%loop to scan row
for u = 0:7
    %loop to scan columns
    for v = 0:7
        %loop for x
        sum = 0;
        for x = 0:7
            %loop for y
            for y = 0:7
                sum = sum + ...
                    input_array(x+1, y+1) * ...
                    cos(pi*(x + 0.5)*u/8) * ...
                    cos(pi*(y + 0.5)*v/8);
            end
        end
        dct_array(u+1, v+1) = (1/4) * dct_c(u) * dct_c(v) * sum;
    end
end

end

