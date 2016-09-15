function inv_dct_array = inverse_dct( input_array )
%inverse_dct Performs inverse DCT on an 8*8 matrix, returns an 8*8 too

inv_dct_array = zeros(8, 8);
%loop to scan row
for x = 0:7
    %loop to scan columns
    for y = 0:7
        %loop for x
        sum = 0;
        for u = 0:7
            %loop for y
            for v = 0:7
                sum = sum + ...
                    dct_c(u) * dct_c(v) * ...
                    input_array(u+1, v+1) * ...
                    cos(pi*(x + 0.5)*u/8) * ...
                    cos(pi*(y + 0.5)*v/8);
            end
        end
        inv_dct_array(x+1, y+1) = round((1/4) * sum);
    end
end

end

