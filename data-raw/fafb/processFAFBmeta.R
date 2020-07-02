# Load packages
library(natverse)
library(nat.jrcbrains)
library(nat.templatebrains)
library(hemibrainr)
library(catnat)
library(stringi)

# Read our published skids
em.lh.meta.orig = read.csv("data-raw/csv/em_papers_lh_cell_types.csv")
em.lh.meta.orig$skid = hemibrainr:::correct_id(em.lh.meta.orig$skid)
em.lh.meta = change_nonascii(em.lh.meta.orig)

# And Marin et al.
# marin.meta.orig = read.csv("data-raw/csv/marin_2020.csv")
# marin.meta.orig$skid = hemibrainr:::correct_id(marin.meta.orig$skid)
# marin.meta = change_nonascii(marin.meta.orig)

# Get hemibrain matches and therefore cell types
# matched = hemibrain_matches(priority = "FAFB")
#
# # Add new ct column
# em.lh.meta$cell_type = matched[as.character(em.lh.meta$skid),"cell.type"]
# em.lh.meta$hemibrain_match = matched[as.character(em.lh.meta$skid),"match"]
# em.lh.meta$cell = paste0(em.lh.meta$cell_type,"#",ave(em.lh.meta$cell_type,em.lh.meta$cell_type,FUN= seq.int))

# Make cohesive with Marin
# inmarin = match(marin.meta$skid,em.lh.meta$skid)
# em.lh.meta$cell_type[inmarin] = gsub("#","",marin.meta$proposed_name)
# em.lh.meta$cell[inmarin] = marin.meta$proposed_name

# Update CATMAID names
em.lh.meta$catmaid_name = catmaid_get_neuronnames(em.lh.meta$skid)

# Save
fafb_lhns = em.lh.meta
rownames(fafb_lhns) = fafb_lhns$skid
usethis::use_data(fafb_lhns, overwrite = TRUE)
# write.csv(fafb_lhns,file = "data-raw/csv/em_papers_lh_cell_types.csv", row.names = TRUE)

