pro fit_double_gauss, x, A, F
    exponentone = -1*((x-50)^2 )/2*(A[1])^2
    first = A[0] * exp(exponentone)
    exponenttwo = -1*((x-50)^2 )/2*(A[3])^2
    second =  A[2] * exp(exponenttwo)
    F = first + second
end