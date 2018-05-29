# Load relevant libraries
library(nat)

## data frames, for exporting into NAMESPACE when attached to neuronlists. Export stated in data.R file.
load("data/mbons.light.dps.rda")
load("data/pn.axons.light.rda")
load("data/pn.axons.light.dps.rda")
load("data/most.lhns.rda")
load("data/most.lhns.dps.rda")
load("data/most.lhins.rda")
load("data/most.lhins.dps.rda")
load("data/lh.splits.dps.rda")
#load("data/lh.mcfo.rda")
#load("data/lh.mcfo.dps.rda")

## load raw data
load("data-raw/mbons.dps.rda")
load("data-raw/light_PN_tracings.rda")
load("data-raw/light_PN_tracings_dps.rda")
# for segmented split lines:
load("data-raw/segmented.splits.1.dps.rda")
load("data-raw/segmented.splits.2.dps.rda")
dolan.splits = c(dolan.splits.1,dolan.splits.2)
# For most.lhns:
load("data-raw/most.lhns.raw.rda")
load("data-raw/most.lhns.raw.dps.rda")
# For most.lhins:
load("data-raw/lh.inputs.rda")
load("data-raw/lh.inputs.dps.rda")
# For MCFO data - also, add to most.lhns
load("data-raw/dolan_mcfo.rda")

# Add updatable metadata to data object
.onLoad <- function(libname, pkgname) {
  message("Assigning meta-data to neuronlists")
  # Sort out some of the raw data
  light.pn.axons=subset(light.pn.axons, !Glomerulus%in%c("acj6","NP5194","NP6099")) # Get rid of lingering LHNs
  light.pn.axons = light.pn.axons[light.pn.axons[,"PNType"]=="iPN"]
  light.pn.axons.dps=subset(light.pn.axons.dps, !Glomerulus%in%c("acj6","NP5194","NP6099")) # Get rid of lingering LHNs
  light.pn.axons.dps = light.pn.axons.dps[light.pn.axons.dps[,"PNType"]=="iPN"]
  most.lhns.raw = most.lhns.raw[!names(most.lhns.raw)%in%rownames(most.lhins)] # Remove skeletons also in most.lhins
  most.lhns.raw.dps = most.lhns.raw.dps[!names(most.lhns.raw.dps)%in%rownames(most.lhins.dps)] # Remove skeletons also in most.lhins
  # Attach meta-data
  attr(mbons.dps,"df") = mbons.light.dps
  attr(light.pn.axons,"df") = pn.axons.light
  attr(light.pn.axons.dps,"df") = pn.axons.light.dps
  attr(most.lhns.raw,"df") = most.lhns
  attr(most.lhns.raw.dps,"df") = most.lhns.dps
  attr(lh.inputs,"df") = most.lhins
  attr(lh.inputs.dps,"df") = most.lhins.dps
  attr(dolan.splits,"df") = lh.splits.dps
  # Re-name objects
  mbons.light.dps <<- mbons.dps
  pn.axons.light <<- light.pn.axons
  pn.axons.light.dps <<- light.pn.axons.dps
  most.lhns <<- most.lhns.raw
  most.lhns.dps <<- most.lhns.raw.dps
  most.lhins <<- lh.inputs
  most.lhins.dps <<- lh.inputs.dps
  lh.splits.dps <<- dolan.splits
  # Add MCFO data to most.lhns ?
}
