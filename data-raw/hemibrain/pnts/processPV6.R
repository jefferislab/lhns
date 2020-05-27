#######
# PV6 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("5813010495", "356818664", "449564352", "511626286", "480590606",
      "5813011299", "573009633", "5813134617", "449901277", "449910481",
      "325797488", "449568880", "5813009800", "480595244", "511626068",
      "294774719", "418552044", "418224293", "327506825", "5813010948",
      "326812225", "449910491", "326817565", "387180498", "5813010690",
      "449910741", "449568848", "327851331", "330246657", "387870860",
      "480923210", "294445931", "449564064", "449555633", "604039904",
      "325802256", "574468840", "392308518", "357160116", "295111672",
      "5813009280", "325472654", "359279388", "603095061", "449910907",
      "696830498", "511966731", "543684107", "480945354", "481627444",
      "5813012322", "5813055734", "360596183", "5813087551", "295779879",
      "294756576", "574372960", "449555517", "636102761", "480599437",
      "419557747", "480594756", "480590337", "511625768", "5813039907",
      "758154573", "513317334", "5813010385", "388863775", "325455473",
      "325797575", "325787243", "294760680", "327865394", "5813061371",
      "5813049920", "696829800", "294782488", "418875451", "727527845",
      "5813056278")
y = c("787227302", "725498630", "694471913", "695167675", "695508439",
      "294760837", "5813010541", "356499529", "326164634", "881696475",
      "635424442", "5813011395", "386838513", "5813022453", "481946285",
      "541007502", "540662210", "418205694", "5812979935", "356503889", "540657374",
      "541373868", "664824047", "387215056", "417869138", "5813067776", "5813021912",
      "5813047683","881696475", "666916874", "849275471",
      "296846768", "696489026", "727182822", "541681271", "509968249", "571346887")
z = c("5813064406", "5813016450", "758239379", "5813012048", "634090169",
      "604070461", "695798021","388881226")
w = c("515385637","392636270")
pv6 = c(x,y,z,w)

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
# ### PDL07^dLH PDL10^pLH3 PDL14^pLH6 PDL20^pLH7
# PDL10 = neuprint_read_neurons("PDL10")
# PDL10 = PDL10[names(PDL10)%in%hemibrain.lhn.bodyids]
# PDL14 = neuprint_read_neurons("PDL14")
# PDL14 = PDL14[names(PDL14)%in%hemibrain.lhn.bodyids]
# PDL20 = neuprint_read_neurons("PDL20")
# PDL20 = PDL20[names(PDL20)%in%hemibrain.lhn.bodyids]
# pv6.hemi = union(PDL10,PDL20,PDL20)
#
# ### Re-define some of these CBFs
# sd = setdiff(pv6, names(pv6.hemi))
# ds = setdiff(names(pv6.hemi),pv6)
# pv6 = unique(pv6, names(pv6.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% pv6)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "LHp2_lateral"
df[x,"Hartenstein_Hemilineage"] = "DPLp1_lateral"
df[z,"ItoLee_Hemilineage"] = "unknown"
df[z,"Hartenstein_Hemilineage"] = "BLP3_ventral"
df[y,"ItoLee_Hemilineage"] = "LHp2_medial"
df[y,"Hartenstein_Hemilineage"] = "DPLp1_medial"
df[w,"ItoLee_Hemilineage"] = "primary"
df[w,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### PV6x ###
############

o1 = "727527845"
df[o1,"cell.type"] = "PV6o1"

p1 = "392636270" # maybe
df[p1,"cell.type"] = "PV6p1"

#####
# i #
#####

i1 = c("327851331", "327865394") # dead
df[i1,"cell.type"] = "PV6i1"

#####
# g #
#####

g1 = c("5813049920") # light = c("Gad1-F-500258","VGlut-F-200258")
df[g1,"cell.type"] = "PV6g1"

#####
# f #
#####

j1 = c("636102761")
df[j1,"cell.type"] = "PV6j1"

#####
# h #
#####

h1= c("418224293", "696829800", "696830498", "449910481", "387180498","5813010690")
df[h1,"cell.type"] = "PV6h1"

h2 = c("449568848", "418552044", "5813010948")
df[h2,"cell.type"] = "PV6h2"

h3 = c("449901277", "449910741", "449910907")
df[h3,"cell.type"] = "PV6h3"

#####
# a #
#####

a1 =c("5813012322", "480945354", "481627444", "480590337", "511966731",
     "5813039907", "480594756", "511625768", "758154573", "574468840",
     "511626286", "511626068", "543684107", "480599437")
# light = c("L62#1","VGlut-F-400394")
df[a1,"cell.type"] = "PV6a1"

a2 = c("295779879", "294445931", "604039904", "449555633", "449564064") # light = c("Cha-F-200186")
df[a2,"cell.type"] = "PV6a2"

a3 = c("574372960", "419557747", "325455473", "388863775", "5813010385")# light = c("L2193#4", "L2185#1", "L2185#2","L2193#1", "L2193#5")
df[a3,"cell.type"] = "PV6a3"

a4 = c("5813055734", "5813087551", "294760680", "325797575", "294756576", "325787243")
df[a4,"cell.type"] = "PV6a4"

a5 = c("360596183", "449555517")
df[a5,"cell.type"] = "PV6a5"

a6 = c("5813061371", "449564352", "294774719", "325802256")
df[a6,"cell.type"] = "PV6a6"

a7 = c("5813010495", "480590606", "5813011299")
df[a7,"cell.type"] = "PV6a7"

a8 = c("326817565", "325797488", "449568880")
df[a8,"cell.type"] = "PV6a8"

a9 = c("5813009800", "294782488", "418875451", "356818664", "480595244")
df[a9,"cell.type"] = "PV6a9"

a10 = c("480923210") #light = c("L2193#3","L2193#2")
df[a10,"cell.type"] = "PV6a10"

a11 = c("327506825", "326812225", "449910491")
df[a11,"cell.type"] = "PV6a11"

#####
# b #
#####

b1 = c("603095061", "5813134617", "359279388", "573009633", "325472654",
       "295111672", "5813009280")
df[b1,"cell.type"] = "PV6b1"

b2 = c("481946285", "5813011395", "356499529", "386838513", "635424442") # light = c("Cha-F-100398")
df[b2,"cell.type"] = "PV6b2"

b3 = c("5813056278", "5813010541", "294760837", "326164634")
df[b3,"cell.type"] = "PV6b3"

#####
# d #
#####

d1 = c("357160116", "392308518")
df[d1,"cell.type"] = "PV6d1"

#####
# e #
#####

e1 = "513317334"
df[e1,"cell.type"] = "PV6e1"

#####
# c #
#####

c1 = c("387870860") # light = c("L2220#1", "2220#3", "L2220#2", "L2220#3", "L2220#4")
df[c1,"cell.type"] = "PV6c1"

c2 = c("330246657")
df[c2,"cell.type"] = "PV6c2"


############
### PV6y ###
############

#####
# f #
#####

f1 = c("695167675", "787227302", "695508439", "5813022453", "694471913",  "725498630")
df[f1,"cell.type"] = "PV6f1"

f2 = c("881696475", "666916874", "849275471") # maybe
df[f2,"cell.type"] = "PV6f2"

f3 = c("296846768", "696489026", "727182822", "541681271", "509968249", "571346887")
df[f3,"cell.type"] = "PV6f3"

f4 = c("541007502", "540662210", "418205694", "5812979935", "356503889")
df[f4,"cell.type"] = "PV6f4"

f5 = c("540657374", "541373868")
df[f5,"cell.type"] = "PV6f5"

f6 = c("387215056", "417869138")
df[f6,"cell.type"] = "PV6f6"

f7 = c("5813067776", "5813021912")
df[f7,"cell.type"] = "PV6f7"

n1 = "664824047"
df[n1,"cell.type"] = "PV6fn1"


############
### PV6z ###
############

#####
# k #
#####

k1 = c("5813016450", "5813064406", "758239379")
# light = c("Gad1-F-400027", "L2392#5", "VGlut-F-600030","VGlut-F-700280","VGlut-F-700342",
#         "VGlut-F-700503","VGlut-F-800064")
df[k1,"cell.type"] = "PV6k1"

k2 = c("604070461", "695798021") # light = c("VGlut-F-400240","VGlut-F-400240","VGlut-F-600311")
df[k2,"cell.type"] = "PV6k2"

#####
# l #
#####

l1 = "5813012048" #light = c("L509#1","L509#2")
df[l1,"cell.type"] = "PV6l1"

l2 = "634090169"
df[l2,"cell.type"] = "PV6l2"

#####
# m #
#####

m1 = "515385637" # dead
df[m1,"cell.type"] = "PV6m1"

q1 = "388881226"
df[q1,"cell.type"] = "PV6q1"

r1 = "5813047683"
df[r1,"cell.type"] = "PV6r1"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/PV6_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))

  # Make 2D Images
  take_pictures(df)
}
