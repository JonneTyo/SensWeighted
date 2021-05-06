
function [se, sp, t] = Csens(sens, spec, th)
  c = 2.0;
  
  foc = [0, c];
  temp = [sens, 1 - spec];
  size(temp)
  d = eukl(foc, temp);
  [argval, argmin] = min(d);
  se = sens(argmin);
  sp = spec(argmin);
   t = th(argmin);
endfunction

function [d] = eukl(pnt1, pnt2)
  d = sqrt((pnt1(1) - pnt2(:,2)).^2 + (pnt1(2)-pnt2(:,1)).^2);
endfunction