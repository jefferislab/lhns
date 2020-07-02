#############
# Transfers #
#############
source("data-raw/hemibrain/startupHemibrain.R")
selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw"

# Udate function
update_gsheet <- function(update,
                          gs,
                          selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                          tab,
                          match,
                          id){
  for(row in 1:nrow(update)){
    columns = c(paste0(match,".match"), paste0(match,".match.quality"))
    r = match(update[row,id],gs[[id]])+1
    if(is.na(r)){
      next
    }
    for(column in columns){
      letter = LETTERS[match(column,colnames(gs))]
      range = paste0(letter,r)
      hemibrainr:::gsheet_manipulation(FUN = googlesheets4::range_write,
                                       ss = selected_file,
                                       range = range,
                                       data = as.data.frame(update[row,column]),
                                       sheet = tab,
                                       col_names = FALSE)
    }
  }

}



##########
# Sheets #
##########

# Read the LM Google Sheet
lmg = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lm",
                                      guess_max = 3000,
                                      return = TRUE)
lmg$id = correct_id(lmg$id)
rownames(lmg) = lmg$id

# Read the FAFB Google Sheet
fg = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "fafb",
                                      guess_max = 3000,
                                      return = TRUE)
fg$skid = correct_id(fg$skid)
rownames(fg) = fg$skid

# Read the hemibrain Google Sheet
hg = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lhns",
                                      guess_max = 3000,
                                      return = TRUE)
hg$bodyid = correct_id(hg$bodyid)
rownames(hg) = hg$bodyid

##############
# LM -> FAFB #
##############
missing = is.na(fg$LM.match)
matches = lmg$id[match(fg$skid[missing],lmg$FAFB.match)]
quality = lmg$FAFB.match.quality[match(fg$skid[missing],lmg$FAFB.match)]
fg[missing,"LM.match"] = matches
fg[missing,"LM.match.quality"] = quality
sorted = which(missing)[!is.na(matches)]
update_gsheet(update = fg[sorted,],
              gs = fg,
              tab = "fafb",
              match = "LM",
              id = "skid")

###################
# LM -> Hemibrain #
###################
missing = is.na(hg$LM.match)
matches = lmg$id[match(hg$bodyid[missing],lmg$hemibrain.match)]
quality = lmg$hemibrain.match.quality[match(hg$bodyid[missing],lmg$hemibrain.match)]
hg[missing,"LM.match"] = matches
hg[missing,"LM.match.quality"] = quality
sorted = which(missing)[!is.na(matches)]
update_gsheet(update = hg[sorted,],
              gs = hg,
              tab = "lhns",
              match = "LM",
              id = "bodyid")

##############
# FAFB -> LM #
##############
missing = is.na(lmg$FAFB.match)
matches = fg$skid[match(lmg$id[missing],fg$LM.match)]
quality = fg$LM.match.quality[match(lmg$id[missing],fg$LM.match)]
lmg[missing,"FAFB.match"] = matches
lmg[missing,"FAFB.match.quality"] = quality
sorted = which(missing)[!is.na(matches)]
update_gsheet(update = lmg[sorted,],
              gs = lmg,
              tab = "lm",
              match = "FAFB",
              id = "id")

#####################
# FAFB -> Hemibrain #
#####################
missing = is.na(hg$FAFB.match)
matches = fg$skid[match(hg$bodyid[missing],fg$hemibrain.match)]
quality = fg$hemibrain.match.quality[match(hg$bodyid[missing],fg$hemibrain.match)]
hg[missing,"FAFB.match"] = matches
hg[missing,"FAFB.quality"] = quality
sorted = which(missing)[!is.na(matches)]
update_gsheet(update = hg[sorted,],
              gs = hg,
              tab = "lhns",
              match = "FAFB",
              id = "bodyid")

###################
# Hemibrain -> LM #
###################
missing = is.na(lmg$hemibrain.match)
matches = hg$bodyid[match(lmg$id[missing],hg$LM.match)]
quality = hg$LM.match.quality[match(lmg$id[missing],hg$LM.match)]
lmg[missing,"hemibrain.match"] = matches
lmg[missing,"hemibrain.quality"] = quality
sorted = which(missing)[!is.na(matches)]
update_gsheet(update = lmg[sorted,],
              gs = lmg,
              tab = "lm",
              match = "hemibrain",
              id = "id")

#####################
# Hemibrain -> FAFB #
#####################
missing = is.na(fg$hemibrain.match)
matches = hg$bodyid[match(fg$skid[missing],hg$FAFB.match)]
quality = hg$FAFB.match.quality[match(fg$skid[missing],hg$FAFB.match)]
fg[missing,"hemibrain.match"] = matches
fg[missing,"hemibrain.match.quality"] = quality
sorted = which(missing)[!is.na(matches)]
update_gsheet(update = fg[sorted,],
              gs = fg,
              tab = "fafb",
              match = "hemibrain",
              id = "skid")
