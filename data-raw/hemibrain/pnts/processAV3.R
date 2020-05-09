#######
# AV3 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("575389396", "390603428", "607441336", "822004733", "5813011773",
      "790288721", "5813021535", "454386099", "456847100", "329225149",
      "329897255", "574041014", "667832004", "390560212", "822692353",
      "5813078194", "666122442", "1288522544", "5813009781", "605058898",
      "1260949362", "389205204")
y = c("326154371", "480257882", "325814669", "480257743", "480257914",
          "419929377", "295798962", "5813035078", "295461871", "480257896",
          "480258191", "480599285", "388513242", "450609707", "358874595",
          "358878546", "295807429", "389536816", "327857238", "356832459",
          "295780154", "295461707", "295785459", "357496172", "295470623",
          "327152465", "420235167", "328519904", "390586752", "295799057",
          "359210479", "327220514", "294437328", "295439322", "421292214",
          "541961677", "449223347", "510943286", "390935343", "450267976",
          "419234116", "541961750", "5813057662", "359555628", "480257919",
          "390254536", "5813057660", "542643555", "390919685", "329566467",
          "419578845", "449577409", "451296290", "480262368", "360928792",
          "480262270", "449223379", "605090489", "480253500", "5813010546",
          "391604407", "479917126", "511271379", "449227486", "541624179",
          "390931864", "5813098306", "449223263", "325834652", "356832508",
          "5813047004", "418861761", "448899493", "511262952", "480586157",
          "511621576", "326817510", "419575044", "5813097073", "5813068507",
          "359555689", "5813047178", "5901196932", "5813039880", "296489073",
          "357832762", "295456869", "295797312", "328543014", "297851977",
          "665454282", "1439962910", "5813056083", "696143413", "417550216",
          "544699051", "574377845", "5813009276", "633793553", "357855613",
          "327844600", "294778999", "388898076", "356494648", "424716408",
          "5813010511", "698180927", "359581549", "698185483", "453018720",
          "482680447", "5813078261", "296120593", "419880359", "633097828")
av3 = c(x,y)

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
### AVL18^LEA2 AVL12^LEA5 ADL04^LBDL7 ADL10^LBDL6
AVL18 = neuprint_read_neurons("AVL18")
AVL18 = AVL18[names(AVL18)%in%lhn.ids]
AVL12 = neuprint_read_neurons("AVL12")
AVL12 = AVL12[names(AVL12)%in%lhn.ids]
ADL04 = neuprint_read_neurons("ADL04")
ADL04 = ADL04[names(ADL04)%in%lhn.ids]
ADL10 = neuprint_read_neurons("ADL10")
ADL10 = ADL10[names(ADL10)%in%lhn.ids]
av3.hemi = c(ADL22,ADL04,AVL07,ADL10)

### Re-define some of these CBFs
sd = setdiff(av3, names(av3.hemi))
ds = setdiff(names(av3.hemi),av3)
av3 = unique(av3, names(av3.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av3)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("")
df[wrong1,"cbf.change"] = ""

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "SLPav1_lateral"
df[x,"Hartenstein_Hemilineage"] = "BLAl_lateral"
df[y,"ItoLee_Hemilineage"] = "SLPpl3_lateral"
df[y,"Hartenstein_Hemilineage"] = "new_lateral"

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

e3 = "389205204"
df[e3,"cell.type"] = "AV3e3"

e4 = c("390560212", "5813009781")
df[e4,"cell.type"] = "AV3e4"

e5 = c("5813011773", "607441336", "666122442")
df[e5,"cell.type"] = "AV3e5"

e6 = c("574041014", "605058898")
df[e6,"cell.type"] = "AV3e6"

e7 = "667832004"
df[e7,"cell.type"] = "AV3e7"

e8 = "390603428"
df[e8,"cell.type"] = "AV3e8"

e9 = "575389396"
df[e9,"cell.type"] = "AV3e9"

#####
# f #
#####

f1 = c("329225149", "329897255") # light = c("Gad1-F-500030") # AV6?
df[f1,"cell.type"] = "AV3m"

f2 = "5813021535"
df[f2,"cell.type"] = "AV3n"

f3 = c("454386099") # light = "Gad1-F-900160"
df[f3,"cell.type"] = "AV3o"

############
### AV3y ###
############

#####
# u #
#####

g1 = "453320313" # light = "E0585-F-000005"
df[g1,"cell.type"] = "AV3g1"

g2 = "5901193389"
df[g2,"cell.type"] = "AV3g2"

g3 = c("484696850", "545427747")
df[g3,"cell.type"] = "AV3g3"

g4 = "514683250"
df[g4,"cell.type"] = "AV3g4"

g5 = "766734548"
df[g5,"cell.type"] = "AV3g5"

g6 = c("448908723", "983007405", "420904348", "760630148")
df[g6,"cell.type"] = "AV3g6"

#####
# u #
#####

h1 = "669512877"
df[h1,"cell.type"] = "AV3h1"

#####
# u #
#####

j1 = c("1354972766", "760971727") # light = "Gad1-F-600114"
df[j1,"cell.type"] = "AV3j1"

j2 = c("541326096", "480608510", "851365481")
df[j2,"cell.type"] = "AV3j2"

############
### AV3z ###
############

#####
# d #
#####

d1 = "665454282"
df[d1,"cell.type"] = "AV3d1"

#####
# u #
#####

a1 = c("5813035078", "480257896", "295798962", "419929377", "480258191", "295461871", "480599285")
df[a1,"cell.type"] = "AV3a1"

a2 = c("480257882", "480257914", "480257743", "326154371", "325814669") # light  = c("Cha-F-200357")
df[a2,"cell.type"] = "AV3a2"

a3 = c("294778999", "357855613", "388898076")
df[a3,"cell.type"] = "AV3a3"

a4 = "419880359"
df[a4,"cell.type"] = "AV3a4"

a5 = "296120593"
df[a5,"cell.type"] = "AV3a5"

a6 = "696143413"
df[a6,"cell.type"] = "AV3a6"

#####
# c #
#####

c3 = "419575044" #light = "Cha-F-000470"
df[c3,"cell.type"] = "AV3c"

#####
# u #
#####

e1 = "574377845"
df[e1,"cell.type"] = "AV3e1"

e2 = c("633097828")
df[e2,"cell.type"] = "AVe2"

#####
# u #
#####

g1 = c("544699051", "5813009276")
df[z,"cell.type"] = "AV3g1"

g2 = c("698180927", "698185483")
df[zd,"cell.type"] = "AV3g2"

#####
# u #
#####

k1 = "5901196932"
df[k1,"cell.type"] = "AV3k1"

#####
# u #
#####

b1 = c("391604407", "390931864", "5813098306") # light = "Cha-F-200387"
df[b1,"cell.type"] = "AV3b1"

b2 = c("449227486", "541624179","480253500", "479917126", "511271379")
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

b8= c("542643555", "5813010546", "359555628","5813057660", "419578845", "390254536", "480257919")
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
df[zm,"cell.type"] = "AV3b13"

#####
# u #
#####

l1 = "297851977"
df[l1,"cell.type"] = "AV3l1"

#####
# u #
#####

m1 = "424716408"
df[m1,"cell.type"] = "AV3m1"

m2 = "5813010511"
df[m2,"cell.type"] = "AV3m2"

m3 = "482680447"
df[m3,"cell.type"] = "AV3m3"

m4 = "5813097073"
df[m4,"cell.type"] = "AV3m4"

m5 = "328543014"
df[m5,"cell.type"] = "AV3m5"

m6 = "359581549"
df[m6,"cell.type"] = "AV3m6"

n1 = "513029260"
df[n1,"cell.type"] = "AV3n1"

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

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AV3_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="AV3")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))


##########
# Issues #
##########

# 513029260

