# #################
# Process Raw Data #
###################

load("data-raw/light_PN_tracings.rda")
pn.axons.light=subset(light.pn.axons, !Glomerulus%in%c("acj6","NP5194","NP6099")) # Get rid of lingering LHNs
pn.axons.light = pn.axons.light[pn.axons.light[,"PNType"]=="iPN"]
pn.axons.light[,"tract"] = "mALT"
pn.axons.light[,"type"] = "IN"
pn.axons.light[,"skeleton.type"] = "FijiTracing"
pn.axons.light[,"id"] = names(pn.axons.light)
pn.axons.light.dps = nat::nlapply(pn.axons.light,nat::dotprops,resample = 1, OmitFailures = TRUE)

# #################
# Update Meta-Data #
###################

pn.axons.light = as.neuronlistfh(pn.axons.light,dbdir = 'inst/extdata/data/', WriteObjects="yes")
pn.axons.light.dps = as.neuronlistfh(pn.axons.light.dps,dbdir = 'inst/extdata/data/', WriteObjects="yes")

#####################
# Write neuronlistfh #
#####################

#write.neuronlistfh(pn.axons.light, file='inst/extdata/pn.axons.light.rds',overwrite = TRUE)
#write.neuronlistfh(pn.axons.light.dps, file='inst/extdata/pn.axons.light.dps.rds',overwrite = TRUE)
