#######
# AV7 #
#######
if(!exists("process")){
   source("data-raw/hemibrain/startupHemibrain.R")
   process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
av7 = x = c("609233083", "453031248", "515096130", "452673242", "541970375",
      "5813010471", "5813079244", "542652400", "608188506", "608534083",
      "791307174", "732686529", "853376855", "761636549", "456432557",
      "821625208", "580231908", "604722017", "329216050", "602990602",
      "5813049045", "5813071354", "361614914", "451982195", "760993807",
      "516055524", "889497360", "858803404","577464071", "423351806",
      "513741732", "517479202", "576161592"
)
av8 = y = "636789034"
av9 = z = c("794406234", "953755666", "793728667", "642660081", "671307834",
        "579235017", "607195856")
av7_av8_av9 = c(av7,av7,av8,av9)

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
# ### ADL19^lgL
# ADL19 = neuprint_read_neurons("ADL19")
# ADL19 = ADL19[names(ADL19)%in%hemibrain.lhn.bodyids]
# av7.hemi = c(ADL19)
#
# ### Re-define some of these CBFs
# sd = setdiff(av7, names(av7.hemi))
# ds = setdiff(names(av7.hemi),av7)
# av7 = unique(av7, names(av7.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av7_av8_av9)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "AOTUv2"
df[x,"Hartenstein_Hemilineage"] = "DALl1"
df[x,"ItoLee_Hemilineage"] = "primary"
df[x,"Hartenstein_Hemilineage"] = "primary"
df[z,"ItoLee_Hemilineage"] = "unknown"
df[z,"Hartenstein_Hemilineage"] = "unknown"

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

b1 = c("889497360", "858803404")
df[b1,"cell.type"] = "AV7b1"

c1 = "516055524" # dead
df[c1,"cell.type"] = "AV7c1"

############
### AV7z ###
############

#####
# c #
#####

c1 = c("5813071354","361614914", "451982195") # light = c("fru-M-200393") # dead
df[c1,"cell.type"] = "AV7c1"

c2 = c("760993807") # dead
df[c2,"cell.type"] = "AV7c2"


#######
# AV8 #
#######

a1 = "636789034"
df[a1,"cell.type"] = "AV8a1"


############
### AV9 ###
############

a1 = c("794406234", "953755666", "793728667")
df[a1,"cell.type"] = "AV9a1"

a2 = c("642660081", "671307834")
df[a2,"cell.type"] = "AV9a1"

a3 = c("579235017", "607195856")
df[a3,"cell.type"] = "AV9a1"


#####
# a #
#####

a1

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AV_other_celltyping.csv", row.names = FALSE)

# Process
if(process){
   # Make 2D Images
   take_pictures(df)

   # Update googlesheet
   write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}
