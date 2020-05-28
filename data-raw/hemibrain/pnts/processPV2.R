#######
# PV2 #
#######
if(!exists("process")){
   source("data-raw/hemibrain/startupHemibrain.R")
   process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

x = c("946153322", "789248033", "825032139", "856066807", "885435892",
      "913345831", "819220237", "917842566", "857806966", "828144363",
      "946485296", "763652770", "915792794", "5813013545", "764001607",
      "792338630", "823374529", "823705448", "1039906056", "853386077",
      "974788612", "885776346", "886124924",  "823400451", "889194717",
      "1007882308", "854776068")
y = c("729535036", "791946438", "821946760", "698194389", "793992755",
      "791946302", "761252954", "761593520", "604735824", "605391864",
      "700567946", "946814479", "761247578", "821987663", "883358778",
      "731922839", "944371051", "763731153", "822687493", "573350770",
      "852293337", "605754137", "759586495", "5813090530", "698513115",
      "790948245", "5813021291", "5813075020", "886130319", "789934899",
      "5813041244", "853717974", "758903321", "822005494", "5813014218",
      "791311618", "764409134", "791303168", "759582415", "912045178",
      "729527582",  "822009511", "724820565", "822684007",
      "912045124", "882383361", "881342447", "5813016163")
z = c("543766436", "725860918", "794752471", "943416162", "913754682")
w = c("882995659", "914027038")
pv2 = c(x,y,z,w)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)
# z.match = unique(hemibrain_lhns[z,"FAFB.match"])
# z.match = z.match[!is.na(z.match)]
# z.match = read.neurons.catmaid.meta(z.match)
#
# ### Meta info
# mx = neuprint_get_meta(x)
# my = neuprint_get_meta(y)
# mz = neuprint_get_meta(z)
# table(mx$cellBodyFiber)
# table(my$cellBodyFiber)
# table(mz$cellBodyFiber)
#
# ### CBFs:
# ### ADL19^lgL
# PDL09 = neuprint_read_neurons("PDL09")
# PDL09 = PDL09[names(PDL09)%in%hemibrain.lhn.bodyids]
# PVL01 = neuprint_read_neurons("PVL01")
# PVL01 = PVL01[names(PVL01)%in%hemibrain.lhn.bodyids]
# PVL03 = neuprint_read_neurons("PVL03")
# PVL03 = PVL03[names(PVL03)%in%hemibrain.lhn.bodyids]
# PDL12 = neuprint_read_neurons("PDL12")
# PDL12 = PDL12[names(PDL12)%in%hemibrain.lhn.bodyids]
# pv2.hemi = union(PDL12,PVL03,PVL01,PDL09)
#
# ### Re-define some of these CBFs
# sd = setdiff(pv2, names(pv2.hemi))
# ds = setdiff(names(pv2.hemi),pv2)
# pv2 = unique(pv2, names(pv2.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv2)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "VLPp&l1_dorsal"
df[x,"Hartenstein_Hemilineage"] = "DPLpv_dorsal"
df[z,"ItoLee_Hemilineage"] = "LHl4_posterior"
df[z,"Hartenstein_Hemilineage"] = "BLD1_posterior"
df[y,"ItoLee_Hemilineage"] = "VPNp&v1_posterior"
df[y,"Hartenstein_Hemilineage"] = "BLP1_posterior"
df[w,"ItoLee_Hemilineage"] = "VPNp&v1_posterior"
df[w,"Hartenstein_Hemilineage"] = "BLP1_posterior"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV2x ###
############

#####
# c #
#####

c1 = c("819220237", "917842566", "825032139", "856066807")
# light = c("Gad1-F-400232", "L1385#18", "L1328#6",
#         "Cha-F-000242", "L1328#2","L1328#5","L568#2")
df[c1,"cell.type"] = "PV2c1"

c2 = c("854776068", "1007882308", "889194717") # light = c("Gad1-F-100074", "L1328#4", "L1328#3", "L1328#1")
df[c2,"cell.type"] = "PV2c2"

c3 = c("789248033", "946153322")
df[c3,"cell.type"] = "PV2c3"

c4 = c("885435892", "913345831") # light = c("Gad1-F-600088", "L568#6")
df[c4,"cell.type"] = "PV2c4"

c5 = c("828144363", "946485296")
df[c5,"cell.type"] = "PV2c5"

c6 = c("5813013545", "857806966", "764001607", "763652770", "915792794") # light = "Gad1-F-500328"
df[c6,"cell.type"] = "PV2c6"

c7 = "823400451"
df[c7,"cell.type"] = "PV2c7"

#####
# e #
#####

e1 = c("885776346", "1039906056", "853386077", "974788612","823705448")
df[e1,"cell.type"] = "PV2e1"

e2 = c("886124924", "823374529", "792338630")
df[e2,"cell.type"] = "PV2e2"

############
### PV2y ###
############

# j1 = "1222769755"
# df[j1,"cell.type"] = "PV2b1"

#####
# b #
#####

b1 = c("883358778", "761247578", "852293337")
df[b1,"cell.type"] = "PV2b1"

b2 = c("791946438", "821946760","729527582", "793992755", "729535036", "791946302")
df[b2,"cell.type"] = "PV2b2"

b3 = c("821987663", "700567946", "761252954", "761593520", "731922839","944371051")
df[b3,"cell.type"] = "PV2b3"

b4 = c("604735824", "605391864")
df[b4,"cell.type"] = "PV2b4"

b5 = c("573350770", "698194389", "946814479") # light = c("131030c0")
df[b5,"cell.type"] = "PV2b5"

#####
# d #
#####

d1 = c("763731153", "764409134") # light = c("Gad1-F-800092")
df[d1,"cell.type"] = "PV2d1"

#########
# wedpn #
#########

# wp6 = c("1131310385", "1005490210", "856131667") # light = c("Cha-F-000086","L85#1","L85#2","L85#4","L85#5")
# df[wp6,"cell.type"] = "WEDPN6"

#####
# d #
#####

f1 = c("5813016163", "881342447", "882383361", "912045124")
df[f1,"cell.type"] = "PV2f1"

#####
# a #
#####

a5 = c("605754137", "759586495")
df[a5,"cell.type"] = "PV2a5"

a4 = c("791303168", "698513115", "790948245")
df[a4,"cell.type"] = "PV2a4"

a2 = c("791311618", "912045178") #light = c("5HT1A-M-100027")
df[a2,"cell.type"] = "PV2a2"

a3 = c("789934899", "759582415", "822687493") # light = c("L2013#2", "131028c0", "Cha-F-300168")
df[a3,"cell.type"] = "PV2a3"

a1 = c("758903321", "822005494", "5813090530", "853717974", "822684007",
       "886130319", "5813014218", "5813041244","724820565", "822009511")
# light = c("5HT1A-F-100028","L258#6", "L258#2", "5HT1A-M-200001",
#         "L258#3", "L258#10", "L258#4", "L258#15", "L258#1", "L259#2", "L259#5",
#         "L258#9", "L259#3","L258#18", "L258#17", "131031c1", "5HT1A-M-100027",
#         "Cha-F-000110", "Cha-F-400222","L1847#1","L1955#1","L258#11","L258#12",
#         "L258#13","L258#14","L258#16","L258#5","L258#7","L258#8","L259#1","L259#4")
df[a1,"cell.type"] = "PV2a1"

########
# mbc1 #
########

mbc1 = c("5813021291", "5813075020") # light = c("L1900#2", "L1900#1") # MBC1
df[mbc1,"cell.type"] = "MB-C1"

############
### PV2w ###
############

#####
# g #
#####

g1 = c("882995659", "914027038")
df[g1,"cell.type"] = "PV2g1"

############
### PV2z ###
############

#####
# d #
#####

h1 = "543766436"
df[h1,"cell.type"] = "PV2h1"

#####
# d #
#####

i1 = c("794752471", "943416162") # WEDPN?
df[i1,"cell.type"] = "PV2i1"

i2 = c("725860918", "913754682") # WEDPN?
df[i2,"cell.type"] = "PV2i2"

# k1 = c("729957687", "667538952")
# df[k1,"cell.type"] = "PV2k1"
#
# l1 = "1005149651" # dead
# df[l1,"cell.type"] = "PV2l1"
#
# m1 = c("702985703", "607787538", "607799924") # dead
# df[m1,"cell.type"] = "PV2m1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)
df$pnt = names(sort(table(df$pnt),decreasing = TRUE)[1])

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV2_celltyping.csv", row.names = FALSE)

# Process
if(process){
   # Update googlesheet
   write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

   # Make 2D Images
   take_pictures(df)
}
