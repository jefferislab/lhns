##################
# Hemibrain LHNs #
##################
devtools::load_all(".")
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

# All the newest names
namelist =  read.csv("data-raw/csv/Namelist-04162020.csv")
colnames(namelist) = c("bodyid","type","cbf","m.type","c.type")

# Get LH information
lh.info = neuprintr::neuprint_find_neurons(
  input_ROIs = "LH(R)",
  output_ROIs =  'LH(R)',
  all_segments = FALSE )

# Get LH meta data
lh.meta = neuprint_get_meta(unique(hemibrain.lhn.bodyids,ito.lhns$body.ID))
lh.meta = lh.meta[order(lh.meta$type),]
lh.meta = subset(lh.meta, bodyid%in%hemibrain.lhn.bodyids)
new.cts = ito.lhns$new.type.name[match(lh.meta$bodyid,ito.lhns$body.ID,)]
new.cts[is.na(new.cts)] = lh.meta$type[is.na(new.cts)]
lh.meta$type = new.cts

# Get neurons
db = hemibrainr::hemibrain_neurons()

# Get most.lhns
most.lhns.hemibrain = hemibrain_lm_lhns()
xyzmatrix(most.lhns.hemibrain) = xyzmatrix(most.lhns.hemibrain)*(1000/8)

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
gs$bodyid = hemibrainr:::correct_id(gs$bodyid)
rownames(gs) = gs$bodyid

## Get LH volume
hemibrain.lhr = hemibrain_roi_meshes("LH(R)")

## Load a save function
write_lhns <- function(df,
                       bodyids = NULL,
                       selected_file = "1OSlDtnR3B1LiB5cwI5x5Ql6LkZd8JOS5bBr-HTi0pOw",
                       column = colnames(gs)){
  # Read the Google Sheet
  gs = gsheet_manipulation(FUN = googlesheets4::read_sheet,
                           ss = selected_file,
                           sheet = "lm",
                           guess_max = 3000,
                           return = TRUE)
  gs$id = correct_id(gs$id)
  rownames(gs) = gs$id
  # Check column
  if((!identical(colnames(gs),column) & length(column) > 1)|(sum(column%in%colnames(gs))<1)){
    stop("Column must be one column of the google sheet, or all the columns")
  }
  # Check df
  if(!is.null(bodyids)){
    df = subset(df, df$bodyid %in% bodyids)
    message("Updating ", nrow(df), " entries")
  }
  rows = match(df$bodyid,gs$bodyid)+1
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
                        data = as.data.frame(df[as.character(r),column]),
                        sheet = "lhns",
                        col_names = FALSE)
  }
}

# hidden
correct_id <-function(v){
  gsub(" ","",v)
}

# hidden
hemibrain_multi3d <- function(..., someneuronlist = hemibrain_neurons()){
  m = as.list(match.call())
  count = length(m)-1
  cols = rainbow(count)
  for(i in 1:count){
    j = i+1
    n = as.character(get(as.character(m[[j]])))
    n = n[n%in%names(someneuronlist)]
    col = grDevices::colorRampPalette(colors = c(cols[i],"grey10"))
    col = col(length(n)+2)[1:length(n)]
    rgl::plot3d(someneuronlist[n], lwd = 2, col = col, soma = TRUE)
  }
}

# hidden
process_types <- function(df, hemibrain_lhns){
  # Make matches
  df$FAFB.match = hemibrain_lhns$FAFB.match[match(df$bodyid,hemibrain_lhns$bodyid)]
  df$FAFB.match.quality = hemibrain_lhns$FAFB.match.quality[match(df$bodyid,hemibrain_lhns$bodyid)]
  df$LM.match = hemibrain_lhns$LM.match[match(df$bodyid,hemibrain_lhns$bodyid)]
  df$LM.match.quality = hemibrain_lhns$LM.match.quality[match(df$bodyid,hemibrain_lhns$bodyid)]
  ## Correct cell types
  for(ct in unique(df$cell.type)){
    d = subset(df, df$cell.type==ct)
    ito.types = d$type
    if(length(ito.types)>1){
      f = factor(d$type, levels = sort(unique(d$type)))
      cell.types = paste0(d$cell.type,letters[f])
      df$cell.type[match(d$bodyid,df$bodyid)] = cell.types
    }
  }
  ## Has there been a type change?
  for(ct in unique(df$cell.type)){
    d = subset(df, df$cell.type==ct)
    ito.types = unique(d$type)
    if(length(ito.types)>1){
      df$type.change[match(d$bodyid,df$bodyid)] = TRUE
    }else{
      e = subset(df, df$type==ito.types)
      if(nrow(e)!=nrow(d)){
        df$type.change[match(d$bodyid,df$bodyid)] = TRUE
      }
    }
  }
  df
}
