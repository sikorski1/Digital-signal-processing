function [s] = step(y)
    s = 0;
    i = 1;
    jump = 100;
    state = false;
    prevV = 0;
    while(jump*i < length(y))
        v = mean(abs(y(jump*(i-1)+1:jump*i)));
        if v > 0.06
            state = true;
        elseif v < 0.1 && state==true
            return
        end
        prevV = v;
        s = s + jump;
        i = i + 1;
    end
end

