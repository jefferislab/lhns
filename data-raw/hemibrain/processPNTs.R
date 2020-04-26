########
# PNTs #
########
source("data-raw/hemibrain/startupHemibrain.R")

# NBLAST matrix
hemibrain_pnt_nblast = hemibrain_pnt_nblast[lhn.bodyids,lhn.bodyids]
