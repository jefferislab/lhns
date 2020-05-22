########
# PNTs #
########
source("data-raw/hemibrain/startupHemibrain.R")
process = FALSE

# Build all the .csv files
source("data-raw/hemibrain/pnts/processAD1.R")
source("data-raw/hemibrain/pnts/processAD2.R")
source("data-raw/hemibrain/pnts/processAD3.R")
source("data-raw/hemibrain/pnts/processAV1.R")
source("data-raw/hemibrain/pnts/processAV2.R")
source("data-raw/hemibrain/pnts/processAV3.R")
source("data-raw/hemibrain/pnts/processAV4.R")
source("data-raw/hemibrain/pnts/processAV5.R")
source("data-raw/hemibrain/pnts/processAV6.R")
source("data-raw/hemibrain/pnts/processAV7.R")
source("data-raw/hemibrain/pnts/processPD1_PD2.R")
source("data-raw/hemibrain/pnts/processPD3_PD4.R")
source("data-raw/hemibrain/pnts/processPD5.R")
source("data-raw/hemibrain/pnts/processPV1.R")
source("data-raw/hemibrain/pnts/processPV2.R")
source("data-raw/hemibrain/pnts/processPV3.R")
source("data-raw/hemibrain/pnts/processPV4.R")
source("data-raw/hemibrain/pnts/processPV5.R")
source("data-raw/hemibrain/pnts/processPV6.R")
source("data-raw/hemibrain/pnts/processPV7.R")
source("data-raw/hemibrain/pnts/processCENT.R")
source("data-raw/hemibrain/pnts/processWEDPNs.R")

# Build master
csvs = list.files("data-raw/hemibrain/pnts/csv/", full.names = TRUE)
hemibrain.master = data.frame()
for(csv in csvs){
  df = read.csv(file = csv)
  hemibrain.master = rbind(hemibrain.master,df)
}
hemibrain.master = hemibrain.master[!duplicated(hemibrain.master$bodyid),]
rownames(hemibrain.master) = hemibrain.master$bodyid

# Check that each letter is filled
for(p in unique(hemibrain.master$pnt)){
  pt = subset(hemibrain.master, pnt == p & !grepl("WED|CENT|PPL|MB",cell.type))
  ags = sort(unique(gsub(".*([a-z]).*","\\1",pt$cell.type)))
  cat(ags);  message(p)
}

# Fix classes
hemibrain.master$class[is.na(hemibrain.master$class)] = "LHN"
hemibrain.master$ItoLee_Hemilineage[is.na(hemibrain.master$ItoLee_Hemilineage)] = "unknown"
hemibrain.master$Hartenstein_Hemilineage[is.na(hemibrain.master$Hartenstein_Hemilineage)] = "unknown"

# Is this neuron an LHN?
hemibrain.master$is.lhn = is.lhn(hemibrain.master$bodyid)
for(ct in unique(hemibrain.master$cell.type)){
  m = gsub('[a-z]$', '', ct)
  inlh = sum(subset(hemibrain.master,grepl(m,hemibrain.master$cell.type))$is.lhn)>0
  hemibrain.master$is.lhn[hemibrain.master$cell.type==ct] = inlh
}

# Manage connectivity type
hemibrain.master$connectivity.type = hemibrain.master$cell.type
hemibrain.master$cell.type = gsub("[a-z]$","",hemibrain.master$cell.type)

# Add in diffusion model results
diff = read.csv("data-raw/csv/hemibrain_infection_results.csv")
hemibrain.master$layer = diff[match(hemibrain.master$bodyid,diff$node),"layer_mean"]

# Average layer per cell type
hemibrain.master$ct.layer = NA
for(ct in unique(hemibrain.master$cell.type)){
  layer = round(mean(subset(hemibrain.master,cell.type==ct)$layer))
  hemibrain.master$ct.layer[hemibrain.master$cell.type==ct] = layer
}

# What transmitter expression do we think it has?
hls = read.csv("data-raw/csv/hemilineages_by_transmitter.csv")
hemibrain.master$classic.transmitter = "unknown"
hemibrain.master$other.transmitter = "unknown"
for(hl in hls$itolee.hemilineage){
  classic.trans = hls[match(hl,hls$itolee.hemilineage),"classic.transmitter"]
  other.trans = hls[match(hl,hls$itolee.hemilineage),"classic.transmitter"]
  hemibrain.master$classic.transmitter[hemibrain.master$ItoLee_Hemilineage==hl] = classic.trans
  hemibrain.master$other.transmitter[hemibrain.master$ItoLee_Hemilineage==hl] = other.trans
}
hemibrain.master$classic.transmitter[hemibrain.master$classic.transmitter=="acetylcoline"]= "acetylcholine"
hemibrain.master$classic.transmitter[hemibrain.master$cell.type=="LHPV5k1"] = "GABA"

# Add putative cell class for LHNs
source("data-raw/hemibrain/classes.R")
lhon.bodyids = as.character(intersect(lhon.bodyids,hemibrain.master$bodyid[hemibrain.master$class=="LHN"]))
lhln.bodyids = as.character(intersect(lhln.bodyids,hemibrain.master$bodyid[hemibrain.master$class=="LHN"]))
hemibrain.master[lhon.bodyids,"class"] = "LHON"
hemibrain.master[lhln.bodyids,"class"] = "LHLN"

# Create PNT to CBF mapping
pnt_cbf = aggregate(list(count = hemibrain.master$bodyid),
                    list(pnt = hemibrain.master$pnt,
                         cbf = hemibrain.master$cbf,
                         ItoLee_Hemilineage = hemibrain.master$ItoLee_Hemilineage,
                         classic.transmitter = hemibrain.master$classic.transmitter),
                    length)
pnt_cbf = pnt_cbf[order(pnt_cbf$count,decreasing = TRUE),]
hemibrain_pnt_cbf = pnt_cbf[!duplicated(pnt_cbf$cbf),]
rownames(hemibrain_pnt_cbf) = hemibrain_pnt_cbf$cbf

# Save!
if(process){
  usethis::use_data(hemibrain_pnt_cbf, overwrite = TRUE)
}

# State
state_results(hemibrain.master)

# Assign
if(process){
  ## Make 2D Images
  take_pictures(hemibrain.master)

  ## Update googlesheet
  write_lhns(df = hemibrain.master, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Add users
  hemibrain.lhns = hemibrainr:::gsheet_manipulation(FUN = googlesheets4::read_sheet,
                                                    ss = selected_file,
                                                    sheet = "lhns",
                                                    return = TRUE)
  hemibrain.master$User = hemibrain.lhns$User[match(hemibrain.master$bodyid,hemibrain.lhns$bodyid)]
  hemibrain.master$User[is.na(hemibrain.master$User)] = ""

  # Save
  hemibrain_lhns = hemibrain.master
  write.csv(hemibrain_lhns, file = "data-raw/csv/hemibrain_olfactory_lateral_horn_neurons.csv", row.names = FALSE)
  write.csv(hemibrain_pnt_cbf, file = "data-raw/csv/hemibrain_pnt_cbf.csv", row.names = FALSE)
  usethis::use_data(hemibrain_lhns, overwrite = TRUE)
}
