load('data-raw/mbons.dps.rda')
mbons.light=nat.templatebrains::xform_brain(mbons.dps, sample = JFRC2013, reference = FCWB)
devtools::use_data(mbons.light,overwrite=TRUE, compress = FALSE)
