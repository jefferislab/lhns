#######
# PD5 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("484134987", "296199149", "326888609", "514068564")
y = c("329566197", "327933008")
z = "478613576"
pd5 = c(x,y,z)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)

### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)

### CBFs:
### PDM07^SIPT1 PDM10^pSIPB2 PDM11^pSIPB1 PDM29^pSIPB4
# PDM07 = neuprint_read_neurons("PDM07")
# PDM07 =  PDM07[names( PDM07)%in%hemibrain.lhn.bodyids]
# PDM10 = neuprint_read_neurons("PDM10")
# PDM10 = PDM10[names(PDM10)%in%hemibrain.lhn.bodyids]
# PDM11 = neuprint_read_neurons(" PDM11")
# PDM11 =  PDM11[names( PDM11)%in%hemibrain.lhn.bodyids]
# pd5.hemi = union(PDM07,PDM10, PDM11)

### Re-define some of these CBFs
# sd = setdiff(pd5, names(pd5.hemi))
# ds = setdiff(names(pd5.hemi),pd5)
# pd5 = unique(pd5, names(pd5.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pd5)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "SLPpm3"
df[x,"Hartenstein_Hemilineage"] = "DPLc3"
df[y,"ItoLee_Hemilineage"] = "VLPd&p1"
df[y,"Hartenstein_Hemilineage"] = "DPLl2"
df[z,"ItoLee_Hemilineage"] = "SLPad1"
df[z,"Hartenstein_Hemilineage"] = "DPLl3"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### pd5  ###
############

a1 = c("296199149", "326888609", "484134987") # light = c("L1539#2", "fru-F-700240","Gad1-F-200241")
df[a1,"cell.type"] = "PD5a1"

b1 = "514068564"
df[b1,"cell.type"] = "PD5b1"

c1 = "329566197" # light = c("Gad1-F-700184", "VGlut-F-100282", "VGlut-F-300438")
df[c1,"cell.type"] = "PD5c1"

d1 = "327933008" # light = c("fru-M-000077", "fru-F-000098")
df[d1,"cell.type"] = "PD5d1"

e1 = "478613576"
df[e1,"cell.type"] = "PD5e1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PD5_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
