import numpy as np
'''
This library contains functions designed to choose the optimal threshold
in binary classification favoring sensitivity.

All of the methods below require following attributes

sens : iterable
    An iterable containing all possible sensitivity values
spec : iterable
    An iterable containing all possible spec values
th : iterable, optional
    An iterable containing threshold values for the binary classification process.
    
All the functions will return the following:

se : float
    The sensitivity value corresponding to the optimal sensitivity-specificity pair.
sp : float
    The specificity value corresponding to the optimal sensitivity-specificity pair.
th : int, float
    The threshold to achieve the optimal sensitivity-specificity pair.
    If the method was not given ths iterable, the index of the sensitivity is returned instead.
'''

def assert_lengths(given_func):
    def wrapper_func(sens, spec, th=None, *args, **kwargs):
        assert len(sens) == len(spec), 'Arguments sens and spec must be iterables of same length'
        if th is not None:
            assert len(th) == len(sens), 'Argument th must be either None or same length as sens'

        return given_func(sens, spec, th, *args, **kwargs)
    return wrapper_func

# Returns the solution for the problem:  max c*se + sp
@assert_lengths
def SenJ(sens, spec, th=None, c=2.0, **kwargs):

    th = list(range(len(sens))) if th is None else th

    temp = [c*i + j for (i, j) in zip(sens, spec)]
    temp = np.argmax(temp)
    return sens[temp], spec[temp], th[temp]

# Returns the solution for the problem: max c*se + sp s.t. se > sp
@assert_lengths
def SenLin(sens, spec, th=None, c=1, d=1, **kwargs):

    th = list(range(len(sens))) if th is None else th

    temp = [(c*i + j)*int(d*i > j) for (i, j) in zip(sens, spec)]
    temp = np.argmax(temp)

    return sens[temp], spec[temp], th[temp]

# Returns the solution for the problem: min (c - se)^2 + (0 - (1 - sp))^2
# The function also optionally takes in foc1 and/or foc2, which correspond to the foci of an ellipse.
# Essentially, the function calculates the radius of the smallest possible ellipse with given foci
# so that it overlaps with the roc-curve
@assert_lengths
def SenCirc(sens, spec, th=None, c=2, foc1=None, foc2=None, ellipse=False, **kwargs):

    if foc1 is None and foc2 is None:
        foc1 = (0, c)
        if ellipse:
            foc2 = (0, 1)
        else:
            foc2 = foc1

    elif foc1 is None or foc2 is None:
        if foc1 is None:
            foc1 = foc2
        else:
            foc2 = foc1

    # circle method
    def eukl(pnt1, pnt2):
        return (((pnt1[0] - pnt2[0])**2) + ((pnt1[1] - pnt2[1])**2))**0.5


    min_d = max(1e6, abs(2*c))
    min_se = 0
    min_sp = 0
    min_id = 0
    for i, (se, sp) in enumerate(zip(sens, spec)):
        curr_d = (eukl(foc1, (1 - sp, se)) + eukl(foc2, (1 - sp, se))) / 2
        if curr_d < min_d:
            min_d, min_se, min_sp, min_id = curr_d, se, sp, i

    if th is not None:
        min_id = list(th)[min_id]
    return min_se, min_sp, min_id

@assert_lengths
def SenEll(sens, spec, th=None, c=2, foc1=None, foc2=None, **kwargs):
    return SenCirc(sens, spec, th, c, foc1, foc2, True, **kwargs)

# Returns the solution for the problem: max sens*(spec + c)
@assert_lengths
def SenConp(sens, spec, th=None, c=0.5, **kwargs):

    assert c >= 0, 'argument "c" must be greater than or equal to 0'

    max_val, max_se, max_sp, max_i = 0,0,0,0

    for i, (se, sp) in enumerate(zip(sens, spec)):
        if se*(sp+c) > max_val:
            max_val = se*(sp+c)
            max_se = se
            max_sp = sp
            max_i = i
    if th is not None:
        max_i = list(th)[max_i]

    return max_se, max_sp, max_i

# Returns Youden's J index
def J(sens, spec, th=None, **kwargs):
    return SenJ(sens, spec, th, c=1)


def C(sens, spec, th=None, **kwargs):
    return SenCirc(sens, spec, th, foc1=(0, 1))

def CP(sens, spec, th=None, **kwargs):
    return SenConp(sens, spec, th, c=0)







