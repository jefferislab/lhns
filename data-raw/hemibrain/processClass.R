##################
# Hemibrain TONs #
##################
library(natverse)
library(hemibrainr)
source("data-raw/hemibrain/pnts/misc.R")
source("data-raw/hemibrain/classes.R")

################
# Examine LHNs #
################

# Get the LH cell types I have constructed
source("data-raw/hemibrain/processPNTs.R")
lhn.bodyids = subset(hemibrain.master, grepl("LHN",class))$bodyid
centrifugal.bodyids = subset(hemibrain.master, grepl("CENT",class))$bodyid
wedpn.bodyids = subset(hemibrain.master,grepl("WED",class))$bodyid

###########################
# Broad groups of neurons #
###########################

# Read info
dan.bodyids = hemibrainr::class2ids("DAN", possible = TRUE)
mbon.bodyids = hemibrainr::class2ids("MBON", possible = TRUE)
orn.bodyids = hemibrainr::class2ids("ORN", possible = TRUE)
hrn.bodyids = hemibrainr::class2ids("HRN", possible = TRUE)
dan.bodyids = hemibrainr::class2ids("DAN", possible = TRUE)
mod.pns = c(csd.bodyids, vum.bodyids)

## Let's get some other easy and popular neuron types
kc.info = neuprint_search("KC.*")
kc.bodyids = kc.info$bodyid
apl.info = neuprint_search(".*APL.*")
apl.bodyids = apl.info$bodyid

## AL neurons
al.info = neuprint_find_neurons(input_ROIs = c("AL(R)"),  all_segments = FALSE)
al.info$post=apply(al.info,1,function(x) sum(as.numeric(x[grepl("\\.post",colnames(al.info))]))/as.numeric(x["npost"]))
al.info = subset(al.info, post>0.3)
al.bodyids = al.info$bodyid

## AMMC neurons
ammc.info = neuprint_find_neurons(input_ROIs = c("AMMC"),  all_segments = FALSE)
ammc.info$post=apply(ammc.info,1,function(x) sum(as.numeric(x[grepl("\\.post",colnames(ammc.info))]))/as.numeric(x["npost"]))
ammc.info = subset(ammc.info, post>0.3)

## WED neurons
wed.info = neuprint_find_neurons(input_ROIs = c("WED(R)"),  all_segments = FALSE)
wed.info$post=apply(wed.info,1,function(x) sum(as.numeric(x[grepl("\\.post",colnames(wed.info))]))/as.numeric(x["npost"]))
wed.info = subset(wed.info, post>0.3)
wedpn.bodyids  = unique(c(wedpn.bodyids, ammc.info$bodyid, wed.info$bodyid, mechpn.bodyids))

## Putative WED-PNs
wedpn.info= neuprint_find_neurons(input_ROIs = c("WED(R)"), output_ROIs = c("LH(R)"), all_segments = FALSE)
wedpn.info = subset(wedpn.info, bodyid %in% wed.info$bodyid)
wed.info = subset(wed.info,!bodyid %in% wedpn.info$bodyid)

## Gustatory neurons
gng.info = neuprint_find_neurons(input_ROIs = c("GNG"),  all_segments = FALSE)
gng.info$post=apply(gng.info,1,function(x) sum(as.numeric(x[grepl("\\.post",colnames(gng.info))]))/as.numeric(x["npost"]))
gng.info = subset(gng.info, post>0.05)
gng.bodyids = gng.info$bodyid

## Putative GNG-PNs
gngpn.info= neuprint_find_neurons(input_ROIs = c("GNG"), output_ROIs = c("LH(R)"), all_segments = FALSE)
gngpn.info = subset(gngpn.info, bodyid %in% gng.info$bodyid)
gngpn.bodyids = unique(c(gngpn.info$bodyid, mal.bodyids,gngpn.bodyids))

##################################################################################
# TONS are neurons with 1% of their synaptic input / 10 synapses coming from PNs #
##################################################################################

# Get hemibrain PNs
db = hemibrain_neurons()
pns.fib = db[names(db)%in%hemibrainr::pn.ids]

# PN output synapses that are not in the CA
pns.syns = hemibrainr::hemibrain_extract_synapses(pns.fib)
pn.syns.out = subset(pns.syns, Label == 2 & prepost == 0)
ca.mesh = neuprintr::neuprint_ROI_mesh(roi = "CA(R)")
ca.mesh = neuprintr::neuprint_ROI_mesh(roi = "AL(R)")
not.in.ca = !pointsinside(xyzmatrix(pn.syns.out),as.hxsurf(ca.mesh))
not.in.al = !pointsinside(xyzmatrix(pn.syns.out),as.hxsurf(ca.mesh))
pn.syns.out = pn.syns.out[(not.in.ca+not.in.al)>1,]

# Get all downstream/upstream partners that are not in the CA
bis = hemibrainr::hemibrain_neuron_bodyids()
ton.ids = intersect(bis, unique(as.character(subset(pn.syns.out)$partner)))
ton.ids = setdiff(ton.ids,c(hemibrainr::upn.ids,hemibrainr::mpn.ids,hemibrainr::pn.ids))
ton.info = neuprintr::neuprint_get_meta(ton.ids)
upn.syns %>%
  dplyr::filter(partner %in% ton.ids & prepost == 1) %>%
  dplyr::mutate(npost = ton.info[,"post"][match(partner,ton.info$bodyid)]) %>%
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
ton.meta = neuprint_get_meta(unique(upn.conn$partner))
ns = neuprint_search(paste(unique(ton.meta$type),collapse="|"),field="type")
ton.ids =  unique(c(ns$bodyid,upn.conn$partner))
ton.meta = neuprint_get_meta(unique(ton.ids))

# Set classes
ton.meta %>%
  dplyr::mutate(class = "unknown") %>%
  dplyr::mutate(class = replace(class, bodyid %in% contra.axons, "CONTRA")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% ascending.axons, "ASCEND")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% vispn.bodyids, "VISPN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% mod.pns, "MODPN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% apl.bodyids, "APL")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% mbon.bodyids, "MBON")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% al.bodyids, "AL")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% gngpn.bodyids, "GNGPN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% kc.bodyids, "KC")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% wedpn.bodyids, "WEDPN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% orn.bodyids, "ORN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% dn.bodyids, "DN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% hrn.bodyids, "HRN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% dan.bodyids, "DAN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% centrifugal.bodyids, "CENT")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% lhn.bodyids, "LHN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% lhon.bodyids, "LHN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% lhln.bodyids, "LHN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% hemibrainr::upn.ids, "uPN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% hemibrainr::mpn.ids, "mPN")) %>%
  dplyr::mutate(class = replace(class, bodyid %in% hemibrainr::vppn.ids, "vPN")) %>%
  dplyr::mutate(class = replace(class, class == "unknown", "TON")) %>%
  dplyr::filter(!class %in% c("APL","AL","KC","ORN","MODPN")) %>%
  as.data.frame() ->
  ton.info

# Cell types
ton.info$cell.type = ton.info$type
ton.info$connectivity.type = ton.info$type
ton.info[as.character(hemibrain.master$bodyid),"cell.type"] = hemibrain.master$cell.type[match(ton.info[as.character(hemibrain.master$bodyid),"bodyid"],
                                                                                                       hemibrain.master$bodyid)]
ton.info[as.character(hemibrain.master$bodyid),"cell.type"] = hemibrain.master$connectivity.type[match(ton.info[as.character(hemibrain.master$bodyid),"bodyid"],
                                                                                                        hemibrain.master$bodyid)]

# The infection model results
diff = read.csv("data-raw/csv/hemibrain_infection_results.csv")
ton.info$layer = diff[match(ton.info$bodyid,diff$node),"layer_mean"]
ton.info$ct.layer = NA
for(ct in unique(ton.info$cell.type)){
  layer = round(mean(subset(ton.info,cell.type==ct)$layer))
  ton.info$ct.layer[ton.info$cell.type==ct] = layer
}

# Hemilineages and transmitters
ton.info$ItoLee_Hemilineage = "unknown"
ton.info$pnt = "unknown"
ton.info$classic.transmitter = "unknown"
for(cbf in hemibrain_pnt_cbf$cbf){
  ins = grepl(cbf,ton.info$cellBodyFiber)
  ton.info[ins,"pnt"] = hemibrain_pnt_cbf[cbf,"pnt"]
  ton.info[ins,"ItoLee_Hemilineage"] = hemibrain_pnt_cbf[cbf,"ItoLee_Hemilineage"]
  ton.info[ins,"classic.transmitter"] = hemibrain_pnt_cbf[cbf,"classic.transmitter"]
}

# Write!
write.csv(ton.info, file = "data-raw/csv/hemibrain_olfactory_third_order_neurons.csv", row.names = FALSE,)
hemibrain_tons = ton.info

# Save!
hemibrain.ton.bodyids = unique(as.character(hemibrain_tons$bodyid))
usethis::use_data(hemibrain_tons, overwrite = TRUE)
usethis::use_data(hemibrain.ton.bodyids, overwrite = TRUE)

# NBLAST stuff
# nb = hemibrain_nblast()
# res = nb[rownames(nb) %in% ids, colnames(nb)%in%ids]
# hckcs = nhclust(scoremat=res)
# k = 5
# dkcs=dendroextras::colour_clusters(hckcs, k=k)
# for(j in 1:k){
#   clear3d();plot3d(hemibrain.surf,col="grey",alpha = 0.1)
#   plot3d(hckcs,k=k,db=db, group = j)
#   print(dput(subset(hckcs, k=k, group=j)))
#   p = readline()
# }

