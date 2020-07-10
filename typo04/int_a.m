pkg load nan
pkg load statistics
clc
clear

# parameter gamma
global gamma = 0.95;
global T = norminv((gamma + 1) / 2)

# initial conditions of variant 4
global k = 3;
global from = 1;
global to = 4;

# confidence interval search function
function result = monteCarloUnifrnd(n)
    global T;
    global k;
    global from;
    global to;
    x = unifrnd (from, to, n, k);
    z = (to - from) * (3 .^ (-(x .^ 2))); 
    p = mean(mean(z));
    d = mean(T * std(z) / sqrt(n));
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
I1 = monteCarloUnifrnd(10^4);
I2 = monteCarloUnifrnd(10^6);
R = quad(@(x) 3 .^ (-x .^ 2), from, to);
printf("real value = %f\n", R);
if (checkIntervals(I1, I2))
    printf("intervals intersect");
else
    printf("intervals do not intersect");
endif