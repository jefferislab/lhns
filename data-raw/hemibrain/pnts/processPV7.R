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
x = c("392645639", "451308547", "635109166", "511685955","667857582")
z = "359560762"
pv7 = c(x,z)

y = c("604709727", "387952104", "451049385","423748579")
u = "544361987"
z = "883479122"
pv10 = c(y,u,z)

pv8 = w = c("480258208", "728205616", "694818168", "694126781")

pv11 = v = c("483337285", "543718301")

pv9 = k = c("602476655","542751938")

pv12 = j =c("480590566", "574688051")

pv13 = i = c("5813021882", "5813021874")

pv_other = c(pv7,pv8,pv9,pv10,pv11,pv12,pv13)

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
# sd = setdiff(pv_other, names(pv7_8.hemi))
# ds = setdiff(names(pv7_8.hemi),pv_other)
# pv_other = unique(pv7_8, names(pv7_8.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv_other)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPl&p1_posterior"
df[x,"Hartenstein_Hemilineage"] = "BLVp2_posterior"
df[z,"ItoLee_Hemilineage"] = "SLPp&v1_ventral"
df[z,"Hartenstein_Hemilineage"] = "DPLp2_ventral"
df[y,"ItoLee_Hemilineage"] = "SIPp1"
df[y,"Hartenstein_Hemilineage"] = "DPMpl2"
df[w,"ItoLee_Hemilineage"] = "primary"
df[w,"Hartenstein_Hemilineage"] = "primary"
df[u,"ItoLee_Hemilineage"] = "DM1"
df[u,"Hartenstein_Hemilineage"] = "DPMm1"
df[z,"ItoLee_Hemilineage"] = "DM3"
df[z,"Hartenstein_Hemilineage"] = "DPMpm2"
df[i,"ItoLee_Hemilineage"] = "DM1"
df[i,"Hartenstein_Hemilineage"] = "DPMm1"
df[i,"ItoLee_Hemilineage"] = "DM6"
df[i,"Hartenstein_Hemilineage"] = "CM3"
df[j,"ItoLee_Hemilineage"] = "DM4"
df[j,"Hartenstein_Hemilineage"] = "CM4"
df[k,"ItoLee_Hemilineage"] = "DM6"
df[k,"Hartenstein_Hemilineage"] = "CM3"
df[v,"ItoLee_Hemilineage"] = "primary"
df[v,"Hartenstein_Hemilineage"] = "primary"

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

c1 = "667857582"
df[c1,"cell.type"] = "PV7c1"

############
### PV8 ####
############

a1 = "480258208"
df[a1,"cell.type"] = "PV8a1"

b1 = "728205616"
df[b1,"cell.type"] = "PV8b1"

c1 = "694818168"
df[c1,"cell.type"] = "PV8c1"

d1 = "694126781"
df[d1,"cell.type"] = "PV8d1"

#############
### PV11 ####
#############

a1 = c("483337285", "543718301")
df[a1,"cell.type"] = "PV11a1"

#############
### PV10 ####
#############

a1 = c("387952104", "451049385")
# light = c("Gad1-F-400411","Cha-F-100449", "Gad1-F-100290",
#         "Cha-F-300297", "Gad1-F-200414", "Cha-F-000303","Gad1-F-200151")
df[a1,"cell.type"] = "PV10a1"

b1 = "604709727" # Centrifugal-like
df[b1,"cell.type"] = "PV10b1"

c1 = "544361987"
df[c1,"cell.type"] = "PV10c1"

d1 = "423748579"
df[d1,"cell.type"] = "PV10d1"

e1 = "883479122"
df[e1,"cell.type"] = "PV10e1"

#############
### PV11 ####
#############

a1 = "602476655"
df[a1,"cell.type"] = "DNp44"

b1 = "542751938"
df[b1,"cell.type"] = "PV9b1"

#############
### PV12 ####
#############

a1 = c("480590566", "574688051")
df[a1,"cell.type"] = "PV12a1"

a1 = c("5813021882", "5813021874")
df[a1,"cell.type"] = "PV13a1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df["602476655","pnt"] = "LHPV9"

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV_other_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
