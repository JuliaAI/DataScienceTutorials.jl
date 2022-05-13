# This file was generated, do not modify it. # hide
fix_blanks(v) = map(v) do x
    if x == " "
        return "0.0"
    else
        return x
    end
end

df0.TotalCharges = fix_blanks(df0.TotalCharges);