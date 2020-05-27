#######
# AV1 #
#######
if(!exists("process")){
   source("data-raw/hemibrain/startupHemibrain.R")
   process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("5813013207", "824380581", "698888718",
      "855384597", "855439675", "854680421", "913341672",
      "823999645", "883018168", "882987799", "1289190689", "914026662",
      "883338122", "917450071", "1068523766", "1041253084", "857455968",
      "946081491", "789588935", "820563959", "915724147", "919185724")
y = c("5813047150", "424366776", "361259770", "5813047192", "361959852",
      "424706955", "668489498")
z = "390271033"
w = c("765028935" ,"765050884")
av1 = c(x,y,z,w)

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
# table(mx$cellBodyFiber)
# my = neuprint_get_meta(y)
# table(my$cellBodyFiber)
#
# ### CBFs:
# ### AVL02^AVF1 AVL10^LLEA
# AVL02 = neuprint_read_neurons("AVL02")
# AVL02 = AVL02[names(AVL02)%in%hemibrain.lhn.bodyids]
# AVL10 = neuprint_read_neurons("AVL10")
# AVL10 = AVL10[names(AVL10)%in%hemibrain.lhn.bodyids]
# av1.hemi = c(AVL02,AVL10)
#
# ### Re-define some of these CBFs
# sd = setdiff(av1, names(av1.hemi))
# ds = setdiff(names(av1.hemi),av1)
# av1 = unique(av1, names(av1.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av1)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPl&p1_anterior"
df[x,"Hartenstein_Hemilineage"] = "BLVp2_anterior"
df[y,"ItoLee_Hemilineage"] = "VLPl&d1_lateral"
df[y,"Hartenstein_Hemilineage"] = "BLAv1_lateral"
df[z,"ItoLee_Hemilineage"] = "primary"
df[z,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### AV1 ####
############

#####
# b #
#####

b1 = "857455968" # light = c("VGlut-F-600713")
df[b1,"cell.type"] = "AV1b1"

b2 = "1068523766"
df[b2,"cell.type"] = "AV1b2"

b3 = c("698888718", "824380581") # light = c("Cha-F-000347")
df[b3,"cell.type"] = "AV1b3"

b4 = "5813013207"
df[b4,"cell.type"] = "AV1b4"

#####
# a #
#####

a1 = c("789588935", "820563959", "883338122", "915724147")
# light = c("Gad1-F-800137", "Gad1-F-600174", "Gad1-F-200387", "Cha-F-300357", "VGlut-F-000366", "L1989#3",
#         "VGlut-F-600078", "VGlut-F-500269", "L1990#2", "VGlut-F-500847", "VGlut-F-500378",
#         "Gad1-F-500105", "VGlut-F-400535","L1989#4", "VGlut-F-600516", "VGlut-F-500113","VGlut-F-500507",
#         "Cha-F-200201", "VGlut-F-500603","L1989#1","L1989#2","L1990#1","L1990#3","VGlut-F-500255",
#         "VGlut-F-600069", "JJ16", "JJ17")
df[a1,"cell.type"] = "AV1a1"

a2 = c("855384597", "917450071") # light = c("Gad1-F-600303", "Gad1-F-900205")
# e.e = c("Gad1-F-800191", "Gad1-F-700243", "Gad1-F-700100", "Cha-F-100370", "Cha-F-700271",
#         "VGlut-F-600109", "VGlut-F-500744", "VGlut-F-700284", "Gad1-F-300038", "L1990#5",
#         "VGlut-F-700009", "fru-M-100125", "fru-F-400357","L1990#4","L1990#6","L1990#7","L1990#8",
#         "VGlut-F-100009","VGlut-F-400241", "VGlut-F-600072","VGlut-F-600311","VGlut-F-600598",
#         "VGlut-F-700213", "VGlut-F-700266", "JJ15", "JJ16", "JJ22", "JJ87")
df[a2,"cell.type"] = "AV1a2"

a3 = c("854680421", "883018168", "1041253084", "855439675", "823999645", "913341672")
# light = c("Gad1-F-900217", "Gad1-F-500318", "Cha-F-300352", "5HT1A-M-800011", "fru-M-600094",
#         "Cha-F-800066", "5HT1A-F-800019", "Cha-F-200351", "VGlut-F-600081", "VGlut-F-600064",
#         "Gad1-F-600204", "VGlut-F-600739", "Cha-F-500001", "VGlut-F-600773","VGlut-F-700565",
#         "VGlut-F-900129")
df[a3,"cell.type"] = "AV1a3"

a4 = c("1289190689", "914026662", "946081491")
df[a4,"cell.type"] = "AV1a4"

a5 = "882987799"
df[a5,"cell.type"] = "AV1a5"

############
### AV1y ###
############

#####
# a #
#####

d1 = c("668489498", "5813047150")
df[d1,"cell.type"] = "AV1d1"

d2= c("5813047192", "424366776", "361259770",
     "361959852", "424706955")
df[d2,"cell.type"] = "AV1d2"

#####
# c #
#####

c1 = "919185724"
df[c1,"cell.type"] = "AV1c1"

#####
# e #
#####

e1 = "390271033"
df[e1,"cell.type"] = "AV1e1"

f1 = c("765028935", "765050884") # dead
df[f1,"cell.type"] = "AV1f1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AV1_celltyping.csv", row.names = FALSE)

# Process
if(process){
   # Update googlesheet
   write_lhns(df = df, column = c("class", "pnt", "cell.type", "connectivity.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

   # Make 2D Images
   take_pictures(df)
}
