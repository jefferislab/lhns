# #################
# Process Raw Data #
###################

load('data-raw/mbons.dps.rda')
mbons.light.dps=nat.templatebrains::xform_brain(mbons.dps, sample = JFRC2, reference = FCWB)
mbons.light.dps[,"type"] = "MBON"
mbons.light.dps[,"skeleton.type"] = "ConfocalStack"
lhmbons = c("MBON-a'1","MBON-a'3","MBON-a2sc","MBON-calyx")
mbons.light.dps[lhmbons,"type"] = "IN/MBON"
mbons.light.dps[,"id"] = names(mbons.light.dps)
mbons.light.dps = mbons.light.dps

# #################
# Update Meta-Data #
###################

mbons.light.dps = as.neuronlistfh(mbons.light.dps,dbdir = 'inst/extdata/data/', WriteObjects="yes")

#####################
# Write neuronlistfh #
#####################

# write.neuronlistfh(mbons.light.dps, file='inst/extdata/mbons.light.dps.rds',overwrite = TRUE)

