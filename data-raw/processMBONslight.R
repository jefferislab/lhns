load('data-raw/mbons.dps.rda')
mbons.light.dps=nat.templatebrains::xform_brain(mbons.dps, sample = JFRC2013, reference = FCWB)
mbons.light.dps[,"type"] = "MBON"
mbons.light.dps[,"skeleton.type"] = "ConfocalStack"
lhmbons = c("MBON-a'1","MBON-a'3","MBON-a2sc","MBON-calyx")
mbons.light.dps[lhmbons,"type"] = "IN/MBON"
devtools::use_data(mbons.light.dps,overwrite=TRUE, compress = FALSE)
