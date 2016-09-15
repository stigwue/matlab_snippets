function multiplier = dct_c( index_k )
%dct_c Returns the multipliers C(u) and C(v) for any C(k)
if (index_k == 0)
    multiplier = 1 / sqrt(2);
else
    multiplier = 1;
end

end

