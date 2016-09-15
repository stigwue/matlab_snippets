function [ min_diff ] = diff_minimum( timestamps )
%diff_minimum Given an array of timestamps, return the minimum duration
%between two consecutive timestamps

[row col] = size(timestamps);

if (row > 1)
    min_diff = timestamps(1, 1);
    for i = 2 : row
        cur_diff = timestamps(i, 1) - timestamps(i-1, 1);
        if (cur_diff < min_diff)
            min_diff = cur_diff;
        end
    end
else
    %only one row
    min_diff = timestamps(1, 1);
end

end

