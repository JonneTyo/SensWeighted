% Returns the solution for the problem: max c*se + sp s.t. se > sp
function [se, sp, t] = Jsens2(sens, spec, th)
  c = 1.0;
  
  temp = c.*sens;
  temp = (temp + spec).*(temp > spec);
  [argval, argmax] = max(temp);
  se = sens(argmax);
  sp = spec(argmax);
  t = th(argmax);
  endfunction