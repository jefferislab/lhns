# Get overlap scores between LHN dendrites and PN axons
load('data-raw/LHN_PN_Overlap_Scores.rda')
if(exists("most.lhns")){
  i = intersect(colnames(lhns.pn.overlap.matrix),names(most.lhns))
  lhns.chosen = most.lhns[i]
  colnames(lhns.pn.overlap.matrix) = lhns.chosen[,"cell.type"]
  lhns.pn.overlap.matrix = t(apply(t(lhns.pn.overlap.matrix), 2, function(x) tapply(x, colnames(lhns.pn.overlap.matrix), mean, na.rm = TRUE)))
} else {
  stop("Please run processLHNs.R!")
}
devtools::use_data(lhns.pn.overlap.matrix,overwrite=TRUE)
