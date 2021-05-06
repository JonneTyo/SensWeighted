
function [se, sp, t] = Csens2(sens, spec, th)
  c = 2.0;
  
  foc1 = [0, 1];
   foc2 = [0, c];
  temp = [sens, 1 - spec];
  d = (eukl(foc1, temp)+ eukl(foc2, temp))./2;
  [argval, argmin] = min(d);
  se = sens(argmin);
  sp = spec(argmin);
   t = th(argmin);
  endfunction
  
  function [d] = eukl(pnt1, pnt2)
  d = sqrt((pnt1(1) - pnt2(:,2)).^2 + (pnt1(2)-pnt2(:,1)).^2);
  endfunction