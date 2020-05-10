#######
# PV1 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("542315097", "5812981753", "5813049105", "5813071348",
      "1006146837", "294436967",  "5813047655", "5813078065")
y = c("1163384537", "1225761499", "1904117032", "1225114259",
      "2343038967")
pv1 = c(x,y)

### Get FAFB assigned hemilineage information
x.match = unique(hemibrain_lhns[x,"FAFB.match"])
x.match = x.match[!is.na(x.match)]
x.match = read.neurons.catmaid.meta(x.match)
y.match = unique(hemibrain_lhns[y,"FAFB.match"])
y.match = y.match[!is.na(y.match)]
y.match = read.neurons.catmaid.meta(y.match)

### Meta info
mx = neuprint_get_meta(x)
my = neuprint_get_meta(y)
table(mx$cellBodyFiber)
table(my$cellBodyFiber)

### CBFs:
### PVL17^PVF2 PVL14^PLPF6 PVL02^PVF1
PVL17 = neuprint_read_neurons("PVL17")
PVL17 = PVL17[names(PVL17)%in%hemibrain.lhn.bodyids]
PVL14 = neuprint_read_neurons("PVL14")
PVL14 = PVL14[names(PVL14)%in%hemibrain.lhn.bodyids]
pv1.hemi = c(PVL17,PVL14)

### Re-define some of these CBFs
sd = setdiff(pv1, names(pv1.hemi))
ds = setdiff(names(pv1.hemi),pv1)
pv1 = unique(pv1, names(pv1.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv1)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("")
df[wrong1,"cbf.change"] = ""

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = ""
df[x,"Hartenstein_Hemilineage"] = ""
df[y,"ItoLee_Hemilineage"] = ""
df[y,"Hartenstein_Hemilineage"] = ""

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV1 ###
############

a1 = "328533761" # light = c("Cha-F-000461", "TH-F-000012", "TH-M-000030", "TH-M-000013")
df[a1,"cell.type"] = "PV1a1"

c1 = c("542315097", "5812981753")
df[c1,"cell.type"] = "PV1c1"

c2 = "5813049105"
df[c2,"cell.type"] = "PV1c2"

b1 = "5813071348"
# c.c = c("TH-F-300078", "Cha-F-600061",
#         "Gad1-F-500089", "TH-F-000011","TH-M-000071")
df[b1,"cell.type"] = "PV1b1"

ppl2 = "294436967"
# light = c("Gad1-F-500004","TH-M-200079","TH-M-300048","TH-M-000042","TH-M-200033","TH-M-200035",
#         "MB583B#1","MB583B#2","MB583B#3")
df[ppl2,"cell.type"] = "PPL2ab-PN1"

d1 = "1006146837"
df[d1,"cell.type"] = "PV1d1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV1_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
