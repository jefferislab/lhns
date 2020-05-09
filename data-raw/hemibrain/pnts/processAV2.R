#######
# PV5 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("360237650", "391954889", "516098538", "672287506", "573346324",
      "574710121", "604735525", "671933799", "608491067", "578151363",
      "484377189", "578841489", "517117602", "452331917", "483038957",
      "513357277", "423684795", "485736803", "674009814", "422644053",
      "483354202", "422666053", "517458316")
y = c("699212545", "733005935", "5813012462", "606492411", "5813069285",
      "5813040903", "606479285", "360595711", "5812980329", "486073599",
      "855043038", "5813039931", "424384254", "485723857", "391276906",
      "390586997", "455728985", "5813106089", "667841133", "516762858",
      "5813039980", "580546081", "5813013792", "5813013530", "640220321",
      "516771668", "576774002", "609168709", "485732870", "547115923",
      "948135822", "612285653", "486444499", "674001478", "391945237",
      "329206270", "359560118", "360237353", "5812980039", "452327439",
      "454377810", "514406435", "636792984", "640915837", "549521047",
      "5813013203", "574723544", "5813061564", "577801333", "575042709",
      "668152044", "5813057923", "638476210", "5813013183", "638148213",
      "883030091", "638826442", "886066221", "575418068", "607109790",
      "574352231", "606431658", "542665187", "761239957", "543770627",
      "607130326", "574128034", "850636610", "450933288", "450951445",
      "450933392", "481989534", "574378565", "5813011770", "419880359",
      "511970945", "603007915", "546123239", "638196102", "452336396",
      "668552668", "452676790", "452681716")
z = c("455033548", "5812980824", "5813047212", "5813048297", "5813087655",
      "422971316", "975750913", "454693209", "456082779", "881620582",
      "947795335", "518476551", "580547055", "5813015004", "882003599",
      "574378463", "759585675", "574382779", "5813041458", "944720631",
      "945058110", "1259218128", "944423023", "881995193", "978177557",
      "886820993", "947168406", "1039923193", "1101984860", "1538181953",
      "1414046770", "1006142645", "944724233", "944729222", "5813048319",
      "1260582361", "5813016204", "821612285", "851961337", "730562993",
      "852302293", "852302504", "1037510115", "881999404", "819943010",
      "825359499", "5813093028", "850972999", "919526332", "850260732",
      "944047683", "762961590", "912667199", "1013296065", "819895218",
      "919845196", "5813056386", "977123707", "1199181443", "668497214",
      "667827599")
av2 = c(x,y,z)

### Get FAFB assigned hemilineage information
x.match = unique(hemibrain_lhns[x,"FAFB.match"])
x.match = x.match[!is.na(x.match)]
x.match = read.neurons.catmaid.meta(x.match)
z.match = unique(hemibrain_lhns[z,"FAFB.match"])
z.match = z.match[!is.na(z.match)]
z.match = read.neurons.catmaid.meta(z.match)
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
### ADL22^LBDL3  ADL04^LBDL7 AVL07^LEA1
ADL22 = neuprint_read_neurons("ADL22")
ADL22 = ADL22[names(ADL22)%in%lhn.ids]
ADL04 = neuprint_read_neurons("ADL04")
ADL04 = ADL04[names(ADL04)%in%lhn.ids]
AVL07 = neuprint_read_neurons("AVL07")
AVL07 = AVL07[names(AVL07)%in%lhn.ids]
av2.hemi = c(ADL22,ADL04,AVL07)

### Re-define some of these CBFs
sd = setdiff(av2, names(av2.hemi))
ds = setdiff(names(av2.hemi),av2)
av2 = unique(av2, names(av2.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% av2)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("")
df[wrong1,"cbf.change"] = ""

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "SLPav3"
df[x,"Hartenstein_Hemilineage"] = "BLVa2a"
df[z,"ItoLee_Hemilineage"] = "SLPal1"
df[z,"Hartenstein_Hemilineage"] = "VLPl2_dorsal"
df[w,"ItoLee_Hemilineage"] = "SLPal2_ventral"
df[w,"Hartenstein_Hemilineage"] = "BLAv2_dorsal"
df[y,"ItoLee_Hemilineage"] = "LHa2_ventral"
df[y,"Hartenstein_Hemilineage"] = "BLVa1_ventral"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### av2x ###
############

#####
# a #
#####

a2 = c("422666053", "483038957","452331917", "423684795", "517458316", "485736803", "517117602", "422644053", "483354202") #light = c("L876#6", "L876#3", "JJ83")
df[a2,"cell.type"] = "AV2a2"

a5 = c("516098538", "360237650", "391954889")
df[a5,"cell.type"] = "AV2a5"

a6 = c("604735525", "573346324", "574710121") # light = c("L876#2", "L876#1","L876#5")
df[a6,"cell.type"] = "AV2a6"

a7 = c("484377189", "578841489","513357277")
df[a7,"cell.type"] = "AV2a7"

a8 = c("578151363")
df[a8,"cell.type"] = "AV2a8"

#####
# u #
#####

a = "674009814"
df[a,"cell.type"] = "AV2g"

b = c("671933799", "608491067", "672287506")
df[b,"cell.type"] = "AV2h"


############
### AV2y ###
############

#####
# a #
#####

a1 = c("5813012462", "5813040903", "5813069285")
light = "Gad1-F-600244"
df[a1,"cell.type"] = "AV2a1"

a3 = c("360595711", "5813039980") # light = c("fru-F-200126", "Gad1-F-000298", "Cha-F-800106","L907#1","VGlut-F-500323")
df[a3,"cell.type"] = "AV2a3"

a = c("329206270", "360237353", "359560118", "391945237", "5812980039", "452327439", "454377810", "5812980329")
df[a,"cell.type"] = "AV2a"

d = c("516762858", "485723857", "486073599") #
df[d,"cell.type"] = "AV2d"

e = c("5813039931", "424384254", "855043038")
df[e,"cell.type"] = "AV2e"

f = c("5813106089", "390586997", "455728985") #light = c("Cha-F-200387")
df[c(f,f.f),"cell.type"] = "AV2f"

i = c("514406435", "547115923", "640915837") # light = c("Gad1-F-000096", "JJ140")
df[c(i,i.i),"cell.type"] = "AV2i"

j = c("606492411", "667841133", "699212545") #light = c("Gad1-F-800100","JJ82")
df[c(j,j.j),"cell.type"] = "AV2j"

k = c("391276906", "606479285") # light = c("Gad1-F-000203", "Gad1-F-000006")
df[c(k,k.k),"cell.type"] = "AV2k"

g = "450951445"
df[g,"cell.type"] = "AV2g"

#####
# u #
#####

m = c("549521047", "5813061564", "574723544", "5813013203")
df[c(m,m.m),"cell.type"] = "AV2m"

n = "636792984"
df[c(n,n.n),"cell.type"] = "AV2n"

o = "546123239"
df[o,"cell.type"] = "AV2o"

p = "638196102"
df[p,"cell.type"] = "AV2p"

#####
# u #
#####

r = c("612285653", "486444499", "674001478", "948135822") #light = c("Gad1-F-000240")
df[c(r, r.r),"cell.type"] = "AV2r"

a1 = c("5813013530", "640220321", "580546081", "5813013792") # light = c("L629#2", "Gad1-F-800214")
df[a1,"cell.type"] = "AV2a1"

#####
# u #
#####

t = c("516771668", "577801333")
df[t,"cell.type"] = "AV2t"

u = c("485732870", "576774002")
df[u,"cell.type"] = "AV2u"
l = "609168709"

zb = c("575042709") # light = c("Gad1-F-600244")
df[c(zb,z.b),"cell.type"] = "AV2zb"


#####
# u #
#####

v = c("883030091", "638826442", "886066221") # light = c("L629#2", "L629#6", "L629#1","L629#5", "L1385#20","L1385#17","L1385#5")
df[c(v,v.v),"cell.type"] = "AV2v"

x = c("575418068", "638476210", "668152044")
light = c("Gad1-F-600244")
df[c(x,x.x),"cell.type"] = "AV2x"

y = c("5813057923", "5813013183", "607109790", "638148213") # light = c("L1385#2")
df[c(y,y.y),"cell.type"] = "AV2y"

#####
# u #
#####

z = c("542665187", "574378565", "606431658", "574352231", "761239957")
df[z,"cell.type"] = "AV2z"

#####
# u #
#####

za = c("511970945", "603007915","5813011770")
df[za,"cell.type"] = "AV2za"

zc = c("543770627", "574128034",  "850636610")
df[zc,"cell.type"] = "AV2zc"

zzc = "607130326"

zd = c("450933288", "419880359", "450933392")
df[zd,"cell.type"] = "AV2zd"

ze = c("450951445", "481989534")
df[ze,"cell.type"] = "AV2ze"

#####
# u #
#####

zf = c("668552668") # light = c("Cha-F-000256")
df[c(zf,z.f),"cell.type"] = "AV2zf"

zh = c("733005935") # light = c("fru-M-400293")
df[c(zh,z.h),"cell.type"] = "AV2zh"

#####
# u #
#####

h1 = c("482685041", "452336396", "452676790", "452681716", "514073634") # light = c("Gad1-F-000153")
df[h1,"cell.type"] = "AV2h1"

############
### AV2w ##
############

c1 = c("454693209", "5813015004", "5812980824", "455033548", "422971316",
       "881620582", "456082779", "5813048297", "5813087655", "518476551",
       "947795335", "5813047212", "580547055") # light = c("Gad1-F-400156", "Cha-F-400280")
df[c1,"cell.type"] = "AV2c1"

b.1 = "975750913"
df[c(b.1),"cell.type"] = "AV2b2"

#####
# u #
#####

d = c("574378463", "667827599", "668497214")
df[d,"cell.type"] = "AV2d"

c = "1199181443"
df[c,"cell.type"] = "AV2c"

e = c("5813041458", "944423023")

f = c("1259218128", "978177557", "5813041458", "881995193", "944423023")

g1 = c("574382779", "759585675") # light = c("Cha-F-500135")
df[g1,"cell.type"] = "AV2g1"

g = c("944720631")
df[g,"cell.type"] = "AV2g"

gg = "945058110"


#####
# u #
#####

h = c("825359499", "850972999", "919526332", "919845196")
light = c("Cha-F-700299")
df[c(h,h.h),"cell.type"] = "AV2h"

i = c("762961590")
df[i,"cell.type"] = "AV2i"

b1 = c("881999404", "912667199") # light = c("Gad1-F-600189")
df[b5,"cell.type"] = "AV2b5"

#####
# u #
#####

k = c("944047683", "850260732", "882003599")
df[k,"cell.type"] = "AV2k"

h = c("819943010", "919526332", "919845196", "825359499", "850972999",
      "5813093028", "1013296065")
df[h,"cell.type"] = "AV2h"

b1 = c("5813056386", "1260582361", "977123707") # slight = c("Gad1-F-300310","Cha-F-100444")
df[b1,"cell.type"] = "AV2b1"

b4 = c("1538181953", "1101984860", "886820993", "1039923193", "947168406") # light = c("Gad1-F-700003", "Gad1-F-700003")
df[b4,"cell.type"] = "AV2b4"

n = c("944724233", "5813048319", "1006142645", "1414046770") # light = c("Cha-F-300136", "Cha-F-200034")
df[c(n,n.n),"cell.type"] = "AV2n"

nn  = "1130947782"

o = c("944729222")
df[o,"cell.type"] = "AV2o"

b3 = c("819895218", "730562993", "852302293") # light = c("5HT1A-F-300031","Gad1-F-600005")
df[b3,"cell.type"] = "AV2b3"

q = c("821612285", "1037510115", "5813016204", "851961337", "852302504")
# light = c("Gad1-F-300218","Gad1-F-200223", "L2087#2", "L2088#3", "L2088#1",
#         "L2088#2", "Cha-F-600183", "fru-F-300169", "fru-F-600103", "fru-M-300456",
#         "L2087#1", "L2087#3", "L2087#4", "JJ79")
df[c(q,q.q),"cell.type"] = "AV2q"


########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/av2_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="av2")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))


##########
# Issues #
##########

