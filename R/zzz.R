## Export stated in data.R file.
lh.splits.dps <- NULL

.onLoad <- function(libname, pkgname) {
  # message("Building lh.splits")
  base::delayedAssign('lhon.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhon.splits.dps.rds'))))
  base::delayedAssign('lhln.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhln.splits.dps.rds'))))
  base::delayedAssign('lhin.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhin.splits.dps.rds'))))
  base::delayedAssign('lh.splits.dps', c(lhln.splits.dps,lhin.splits.dps,lhon.splits.dps))
  invisible()
}
