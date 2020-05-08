#######
# AV7 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("609233083", "453031248", "515096130", "452673242", "541970375",
      "5813010471", "5813079244", "542652400", "608188506", "608534083",
      "791307174", "732686529", "853376855", "761636549", "456432557",
      "821625208", "580231908", "604722017", "329216050", "602990602"
)
y = c("609233083", "453031248", "515096130", "452673242", "541970375",
      "5813010471", "5813079244", "542652400", "608188506", "608534083",
      "791307174", "732686529", "853376855", "761636549", "456432557",
      "821625208", "580231908", "604722017", "329216050", "602990602"
)
z = c("609233083", "453031248", "515096130", "452673242", "541970375",
      "5813010471", "5813079244", "542652400", "608188506", "608534083",
      "791307174", "732686529", "853376855", "761636549", "456432557",
      "821625208", "580231908", "604722017", "329216050", "602990602"
)
av7 = c(x,y,z)

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
mz = neuprint_get_meta(z)
table(mx$cellBodyFiber)
table(my$cellBodyFiber)
table(mz$cellBodyFiber)

### CBFs:
### ADL19^lgL
ADL19 = neuprint_read_neurons("ADL19")
ADL19 = ADL19[names(ADL19)%in%lhn.ids]
av7.hemi = c(ADL19)

### Re-define some of these CBFs
sd = setdiff(av7, names(av7.hemi))
ds = setdiff(names(av7.hemi),av7)
av7 = unique(av7, names(av7.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av7)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("")
df[wrong1,"cbf.change"] = ""

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VPNl&d1_dorsal"
df[x,"Hartenstein_Hemilineage"] = "BLAvm2_dorsal"
df[z,"ItoLee_Hemilineage"] = "SLPa&l1_anterior"
df[z,"Hartenstein_Hemilineage"] = "BLAvm1_anterior"
df[y,"ItoLee_Hemilineage"] = "AOTUv2"
df[y,"Hartenstein_Hemilineage"] = "DALl1"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### AV7x ###
############

#####
# b #
#####

b1 = c("577464071", "423351806", "513741732", "517479202", "576161592") # light = c("Cha-F-500243")
df[b1,"cell.type"] = "AV7b1"

b2 = c("5813049045") # light = c("fru-F-300158")
df[b2,"cell.type"] = "AV7b2"

############
### AV7y ###
############

#####
# a #
#####

a1 = c("580231908", "821625208", "456432557","602990602", "604722017")
# d.d = c("Gad1-F-200237","L2001#9", "L2001#5",
#         "L2001#4", "Gad1-F-100225", "L2001#1", "L2001#2", "L2001#7"
#         "Cha-F-700110","L2001#10","L2001#3","L2001#6","L2001#8","L2002#1",
#         "L2002#2")
df[a1,"cell.type"] = "AV7a1"

a2 = "761636549"
df[a2,"cell.type"] = "AV7a2"

a3 = c("541970375", "452673242", "5813079244","329216050")
df[a3,"cell.type"] = "AV7a3"

a4 = c("542652400", "608534083", "5813010471", "608188506")
df[a4,"cell.type"] = "AV7a4"

a5 = c("853376855", "732686529", "791307174")
df[a5,"cell.type"] = "AV7a5"

a6 = "609233083"
df[a6,"cell.type"] = "AV7a6"

a7 = c("453031248", "515096130")
df[a7,"cell.type"] = "AV7a7"

############
### AV7z ###
############

#####
# c #
#####

c1 = c("5813071354","361614914", "451982195") # light = c("fru-M-200393")
df[c1,"cell.type"] = "AV7c1"

c2 = c("760993807")
df[c2,"cell.type"] = "AV7c2"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AV7_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="AV7")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
