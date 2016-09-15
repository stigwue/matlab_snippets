function [ new_timestamps ] = fill_missing( timestamps, min_diff, missing_state )
%fill_missing Given an array of timestamps and the minimum duration,
%fill in any gaps between two consecutive timestamps with missing_state
%value

[row col] = size(timestamps);

new_timestamps = [];

if (row > 1)
    new_timestamps(1,:) = timestamps(1,:);
    new_index = 1;
    
    for old_index = 2:row
        old_index_value = timestamps(old_index, 1);
        new_index_value = new_timestamps(new_index) + min_diff;
        
        while new_index_value ~= old_index_value
            new_index = new_index + 1;
            new_timestamps(new_index, 1) = new_index_value;
            new_timestamps(new_index, 2) = missing_state;
            
            new_index_value = new_timestamps(new_index) + min_diff;
        end
        
        new_index = new_index + 1;
        
        new_timestamps(new_index, 1) = new_index_value;
        new_timestamps(new_index, 2) = timestamps(old_index, 2);
    end
else
    %only one row
    new_timestamps = timestamps;
end

end

