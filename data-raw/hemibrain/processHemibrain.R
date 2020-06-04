##################
# Hemibrain LHNs #
##################
library(natverse)
library(hemibrainr)
source("data-raw/hemibrain/pnts/misc.R")

##################################################################################
# LHNs are neurons with 1% of their synaptic input / 10 synapses coming from PNs #
##################################################################################
# And they must be 'neuron' objects in the LH(R) ROI ...
lh.info = neuprintr::neuprint_find_neurons(
  input_ROIs = "LH(R)",
  output_ROIs =  'LH(R)',
  all_segments = FALSE)
lh.info = subset(lh.info, neuronStatus=="Traced")
lh.ids = intersect(lh.info$bodyid,upn.syns$partner)
lh.ids = setdiff(lh.info$bodyid,c(hemibrainr::upn.ids,hemibrainr::mpn.ids,hemibrainr::dan.ids,hemibrainr::mbon.ids,hemibrainr::pn.ids,do.not.name))
lh.roi.info = as.data.frame(neuprint_get_roiInfo(lh.ids))
lh.roi.info = subset(lh.roi.info, `LH(R).pre` >=10|`LH(R).post`>=10|`LH(R).downstream`>=10|`LH(R).upstream`>=10)
lh.ids = lh.roi.info$bodyid
# And they must get at least 1% of their inputs from uPNs, and not themselves be a PN ...
upn.syns %>%
  dplyr::filter(partner %in% lh.ids & prepost == 1) %>%
  dplyr::mutate(npost = lh.info[,"npost"][match(partner,lh.info$bodyid)]) %>%
  dplyr::mutate(norm = weight/as.numeric(npost)) %>%
  dplyr::mutate(include = (weight>=10&norm>=0.01)) %>%
  dplyr::group_by(partner) %>%
  dplyr::mutate(include = sum(include)>=1) %>%
  dplyr::mutate(pn.weight = sum(as.numeric(weight))) %>%
  dplyr::mutate(pn.norm = pn.weight/as.numeric(npost)) %>%
  dplyr::filter(pn.norm >= 0.1 | pn.weight >= 100 | include) %>%
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
jlns = lhns::jfw.lhns
jlns[,] = lhns::jfw.lhns[,intersect(colnames(lhns::most.lhns),colnames(lhns::jfw.lhns))]
jlns[,"id"] = names(jlns)
most.lh = union(lhns::most.lhins, lhns::most.lhns)
most.lh = union(most.lh, jlns)
lm.meta = most.lh[,c("cell.type","type")]
lm.meta = lm.meta[order(lm.meta$cell.type),]
lm.meta$id = rownames(lm.meta)
lm.meta$hemibrain.match = NA
lm.meta$hemibrain.match.quality = NA
lm.meta$FAFB.match = NA
lm.meta$FAFB.match.quality = NA
lm.meta$User = "ASB"
googlesheets4::write_sheet(lm.meta[0,],
                           ss = selected_file,
                           sheet = "lm")
# batches = split(1:nrow(lm.meta), ceiling(seq_along(1:nrow(lm.meta))/500))
# for(i in batches){
#   hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
#                       data = lm.meta[min(i):max(i),],
#                       ss = selected_file,
#                       sheet = "lm")
# }
# Add new neurons
# Read the Google Sheet
# ms = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
#                                       ss = selected_file,
#                                       sheet = "lm",
#                                       guess_max = 3000,
#                                       return = TRUE)
# ms$id = correct_id(ms$id)
# rownames(ms) = ms$id
# lm.meta.new = subset(lm.meta, ! id %in% ms$id)
# hemibrainr:::gsheet_manipulation(FUN = googlesheets4::sheet_append,
#                                       data = lm.meta.new,
#                                       ss = selected_file,
#                                       sheet = "lm",
#                                       return = TRUE)

##########################################################################
# Save GooglesSheet Database for recording information on hemibrain LHNs #
##########################################################################
# Read the Google Sheet
hemibrain_lhns = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lhns",
                                      return = TRUE)
hemibrain_lhns$bodyid = correct_id(hemibrain_lhns$bodyid)
hemibrain_lhns = hemibrain_lhns[!duplicated(hemibrain_lhns$bodyid),]
hemibrain_lhns = hemibrain_lhns[hemibrain_lhns$bodyid!="",]
rownames(hemibrain_lhns) = hemibrain_lhns$bodyid
hemibrain_lhns$User = NULL

# Add putative transmitter assignment based on hemilineage
hls = read.csv("data-raw/csv/hemilineages_by_transmitter.csv")
hemibrain_lhns$classic.transmitter = "unknown"
hemibrain_lhns$other.transmitter = "unknown"
for(hl in hls$itolee.hemilineage){
  classic.trans = hls[match(hl,hls$itolee.hemilineage),"classic.transmitter"]
  other.trans = hls[match(hl,hls$itolee.hemilineage),"classic.transmitter"]
  hemibrain_lhns$classic.transmitter[hemibrain_lhns$ItoLee_Hemilineage==hl] = classic.trans
  hemibrain_lhns$other.transmitter[hemibrain_lhns$ItoLee_Hemilineage==hl] = other.trans
}
hemibrain_lhns$classic.transmitter[hemibrain_lhns$cell.type=="LHPV5k1"] = "GABA"

# Save
usethis::use_data(hemibrain_lhns, overwrite = TRUE)

# Read the Google Sheet
lm_em_matches = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                      ss = selected_file,
                                      sheet = "lm",
                                      guess_max = 3000,
                                      return = TRUE)
lm_em_matches$id = correct_id(lm_em_matches$id)
rownames(lm_em_matches) = lm_em_matches$id
usethis::use_data(lm_em_matches, overwrite = TRUE)
