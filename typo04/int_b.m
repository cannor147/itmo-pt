pkg load nan
pkg load statistics
clc
clear

# parameter gamma
global gamma = 0.95;
global T = norminv((gamma + 1) / 2)

# initial conditions of variant 4
global k = 3;
global lambda = 1/2;

# confidence interval search function
function result = monteCarloExprnd(n)
    global T;
    global k;
    global lambda;
    x = exprnd(lambda, n, k);
    z = lambda * (x .^ (2/3));
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
I1 = monteCarloExprnd(10^4);
I2 = monteCarloExprnd(10^6);
R = quad(@(x) (x .^ (2/3)) .* exp(-2 * x), 0, inf);
printf("real value = %f\n", R);
if (checkIntervals(I1, I2))
    printf("intervals intersect");
else
    printf("intervals do not intersect");
endif