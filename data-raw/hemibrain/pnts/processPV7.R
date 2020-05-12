#########
# PV7/8 #
#########
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
pv7 = x = c("392645639", "451308547", "635109166", "511685955")
y = c("604709727", "387952104", "451049385")
z = "359560762"
pv7 = c(x,z)
pv7_pv8 = c(pv7,pv8)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
#
# ### CBFs:
# ### PVL11^PLPF5 PDM09^iPB2 PVL04^PLPF11
# PVL11 = neuprint_read_neurons("PVL11")
# PVL11 = PVL11[names(PVL11)%in%hemibrain.lhn.bodyids]
# PDM09 = neuprint_read_neurons("PDM09")
# PDM09 = PDM09[names(PDM09)%in%hemibrain.lhn.bodyids]
# PVL04 = neuprint_read_neurons("PVL04")
# PVL04 = PVL04[names(PVL04)%in%hemibrain.lhn.bodyids]
# pv7_8.hemi = union(PDM09,PVL04,PVL11)
#
# ### Re-define some of these CBFs
# sd = setdiff(pv7_pv8, names(pv7_8.hemi))
# ds = setdiff(names(pv7_8.hemi),pv7_pv8)
# pv7_pv8 = unique(pv7_8, names(pv7_8.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv7_pv8)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPl&p1_posterior"
df[x,"Hartenstein_Hemilineage"] = "BLVp2_posterior"
df[y,"ItoLee_Hemilineage"] = "SIPp1"
df[y,"Hartenstein_Hemilineage"] = "DPMpl2"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV7 ####
############

a1 = c("392645639", "451308547")
df[a1,"cell.type"] = "PV7a1"

a2 = c("635109166", "511685955")
df[a2,"cell.type"] = "PV7a2"

b1 = "359560762"
df[b1,"cell.type"] = "PV7b1"

############
### PV8 ####
############

a1 = c("387952104", "451049385")
# light = c("Gad1-F-400411","Cha-F-100449", "Gad1-F-100290",
#         "Cha-F-300297", "Gad1-F-200414", "Cha-F-000303","Gad1-F-200151")
df[a1,"cell.type"] = "PV8a1"

b1 = "604709727" # Centrifugal-like
df[b1,"cell.type"] = "PV8b1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV7_PV8_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
