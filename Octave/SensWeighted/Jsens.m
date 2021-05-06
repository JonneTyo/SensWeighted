
function [se, sp, t] = Jsens(sens, spec, th)
  % Returns the solution for the problem:  max c*se + sp
  c=2.0;
  temp = sens.*c + spec;
  [argval, argmax] = max(temp);
  se = sens(argmax);
  t =  th(argmax);
  sp =  spec(argmax);
endfunction