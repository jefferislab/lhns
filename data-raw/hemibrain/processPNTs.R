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

# Is this neuron an LHN?
hemibrain.master$is.lhn = is.lhn(hemibrain.master$bodyid)

# Create PNT to CBF mapping
pnt_cbf = aggregate(list(count = hemibrain.master$bodyid),
                    list(pnt = hemibrain.master$pnt,
                         cbf = hemibrain.master$cbf),
                    length)
pnt_cbf = pnt_cbf[order(pnt_cbf$count,decreasing = TRUE),]
hemibrain_pnt_cbf = pnt_cbf[!duplicated(pnt_cbf$cbf),]
rownames(hemibrain_pnt_cbf) = hemibrain_pnt_cbf$cbf
# Save!
usethis::use_data(hemibrain_pnt_cbf, overwrite = TRUE)

# Assign
## Make 2D Images
take_pictures(hemibrain.master)

## Update googlesheet
write_lhns(df = hemibrain.master, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))


