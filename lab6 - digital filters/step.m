function [s] = step(y, l)
    s = 0;
    i = 1;
    jump = 100;
    state = false;
    prevV = 0;
    maxValue = 0.42;
    minValue = 0.036;
    if l >= 59 
        maxValue = 0.63;
        minValue = 0.05;
    end
    if l == 62 
        maxValue = 0.60;
        minValue = 0.03;
    end
    if l > 65
        maxValue = 0.63;
        minValue = 0.02;
    end

    if l > 68
        maxValue = 0.8;
        minValue = 0.05;
    end

    if l > 70
        maxValue = 0.8;
        minValue = 0.1;
    end

    while(jump*i < length(y))
        v = mean(abs(y(jump*(i-1)+1:jump*i)));
        r = mean(abs(y(jump*(i-1)+1:jump*i)));
        if v > maxValue
            state = true;
        elseif r < minValue && state==true
            return
        end
        prevV = v;
        s = s + jump;
        i = i + 1;
    end
end

