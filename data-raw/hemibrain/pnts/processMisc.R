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



missing = c("390586752", "787205311", "728625156", "295107514", "573381453",
            "451602687", "1005119041", "5812982844", "579169802", "579169910",
            "360236724", "359210228", "668552668", "327220514", "328519904",
            "359210479", "390919685", "390586752", "642612763", "765029085",
            "488550675", "455746581", "545082184", "517445395", "578474907",
            "638178497", "1130947782", "5813054304", "703033179", "887165687",
            "642723975", "486073415", "607131089", "611323175", "5812996641",
            "294773987", "295127956", "325815440", "294786630", "295115794",
            "356809554", "5901219179", "422997837", "482356368", "482684855",
            "546438473")


#LHAV3
a = c("390586752", "327220514", "328519904", "359210479", "390919685", "390586752")

#LHPV6
b = c("787205311", "294773987", "295127956", "325815440")

#LHPV5
c = "728625156"

#LHPV6
d= c("295107514", "573381453", "451602687")

#LHPV5
e = c("1005119041", "5812982844")

#LHAV4
f = c("579169802", "579169910", "360236724")

#LHAD1
g = "359210228"

#LHAV2
h = "668552668"

#LHAV5
i = c("642612763", "765029085")

#LHAD3
j = c("488550675", "455746581", "545082184")

#LHAV1
k = c("517445395", "578474907", "638178497")

#LHAV2
l = "1130947782"

#
m = "5813054304"

#
n = c("703033179", "887165687", "642723975", "486073415", "607131089")

#
o = "611323175"

#LHPD4
p= c("294786630", "295115794")

#LHPV4
q = "356809554"

# LHAV3
r = "5901219179"

#
s = c("422997837", "482356368", "482684855")











