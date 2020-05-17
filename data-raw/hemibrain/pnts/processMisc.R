########
# Misc #
########
source("data-raw/hemibrain/startupHemibrain.R")

# Groups
source("data-raw/hemibrain/pnts/misc.R")

# Just get neuron assigned objects around the LH
lh.info = neuprintr::neuprint_find_neurons(
  input_ROIs = "LH(R)",
  output_ROIs =  'LH(R)',
  all_segments = FALSE)
lh.info.neurons = subset(lh.info, neuronStatus!="Traced")$bodyid

# Not in main files
csvs = list.files("data-raw/hemibrain/pnts/csv/", full.mes = TRUE)
hemibrain.master = data.frame()
for(csv in csvs){
  df = read.csv(file = csv)
  hemibrain.master = rbind(hemibrain.master,df)
}

# Find missing neurons
missing = setdiff(hemibrain.lhn.bodyids,hemibrain.master$bodyid)
missing = setdiff(missing, lh.info.neurons)
missing = as.character(setdiff(missing, do.not.name))

# Get ids
missing.info  = neuprint_get_meta(missing)
cbs = unique(missing.info$cellBodyFiber)
for(cb in cbs){
  message(hemibrain_pnt_cbf[gsub("\\^.*","",cb),"pnt"])
  s = subset(missing.info, cellBodyFiber == cb)
  dput(s$bodyid)
}

# examine these neurons
if(length(missing)){
  missingn = neuprint_read_skeletons(missing)
}else{
  missingn =  NULL
}

# Missing df
missing.meta = neuprint_get_meta(missing)
df = data.frame()
for(i in 1:nrow(missing.meta)){
  t = missing.meta[i,"type"]
  if(is.na(t)){
    next
  }
  bi = missing.meta[i,"bodyid"]
  if(t %in% hemibrain.master$type){
    tdf = subset(hemibrain.master, type == t)[1,]
    tdf$bodyid = bi
    df = rbind(df,tdf)
  }
}
missing.meta = subset(namelist, bodyid %in% missing)
for(i in 1:nrow(missing.meta)){
  t = missing.meta[i,"type"]
  if(is.na(t)){
    next
  }
  bi = missing.meta[i,"bodyid"]
  if(t %in% hemibrain.master$type){
    tdf = subset(hemibrain.master, type == t)[1,]
    tdf$bodyid = bi
    df = rbind(df,tdf)
  }
}
df = df[!duplicated(df$bodyid),]
write.csv(df, file = "data-raw/hemibrain/pnts/csv/other_celltyping.csv", row.names = FALSE)



