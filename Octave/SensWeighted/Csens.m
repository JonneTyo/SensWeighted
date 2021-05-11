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

% Returns the solution for the problem min sqrt((1 - spec)^2 + (c - sens)^2)
function [se, sp, t] = Csens(sens, spec, th)
  c = 2.0;
  
  foc = [0, c];
  temp = [sens, 1 - spec];
  d = eukl(foc, temp);
  [argval, argmin] = min(d);
  se = sens(argmin);
  sp = spec(argmin);
   t = th(argmin);
endfunction

function [d] = eukl(pnt1, pnt2)
  d = sqrt((pnt1(1) - pnt2(:,2)).^2 + (pnt1(2)-pnt2(:,1)).^2);
endfunction