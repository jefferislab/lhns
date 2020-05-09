#######
# pv7/8 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
pv7 = x = "480258208"
pv8 = y = c("604709727", "387952104", "451049385")

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
### PDM08^pSM1 PDM15^pSM4 PDM09^iPB2 PDM22^iPB7
PDL10 = neuprint_read_neurons("PDL10")
PDL10 = PDL10[names(PDL10)%in%hemibrain.lhn.bodyids]
PDL14 = neuprint_read_neurons("PDL14")
PDL14 = PDL14[names(PDL14)%in%hemibrain.lhn.bodyids]
PDL20 = neuprint_read_neurons("PDL20")
PDL20 = PDL20[names(PDL20)%in%hemibrain.lhn.bodyids]
pv7_8.hemi = union(PDL10,PDL20,PDL20)

### Re-define some of these CBFs
sd = setdiff(pv7_8, names(pv7_8.hemi))
ds = setdiff(names(pv7_8.hemi),pv7_8)
pv7_8 = unique(pv7_8, names(pv7_8.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv7_8)
df$cbf.change = FALSE
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
### PV7 ####
############

a1 = "392645639"
df[a1,"cell.type"] = "PV7a1"

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

# Make 2D Images
take_pictures(df, pnt="PV7_PV8")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
