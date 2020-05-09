##################
# Hemibrain LHNs #
##################
devtools::load_all(".")
library(natverse)
library(neuprintr)
library(hemibrainr)
library(nat.jrcbrains)
source("data-raw/hemibrain/lh_hemibrain_functions.R")

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
