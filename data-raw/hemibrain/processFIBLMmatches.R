#####################
# FIB-FAFB matching #
#####################
source("data-raw/hemibrain/startupHemibrain.R")

# The google sheet database:
# https://docs.google.com/spreadsheets/d/1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw/edit#gid=0

# Read the Google Sheet
gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lhns",
                                      return = TRUE)
gs$bodyid = correct_id(gs$bodyid)
rownames(gs) = gs$bodyid

# load NBLAST
load("/Volumes/GoogleDrive/Shared\ drives/hemibrain/hemibrain_nblast/hemibrain.lhns.mean.compressed.rda")
# load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb.fib.twigs5.crossnblast.rda") ## Or this one
nb.complete = t(fafb.fib.twigs5.crossnblast)
rm("fafb.fib.twigs5.crossnblast")

