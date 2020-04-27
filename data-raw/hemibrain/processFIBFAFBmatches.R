#####################
# FIB-FAFB matching #
#####################
devtools::load_all(".")
source("data-raw/hemibrain/startupHemibrain.R")

# The google sheet database:
# https://docs.google.com/spreadsheets/d/1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw/edit#gid=0

# load NBLAST
load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb (1).fib.twigs5.crossnblast.rda")
# load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb.fib.twigs5.crossnblast.rda") ## Or this one
nb.complete = t(fafb.fib.twigs5.crossnblast)
rm("fafb.fib.twigs5.crossnblast")

# Match!
hemibrain_FAFB_matching(bodyids=lhns::hemibrain.lhn.bodyids, hemibrain.fafb.nblast = fafb.fib.twigs5.crossnblast)
