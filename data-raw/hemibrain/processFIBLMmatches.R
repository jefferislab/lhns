#####################
# LM-FAFB matching #
#####################
source("data-raw/hemibrain/startupHemibrain.R")

# The google sheet database:
# https://docs.google.com/spreadsheets/d/1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw/edit#gid=0

# Read the Google Sheet
ms = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lm",
                                      guess_max = 3000,
                                      return = TRUE)
ms$id = correct_id(ms$id)
rownames(ms) = ms$id

# Add matches already made to Google Sheet (i.e. reverse LM->EM matches)
matches = ms[,c("id","hemibrain.match","hemibrain.match.quality")]
matches = subset(matches, !is.na(hemibrain.match))
colnames(matches) = c("LM.match","bodyid","LM.match.quality")
matches = subset(matches, !matches$LM.match.quality%in%c("p","n"))
for(bi in unique(matches$bodyid)){
  m = subset(matches, matches$bodyid == bi)
  if("e"%in%m$LM.match.quality){
    m = subset(m, m$LM.match.quality == "e")
  }
  if(sum(m$LM.match%in%names(lh.mcfo))>1){
    m = m[m$LM.match%in%names(lh.mcfo),]
  }
  matches$LM.match[match(bi,matches$bodyid)] = m$LM.match[1]
  matches$LM.match.quality[match(bi,matches$bodyid)] = m$LM.match.quality[1]
}
matches = matches[!duplicated(matches$bodyid),]

# Read the main Google Sheet
gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lhns",
                                      return = TRUE)
gs$bodyid = correct_id(gs$bodyid)
rownames(gs) = gs$bodyid

# Update
for(row in 1:nrow(matches)){
  columns = c("LM.match", "LM.match.quality")
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


# Add new neurons
gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                                      sheet = "lm",
                                      return = TRUE)
gs$id = correct_id(gs$id)
rownames(gs) = gs$id
source("data-raw/lm/processDolanSplits.R")
lm.matches = lm_matches()
fafb.matches = hemibrain_matches()
h.match = lm.matches[lh.splits.dps[,"match"],"match"]
h.quality = lm.matches[lh.splits.dps[,"match"],"quality"]
h.match[h.match=="none"] = h.quality[h.match=="none"] = NA
f.match = fafb.matches[h.match,"match"]
f.quality = fafb.matches[h.match,"quality"]
f.match[f.match=="none"] = f.quality[f.match=="none"] = NA
sdf = lh.splits.dps[,c("cell.type", "type", "imagecode")]
colnames(sdf) = c("cell.type", "type", "id")
sdf$hemibrain.match = h.match
sdf$hemibrain.match.quality = h.quality
sdf$FAFB.match = f.match
sdf$FAFB.match.quality = f.quality
sdf$User = "ASB"
sdf = sdf[setdiff(sdf$id,gs$id),colnames(gs)]
sdf[is.na(sdf)]=""
rownames(sdf) = NULL
if(nrow(sdf)){
  hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
                                   data = sdf,
                                   ss = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                                   sheet = "lm")
}





