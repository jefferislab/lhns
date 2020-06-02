#######
# AV3 #
#######
if(!exists("process")){
  source("data-raw/hemibrain/startupHemibrain.R")
  process = TRUE
}
# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
#LHAV3
x = c("575389396", "390603428", "607441336", "822004733", "5813011773",
      "790288721", "574041014", "390560212", "822692353", "5813078194",
      "666122442", "5813009781", "605058898","360259229", "667832004")
y = c("326154371", "480257882", "325814669", "480257743", "480257914",
      "419929377", "295798962", "5813035078", "295461871", "480257896",
      "480258191", "480599285", "450609707", "295807429", "421292214",
      "541961677", "449223347", "510943286", "390935343", "450267976",
      "419234116", "541961750", "5813057662", "359555628", "480257919",
      "390254536", "5813057660", "542643555", "329566467", "419578845",
      "449577409", "451296290", "480262368", "360928792", "480262270",
      "449223379", "605090489", "5813010546", "391604407", "449227486",
      "541624179", "390931864", "5813098306", "5813097073", "5813068507",
      "359555689", "5813047178", "5901196932", "328543014", "665454282",
      "696143413", "544699051", "574377845", "5813009276", "357855613",
      "388898076", "424716408", "5813010511", "698180927", "359581549",
      "698185483", "482680447", "296120593",
      "541624179","480253500", "479917126", "511271379",
      "480586157", "511621576", "511262952", "356832508", "325834652", "418861761",
      "448899493", "449223263", "5813047004", "295780154", "295461707", "357496172",
      "295785459","633793553",  "360255138",
      "390586752", "327220514", "328519904", "359210479", "390919685"
)
w = c("358538040", "5813109792", "510956058", "358541542", "510956443",
      "388898076", "358538491", "387538632","541965840", "5901194027",
      "513029260", "297851977","5901219179")
z = "633097828"
av3 = c(x,y,w)

### Get FAFB assigned hemilineage information
# x.match = unique(hemibrain_lhns[x,"FAFB.match"])
# x.match = x.match[!is.na(x.match)]
# x.match = read.neurons.catmaid.meta(x.match)
# y.match = unique(hemibrain_lhns[y,"FAFB.match"])
# y.match = y.match[!is.na(y.match)]
# y.match = read.neurons.catmaid.meta(y.match)
#
# ### Meta info
mx = neuprint_get_meta(x)
my = neuprint_get_meta(y)
mw = neuprint_get_meta(w)
table(mx$cellBodyFiber)
table(my$cellBodyFiber)
table(mw$cellBodyFiber)

# ### CBFs:
# ### AVL18^LEA2 AVL12^LEA5 ADL04^LBDL7 ADL10^LBDL6
# AVL18 = neuprint_read_neurons("AVL18")
# AVL18 = AVL18[names(AVL18)%in%hemibrain.lhn.bodyids]
# AVL12 = neuprint_read_neurons("AVL12")
# AVL12 = AVL12[names(AVL12)%in%hemibrain.lhn.bodyids]
# ADL24 = neuprint_read_neurons("ADL24")
# ADL24 = ADL24[names(ADL24)%in%hemibrain.lhn.bodyids]
# PDL17 = neuprint_read_neurons("PDL17")
# PDL17 = PDL17[names(PDL17)%in%hemibrain.lhn.bodyids]
# av3.hemi = c(AVL18,AVL12,ADL24,PDL17)
#
# ### Re-define some of these CBFs
# sd = setdiff(av3, names(av3.hemi))
# ds = setdiff(names(av3.hemi),av3)
# av3 = unique(av3, names(av3.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av3)
df$cbf.change = FALSE
df$class = "LHN"
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("389205204")
df[wrong1,"cbf.change"] = "AVL18^LEA2"
wrong2 = c("358874595", "327857238", "356832459", "295470623", "327152465",
           "420235167", "294437328", "390254536", "5813057660", "451296290",
           "390931864", "5901196932", "295456869", "453018720")
df[wrong2,"cbf.change"] = "ADL10^LBDL6"
df = subset(df, !is.na(class))

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "SLPav1_lateral"
df[x,"Hartenstein_Hemilineage"] = "BLAl_lateral"
df[y,"ItoLee_Hemilineage"] = "LHa3"
df[y,"Hartenstein_Hemilineage"] = "BLVa2"
df[w,"ItoLee_Hemilineage"] = "LHa3"
df[w,"Hartenstein_Hemilineage"] = "BLVa2"
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
### AV3x ###
############

#####
# e #
#####

e1 = c("5813078194", "822692353")
df[e1,"cell.type"] = "AV3e1"

e2 = c("790288721", "822004733")
df[e2,"cell.type"] = "AV3e2"

e3 = c("390560212", "5813009781")
df[e3,"cell.type"] = "AV3e3"

e4 = c("5813011773", "607441336", "666122442")
df[e4,"cell.type"] = "AV3e4"

e5 = c("574041014", "605058898")
df[e5,"cell.type"] = "AV3e5"

e6 = "667832004"
df[e6,"cell.type"] = "AV3e6"

e7 = "390603428"
df[e7,"cell.type"] = "AV3e7"

e8 = "575389396"
df[e8,"cell.type"] = "AV3e8"

#####
# f #
#####

# f1 = c("329225149", "329897255") # light = c("Gad1-F-500030") # AV6?
# df[f1,"cell.type"] = "AV3f1"

# f1 = "5813021535" # dead
# df[f1,"cell.type"] = "AV3f1"
#
# f2 = c("454386099") # light = "Gad1-F-900160" # dead
# df[f2,"cell.type"] = "AV3f2"

#####
# p #
#####

h1 = "360259229"
df[h1,"cell.type"] = "AV3h1"

############
### AV3y ###
############

############
### AV3z ###
############

#####
# d #
#####

d1 = "665454282"
df[d1,"cell.type"] = "AV3d1"

#####
# a #
#####

a1 = c("5813035078", "480257896", "295798962", "419929377", "480258191", "295461871", "480599285", "296120593")
df[a1,"cell.type"] = "AV3a1"

a2 = c("480257882", "480257914", "480257743", "326154371", "325814669","295807429") # light  = c("Cha-F-200357")
df[a2,"cell.type"] = "AV3a2"

a3 = c("357855613", "388898076")
df[a3,"cell.type"] = "AV3a3"

a5 = c("295780154", "295461707", "357496172", "295785459")
df[a5,"cell.type"] = "AV3a5"

a4 = "696143413"
df[a4,"cell.type"] = "AV3a4"

a6 = c("327220514", "328519904", "359210479", "390919685")
df[a6,"cell.type"] = "AV3a6"

#####
# e #
#####

f1 = "574377845"
df[f1,"cell.type"] = "AV3f1"

q1 = c("633097828")
df[q1,"cell.type"] = "AV3q1"

#####
# g #
#####

g1 = c("544699051", "5813009276")
df[g1,"cell.type"] = "AV3g1"

g2 = c("698180927", "698185483")
df[g2,"cell.type"] = "AV3g2"

#####
# k #
#####

i1 = "5901196932"
df[i1,"cell.type"] = "AV3i1"

#####
# b #
#####

b1 = c("391604407", "390931864", "5813098306") # light = "Cha-F-200387"
df[b1,"cell.type"] = "AV3b1"

b2 = c("449227486", "541624179","480253500", "479917126", "511271379", "390586752")
df[b2,"cell.type"] = "AV3b2"

b3 = c("542643555", "5813010546", "359555628")
df[b3,"cell.type"] = "AV3b3"

b4 = c("510943286")
df[b4,"cell.type"] = "AV3b4"

b5 = c("421292214", "449223347", "541961677") #light = "Gad1-F-000132"
df[b5,"cell.type"] = "AV3b5"

b6 = c("419234116", "541961750", "390935343", "450267976", "5813057662")
df[b6,"cell.type"] = "AV3b6"

b7 = c("329566467", "449577409")
df[b7,"cell.type"] = "AV3b7"

b8= c("5813057660", "419578845", "390254536", "480257919")
df[b8,"cell.type"] = "AV3b8"

b9 = c("449577409", "451296290")
df[b9,"cell.type"] = "AV3b9"

b10 = c("360928792", "480262270")
df[b10,"cell.type"] = "AV3b10"

b11 = c("605090489", "449223379", "450609707", "480262368")
df[b11,"cell.type"] = "AV3b11"

b12 = "359555689"
df[b12,"cell.type"] = "AV3b12"

b13 = c("5813047178", "5813068507")
df[b13,"cell.type"] = "AV3b13"

#####
# l #
#####

j1 = "297851977"
df[j1,"cell.type"] = "AV3j1"

#####
# m #
#####

k1 = "424716408"
df[k1,"cell.type"] = "AV3k1"

k2 = "5813010511"
df[k2,"cell.type"] = "AV3k2"

k3 = "482680447"
df[k3,"cell.type"] = "AV3k3"

k4 = "5813097073"
df[k4,"cell.type"] = "AV3k4"

k5 = "328543014"
df[k5,"cell.type"] = "AV3k5"

k6 = "359581549"
df[k6,"cell.type"] = "AV3k6"

l1 = "513029260"
df[l1,"cell.type"] = "AV3l1"

n1 = c("356832508", "325834652", "418861761", "448899493", "449223263","5813047004")
df[n1,"cell.type"] = "AV3n1"

o1 = c("480586157", "511621576", "511262952")
df[o1,"cell.type"] = "AV3o1"

p1 = "633793553"
df[p1,"cell.type"] = "AV3p1"

# q1 = "295814411" # dead
# df[q1,"cell.type"] = "AV3q1"

m1 = "360255138"
df[m1,"cell.type"] = "AV3m1"


############
### AV3w ###
############

c1 = c("358538040", "5813109792", "510956058", "358541542", "510956443")
# light=c("Cha-F-000174","VGlut-F-700360","VGlut-F-600716",
#           "VGlut-F-300265","VGlut-F-400112","Cha-F-600218","Gad1-F-000203",
#           "VGlut-F-800054","VGlut-F-500832","VGlut-F-500109","L1117#1")
df[c1,"cell.type"] = "AV3c1"

c2 = c("388898076", "358538491", "387538632")
df[c2,"cell.type"] = "AV3c2"

c3 = c("541965840", "5901194027")
df[c3,"cell.type"] = "AV3c3"

c4 = "5901219179"
df[c4,"cell.type"] = "AV3c4"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AV3_celltyping.csv", row.names = FALSE)

# Process
if(process){
  # Make 2D Images
  take_pictures(df)

  # Update googlesheet
  write_lhns(df = df, column = c("class", "pnt", "cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))
}

##########
# Issues #
##########

#####
# h #
#####

# h1 = "669512877"
# df[h1,"cell.type"] = "AV3h1"

#####
# g #
#####

# g1 = "453320313" # light = "E0585-F-000005"
# df[g1,"cell.type"] = "AV3g1"
#
# g2 = "5901193389"
# df[g2,"cell.type"] = "AV3g2"
#
# g3 = c("484696850", "545427747")
# df[g3,"cell.type"] = "AV3g3"
#
# g4 = "514683250"
# df[g4,"cell.type"] = "AV3g4"
#
# g5 = "766734548"
# df[g5,"cell.type"] = "AV3g5"
#
# g6 = c("448908723", "983007405", "420904348", "760630148")
# df[g6,"cell.type"] = "AV3g6"

#####
# j #
#####

# j1 = c("1354972766", "760971727") # light = "Gad1-F-600114"
# df[j1,"cell.type"] = "AV3j1"
#
# j2 = c("541326096", "480608510", "851365481")
# df[j2,"cell.type"] = "AV3j2"

# #####
# # o #
# #####
#
# o1 = "419575044" #light = "Cha-F-000470"
# df[o1,"cell.type"] = "AV3o1"

# e3 = "389205204"
# df[e3,"cell.type"] = "AV3e3"
