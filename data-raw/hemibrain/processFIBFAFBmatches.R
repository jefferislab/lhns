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

# # Add matches already made to Google Sheet
matches = fafb_lhns
matches$FAFB.match = matches$skid
matches$FAFB.match.quality = "good"
matches$hemibrain.match = matches$hemibrain_match
matches$hemibrain.match.quality = "good"
matches$bodyid = matches$hemibrain_match
matches$User = "ASB"
matches$pnt = matches$primary_neurite
matches$LM.match = matches$closest_light_match
matches$LM.match[matches$LM_match_quality!="cell.type"] = NA
matches$LM.match[grepl("new",matches$LM.match)] = NA
matches$LM.match.quality = "good"
matches = matches[rev(order(matches$status)),]
for(row in 1:nrow(matches)){
  columns = c("FAFB.match", "FAFB.match.quality", "User")
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

# Get all lineage annotated neurons
skids = catmaid::catmaid_skids("annotation:Lineage_annotated")
meta = c("ItoLee_Lineage", "ItoLee_Hemilineage",
         "Hartenstein_Lineage", "Hartenstein_Hemilineage")
maddf <- data.frame()
sub = " |:"
for (ma in meta) {
  mad <- catmaid::catmaid_query_meta_annotations(ma, OmitFailures = TRUE)
  mad$meta <- ma
  mad$field <- gsub(ma, "", mad$name)
  mad$field <- gsub(sub, "", mad$field)
  maddf <- rbind(maddf, mad)
}
as <- catmaid::catmaid_get_annotations_for_skeletons(skids, OmitFailures = TRUE)
as <- as[as$id %in% maddf$id, ]
m <- merge(maddf, as[, c("skid", "id")])
n = data.frame(skid = skids)
rownames(n) <- skids
n[, c(meta, "unique.assignment")] <- NA
for (skid in n[, "skid"]) {
  mm <- m[m$skid == skid, ]
  unique.assignment <- TRUE
  mmm <- data.frame()
  for (ma in meta) {
    field <- mm[mm$meta == ma, "field"]
    if (length(field) > 1) {
      field <- paste(field, collapse = "/")
      unique.assignment <- FALSE
    }
    else if (length(field) == 0) {
      field <- NA
    }
    mmm <- rbind(mmm, data.frame(meta = ma, field = field))
  }
  n[as.character(skid), "unique.assignment"] <- unique.assignment
  n[as.character(skid), meta] <- mmm[match(meta, mmm$meta),
                                     "field"]
}
n$hemibrain.match = NA
n$hemibrain.match.quality = NA
n$LM.match = NA
n$LM.match.quality = NA

# Uses some matches already made
n$hemibrain.match = gs$bodyid[match(n$skid,gs$FAFB.match)]
n$hemibrain.match.quality = gs$FAFB.match.quality[match(n$skid,gs$FAFB.match)]

# Add user
n$User = "AJ"

# Get current fafb matches
gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "fafb",
                                      return = TRUE)
gs$skid = correct_id(gs$skid)
rownames(gs) = gs$skid

# Uses some matches already made
n$hemibrain.match = gs$hemibrain.match[match(n$skid,gs$skid)]
n$hemibrain.match.quality = gs$hemibrain.match.quality[match(n$skid,gs$skid)]
n$User = gs$User[match(n$skid,gs$skid)]

# Create google sheet
googlesheets4::write_sheet(n[0,],
                           ss = selected_file,
                           sheet = "fafb")
batches = split(1:nrow(n), ceiling(seq_along(1:nrow(n))/500))
for(i in batches){
  hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
                      data = n[min(i):max(i),],
                      ss = selected_file,
                      sheet = "fafb")
}

# Add matches already made from spreadhseet
for(row in 1:nrow(matches)){
  columns = c("hemibrain.match", "hemibrain.match.quality", "User")
  r = match(matches[row,"skid"],gs$skid)+1
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
                                     sheet = "fafb",
                                     col_names = FALSE)
  }
}

# Write neurons to FAFB sheet
write_lhns(df = n[ids,],
           sheet = "fafb",
           id.field = "skid",
           column = c("skid", "ItoLee_Lineage", "ItoLee_Hemilineage", "Hartenstein_Lineage",
                      "Hartenstein_Hemilineage",  "hemibrain.match",
                      "hemibrain.match.quality","unique.assignment", "LM.match", "LM.match.quality", "User"
           ))


