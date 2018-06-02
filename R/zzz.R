## Export stated in data.R file.
# make fake neuronlist so that docs are correct
lh.splits.dps <- structure(as.list(1:209), class=c('neuronlist', 'list'))

.onLoad <- function(libname, pkgname) {
  # message("Building lh.splits")
  base::delayedAssign('lhon.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhon.splits.dps.rds', package='lhns'))))
  base::delayedAssign('lhln.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhln.splits.dps.rds', package='lhns'))))
  base::delayedAssign('lhin.splits.dps', nat::as.neuronlist(nat::read.neuronlistfh(nat.utils::find_extdata('lhin.splits.dps.rds', package='lhns'))))
  base::delayedAssign('lh.splits.dps', c(lhln.splits.dps,lhin.splits.dps,lhon.splits.dps))
  invisible()
}
