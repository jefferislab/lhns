#######
# pv3 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("1036503560", "913681721", "792313813", "793677224", "5813056930",
      "974788614", "914364284", "945057870", "1006160722", "947172504",
      "1068543885", "1068912795", "912732057", "1037535479", "479935033",
      "5813076392")
pv3 = c(x)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# table(mx$cellBodyFiber)
#
# ### CBFs:
# ### PVL10^PLBDL2 AVL04^lVLPT1
# PVL10 = neuprint_read_neurons("PVL10")
# PVL10 = PVL10[names(PVL10)%in%hemibrain.lhn.bodyids]
# AVL04 = neuprint_read_neurons("AVL04")
# AVL04 = AVL04[names(AVL04)%in%hemibrain.lhn.bodyids]
# pv3.hemi = c(PVL10,AVL04)
#
# ### Re-define some of these CBFs
# sd = setdiff(pv3, names(pv3.hemi))
# ds = setdiff(names(pv3.hemi),pv3)
# pv3 = unique(pv3, names(pv3.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv3)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VPNp1_posterior"
df[x,"Hartenstein_Hemilineage"] = "BLD5_posterior"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV3x ###
############

#####
# a #
#####

a1 = c("5813076392", "1036503560", "913681721") # light = c("Gad1-F-300161","Gad1-F-000101")
df[a1,"cell.type"] = "PV3a1"

a2 = c("792313813", "793677224") # light = c("Gad1-F-600301")
df[a2,"cell.type"] = "PV3a2"

a3 = c("5813056930", "974788614", "914364284", "945057870")
df[a3,"cell.type"] = "PV3a3"

#####
# b #
#####

b1 = c("1006160722", "1037535479", "947172504", "1068912795", "1068543885","912732057") # light = c("Gad1-F-700071")
df[b1,"cell.type"] = "PV3b1"

c1 = "479935033"
df[c1,"cell.type"] = "PV3c1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV3_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
