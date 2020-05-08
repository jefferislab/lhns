#######
# PV5 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
# WEDT lineage, near AMMC
x = c("1573741727", "5813015982", "2214846055", "1069223047", "1440645010",
         "2030342003", "2214504597", "1437618127", "5813021911", "5813013913",
         "1006854683", "5813020138", "916828438", "853726809", "915451074",
         "579912201", "973765182", "5813032740", "885788485")
y = c("1193378968", "1040609241", "857793013", "1573741727", "5813056323")
z = c("1131310385", "1005490210", "856131667","912390224")
w = c("1539309050", "2061028219", "5813055629", "1565802648", "2096914287", "1040609541","947858407", "2096909904")
wedpns = c(x,y,z)

### Get FAFB assigned hemilineage information
x.match = unique(hemibrain_lhns[x,"FAFB.match"])
x.match = x.match[!is.na(x.match)]
x.match = read.neurons.catmaid.meta(x.match)
y.match = unique(hemibrain_lhns[y,"FAFB.match"])
y.match = y.match[!is.na(y.match)]
y.match = read.neurons.catmaid.meta(y.match)
z.match = unique(hemibrain_lhns[z,"FAFB.match"])
z.match = z.match[!is.na(z.match)]
z.match = read.neurons.catmaid.meta(z.match)
w.match = unique(hemibrain_lhns[w,"FAFB.match"])
w.match = w.match[!is.na(w.match)]
w.match = read.neurons.catmaid.meta(w.match)

### Meta info
mx = neuprint_get_meta(x)
my = neuprint_get_meta(y)
mz = neuprint_get_meta(z)
mw = neuprint_get_meta(w)
table(mx$cellBodyFiber)
table(my$cellBodyFiber)
table(mz$cellBodyFiber)
table(mw$cellBodyFiber)

### CBFs:
### AVL01^aVLPT3 AVL09^aVLPT1
AVL01 = neuprint_read_neurons("AVL01")
AVL01 = AVL01[names(AVL01)%in%lhn.ids]
AVL09 = neuprint_read_neurons("AVL09")
AVL09 = AVL09[names(AVL09)%in%lhn.ids]
wedpns.hemi = c(AVL01,AVL09)

### Re-define some of these CBFs
sd = setdiff(wedpns, names(wedpns.hemi))
ds = setdiff(names(wedpns.hemi),wedpns)
wedpns = unique(wedpns, names(wedpns.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% wedpns)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("")
df[wrong1,"cbf.change"] = "ADL15"

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "WEDa2"
df[x,"Hartenstein_Hemilineage"] = "BAlp3"
df[y,"ItoLee_Hemilineage"] = "primary"
df[y,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhins.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

#############
### WEDPN ###
#############

#####
# x #
#####

wp1 = c("1440645010", "2214846055", "2214504597", "1069223047", "2030342003") # light = c("Gad1-F-100133", "VGlut-F-500810", "VGlut-F-100375", "VGlut-F-600117","L112#1","L112#2","L112#3","L112#4","L770#1","L770#2","L772#1","L772#2","L984#1","L984#2","L984#3","L984#4","L984#5","L984#6","L984#7","L984#8","L984#9")
df[wp1,"cell.type"] = "WED-PN1"

wp5 = "5813015982" # light= c("L1337#1","L1337#2","L1337#4","L1337#7","L1337#8")
df[wp5,"cell.type"] = "WEDPN5"

wp2 = c("973765182", "885788485", "915451074") # light = c("Cha-F-000514","L1524#3","L1524#4","L452#1")
df[wp2,"cell.type"] = "WEDPN2"

wp4 = "5813032740"
df[wp4,"cell.type"] = "WEDPN4"

wp3 = c("853726809", "5813013913", "5813020138", "1006854683", "916828438") # light = c("Cha-F-600036","fru-M-300059","L1524#1","L1524#2","L1518#1","L1518#2","L1518#3","L1518#4","L1518#5", "L1949#3","L1668#1", "L1668#2", "L1668#3", "L1668#4","L1949#1", "L1949#2","L452#2")
df[wp3,"cell.type"] = "WEDPN3"

#####
# y #
#####

wp7 = c("1040609241", "1193378968", "1573741727", "5813056323") #light = c("L1337#3","L1337#5","L1337#6")
df[wp7,"cell.type"] = "WEDPN7"

#####
# z #
#####

wp6 = c("1131310385", "1005490210", "856131667")
df[wp6,"cell.type"] = "WEDPN6"

wp10 = "912390224"
df[wp10,"cell.type"] = "WEDPN10"

#####
# w #
#####

wp8 = c("1539309050", "2061028219", "5813055629", "1565802648", "2096914287", "1040609541","947858407", "2096909904")
df[wp8,"cell.type"] = "WEDPN8"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/WEDPN_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="WEDPN")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

