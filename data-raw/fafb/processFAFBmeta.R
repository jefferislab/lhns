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
skids = as.character(unique(em.lh.meta$skid))
skids = hemibrainr:::correct_id(skids)

# Read neurons together with their meta data
fafb = catnat::read.neurons.catmaid.meta(skids)

# Get hemibrain matches and therefore cell types
matched = hemibrain_matches(priority = "FAFB")
matched.chosen = matched[skids,]

# Add new ct column
em.lh.meta$new.cell.type = matched[as.character(em.lh.meta$skid),"cell.type"]
em.lh.meta$new.match = matched[as.character(em.lh.meta$skid),"match"]
em.lh.meta$is.lhn = is.lhn(em.lh.meta$new.match)

# Save
fafb_lhns = em.lh.meta
rownames(fafb_lhns) = fafb_lhns$skid
usethis::use_data(fafb_lhns, overwrite = TRUE)
