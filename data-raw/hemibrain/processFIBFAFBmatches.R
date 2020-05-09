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

# Add matches already made to Google Sheet
matches = fafb_lhns
matches$FAFB.match = matches$skid
matches$FAFB.match.quality = "e"
matches$bodyid = matches$hemibrain_match
matches$User = "ASB"
matches$pnt = matches$primary_neurite
matches$LM.match = matches$closest_light_match
matches$LM.match[matches$LM_match_quality!="cell.type"] = NA
matches$LM.match[grepl("new",matches$LM.match)] = NA
matches$LM.match.quality = "e"
for(row in 1:nrow(matches)){
  columns = c("pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage", "FAFB.match", "FAFB.match.quality", "User")
  r = match(matches[row,"bodyid"],gs$bodyid)+1
  if(is.na(r)){
    next
  }
  for(column in columns){
    letter = LETTERS[match(column,colnames(gs))]
    range = paste0(letter,r)
    hemibrainr:::gsheet_manipulation(FUN = googlesheets4::range_write,
                                     ss = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                                     range = range,
                                     data = as.data.frame(matches[row,column]),
                                     sheet = "lhns",
                                     col_names = FALSE)
  }
}

# load NBLAST
load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb (1).fib.twigs5.crossnblast.rda")
# load("/Volumes/GoogleDrive/Shared\ drives/flyconnectome/fafbpipeline/fafb.fib.twigs5.crossnblast.rda") ## Or this one
nb.complete = t(fafb.fib.twigs5.crossnblast)
rm("fafb.fib.twigs5.crossnblast")

# Match!
hemibrain_FAFB_matching(bodyids=lhns::hemibrain.lhn.bodyids, hemibrain.fafb.nblast = fafb.fib.twigs5.crossnblast)
