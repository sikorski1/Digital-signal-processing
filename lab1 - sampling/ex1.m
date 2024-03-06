%A
clear all;
close all;
n1 = 0:1000;
n2 = 0:50;
n3 = 0:20;
dt1 = 1/10000;
dt2 = 1/500;
dt3 = 1/200;
A = 230;
f = 50;
y1 = A*sin(2*pi*50*dt1*n1); %probka x200 w T
y2 = A*sin(2*pi*50*dt2*n2); %probka x10 w T
y3 = A*sin(2*pi*50*dt3*n3); %probka x4 w T
plot(dt1*n1, y1, "b-");
hold on
plot(dt2*n2, y2, "r-o");
plot(dt3*n3, y3, "k-x");

%B

n1 = 0:10000;
n2 = 0:51;
n3 = 0:50;
n4 = 0:49;
dt1 = 1/10000;
dt2 = 1/51;
dt3 = 1/50;
dt4 = 1/49;
y1 = A*sin(2*pi*50*dt1*n1); %probka x200 w T
y2 = A*sin(2*pi*50*dt2*n2); %probka 50/51 troche szybciej niz T
y3 = A*sin(2*pi*50*dt3*n3); %probka 50/50 co T
y4 = A*sin(2*pi*50*dt4*n4); %probka 50/49 troche wolniej niz T
figure;
plot(dt1*n1, y1, "b-");
hold on
plot(dt2*n2, y2, "g-o");
plot(dt3*n3, y3, "r-o");
plot(dt4*n4, y4, "k-o");
title("10kHz - b, 51Hz - g, 50Hz - r, 49Hz - k")
t1 = 0:1/26:1;
t2 = 0:1/25:1;
t3 = 0:1/24:1;
y5 = A*sin(2*pi*50*t1);
y6 = A*sin(2*pi*50*t2);
y7 = A*sin(2*pi*50*t3);
figure
hold on                                                        
plot(t1, y5, "g-o")
plot(t2, y6, "r-o")
plot(t3, y7, "k-o")
title("26Hz - g, 25Hz - r, 24Hz - k")
%C

fs = 100;
dt = 1/100;
n = 0:100;
t = dt*n;
counter = 1;
freq1 = [];
freq2 = [];
color = ["g-o", "r-o", "k-o"];
figure;
for i = 0:5:300
    plot(t, sin(2*pi*i*t))
    title(counter, "sin");
    
    counter = counter + 1;
    if mod(i,100) == 5
       freq1 = [freq1, i]; 
    
    elseif mod(i, 100) == 95
        freq2 = [freq2, i];
    end
end
figure
for i = 1:3
    plot(t, sin(2*pi*freq1(i)*t), color(i))
    hold on
end
title("5, 105, 205, sin")
figure
for i = 1:3
    plot(t, sin(2*pi*freq2(i)*t), color(i))
    hold on
end
title("95, 195, 295, sin")

figure 
plot(t, sin(2*pi*freq1(2)*t), "g--")
hold on
plot(t, sin(2*pi*freq2(1)*t), "b--")
title("95, 105 sin")
freq3 = [];
freq4 = [];
figure;
for i = 0:5:300
    plot(t, cos(2*pi*i*t))
    title(counter, "cos");
    
    counter = counter + 1;
    if mod(i,100) == 5
       freq3 = [freq3, i]; 
    
    elseif mod(i, 100) == 95
        freq4 = [freq4, i];
    end
end  
figure
for i = 1:3
    plot(t, cos(2*pi*freq3(i)*t), color(i))
    hold on
end
title("5, 105, 205, cos")
figure
for i = 1:3
    plot(t, cos(2*pi*freq4(i)*t), color(i))
    hold on
end
title("95, 195, 295, cos")

figure 
plot(t, cos(2*pi*freq3(2)*t), "g--")
hold on
plot(t, cos(2*pi*freq4(1)*t), "b--")
title("95, 105, cos")
