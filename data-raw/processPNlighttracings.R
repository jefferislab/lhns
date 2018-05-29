# Prepare PN light tracing data
load("data-raw/light_PN_tracings.rda")
load("data-raw/light_PN_tracings_dps.rda")
pn.axons.light=subset(light.pn.axons, !Glomerulus%in%c("acj6","NP5194","NP6099")) # Get rid of lingering LHNs
pn.axons.light = pn.axons.light[pn.axons.light[,"PNType"]=="iPN"]
pn.axons.light[,"tract"] = "mALT"
pn.axons.light[,"type"] = "IN"
pn.axons.light[,"skeleton.type"] = "FijiTracing"
pn.axons.light[,"id"] = names(pn.axons.light)
pn.axons.light = pn.axons.light[,]
pn.axons.light.dps = pn.axons.light[names(light.pn.axons.dps),] # Save only the metadata
devtools::use_data(pn.axons.light,overwrite=TRUE)
devtools::use_data(pn.axons.light.dps,overwrite=TRUE)
