function output_matrix = dezigzag( input_vector )
%dezigzag De Zig Zag a vector to a matrix

%test if input is 1*64
r = size(input_vector, 1);
c = size(input_vector, 2);

if (r == 1 & c == 64)
    output_matrix = zeros(8, 8);
else
    output_matrix = zeros(8, 8);
    return;
end

%zig zag is composed of the following steps

%0. start at origin (1,1)
%1. move horizontally right by one (or down by one if on last column)
%2. move diagonally left until you hit the boundary
%3. move vertically down by one (or right by one if on last row)
%4. move diagonally right until you hit the boundary
%5. goto 1

vi = 1;
ri = 1; ci = 1;
%step 0, start point
output_matrix(ri, ci) = input_vector(vi);
state = 'side-right'; %states: side-right, down-left, down-down, up-right
ci = ci + 1;

while (vi < 64) %the vector index
    vi = vi + 1;
    
    output_matrix(ri, ci) = input_vector(vi);
    
    if strcmp(state, 'side-right')
        if (ci < 8)
            if (ri == 1)
                state = 'down-left';
                ri = ri + 1;
                ci = ci - 1;
                continue;
            else %bottom boundaries
                state = 'up-right';
                ri = ri - 1;
                ci = ci + 1;
                continue;
            end
        else %right hand boundary hit
            if (ri == 1) 
                state = 'down-left';
                ri = ri + 1;
                ci = ci - 1;
                continue;
            elseif (ri == 8 & ci ~= 8)
                state = 'up-right';
                ri = ri - 1;
                ci = ci + 1;
                continue;
            else
                %terminates here i think
                %disp('the end');
                break;
            end
        end
    elseif strcmp(state, 'down-left')
        if (ci == 1 & ri ~= 8) %left boundary hit
            state = 'down-down';
            ri = ri + 1;
            continue;
        elseif (ci == 1 & ri == 8) %bottom corner boundary hit
            state = 'side-right';
            ci = ci + 1;
            continue;
        elseif (ri == 8) %bottom boundary hit
            state = 'side-right';
            ci = ci + 1;
            continue;
        else %continue the down-left diagonal
            %state is unchanged
            ci = ci - 1;
            ri = ri + 1;
            continue;
        end
    elseif strcmp(state, 'down-down')
        if (ci < 8)
            %state is unchanged
            state = 'up-right';
            ri = ri - 1;
            ci = ci + 1;
            continue;
        else %right boundary hit
           state = 'down-left';
           ri = ri + 1;
           ci = ci - 1;
           continue;
        end
    elseif strcmp(state, 'up-right')
        if (ri == 1 & ci ~= 8) %hit top boundary
            state = 'side-right';
            ci = ci + 1;
            continue;
        elseif (ci == 8) %hit right boundary
            state = 'down-down';
            ri = ri + 1;
            continue
        else %continue the up-right diagonal
            %state is unchanged
            ci = ci + 1;
            ri = ri - 1;
            continue;
        end
    end
end

end

