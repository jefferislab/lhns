# Load packages
library(natverse)
library(nat.jrcbrains)
library(nat.templatebrains)
library(hemibrainr)
library(catnat)
library(stringi)

# INSERT CATMAID_LOGIN HERE
## FAFB.conn = catmaid_login(server = "https://neuropil.janelia.org/tracing/fafb/v14/", authname = "X", authpassword = "X", token = "X")

### Original search saved in a GoogleSheet ###
# gs = googlesheets::gs_title("EMsearch")
##############################################

# Get FAFB meta data
em.lh.meta.orig = read.csv("data-raw/csv/em_papers_lh_cell_types.csv")
em.lh.meta = change_nonascii(em.lh.meta.orig)
fafb_lhns = em.lh.meta
rownames(fafb_lhns) = fafb_lhns$skid
usethis::use_data(fafb_lhns, overwrite = TRUE)

# Read in our favourite LHNs from the FAFB project
lh.fafb = catmaid::read.neurons.catmaid(em.lh.meta$skid)
lh.fafb[,] = em.lh.meta
lh.fafb[,"skeleton.type"] = "EM"
lh.fafb[,"dataset"] = "FAFB"
lh.fafb = flow.centrality(lh.fafb, polypre = FALSE, mode = "centrifugal", split = "distance")
lh.fafb = xform_brain(lh.fafb, reference = FCWB, sample = FAFB)

# Read in our favourite LHNs from the hemibrain project
# bis = as.character(unique(em.lh.meta$hemibrain_match))
# db = hemibrain_neurons()
# bis = intersect(bis, names(db))
# lh.hemibrain = hemibrainr::hemibrain_read_neurons(bis, microns = TRUE, OmitFailures = TRUE)
# lh.hemibrain[,] = em.lh.meta[match(em.lh.meta$bodyid,names(lh.hemibrain)),]
# lh.hemibrain[,"skeleton.type"] = "EM"
# lh.hemibrain[,"dataset"] = "hemibrain"
# lh.hemibrain = xform_brain(lh.hemibrain, reference= "FCWB", sample="JRCFIB2018F")

# And the same for FAFB PNs
em.pn.meta = read.csv("data-raw/csv/pn_cell_types.csv")
rownames(em.pn.meta) = em.pn.meta$skeleton_id
em.pn.meta = change_nonascii(em.pn.meta)
pn.fafb = catmaid::read.neurons.catmaid(unique(em.pn.meta$skeleton_id), OmitFailures = TRUE)
pn.fafb[,] = em.pn.meta[names(pn.fafb),]
pn.fafb[,"skeleton.type"] = "EM"
pn.fafb[,"dataset"] = "FAFB"
pn.fafb = xform_brain(pn.fafb, reference = FCWB, sample = FAFB)

# Save
lh.fafb = as.neuronlistfh(lh.fafb, dbdir='inst/extdata/data')
lh.hemibrain = as.neuronlistfh(lh.hemibrain, dbdir='inst/extdata/data')
pn.fafb = as.neuronlistfh(pn.fafb, dbdir='inst/extdata/data')
write.neuronlistfh(lh.fafb, file='inst/extdata/lh.fafb.rds',overwrite = TRUE)
write.neuronlistfh(lh.hemibrain, file='inst/extdata/lh.hemibrain.rds',overwrite = TRUE)
write.neuronlistfh(pn.fafb, file='inst/extdata/pn.fafb.rds',overwrite = TRUE)



