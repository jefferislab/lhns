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
csvs = list.files("data-raw/hemibrain/pnts/csv/", full.names = TRUE)
hemibrain.master = data.frame()
for(csv in csvs){
  df = read.csv(file = csv)
  hemibrain.master = rbind(hemibrain.master,df)
}

# Find missing neurons
missing = setdiff(hemibrain.lhn.bodyids,hemibrain.master$bodyid)
missing = setdiff(missing, lh.info.neurons)
missing = as.character(setdiff(missing, do.not.name))

# examine these neurons
if(length(missing)){
  missingn = neuprint_read_skeletons(missing)
}else{
  missingn =  NULL
}






a= c( "548545143", "850653341",
  "546771021")
