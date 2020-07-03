# Up-date light level names to be in line with hemibrain names
library(hemibrainr)
source("R/utilities.R")

##############
# most.lhins #
##############
source("data-raw/lm/processLHinputs.R") # Old names from Frechter et al.
df = re_cell_type(df = most.lhins[,], lhn = FALSE)
most.lhins[,] = df
######################
# Write neuronlistfh #
######################
most.lhins = as.neuronlistfh(most.lhins,dbdir = 'inst/extdata/data/', WriteObjects="missing")
most.lhins.dps = nat::dotprops(most.lhins,resample=1)
most.lhins.dps = as.neuronlistfh(most.lhins.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
####################
# Update Meta-Data #
####################
write.neuronlistfh(most.lhins, file='inst/extdata/most.lhins.rds',overwrite = TRUE, compress = TRUE, version = 2)
write.neuronlistfh(most.lhins.dps, file='inst/extdata/most.lhins.dps.rds',overwrite = TRUE, compress = TRUE, version = 2)

#############
# most.lhns #
#############
source("data-raw/lm/processLHNs.R") # Old names from Frechter et al.
most.lhns = most.lhns[!names(most.lhns)%in%names(most.lhins)] # Remove skeletons also in most.lhins
df = re_cell_type(df = most.lhns[,])
most.lhns[,] = df
######################
# Write neuronlistfh #
######################
most.lhns = as.neuronlistfh(most.lhns,dbdir = 'inst/extdata/data/', WriteObjects="missing")
most.lhns.dps = nat::dotprops(most.lhns,resample=1)
most.lhns.dps = as.neuronlistfh(most.lhns.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
####################
# Update Meta-Data #
####################
write.neuronlistfh(most.lhns, file='inst/extdata/most.lhns.rds',overwrite = TRUE, compress = TRUE, version = 2)
write.neuronlistfh(most.lhns.dps, file='inst/extdata/most.lhns.dps.rds',overwrite = TRUE, compress = TRUE, version = 2)

########
# MCFO #
########
source("data-raw/lm/processMCFO.R")
df = re_cell_type(df = lh.mcfo[,])
lh.mcfo[,] = df
#######################
# Create neuronlistfh #
#######################
lh.mcfo = subset(lh.mcfo,!match%in%c("mis-registered","notLHproper","none"))
lh.mcfo = nat::nlapply(lh.mcfo,nat::resample,stepsize = 1)
lh.mcfo = as.neuronlistfh(lh.mcfo,dbdir = 'inst/extdata/data/', WriteObjects="missing")
lh.mcfo.dps = nat::dotprops(lh.mcfo,OmitFailures=TRUE)
lh.mcfo.dps = as.neuronlistfh(lh.mcfo.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
####################
# Update Meta-Data #
####################
write.neuronlistfh(lh.mcfo, file='inst/extdata/lh.mcfo.rds',overwrite = TRUE, compress = TRUE, version = 2)
write.neuronlistfh(lh.mcfo.dps, file='inst/extdata/lh.mcfo.dps.rds',overwrite = TRUE, compress = TRUE, version = 2)

######
# JJ #
######
source("data-raw/lm/processJJLHNs.R")
df = re_cell_type(df = jfw.lhns[,])
jfw.lhns[,] = df
#######################
# Create neuronlistfh #
#######################
jfw.lhns = nlapply(jfw.lhns,nat::resample,stepsize = 1)
jfw.lhns = as.neuronlistfh(jfw.lhns,dbdir = 'inst/extdata/data/', WriteObjects="missing")
jfw.lhns.dps = nat::dotprops(jfw.lhns,OmitFailures=TRUE)
jfw.lhns.dps = as.neuronlistfh(jfw.lhns.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
####################
# Update Meta-Data #
####################
write.neuronlistfh(jfw.lhns, file='inst/extdata/jfw.lhns.rds',overwrite = TRUE, compress = TRUE, version = 2)
write.neuronlistfh(jfw.lhns.dps, file='inst/extdata/jfw.lhns.dps.rds',overwrite = TRUE, compress = TRUE, version = 2)

##########
# Splits #
##########
source("data-raw/lm/processDolanSplits.R")
lh.splits.dps[,] = re_cell_type(df = lh.splits.dps[,])
most.lh = nat::union(most.lhns, most.lhins)
# Synchronise with lh.mcfo
lh.mcfo.df.clean = subset(lh.mcfo,InLine==TRUE)[,]
for(o in lh.splits.dps[,]$old.cell.type){
  if(o%in%lh.mcfo[,"old.cell.type"]){
    cts = sort(lh.mcfo.df.clean[lh.mcfo.df.clean$old.cell.type==o,"cell.type"])
    cts = unique(unlist(strsplit(cts,"/")))
    cts = paste(sort(na.omit(unique(cts))),collapse="/")
    t = paste(sort(unique(subset(most.lh,cell.type%in%unlist(strsplit(cts,"/")))[,"type"])),collapse="/")
    lh.splits.dps[,][lh.splits.dps[,]$old.cell.type==o,"cell.type"] = cts
    lh.splits.dps[,][lh.splits.dps[,]$old.cell.type==o,"anatomy.group"] = paste(sort(na.omit(unique(process_lhn_name(unique(cts))$anatomy.group))),collapse="/")
    lh.splits.dps[,][lh.splits.dps[,]$old.cell.type==o,"pnt"] = paste(sort(na.omit(unique(process_lhn_name(unique(cts))$pnt))),collapse="/")
    lh.splits.dps[,][lh.splits.dps[,]$old.cell.type==o,"type"] = t
  }
}
#######################
# Create neuronlistfh #
#######################
lh.splits.dps = as.neuronlistfh(lh.splits.dps,dbdir = 'inst/extdata/data/', WriteObjects="missing")
####################
# Update Meta-Data #
####################
write.neuronlistfh(lh.splits.dps, file='inst/extdata/lh.splits.dps.rds',overwrite = TRUE, compress = TRUE, version = 2)

#########
# Other #
#########
source("data-raw/lm/processPNlighttracings.R")
source("data-raw/lm/processMBONslight.R")
source("data-raw/lm/processLHNlines.R")
source("data-raw/lm/processOverlap.R")
source("data-raw/lm/processEPhys.R")
source("data-raw/lm/processFunctionalConnectivity.R")
source("data-raw/lm/processNBLAST.R")

## Delete things not needed:
###Delete filehash files we no longer need
files = c('mbons.light.dps.rds',
          "pn.axons.light.rds",
          "pn.axons.light.dps.rds",
          "most.lhns.rds",
          "most.lhns.dps.rds",
          "most.lhins.rds",
          "most.lhins.dps.rds",
          "lh.splits.dps.rds",
          "lh.mcfo.rds",
          "lh.mcfo.dps.rds",
          "jfw.lhns.rds",
          "jfw.lhns.dps.rds",
          "lh.fafb.rds",
          "pn.fafb.rds")
all.keys = c()
for(f in files){
  a = readRDS(paste0("inst/extdata/",f))
  b = attributes(a)
  keys = b$keyfilemap
  all.keys = c(all.keys,keys)
}
all.files = list.files("inst/extdata/data/")
delete = setdiff(all.files,all.keys)
delete = paste0("inst/extdata/data/",delete)
file.remove(delete)


