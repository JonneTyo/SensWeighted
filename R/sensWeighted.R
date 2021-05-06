#
#This library contains functions designed to choose the optimal threshold
#in binary classification favoring sensitivity.
#
#All of the methods below require following attributes
#
#sens : iterable
#    An iterable containing all possible sensitivity values
#spec : iterable
#    An iterable containing all possible spec values
#th : iterable, optional
#    An iterable containing threshold values for the binary classification process.
#
#All the functions will return the following:
#
#sens : float
#    The sensitivity value corresponding to the optimal sensitivity-specificity pair.
#spec : float
#    The specificity value corresponding to the optimal sensitivity-specificity pair.
#th : int, float
#    The threshold to achieve the optimal sensitivity-specificity pair.
#    If the method was not given ths iterable, the index of the sensitivity is returned instead.


# checks that the vectors are the same length (or that th is NULL)
length_assertion <- function(sens, spec, th){
  n_senses <- length(sens)

  # check for lengths
  if(n_senses != length(spec)){
    stop("Arguments sens and spec must be the same length")
  }
  if (!is.null(th)){
    if(n_senses != length(th)){
      stop("Argument th must be either NULL or the same length as sens")
    }
  }
}

# formats the sens, spec, th as a dataframe
create_frame <- function(sens, spec, th){
  n_senses <- length(sens)
  if (is.null(th)){
    th <- 1:n_senses
  }

  to_return <- data.frame(
  sens = sens,
  spec = spec,
  th = th
  )

  return(to_return)
}

eukl <- function(pnt1, pnt2){
  return(sqrt((pnt2[1] - pnt1[1])^2 + (pnt2[2] - pnt1[2])^2))
}

get_return_vals <- function(vals, sens, spec, th, get_max=TRUE){
  max_i <- max(vals)
  if(!get_max){
    max_i <- min(vals)
  }
  max_i <- match(c(max_i), vals)
  max_th <- max_i
  if (!is.null(th)){
    max_th <- th[max_i]
  }
  to_return <- list(sens=sens[max_i], spec=spec[max_i], th=max_th)
  return(to_return)
}

# Returns the solution for the problem:  max c*se + sp
Jsens <- function(sens, spec, th=NULL, c=2.0, ...){
  length_assertion(sens, spec, th)

  vals <- c*sens + spec
  to_return <- get_return_vals(vals, sens, spec, th=th)
  return(to_return)
}

# Returns the solution for the problem: max c*se + sp s.t. se > sp
Jsens2 <- function(sens, spec, th=NULL, c=1.0, ...){
  length_assertion(sens, spec, th)
  df <- create_frame(sens, spec, th)

  vals <- sapply(as.data.frame(t(as.matrix(df))), my_fun <- function(x){
    if(c*x[1] >= x[2]){
      return(c*x[1] + x[2])
    }
    return(0)
  }, simplify=TRUE)

  to_return <- get_return_vals(vals, sens, spec, th)
  return(to_return)
}

# Returns the solution for the problem: min (c - se)^2 + (0 - (1 - sp))^2
# The function also optionally takes in foc1 and/or foc2, which correspond to the foci of an ellipse.
# Essentially, the function calculates the radius of the smallest possible ellipse with given foci
# so that it overlaps with the roc-curve
Csens <- function(sens, spec, th=NULL, c=2.0, foc1=NULL, foc2=NULL, is.ellipse=FALSE, ...){
  length_assertion(sens, spec, th)
  df <- create_frame(sens, spec, th)

  # create focus points. For circle, the focus points are both the center point
  if(is.null(foc1) && is.null(foc2)){
    foc1 <- c(0, c)
    if(is.ellipse){
      foc2 <- c(0, 1)
    } else {
      foc2 <- foc1
    }
  }


  vals <- sapply(as.data.frame(t(as.matrix(df))), distance_check <- function(x){
    d1 <- eukl(foc1, c(1 - x[2], x[1]))
    d2 <- eukl(foc2, c(1 - x[2], x[1]))
    return(d1 + d2)
  }, simplify=TRUE)
  to_return <- get_return_vals(vals, sens, spec, th, get_max=FALSE)
  return(to_return)
}

Csens2 <- function(sens, spec, th=NULL, c=2.0, foc1=NULL, foc2=NULL, is.ellipse=TRUE, ...){
  return(Csens(sens, spec, th, c, foc1, foc2, is.ellipse))
}

# Returns the solution for the problem: max sens*(spec + c)
CPsens <- function(sens, spec, th=NULL, c=0.5, ...){
  length_assertion(sens, spec, th)
  df <- create_frame(sens, spec, th)

  vals <- sapply(as.data.frame(t(as.matrix(df))), calc <- function(x){
    return(x[1]*(x[2]+c))
  }, simplify = TRUE)

  to_return <- get_return_vals(vals, sens, spec, th)
  return(to_return)
}

# Returns Youden's J index
J <- function(sens, spec, th=NULL, c=1, ...){
  return(Jsens(sens, spec, th, c))
}

C <- function(sens, spec, th=NULL, c=1, ...){
  return(Csens(sens, spec, th, c))
}

CP <- function(sens, spec, th=NULL, c=0, ...){
  return(CPsens(sens, spec, th, c))
}



