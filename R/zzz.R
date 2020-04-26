# set options
.onAttach <- function(libname, pkgname){
  base::delayedAssign('emlhns', c(lhns::lh.fafb, lhns::lh.hemibrain))
}
