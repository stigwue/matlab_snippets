function [ output_vector ] = diff_code( input_vector )
%diff_code Difference coding of DC coefficients
    input_size = size(input_vector, 2);
    output_vector = zeros(1, input_size);
    for i = 1:input_size
        if (i == 1)
            output_vector(i) = input_vector(i) - 0;
        else
            output_vector(i) = input_vector(i) - input_vector(i-1);
        end
    end
end

