##################
# Hemibrain LHNs #
##################
library(natverse)
library(hemibrainr)

###################################################################################
# LHNs are neurons with 1% of their synaptic input / 10 synapses coming from uPNs #
###################################################################################
# LHNs must be downstream of uPNs ...
upns = neuprint_read_neurons(hemibrainr::upn.ids)
upn.syns = hemibrainr::hemibrain_extract_connections(upns)
# And they must be 'neuron' objects in the LH(R) ROI ...
lh.info = neuprintr::neuprint_find_neurons(
  input_ROIs = "LH(R)",
  output_ROIs =  'LH(R)',
  all_segments = FALSE )
lh.ids = intersect(lh.info$bodyid,upns.down.ids)
# And they must get at least 1% of their inputs from uPNs, and not themselves be a PN ...
upn.syns %>%
  dplyr::filter(partner %in% lh.info$bodyid
                & ! partner %in% c(hemibrainr::upn.ids, hemibrainr::mpn.ids, hemibrainr::mbon.ids)
                & prepost == 1) %>%
  dplyr::mutate(npost = lh.info[,"npost"][match(partner,lh.info$bodyid)]) %>%
  dplyr::group_by(partner) %>%
  dplyr::mutate(pn.weight = sum(as.numeric(weight))) %>%
  dplyr::mutate(norm = pn.weight/as.numeric(npost)) %>%
  dplyr::filter(norm > 0.01 | pn.weight > 10) %>%
  dplyr::ungroup() %>%
  dplyr::filter(!duplicated(partner)) %>%
  as.data.frame() ->
  upn.conn
lh.meta = neuprint_get_meta(unique(upn.conn$partner))
ns = neuprint_search(paste(unique(lh.meta$type),collapse="|"),field="type")
hemibrain.lhn.bodyids =  unique(c(ns$bodyid,upn.conn$partner))
# Save!
usethis::use_data(hemibrain.lhn.bodyids, overwrite = TRUE)

#####################################################################
# GooglesSheet Database for recording information on hemibrain LHNs #
#####################################################################
# lh.meta = neuprint_get_meta(hemibrain.lhn.bodyids)
# lh.meta = lh.meta[order(lh.meta$type),]
# lh.meta = subset(lh.meta, bodyid%in%hemibrain.lhn.bodyids)
# lh.meta$class = NA
# lh.meta$pnt = NA
# lh.meta$cell.type = NA
# lh.meta$ItoLee_Hemilineage = NA
# lh.meta$Hartenstein_Hemilineage = NA
# lh.meta$FAFB.match = NA
# lh.meta$FAFB.match.quality = NA
# googlesheets4::write_sheet(lh.meta[0,],
#                            ss = selected_file,
#                            sheet = "lhns")
# batches = split(1:nrow(lh.meta), ceiling(seq_along(1:nrow(lh.meta))/500))
# for(i in batches){
#   hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
#                       data = lh.meta[min(i):max(i),],
#                       ss = selected_file,
#                       sheet = "lhns")
# }
# ## And for light level data ###
# most.lh = union(lhns::most.lhins, lhns::most.lhns)
# lm.meta = most.lh[,c("cell.type","type")]
# lm.meta = lm.meta[order(lm.meta$cell.type),]
# lm.meta$id = rownames(lm.meta)
# lm.meta$hemibrain.match = NA
# lm.meta$hemibrain.match.quality = NA
# lm.meta$FAFB.match = NA
# lm.meta$FAFB.match.quality = NA
# lm.meta$User = "ASB"
# googlesheets4::write_sheet(lm.meta[0,],
#                            ss = selected_file,
#                            sheet = "lm")
# batches = split(1:nrow(lm.meta), ceiling(seq_along(1:nrow(lm.meta))/500))
# for(i in batches){
#   hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
#                       data = lm.meta[min(i):max(i),],
#                       ss = selected_file,
#                       sheet = "lm")
# }

##########################################################################
# Save GooglesSheet Database for recording information on hemibrain LHNs #
##########################################################################
# Read the Google Sheet
hemibrain_lhns = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lhns",
                                      return = TRUE)
hemibrain_lhns$bodyid = correct_id(hemibrain_lhns$bodyid)
rownames(hemibrain_lhns) = hemibrain_lhns$bodyid
hemibrain_lhns$User = NULL
usethis::use_data(hemibrain_lhns, overwrite = TRUE)
