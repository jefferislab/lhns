# Prepare PN light tracing data
load("data-raw/light_PN_tracings.rda")
light.pn.axons=subset(light.pn.axons, !Glomerulus%in%c("acj6","NP5194","NP6099")) # Get rid of lingering LHNs
light.pn.axons = light.pn.axons[light.pn.axons[,"PNType"]=="iPN"]
devtools::use_data(light.pn.axons,overwrite=TRUE)
