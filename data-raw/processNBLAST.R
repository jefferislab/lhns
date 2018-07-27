######################
# all by all NBLAST #
######################

library(nat.nblast)
if(!exists("lh.mcfo")){
  stop("Please run processMCFO.R!")
}else if(!exists("lh.splits.dps")){
  stop("Please run processDolanSplits.R!")
}else if(!exists("lh.splits.dps")){
  stop("Please run processDolanSplits.R!")
}else if(!exists("most.lhns.dps")){
  stop("Please run processLHNs.R!")
}else if(!exists("most.lhins.dps")){
  stop("Please run processLHinput.R!")
}else if(!exists("emlhns.dps")){
  stop("Please run processEMskels.R!")
}

#############
# Calculate #
#############

all.neurons.dps = c(most.lhns.dps,most.lhins.dps,lh.splits.dps,mbons.light.dps,emlhns.dps,pn.axons.light.dps,jfw.lhns.dps)
all.neurons.dps = dotprops(all.neurons.dps,OmitFailures = TRUE)
lh_nblast = nblast_allbyall(all.neurons.dps, normalisation = "normalised", UseAlpha = TRUE)

########
# Save #
########

devtools::use_data(lh_nblast,overwrite=TRUE)
