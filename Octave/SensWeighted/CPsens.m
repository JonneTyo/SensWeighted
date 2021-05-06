
function [se, sp, t] = CPsens(sens, spec, th)
  c = 0.5;
  
  temp = sens.*(spec + 0.5);
  [argval, argmax] = max(temp);
  se = sens(argmax);
  sp = spec(argmax);
  t = th(argmax);
  endfunction