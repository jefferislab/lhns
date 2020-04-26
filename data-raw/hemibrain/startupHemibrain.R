##################
# Hemibrain LHNs #
##################
library(natverse)
library(neuprintr)
library(hemibrainr)
library(nat.jrcbrains)

# Google Sheet database
selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw"

# Information from Kei Ito
cbfs = read.csv("data-raw/csv/CBF-Lineage-mapping.csv")
ito.lhns = read.csv("data-raw/csv/ito_lhns.csv")
rownames(ito.lhns) = ito.lhns$body.ID

# Get LH information
lh.info = neuprintr::neuprint_find_neurons(
  input_ROIs = "LH(R)",
  output_ROIs =  'LH(R)',
  all_segments = FALSE )

# Get LH meta data
lh.meta = neuprint_get_meta(hemibrain.lhn.bodyids)
lh.meta = lh.meta[order(lh.meta$type),]
lh.meta = subset(lh.meta, bodyid%in%hemibrain.lhn.bodyids)

# Get neurons
db = hemibrainr::hemibrain_neurons()

# Get all-by-all hemibrain NBLAST
# hemibrain_all_nblast = hemibrain_nblast(nblast="all")
# hemibrain_arbour_nblast = hemibrain_nblast(nblast="arbour")
# hemibrain_pnt_nblast = hemibrain_nblast(nblast="primary.neurites")
# hemibrain_spine_nblast = hemibrain_nblast(nblast="spines")

# Read the Google Sheet
gs = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                         ss = selected_file,
                         sheet = "lhns",
                         return = TRUE)
rownames(gs) = gs$bodyid

## Get LH volume
hemibrain.lhr = hemibrain_roi_meshes("LH(R)")

## Load a save function
write_lhns <- function(gs,
                       bodyids = NULL,
                       selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                       column = colnames(gs)){
  if((!identical(colnames(gs),column) & length(column) > 1)|(sum(column%in%colnames(gs))<1)){
    stop("Column must be one column of the google sheet, or all the columns")
  }
  rows = (1:nrow(gs))+1
  rownames(gs) = rows
  if(!is.null(bodyids)){
    gs = subset(gs, gs$bodyid %in% bodyids)
    message("Updating ", nrow(gs), " entries")
    rows = rownames(gs)
  }
  for(r in rows){
    if(length(column)==1){
      letter = LETTERS[match(column,colnames(gs))]
      range = paste0(letter,r)
    }else{
      range = paste0("A",r,":",LETTERS[ncol(gs)],r)
    }
    hemibrainr:::gsheet_manipulation(FUN = googlesheets4::range_write,
                        ss = selected_file,
                        range = range,
                        data = as.data.frame(gs[as.character(r),column]),
                        sheet = "lhns",
                        col_names = FALSE)
  }
}



