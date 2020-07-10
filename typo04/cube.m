pkg load nan
clc
clear

# parameter gamma
global gamma = 0.95;
global T = norminv((gamma + 1) / 2)

# initial conditions of variant 4
global k = 3;
global c = 2.8;
global a = 3;
function result = f(x)
    global a;
    result = log(a * x + 1);
endfunction

# confidence interval search function
function result = monteCarloCube(n)
    global T;
    global k;
    global c;
    x = rand(n, k);
    y = f(x);
    z = sum(y');
    p = mean(z <= c);
    d = T * sqrt(p * (1 - p ) / n);
    I = [p - d, p + d];
    result = I;
    printf("n = %d\n", n);
    printf("p = %f\n", p);
    printf("d = %f\n", d);
    printf("I = [%f, %f]\n", I)
    printf("\n")
endfunction

# interval intersection check function
function result = checkIntervals(I1, I2)
    if (I1(2) < I2(1))
        result = false;
    elseif (I1(1) > I2(2))
        result = false;
    else
        result = true;
    endif
endfunction

# solution
I1 = monteCarloCube(10^4);
I2 = monteCarloCube(10^6);
if (checkIntervals(I1, I2))
    printf("intervals intersect");
else
    printf("intervals do not intersect");
endif