#######
# AV6 #
#######
if(!exists("process")){
   source("data-raw/hemibrain/startupHemibrain.R")
   process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("420956527", "5813040095", "5813010494", "486116439", "573329873",
      "452677169", "546083486", "544750318", "390948259", "451995819",
      "451304268", "511262901", "793702856", "390948580", "482002701",
      "5813010591", "665747387", "451646040", "451644891", "5812980880",
      "453665759", "391609333", "422656780", "423330124", "603681826",
      "452664348", "421957711", "5813009995", "544007573", "422311625",
      "574011220", "668144344", "392640591", "579562628", "514396940",
      "5813077898", "5813129316", "297921527", "329211098", "360578457",
      "454697392", "514375643", "5813087438", "391631218", "360578625",
      "572988605", "514713432", "764408961", "5813040093",
      "483021600", "702674134", "696795331", "698180486", "572988717",
      "425803370", "516425902", "451987038", "543446584", "512416525",
      "605153844", "605801224", "672960748", "453009665")
y = "390275105"
av6 = c(x,y)

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
# ### ADL11^LBDL5 ADL07^dlLHT ADL07^dlLHT
# ADL13 = neuprint_read_neurons("ADL13")
# ADL13 = ADL13[names(ADL13)%in%hemibrain.lhn.bodyids]
# ADL16 = neuprint_read_neurons("ADL16")
# ADL16 = ADL16[names(ADL16)%in%hemibrain.lhn.bodyids]
# ADL20 = neuprint_read_neurons("ADL20")
# ADL20 = ADL20[names(ADL20)%in%hemibrain.lhn.bodyids]
# av6.hemi = c(ADL13,ADL16,ADL20)
#
# ### Re-define some of these CBFs
# sd = setdiff(av6, names(av6.hemi))
# ds = setdiff(names(av6.hemi),av6)
# av6 = unique(av6, names(av6.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av6)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "LHa1_medial"
df[x,"Hartenstein_Hemilineage"] = "BLAd1_medial"
df[y,"ItoLee_Hemilineage"] = "SLPal3_dorsal"
df[y,"Hartenstein_Hemilineage"] = "BLAd3_dorsal"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### AV6w ###
############

#####
# d #
#####

d1 = c("390275105") # light = c("Gad1-F-400144", "Cha-F-100427", "Cha-F-500310")
df[d1,"cell.type"] = "AV6d1"

############
### AV6x ###
############

#####
# a #
#####

a1 = c("574011220", "5813009995", "668144344", "392640591", "5813129316","579562628", "5813077898", "360578625", "572988605")
# light = c("Gad1-F-600143", "Gad1-F-500363", "Cha-F-800078", "L1129#2", "L1129#3",
#         "130815c1", "140514c2", "130808c2", "NP6099#5", "L1129#4", "L1117#3", "L1129#1",
#         "140328c1", "130725c4", "130807c1", "130808c1", "130813c0", "130814c1",
#         "130820c0", "130820c2","130822c0", "140402c1", "Gad1-F-200156", "L1129#5","NP6099#1",
#         "NP6099#2", "NP6099#3", "NP6099#4", "NP6099#6", "JJ43", "JJ58", "JJ81")
df[a1,"cell.type"] = "AV6a1"

a2 = c("665747387", "793702856", "544007573", "514396940", "5813010591") # light = c("Cha-F-200185","L271#1","L271#2", "JJ56", "JJ57", "JJ107", "JJ108", "JJ110", "JJ111", "JJ112")
df[a2,"cell.type"] = "AV6a2"

a3 = c("360578457", "297921527", "329211098","454697392", "421957711", "391609333", "423330124", "603681826") # light = c("Gad1-F-800082", "130819c1")
df[a3,"cell.type"] = "AV6a3"

a4 = c("453665759", "422656780", "452664348") # light = c("Cha-F-000158", "Cha-F-400151")
df[a4,"cell.type"] = "AV6a4"

a5 = c("391954490", "329581637", "360254511")
df[a5,"cell.type"] = "AV6a5"

a6 = c("422311625", "451987038") # light = c("Gad1-F-800112","L271#3", "JJ100")
df[a6,"cell.type"] = "AV6a6"

a7 = c("5812980880", "451646040", "451304268", "451995819")
df[a7,"cell.type"] = "AV6a7"

a8 = c("546083486", "482002701", "451644891") # light = c("Gad1-F-200144")
df[a8,"cell.type"] = "AV6a8"

a9 = "453009665"
df[a9,"cell.type"] = "AV6a9"

#####
# b #
#####

b1 = c("390948580", "390948259", "511262901",
      "452677169", "544750318") # light = c("fru-F-400319", "L271#4", "L1117#2","L452#4","L452#7", "JJ115")
df[b1,"cell.type"] = "AV6b1"

b2 = c("5813087438", "514713432", "514375643","764408961") # light = c("5HT1A-M-300006", "Gad1-F-600106", "Gad1-F-500140","L452#5","5HT1A-F-800008", "fru-M-800189", "L452#6", "JJ135","JJ86")
df[b2,"cell.type"] = "AV6b2"

b3 = c("486116439", "5813010494", "573329873", "420956527", "5813040095")
df[b3,"cell.type"] = "AV6b3"

b4 = "391631218"
df[b4,"cell.type"] = "AV6b4"

#####
# c #
#####

c1 = "6772893"
df[c1,"cell.type"] = "AV6c1"

#####
# f #
#####

f1 = c("698180486", "572988717", "696795331") # light = c("Gad1-F-400255","Gad1-F-800107", "JJ138", "JJ30", "JJ60", "JJ85")
df[f1,"cell.type"] = "AV6f1"

f2 = c("425803370", "516425902")
df[f2,"cell.type"] = "AV6f2"

f3 = c("702674134", "483021600", "5813040093") # light = c("JJ53", "JJ55")
df[f3,"cell.type"] = "AV6f3"

#####
# d #
#####

e1 = c("512416525", "605153844", "543446584", "605801224")
df[e1,"cell.type"] = "AV6e1"

g1 = "672960748"
df[g1,"cell.type"] = "AV6g1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/av6_celltyping.csv", row.names = FALSE)

# Process
if(process){
   # Make 2D Images
   take_pictures(df)

   # Update googlesheet
   write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}
