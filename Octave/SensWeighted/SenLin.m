#{
This library contains functions designed to choose the optimal threshold
in binary classification favoring sensitivity.

All of the methods require at least the following attributes

sens : vector of size nx1
    An iterable containing all possible sensitivity values
spec : vector of size nx1
    An iterable containing all possible spec values
th : vector of size nx1
    An iterable containing threshold values for the binary classification process.
    
All the functions will return the following:

se : double
    The sensitivity value corresponding to the optimal sensitivity-specificity pair.
sp : double
    The specificity value corresponding to the optimal sensitivity-specificity pair.
t : scalar
    The threshold to achieve the optimal sensitivity-specificity pair.
#}

% Returns the solution for the problem: max c*sens + spec s.t. c*sens > spec
function [se, sp, t] = SenLin(sens, spec, th)
  c = 1.0;
  d = 1.0;
  temp = c.*sens;
  temp = (temp + spec).*(d.*sens > spec);
  [argval, argmax] = max(temp);
  se = sens(argmax);
  sp = spec(argmax);
  t = th(argmax);
  endfunction