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

% Returns the solution for the problem max c*sens + spec
function [se, sp, t] = Jsens(sens, spec, th)
  % Returns the solution for the problem:  max c*se + sp
  c=2.0;
  temp = sens.*c + spec;
  [argval, argmax] = max(temp);
  se = sens(argmax);
  t =  th(argmax);
  sp =  spec(argmax);
endfunction