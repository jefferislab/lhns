# set options
.onAttach <- function(libname, pkgname){
  base::delayedAssign('emlhns', lhns::lh.fafb)
}
