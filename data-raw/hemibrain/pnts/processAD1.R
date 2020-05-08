#######
# PV5 #
#######
source("data-raw/hemibrain/startupHemibrain.R")

# First read all LHNs in the related cell body fibres
### Use plot3d(), nlscan() and find.neuron() to choose IDs.

# Groups
x = c("391716661", "5813096129", "424776680", "425121959", "424780893",
         "424781115", "360314997", "511617404", "638472166", "574688277",
         "5813035242", "5813047019", "573328325", "605732731", "574706585",
         "605046401", "5813013202", "769199010", "762274975", "824349873",
         "575384259", "705139000", "729867599", "611352588", "451995734",
         "573683438", "606461310", "483017681", "5813052205", "5813022459",
         "673426956", "544107243", "730562988", "544107335", "543321179",
         "574040939", "361264970", "638136814", "581652283", "583015749",
         "451382570", "517842578", "5813067728", "421957539", "455828904",
         "513404289", "5901195496", "452336897", "551298257", "425471220",
         "512765816")
y = c("792326206", "327838570", "359210228", "329206392", "5813026615")
z = c("422669150", "453355233", "360954739", "452677002", "297519736",
         "451663172", "947820593", "393340402", "420956213", "392307898",
         "453350926", "546472393", "577844302", "546127037", "577835762",
         "545786473", "453026933", "639240544", "390953189", "5901193642",
         "5813055865", "485745927")
w = c("328524517", "420615275", "421983723", "360932188", "452651021",
         "452323015", "453350952", "5813010191", "5901193715", "451960272",
         "5813085995", "391643292", "328542009", "359905678", "452651486",
         "359901157", "452996289", "545441096", "734693858", "545440837",
         "576812462", "515437073", "485430376", "760604568", "514073078",
         "667132722", "454045389", "483716037", "575806223", "454706490",
         "697132415", "454019960", "485430434", "485775679", "5813115796",
         "421992069", "547158593", "582696254", "614081109", "641278400",
      "576143501")
ad1 = c(x,y,z,w)

### Get FAFB assigned hemilineage information
x.match = unique(hemibrain_lhns[x,"FAFB.match"])
x.match = x.match[!is.na(x.match)]
x.match = read.neurons.catmaid.meta(x.match)
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
### ADL02^hLHT1 ADL03^hLHT3 ADL15^hLHT2 ADL21^hLHT4 ADL26^hLHT5
ADL03 = neuprint_read_neurons("ADL03")
ADL03 = ADL03[names(ADL03)%in%lhn.ids]
ADL15 = neuprint_read_neurons("ADL15")
ADL15 = ADL15[names(ADL15)%in%lhn.ids]
ADL02 = neuprint_read_neurons("ADL02")
ADL02 = ADL02[names(ADL02)%in%lhn.ids]
ad1.hemi = c(ADL03,ADL15,ADL02)

### Re-define some of these CBFs
sd = setdiff(ad1, names(ad1.hemi))
ds = setdiff(names(ad1.hemi),ad1)
ad1 = unique(ad1, names(ad1.hemi))

### Set-up data.frame
df = subset(namelist, bodyid %in% ad1)
df$cbf.change = FALSE
df$cell.type = NA
rownames(df) = df$bodyid

### Wrong CBF
wrong1 = c("547158593","705139000","544107243", "730562988")
df[wrong1,"cbf.change"] = "ADL15"

### Hemilineages:
df[x,"ItoLee_Hemilineage"] = "LHl2_medial"
df[x,"Hartenstein_Hemilineage"] = "DPLal2_medial"
df[z,"ItoLee_Hemilineage"] = "SLPal1"
df[z,"Hartenstein_Hemilineage"] = "DPLal1"
df[w,"ItoLee_Hemilineage"] = "SLPal2_ventral"
df[w,"Hartenstein_Hemilineage"] = "DPLal3_ventral"
df[y,"ItoLee_Hemilineage"] = "primary"
df[y,"Hartenstein_Hemilineage"] = "primary"

##############################
# Make and review cell types #
##############################
# hemibrain_type_plot(bodyids = a, meta = lh.meta, someneuronlist = db);plot3d(most.lhns.hemibrain[light],col="black")
### Plot your candidate type alongside the equivalent Ito groupings
# hemibrain_milti3d(a1, a2)
### Easily plot several of your candidate types at once

############
### AD1x ###
############

#####
# b #
#####

b1 = c("5813095395", "456187010", "551989415") # light = c("120726c3", "130726c1", "130731c1", "130910c0","140514c1")
df[b1,"cell.type"] = "AD1b1"

b2 = c("543321179", "574040939", "483017681", "573683438", "5813022459", "5813052205",
       "544107243", "730562988", "544107335", "673426956",
       "606461310", "769199010", "824349873", "5813013202", "762274975") # light = c("L1539#1", "120704c1", "120714c4", "JJ126", "JJ130", "JJ136", "JJ84")
df[b2,"cell.type"] = "AD1b2"

b3 = c("451995734", "611352588", "452336897", "425471220", "512765816") #light = c("120816c1") # "JJ26" # Change to AD1b1
df[b3,"cell.type"] = "AD1b3"

b4 = c("5813021223", "392645419", "5813012028") # light = c("120813c1", "120911c0")
df[b4,"cell.type"] = "AD1b4"

b5 = c("5813067728", "5901195496", "421957539", "517842578", "513404289") # light = c("120813c1")
df[b5,"cell.type"] = "AD1b5"

b6 = c("451382570", "5813047019") # light = "L1539#4"
df[b6,"cell.type"] = "AD1b6"

b7 = c("581652283", "583015749")
light = c("130731c1", "130729c0", "130801c1", "130802c0", "JJ37")
df[c(ad1b11111,ad1.b.1.1111),"cell.type"] = "DPLal2_medial_s"

b8 = c("575384259","638136814")
df[t,"cell.type"] = "DPLal2_medial_u"

#####
# c #
#####

c1 = c("705139000","729867599")
df[c1,"cell.type"] = "AD1c1"

c2 = c("424776680", "424780893", "424781115", "425121959", "551298257") # light=c("Gad1-F-600330", "Gad1-F-400233", "120830c2",  "JJ25", "JJ31","121129c0", "130711c3", "120913c1", "JJ129", "JJ132", "JJ20", "JJ33")
df[c2,"cell.type"] = "AD1c2"# light = c("L494#1", "L494#2","L475#1", "L475#2","Gad1-F-300262","Gad1-F-500014", "140612c0", "JJ27")

c3 = c("573328325", "605732731", "574706585", "605046401") # light = c("Gad1-F-700076")
df[a5,"cell.type"] = "AD1c3"

#####
# d #
#####

d1 = c("574688277", "5813035242",  "511617404", "638472166") # light = c("L2446#1", "L2446#2")
df[d1,"cell.type"] = "AD1d1"

d2 = c("5813096129", "391716661", "360314997")
df[d2,"cell.type"] = "AD1d2"

#####
# k #
#####

k1 = c("328883562", "360242173", "5813009578")
df[k1,"cell.type"] = "AD1k1"

k2 = c("361264970", "573699419")
df[k2,"cell.type"] = "AD1k2"


#############
### AD1y ####
#############

#####
# l #
#####

l1 = "676479217"
df[l1,"cell.type"] = "AD1l1"

#####
# h #
#####

h1 = "792326206" # light =  "VGlut-F-200392"
df[h1,"cell.type"] = "AD1h1"

#####
# m #
#####

m1 = "327838570"
df[m1,"cell.type"] = "AD1m1"

m2 = "359210228" #
df[m2,"cell.type"] = "AD1m2"

#####
# g #
#####

g1 = "5813026615"
df[g1,"cell.type"] = "AD1g1"

#####
# n #
#####

n1 = "329206392" #
df[n1,"cell.type"] = "AD1n1"

############
### AD1z ###
############

#####
# a #
#####

a3 = c("453350926", "392307898", "420956213") # light = c("Cha-F-100223", "VGlut-F-200319","Cha-F-300272","VGlut-F-400267","VGlut-F-600424","VGlut-F-700522", "130524c0","JJ42")
df[a3,"cell.type"] = "AD1a3"

a8 = c("329206628", "393340402", "480978811", "360954739", "421300612",
      "390590590", "297519736", "359227113", "359240144", "359926923",
      "5813055866", "5813010259","5813055907", "359219722") # light = "Gad1-F-400155"
df[a8,"cell.type"] = "AD1a8"

a7 = c("422669150", "453355233", "451663172", "452677002", "947820593") #light = c("Cha-F-400246","L1721#1", "L1721#3")
df[a7,"cell.type"] = "AD1a7"

a9 = c("453026933", "545786473", "639240544", "390953189", "5901193642") # light = c("VGlut-F-500156")
df[a9,"cell.type"] = "AD1a9"

a10 = c("5813055865") # light = c("Cha-F-100223") # Aspis in the EM
df[a3,"cell.type"] = "AD1a10"

a11 = c("546472393", "577835762", "546127037", "577844302") # light = c("Gad1-F-200033","Cha-F-700185")
df[a11,"cell.type"] = "AD1a11"

a12 = "485745927"
df[a11,"cell.type"] = "AD1a12"

#####
# j #
#####

j1  = c("452971138", "543692985") # light = "Gad1-F-200247"
df[j1,"cell.type"] = "AD1j1"

#############
### AD1w ###
#############

#####
# i #
#####

i5 = c("359219503", "328524517", "5813085995")
df[i5,"cell.type"] = "AD1i6"

i4 = c("451960272")
df[i4,"cell.type"] = "AD1i5"

i3 = c("453350952", "454019960")
df[i3,"cell.type"] = "AD1i3"

i2 = c("981547981", "328542009", "452323015", "5901193715")
df[i2,"cell.type"] = "AD1i2"

i1 = c("359901157", "452651486", "452996289", "391643292", "5813010191",  "359905678") # light = c("JJ50")
df[i1,"cell.type"] = "AD1i1"

#####
# f #
#####

f1 = "576143501" # light = c("L1740#10", "L1740#5", "L1740#6","L1740#4")
df[f1,"cell.type"] = "AD1f1"

#####
# e #
#####

e1 = c("485430434", "485775679", "855414220", "887148641", "641278400", "949534412", "610916994") #light = c("Gad1-F-300229","Cha-F-200360","fru-F-300009","Gad1-F-200365","L1614#1","L1827#3")
df[e1,"cell.type"] = "AD1e1"

e2 = c("5813115796", "421992069") # light = c("Gad1-F-700032", "fru-F-200156")
df[e2,"cell.type"] = "AD1e2"

e3 = c("547158593", "582696254", "614081109") # light = c("Gad1-F-000249","JJ32")
df[e3,"cell.type"] = "AD1e3"

#####
# a #
#####

a1 = c("454045389", "483716037", "575806223") # light = c("130123c1","130523c0", "130524c0","Cha-F-000258","L1740#3", "L1740#7", "L1740#8", "L1740#11","L1740#2","L1739#1","JJ113", "JJ114", "JJ63", "JJ67")
df[a1,"cell.type"] = "AD1a1"

a2 = c("545440837", "576812462", "734693858",
        "760604568", "514073078", "485430376", "667132722") # light  = c("Cha-F-400246","L1721#1", "L1721#3","Gad1-F-400257","140402c0", "121206c0", "140403c1","L1721#2","L1812#1","L1812#2")
df[a2,"cell.type"] = "AD1a2"

a4 = c("454706490", "697132415") # light = c("120925c1", "121127c1", "121122c1", "121128c3", "L1740#2")
df[a4,"cell.type"] = "AD1a4"

a5 = c("360932188", "452651021", "420615275", "421983723")
df[a5,"cell.type"] = "AD1a5"

a6 = c("515437073", "545441096","453376390")
df[a6,"cell.type"] = "AD1a6"

########
# save #
########

# Organise cell types
df = process_types(df = df, hemibrain_lhns = hemibrain_lhns)

# Summarise results
state_results(df)

# Write .csv
write.csv(df, file = "data-raw/hemibrain/pnts/csv/AD1_celltyping.csv", row.names = FALSE)

# Make 2D Images
take_pictures(df, pnt="AD1")

# Update googlesheet
write_lhns(df = df, column = c("cell.type", "ItoLee_Hemilineage", "Hartenstein_Hemilineage"))


##########
# Issues #
##########

